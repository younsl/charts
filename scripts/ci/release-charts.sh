#!/bin/bash
set -euo pipefail

# Package and push multiple Helm charts to OCI registry
# Uses CHARTS_TO_RELEASE environment variable containing JSON array

REGISTRY="${REGISTRY:-ghcr.io}"
REPOSITORY_OWNER="${GITHUB_REPOSITORY_OWNER}"

# Arrays for tracking results
RELEASED=()
SKIPPED=()
FAILED=()

release_chart() {
    local chart_name="${1}"
    local chart_dir="charts/${chart_name}"
    local chart_version
    
    chart_version=$(yq eval '.version' "${chart_dir}/Chart.yaml")
    
    echo "📦 Processing ${chart_name}:${chart_version}"
    
    # Check if version already exists in OCI registry
    local oci_url="oci://${REGISTRY}/${REPOSITORY_OWNER}/charts/${chart_name}"
    echo "🔍 Checking if ${chart_name}:${chart_version} already exists..."
    
    if helm pull "${oci_url}" --version "${chart_version}" --destination /tmp/check 2>/dev/null; then
        SKIPPED+=("${chart_name}|${chart_version}|Version already exists in registry")
        echo "⏭️ Skipped ${chart_name}:${chart_version} (version already exists in registry)"
        rm -rf /tmp/check
        return 0
    fi
    rm -rf /tmp/check 2>/dev/null || true
    
    # Package the chart
    if ! helm package "${chart_dir}" --destination /tmp 2>/dev/null; then
        FAILED+=("${chart_name}|-|Failed to package")
        return 1
    fi
    
    # Push to OCI registry
    local output
    output=$(helm push "/tmp/${chart_name}-${chart_version}.tgz" \
        "oci://${REGISTRY}/${REPOSITORY_OWNER}/charts" 2>&1)
    
    if [ $? -eq 0 ]; then
        RELEASED+=("${chart_name}|${chart_version}|oci://${REGISTRY}/${REPOSITORY_OWNER}/charts/${chart_name}")
        echo "✅ Released ${chart_name}:${chart_version}"
    else
        FAILED+=("${chart_name}|${chart_version}|Push failed: ${output}")
        echo "❌ Failed ${chart_name}:${chart_version}: ${output}"
        return 1
    fi
    
    # Cleanup
    rm -f "/tmp/${chart_name}-${chart_version}.tgz"
}

generate_summary() {
    {
        echo "## 📦 Helm Charts Release Summary"
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
main() {
    # Parse charts from environment variable
    if [ -z "${CHARTS_TO_RELEASE:-}" ]; then
        echo "No charts to release"
        exit 0
    fi
    
    # Convert JSON array to bash array
    readarray -t charts < <(echo "${CHARTS_TO_RELEASE}" | jq -r '.[]')
    
    if [ ${#charts[@]} -eq 0 ]; then
        echo "No charts to release"
        exit 0
    fi
    
    echo "📦 Releasing ${#charts[@]} chart(s): ${charts[*]}"
    echo ""
    
    # Process each chart
    for chart in "${charts[@]}"; do
        release_chart "${chart}" || true
    done
    
    # Generate summary
    generate_summary
    
    # Exit with error if any charts failed
    [ ${#FAILED[@]} -eq 0 ] || exit 1
}

main "$@"