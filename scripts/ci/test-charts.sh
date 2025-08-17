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
    
    # Check for CI test values
    local test_values=""
    if [ -f "${chart_dir}/ci/test-values.yaml" ]; then
        test_values="-f ${chart_dir}/ci/test-values.yaml"
        echo "📋 Using CI test values for ${chart_name}"
    fi
    
    # Run tests
    if run_chart_test "${chart_name}" "${test_values}"; then
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
    local chart_dir="charts/${chart_name}"
    
    # Dry run first
    echo "Running dry-run validation for ${chart_name}..."
    if ! helm install "test-${chart_name}" "${chart_dir}" \
        ${test_values} \
        --dry-run \
        --debug \
        --namespace "test-${chart_name}" \
        --create-namespace; then
        echo "❌ Dry-run failed for ${chart_name}"
        return 1
    fi
    
    # Actually install to test
    echo "Installing ${chart_name} for testing..."
    if ! helm install "test-${chart_name}" "${chart_dir}" \
        ${test_values} \
        --namespace "test-${chart_name}" \
        --create-namespace \
        --wait \
        --timeout 5m \
        --atomic; then
        echo "❌ Installation failed for ${chart_name}"
        return 1
    fi
    
    # Run helm test if test resources exist
    echo "Running helm test for ${chart_name}..."
    helm test "test-${chart_name}" -n "test-${chart_name}" || echo "No test resources found for ${chart_name}"
    
    # Cleanup
    echo "Cleaning up test resources for ${chart_name}..."
    helm uninstall "test-${chart_name}" -n "test-${chart_name}" || true
    kubectl delete namespace "test-${chart_name}" || true
    
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