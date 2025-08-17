#!/bin/bash
set -euo pipefail

# Detect changed charts based on event type and inputs
# Outputs: charts (JSON array), matrix (JSON object for matrix strategy), has_changes (boolean)

detect_changed_charts() {
    local event_name="${1}"
    local input_chart="${2:-}"
    local charts_to_process=()
    
    if [ "${event_name}" == "workflow_dispatch" ]; then
        if [ -n "${input_chart}" ]; then
            # Specific chart requested
            if [ -f "charts/${input_chart}/Chart.yaml" ]; then
                charts_to_process+=("${input_chart}")
            else
                echo "❌ Chart ${input_chart} not found" >&2
                output_empty_results
                exit 1
            fi
        else
            # All charts requested
            for chart_dir in charts/*/; do
                if [ -f "${chart_dir}/Chart.yaml" ]; then
                    chart=$(basename "${chart_dir}")
                    charts_to_process+=("${chart}")
                fi
            done
        fi
    else
        # Push trigger - detect charts with Chart.yaml changes
        local changed_files
        changed_files=$(git diff --name-only HEAD~1...HEAD | grep '^charts/.*/Chart.yaml$' || true)
        
        if [ -z "${changed_files}" ]; then
            echo "No Chart.yaml changes detected" >&2
            output_empty_results
            exit 0
        fi
        
        # Extract chart names from changed Chart.yaml paths
        while IFS= read -r chart_file; do
            [ -z "${chart_file}" ] && continue
            chart=$(echo "${chart_file}" | cut -d'/' -f2)
            charts_to_process+=("${chart}")
            echo "📦 Detected Chart.yaml change in: ${chart}" >&2
        done <<< "${changed_files}"
    fi
    
    # Output results
    if [ ${#charts_to_process[@]} -eq 0 ]; then
        output_empty_results
    else
        output_results "${charts_to_process[@]}"
    fi
}

output_empty_results() {
    echo "charts=[]" >> "${GITHUB_OUTPUT}"
    echo "has_changes=false" >> "${GITHUB_OUTPUT}"
}

output_results() {
    local charts=("$@")
    local charts_json="["
    local first=true
    
    for chart in "${charts[@]}"; do
        if [ "${first}" = true ]; then
            first=false
        else
            charts_json+=","
        fi
        charts_json+="\"${chart}\""
    done
    
    charts_json+="]"
    
    echo "charts=${charts_json}" >> "${GITHUB_OUTPUT}"
    echo "has_changes=true" >> "${GITHUB_OUTPUT}"
}

# Main execution
detect_changed_charts "${GITHUB_EVENT_NAME}" "${INPUT_CHART:-}"