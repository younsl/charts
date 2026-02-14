#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
README_FILE="$ROOT_DIR/README.md"
CHARTS_DIR="$ROOT_DIR/charts"

# Marker comments used to identify the auto-generated section
MARKER_START="<!-- CHARTS_TABLE_START -->"
MARKER_END="<!-- CHARTS_TABLE_END -->"

generate_charts_section() {
    local active=0 deprecated=0

    for chart_yaml in "$CHARTS_DIR"/*/Chart.yaml; do
        [ -f "$chart_yaml" ] || continue
        if [ "$(yq eval '.deprecated // false' "$chart_yaml")" = "true" ]; then
            deprecated=$((deprecated + 1))
        else
            active=$((active + 1))
        fi
    done

    local total=$((active + deprecated))

    echo "$MARKER_START"
    echo "## Available Charts"
    echo ""
    echo "This repository contains **${total}** Helm charts (${active} active, ${deprecated} deprecated)."
    echo ""
    echo "| Chart | Version | App Version | Status | Description |"
    echo "|-------|---------|-------------|--------|-------------|"

    for chart_yaml in "$CHARTS_DIR"/*/Chart.yaml; do
        [ -f "$chart_yaml" ] || continue

        local chart_name version app_version deprecated description status

        chart_name=$(yq eval '.name' "$chart_yaml")
        version=$(yq eval '.version' "$chart_yaml")
        app_version=$(yq eval '.appVersion // "-"' "$chart_yaml")
        deprecated=$(yq eval '.deprecated // false' "$chart_yaml")
        description=$(yq eval '.description' "$chart_yaml" | head -n1 | sed 's/|//g' | xargs)

        if [ "$deprecated" = "true" ]; then
            status="Deprecated"
        else
            status="Active"
        fi

        if [ ${#description} -gt 80 ]; then
            description="${description:0:77}..."
        fi

        echo "| [\`${chart_name}\`](charts/${chart_name}) | ${version} | ${app_version} | ${status} | ${description} |"
    done

    echo "$MARKER_END"
}

# --- Validation -----------------------------------------------------------

if ! command -v yq &>/dev/null; then
    echo "Error: yq is not installed. Please install yq first."
    echo "Visit: https://github.com/mikefarah/yq#install"
    exit 1
fi

if [ ! -f "$README_FILE" ]; then
    echo "Error: README.md not found at $README_FILE"
    exit 1
fi

# --- Generate & inject ----------------------------------------------------

section=$(generate_charts_section)

if grep -q "$MARKER_START" "$README_FILE"; then
    # Replace existing section between markers
    # 1. Print lines before MARKER_START
    # 2. Print new section
    # 3. Print lines after MARKER_END
    {
        sed -n "1,/${MARKER_START}/{ /${MARKER_START}/!p; }" "$README_FILE"
        echo "$section"
        sed -n "/${MARKER_END}/,\${ /${MARKER_END}/!p; }" "$README_FILE"
    } > "${README_FILE}.tmp"
    mv "${README_FILE}.tmp" "$README_FILE"
    echo "Updated existing Available Charts section in $README_FILE"
else
    # Insert section before the first heading after the badge/intro block
    # Strategy: append after the intro paragraph, before ## Documentation
    {
        sed -n '1,/^## Documentation/{ /^## Documentation/!p; }' "$README_FILE"
        echo ""
        echo "$section"
        echo ""
        sed -n '/^## Documentation/,$p' "$README_FILE"
    } > "${README_FILE}.tmp"
    mv "${README_FILE}.tmp" "$README_FILE"
    echo "Inserted Available Charts section into $README_FILE"
fi
