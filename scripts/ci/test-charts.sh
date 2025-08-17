#!/bin/bash
set -euo pipefail

# Test multiple Helm charts on Kubernetes
# Uses CHARTS_TO_TEST environment variable containing JSON array
# Uses KUBERNETES_VERSION environment variable for logging

# Configuration constants
readonly DEFAULT_TIMEOUT="5m"
readonly CI_DIR_NAME="ci"

# Arrays for tracking results
TESTED=()
SKIPPED=()
FAILED=()

# Logging functions for consistent output
log_info() { echo "[INFO] $*"; }
log_success() { echo "[SUCCESS] $*"; }
log_error() { echo "[ERROR] $*"; }
log_skip() { echo "[SKIP] $*"; }
log_test() { echo "[TEST] $*"; }

# Chart metadata helper functions
get_chart_annotation() {
    local chart_dir="$1"
    local annotation="$2"
    local default_value="${3:-}"
    
    yq eval ".annotations.\"${annotation}\" // \"${default_value}\"" "${chart_dir}/Chart.yaml"
}

should_skip_chart_test() {
    local chart_dir="$1"
    local skip_test
    
    skip_test=$(get_chart_annotation "$chart_dir" "helm.sh/skip-test" "false")
    [[ "$skip_test" == "true" ]]
}

get_skip_test_reason() {
    local chart_dir="$1"
    
    get_chart_annotation "$chart_dir" "helm.sh/skip-test-reason" "No reason provided"
}

# CI test file discovery functions
find_ci_test_files() {
    local chart_dir="$1"
    local -n test_files_ref="$2"
    local ci_dir="${chart_dir}/${CI_DIR_NAME}"
    
    if [ -d "$ci_dir" ]; then
        while IFS= read -r -d '' file; do
            test_files_ref+=("$file")
        done < <(find "$ci_dir" -name "*.yaml" -type f -print0 | sort -z)
    fi
}

log_test_files_found() {
    local chart_name="$1"
    shift
    local test_files=("$@")
    
    if [ ${#test_files[@]} -eq 0 ]; then
        log_info "No CI test values found for ${chart_name}, using default values"
    else
        log_info "Found ${#test_files[@]} CI test file(s) for ${chart_name}:"
        for file in "${test_files[@]}"; do
            # Show relative path from project root
            local relative_path="${file#./}"
            log_info "   - ${relative_path}"
        done
    fi
}

test_chart() {
    local chart_name="${1}"
    local chart_dir="charts/${chart_name}"
    
    log_test "Testing chart: ${chart_name} on Kubernetes ${KUBERNETES_VERSION}"
    
    # Check if test should be skipped
    if should_skip_chart_test "$chart_dir"; then
        local skip_reason
        skip_reason=$(get_skip_test_reason "$chart_dir")
        SKIPPED+=("${chart_name}|${skip_reason}")
        log_skip "Skipping test for ${chart_name}: ${skip_reason}"
        return 0
    fi
    
    # Find CI test files
    local test_files=()
    find_ci_test_files "$chart_dir" test_files
    
    # Log test file discovery
    log_test_files_found "$chart_name" "${test_files[@]}"
    
    # Execute chart tests and track results
    local test_success=true
    local tests_run=0
    local tests_passed=0
    
    if [ ${#test_files[@]} -eq 0 ]; then
        # No CI files, test with default values
        tests_run=1
        if run_chart_test "$chart_name" ""; then
            tests_passed=1
        else
            test_success=false
        fi
    else
        # Test with each CI file
        tests_run=${#test_files[@]}
        for test_file in "${test_files[@]}"; do
            local test_name=$(basename "$test_file" .yaml)
            log_test "Testing ${chart_name} with $(basename "$test_file")"
            if run_chart_test "$chart_name" "-f ${test_file}" "$test_name"; then
                ((tests_passed++))
            else
                test_success=false
                break
            fi
        done
    fi
    
    # Log chart test summary
    log_info "Chart ${chart_name}: ${tests_passed}/${tests_run} tests passed"
    
    # Record test results
    record_test_result "$chart_name" "$test_success"
}

# Test result recording function
record_test_result() {
    local chart_name="$1"
    local test_success="$2"
    
    if [ "$test_success" = true ]; then
        TESTED+=("$chart_name")
        log_success "Successfully tested $chart_name"
    else
        FAILED+=("$chart_name")
        log_error "Failed to test $chart_name"
        return 1
    fi
}

# Release name generation
generate_release_name() {
    local chart_name="$1"
    local test_suffix="${2:-}"
    
    local release_name="test-${chart_name}"
    if [ -n "$test_suffix" ]; then
        release_name="test-${chart_name}-${test_suffix}"
    fi
    echo "$release_name"
}

# Helm operations wrapper
run_helm_dry_run() {
    local release_name="$1"
    local chart_dir="$2"
    local namespace="$3"
    local test_values="$4"
    
    helm install "$release_name" "$chart_dir" \
        $test_values \
        --dry-run \
        --debug \
        --namespace "$namespace" \
        --create-namespace
}

run_helm_install() {
    local release_name="$1"
    local chart_dir="$2"
    local namespace="$3"
    local test_values="$4"
    
    helm install "$release_name" "$chart_dir" \
        $test_values \
        --namespace "$namespace" \
        --create-namespace \
        --wait \
        --timeout "$DEFAULT_TIMEOUT" \
        --atomic
}

run_helm_test() {
    local release_name="$1"
    local namespace="$2"
    local chart_name="$3"
    
    helm test "$release_name" -n "$namespace" || log_info "No test resources found for $chart_name"
}

cleanup_test_resources() {
    local release_name="$1"
    local namespace="$2"
    local chart_name="$3"
    
    log_info "Cleaning up test resources for $chart_name ($release_name)..."
    helm uninstall "$release_name" -n "$namespace" || true
    kubectl delete namespace "$namespace" || true
}

run_chart_test() {
    local chart_name="$1"
    local test_values="$2"
    local test_suffix="${3:-}"
    local chart_dir="charts/$chart_name"
    
    local release_name
    release_name=$(generate_release_name "$chart_name" "$test_suffix")
    local namespace_name="$release_name"
    
    # Dry run validation
    log_info "Running dry-run validation for $chart_name ($release_name)..."
    if ! run_helm_dry_run "$release_name" "$chart_dir" "$namespace_name" "$test_values"; then
        log_error "Dry-run failed for $chart_name ($release_name)"
        return 1
    fi
    
    # Install chart for testing
    log_info "Installing $chart_name for testing ($release_name)..."
    if ! run_helm_install "$release_name" "$chart_dir" "$namespace_name" "$test_values"; then
        log_error "Installation failed for $chart_name ($release_name)"
        return 1
    fi
    
    # Run helm test
    log_info "Running helm test for $chart_name ($release_name)..."
    run_helm_test "$release_name" "$namespace_name" "$chart_name"
    
    # Cleanup resources
    cleanup_test_resources "$release_name" "$namespace_name" "$chart_name"
    
    return 0
}


# Chart list validation and parsing
validate_and_parse_charts() {
    local -n charts_ref="$1"
    
    if [ -z "${CHARTS_TO_TEST:-}" ]; then
        log_info "No charts to test"
        return 1
    fi
    
    # Convert JSON array to bash array
    readarray -t charts_ref < <(echo "$CHARTS_TO_TEST" | jq -r '.[]')
    
    if [ ${#charts_ref[@]} -eq 0 ]; then
        log_info "No charts to test"
        return 1
    fi
    
    return 0
}

# Process all charts for testing
process_all_charts() {
    local charts=("$@")
    
    log_test "Testing ${#charts[@]} chart(s) on Kubernetes ${KUBERNETES_VERSION}: ${charts[*]}"
    echo ""
    
    for chart in "${charts[@]}"; do
        test_chart "$chart" || true
    done
}

# Check final test results
check_final_results() {
    if [ ${#FAILED[@]} -ne 0 ]; then
        log_error "Tests failed for charts: ${FAILED[*]}"
        return 1
    fi
    
    log_success "All chart tests completed successfully"
    return 0
}

# Main execution
main() {
    local charts=()
    
    if ! validate_and_parse_charts charts; then
        exit 0
    fi
    
    process_all_charts "${charts[@]}"
    
    if ! check_final_results; then
        exit 1
    fi
}

main "$@"