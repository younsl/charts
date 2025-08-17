#!/bin/bash
set -euo pipefail

# Package and push a Helm chart to OCI registry
# Usage: release-chart.sh <chart-name>

CHART_NAME="${1}"
CHART_DIR="charts/${CHART_NAME}"
REGISTRY="${REGISTRY:-ghcr.io}"
REPOSITORY_OWNER="${GITHUB_REPOSITORY_OWNER}"

# Arrays for tracking results
RELEASED=()
SKIPPED=()
FAILED=()

release_chart() {
    local chart_version
    chart_version=$(yq eval '.version' "${CHART_DIR}/Chart.yaml")
    
    echo "📦 Processing ${CHART_NAME}:${chart_version}"
    
    # Check if version already exists in OCI registry
    local oci_url="oci://${REGISTRY}/${REPOSITORY_OWNER}/charts/${CHART_NAME}"
    echo "🔍 Checking if ${CHART_NAME}:${chart_version} already exists..."
    
    if helm pull "${oci_url}" --version "${chart_version}" --destination /tmp/check 2>/dev/null; then
        SKIPPED+=("${CHART_NAME}|${chart_version}|Version already exists in registry")
        echo "⏭️ Skipped ${CHART_NAME}:${chart_version} (version already exists in registry)"
        rm -rf /tmp/check
        return 0
    fi
    rm -rf /tmp/check 2>/dev/null || true
    
    # Package the chart
    if ! helm package "${CHART_DIR}" --destination /tmp 2>/dev/null; then
        FAILED+=("${CHART_NAME}|-|Failed to package")
        return 1
    fi
    
    # Push to OCI registry
    local output
    output=$(helm push "/tmp/${CHART_NAME}-${chart_version}.tgz" \
        "oci://${REGISTRY}/${REPOSITORY_OWNER}/charts" 2>&1)
    
    if [ $? -eq 0 ]; then
        RELEASED+=("${CHART_NAME}|${chart_version}|oci://${REGISTRY}/${REPOSITORY_OWNER}/charts/${CHART_NAME}")
        echo "✅ Released ${CHART_NAME}:${chart_version}"
    else
        FAILED+=("${CHART_NAME}|${chart_version}|Push failed: ${output}")
        echo "❌ Failed ${CHART_NAME}:${chart_version}: ${output}"
        return 1
    fi
    
    # Cleanup
    rm -f "/tmp/${CHART_NAME}-${chart_version}.tgz"
}

generate_summary() {
    {
        echo "## 📦 Helm Chart Release Summary"
        echo ""
        echo "| Status | Chart | Version | Details |"
        echo "|--------|-------|---------|---------|"
        
        for item in "${RELEASED[@]}"; do
            IFS='|' read -r name version location <<< "${item}"
            echo "| ✅ Released | ${name} | ${version} | \`${location}\` |"
        done
        
        for item in "${SKIPPED[@]}"; do
            IFS='|' read -r name version reason <<< "${item}"
            echo "| ⏭️ Skipped | ${name} | ${version} | ${reason} |"
        done
        
        for item in "${FAILED[@]}"; do
            IFS='|' read -r name version reason <<< "${item}"
            echo "| ❌ Failed | ${name} | ${version} | ${reason} |"
        done
        
        echo ""
        echo "### Summary"
        echo "- ✅ Released: ${#RELEASED[@]}"
        echo "- ⏭️ Skipped: ${#SKIPPED[@]}"
        echo "- ❌ Failed: ${#FAILED[@]}"
    } >> "${GITHUB_STEP_SUMMARY}"
}

# Main execution
release_chart
generate_summary

# Exit with error if chart failed
[ ${#FAILED[@]} -eq 0 ] || exit 1