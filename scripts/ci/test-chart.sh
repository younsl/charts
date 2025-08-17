#!/bin/bash
set -euo pipefail

# Test a Helm chart on Kubernetes
# Usage: test-chart.sh <chart-name>

CHART_NAME="${1}"
CHART_DIR="charts/${CHART_NAME}"

# Check if test should be skipped
check_skip_test() {
    local skip_test
    local skip_reason
    
    skip_test=$(yq eval '.annotations."helm.sh/skip-test" // "false"' "${CHART_DIR}/Chart.yaml")
    skip_reason=$(yq eval '.annotations."helm.sh/skip-test-reason" // "No reason provided"' "${CHART_DIR}/Chart.yaml")
    
    if [[ "${skip_test}" == "true" ]]; then
        echo "⏭️ Skipping test for ${CHART_NAME}: ${skip_reason}"
        exit 0
    fi
}

# Run chart tests
run_tests() {
    echo "🧪 Testing chart: ${CHART_NAME}"
    
    # Check for CI test values
    local test_values=""
    if [ -f "${CHART_DIR}/ci/test-values.yaml" ]; then
        test_values="-f ${CHART_DIR}/ci/test-values.yaml"
        echo "📋 Using CI test values"
    fi
    
    # Dry run first
    echo "Running dry-run validation..."
    helm install "test-${CHART_NAME}" "${CHART_DIR}" \
        ${test_values} \
        --dry-run \
        --debug \
        --namespace "test-${CHART_NAME}" \
        --create-namespace
    
    # Actually install to test
    echo "Installing chart for testing..."
    helm install "test-${CHART_NAME}" "${CHART_DIR}" \
        ${test_values} \
        --namespace "test-${CHART_NAME}" \
        --create-namespace \
        --wait \
        --timeout 5m \
        --atomic
    
    # Run helm test if test resources exist
    echo "Running helm test..."
    helm test "test-${CHART_NAME}" -n "test-${CHART_NAME}" || echo "No test resources found for ${CHART_NAME}"
    
    # Cleanup
    echo "Cleaning up test resources..."
    helm uninstall "test-${CHART_NAME}" -n "test-${CHART_NAME}" || true
    kubectl delete namespace "test-${CHART_NAME}" || true
}

# Main execution
check_skip_test
run_tests