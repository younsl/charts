#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CATALOG_FILE="$ROOT_DIR/docs/chart-catalog.md"
CHARTS_DIR="$ROOT_DIR/charts"

generate_catalog() {
    cat <<'EOF'
# Helm Charts Catalog

This catalog provides an overview of all Helm charts available in this repository. Charts are distributed via OCI artifacts on GitHub Container Registry (ghcr.io).

## Installation

### Install directly from OCI registry

```bash
helm install <release-name> oci://ghcr.io/younsl/charts/<chart-name> --version <version>
```

### Download chart locally

You can download and extract charts to your local filesystem:

```bash
# Download and extract the chart
helm pull oci://ghcr.io/younsl/charts/<chart-name> --version <version> --untar

# Download without extracting
helm pull oci://ghcr.io/younsl/charts/<chart-name> --version <version>
```

## Available Charts

| Chart Name | Version | App Version | Status | Description |
|------------|---------|-------------|--------|-------------|
EOF

    for chart_yaml in "$CHARTS_DIR"/*/Chart.yaml; do
        if [ -f "$chart_yaml" ]; then
            chart_dir=$(dirname "$chart_yaml")
            chart_name=$(basename "$chart_dir")
            
            name=$(yq eval '.name' "$chart_yaml")
            version=$(yq eval '.version' "$chart_yaml")
            app_version=$(yq eval '.appVersion // "-"' "$chart_yaml")
            deprecated=$(yq eval '.deprecated // false' "$chart_yaml")
            description=$(yq eval '.description' "$chart_yaml" | head -n1 | sed 's/|//g' | xargs)
            
            if [ "$deprecated" = "true" ]; then
                status="⚠️ Deprecated"
            else
                status="✅ Active"
            fi
            
            if [ ${#description} -gt 80 ]; then
                description="${description:0:77}..."
            fi
            
            echo "| [$name](https://github.com/younsl/charts/tree/main/charts/$chart_name) | $version | $app_version | $status | $description |"
        fi
    done

    cat <<'EOF'

## Chart Details
EOF

    for chart_yaml in "$CHARTS_DIR"/*/Chart.yaml; do
        if [ -f "$chart_yaml" ]; then
            name=$(yq eval '.name' "$chart_yaml")
            version=$(yq eval '.version' "$chart_yaml")
            app_version=$(yq eval '.appVersion // ""' "$chart_yaml")
            deprecated=$(yq eval '.deprecated // false' "$chart_yaml")
            description=$(yq eval '.description' "$chart_yaml")
            keywords=$(yq eval '.keywords // [] | join(", ")' "$chart_yaml")
            if [ -z "$keywords" ] || [ "$keywords" = "null" ]; then
                keywords="-"
            fi
            deprecation_msg=$(yq eval '.annotations."helm.sh/deprecation-message" // ""' "$chart_yaml")
            
            if [ "$deprecated" = "true" ]; then
                status="⚠️ Deprecated"
            else
                status="✅ Active"
            fi
            
            echo ""
            echo "### $name"
            echo "**Status:** $status  "
            echo "**Version:** $version  "
            if [ -n "$app_version" ] && [ "$app_version" != "null" ]; then
                echo "**App Version:** $app_version  "
            fi
            if [ "$keywords" != "-" ] && [ "$keywords" != "null" ]; then
                echo "**Keywords:** $keywords  "
            fi
            echo ""
            
            first_line=$(echo "$description" | head -n1 | sed 's/^[[:space:]]*//')
            echo "$first_line"
            
            if [ -n "$deprecation_msg" ] && [ "$deprecation_msg" != "null" ]; then
                echo ""
                first_deprecation_line=$(echo "$deprecation_msg" | head -n1 | sed 's/^[[:space:]]*//')
                echo "> **Deprecation Notice:** $first_deprecation_line"
            fi
        fi
    done

    cat <<EOF

## Requirements

- Helm 3.8.0+
- Kubernetes 1.21.0+

## Contributing

For contributing to these charts, please refer to the [main repository](https://github.com/younsl/charts).

---

*Last updated: $(date +%Y-%m-%d)*
EOF
}

if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Please install yq first."
    echo "Visit: https://github.com/mikefarah/yq#install"
    exit 1
fi

YQ_VERSION=$(yq --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
REQUIRED_VERSION="4.0.0"

version_ge() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

if ! version_ge "$YQ_VERSION" "$REQUIRED_VERSION"; then
    echo "Error: yq version $YQ_VERSION is too old. Required version: $REQUIRED_VERSION or higher."
    echo "Please upgrade yq: https://github.com/mikefarah/yq#install"
    exit 1
fi

echo "Using yq version: $YQ_VERSION"

echo "Generating chart catalog..."
generate_catalog > "$CATALOG_FILE"
echo "Chart catalog updated at: $CATALOG_FILE"
