#!/bin/bash
set -euo pipefail

# Test multiple Helm charts on Kubernetes
# Uses CHARTS_TO_TEST environment variable containing JSON array
# Uses KUBERNETES_VERSION environment variable for logging

# Arrays for tracking results
TESTED=()
SKIPPED=()
FAILED=()

test_chart() {
    local chart_name="${1}"
    local chart_dir="charts/${chart_name}"
    
    echo "🧪 Testing chart: ${chart_name} on Kubernetes ${KUBERNETES_VERSION}"
    
    # Check if test should be skipped
    local skip_test
    local skip_reason
    
    skip_test=$(yq eval '.annotations."helm.sh/skip-test" // "false"' "${chart_dir}/Chart.yaml")
    skip_reason=$(yq eval '.annotations."helm.sh/skip-test-reason" // "No reason provided"' "${chart_dir}/Chart.yaml")
    
    if [[ "${skip_test}" == "true" ]]; then
        SKIPPED+=("${chart_name}|${skip_reason}")
        echo "⏭️ Skipping test for ${chart_name}: ${skip_reason}"
        return 0
    fi
    
    # Check for CI test values (support multiple files)
    local ci_dir="${chart_dir}/ci"
    local test_files=()
    
    if [ -d "${ci_dir}" ]; then
        # Find all YAML files in ci directory
        while IFS= read -r -d '' file; do
            test_files+=("$file")
        done < <(find "${ci_dir}" -name "*.yaml" -type f -print0 | sort -z)
        
        if [ ${#test_files[@]} -eq 0 ]; then
            echo "📋 No CI test values found for ${chart_name}, using default values"
        else
            echo "📋 Found ${#test_files[@]} CI test file(s) for ${chart_name}:"
            for file in "${test_files[@]}"; do
                echo "   - $(basename "$file")"
            done
        fi
    else
        echo "📋 No CI directory found for ${chart_name}, using default values"
    fi
    
    # Run tests with each CI file (or once with default values if no CI files)
    local test_success=true
    if [ ${#test_files[@]} -eq 0 ]; then
        # No CI files, test with default values
        if ! run_chart_test "${chart_name}" ""; then
            test_success=false
        fi
    else
        # Test with each CI file
        for test_file in "${test_files[@]}"; do
            local test_name=$(basename "$test_file" .yaml)
            echo "🧪 Testing ${chart_name} with $(basename "$test_file")"
            if ! run_chart_test "${chart_name}" "-f ${test_file}" "${test_name}"; then
                test_success=false
                break
            fi
        done
    fi
    
    # Update results
    if [ "$test_success" = true ]; then
        TESTED+=("${chart_name}")
        echo "✅ Successfully tested ${chart_name}"
    else
        FAILED+=("${chart_name}")
        echo "❌ Failed to test ${chart_name}"
        return 1
    fi
}

run_chart_test() {
    local chart_name="${1}"
    local test_values="${2}"
    local test_suffix="${3:-}"
    local chart_dir="charts/${chart_name}"
    
    # Create unique release name for multiple tests
    local release_name="test-${chart_name}"
    if [ -n "${test_suffix}" ]; then
        release_name="test-${chart_name}-${test_suffix}"
    fi
    local namespace_name="${release_name}"
    
    # Dry run first
    echo "Running dry-run validation for ${chart_name} (${release_name})..."
    if ! helm install "${release_name}" "${chart_dir}" \
        ${test_values} \
        --dry-run \
        --debug \
        --namespace "${namespace_name}" \
        --create-namespace; then
        echo "❌ Dry-run failed for ${chart_name} (${release_name})"
        return 1
    fi
    
    # Actually install to test
    echo "Installing ${chart_name} for testing (${release_name})..."
    if ! helm install "${release_name}" "${chart_dir}" \
        ${test_values} \
        --namespace "${namespace_name}" \
        --create-namespace \
        --wait \
        --timeout 5m \
        --atomic; then
        echo "❌ Installation failed for ${chart_name} (${release_name})"
        return 1
    fi
    
    # Run helm test if test resources exist
    echo "Running helm test for ${chart_name} (${release_name})..."
    helm test "${release_name}" -n "${namespace_name}" || echo "No test resources found for ${chart_name}"
    
    # Cleanup
    echo "Cleaning up test resources for ${chart_name} (${release_name})..."
    helm uninstall "${release_name}" -n "${namespace_name}" || true
    kubectl delete namespace "${namespace_name}" || true
    
    return 0
}


# Main execution
main() {
    # Parse charts from environment variable
    if [ -z "${CHARTS_TO_TEST:-}" ]; then
        echo "No charts to test"
        exit 0
    fi
    
    # Convert JSON array to bash array
    readarray -t charts < <(echo "${CHARTS_TO_TEST}" | jq -r '.[]')
    
    if [ ${#charts[@]} -eq 0 ]; then
        echo "No charts to test"
        exit 0
    fi
    
    echo "🧪 Testing ${#charts[@]} chart(s) on Kubernetes ${KUBERNETES_VERSION}: ${charts[*]}"
    echo ""
    
    # Process each chart
    for chart in "${charts[@]}"; do
        test_chart "${chart}" || true
    done
    
    
    # Exit with error if any charts failed
    [ ${#FAILED[@]} -eq 0 ] || exit 1
}

main "$@"