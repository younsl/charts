# .github Directory Structure

This directory contains all GitHub-related configurations, scripts, and templates for the Helm charts repository.

## Directory Tree

```
.github/
├── workflows/                    # GitHub Actions CI/CD pipelines
├── scripts/                      # CI/CD automation scripts
│   ├── detect-changed-charts.sh  # Detect changed charts for CI
│   ├── test-charts.sh            # Test charts in Kind cluster
│   ├── release-charts.sh         # Package & push to OCI registry
│   └── update-chart-catalog.sh   # Generate chart catalog docs
└── templates/                    # Documentation templates
    └── README.md.gotmpl          # helm-docs template for charts
```

## Directory Layout

### workflows/

GitHub Actions workflow definitions for CI/CD automation:
- **`release-helm-chart.yml`**: Automated chart testing and release to OCI registry (ghcr.io)
  - Triggers on Chart.yaml changes or manual dispatch
  - Tests on multiple Kubernetes versions (1.31.9, 1.32.5, 1.33.2)
  - Packages and pushes charts as OCI artifacts
- **`update-chart-catalog.yml`**: Auto-generates chart catalog documentation
  - Updates docs/chart-catalog.md when charts change
  - Creates automated pull requests with documentation updates
- **`pr-title-check.yml`**: Validates pull request title format
  - Enforces format: `[charts/<chart-name>] description`
  - Provides automated feedback on invalid titles
- **`helm-docs-check.yml`**: Validates helm-docs generated documentation
  - Ensures README files are up-to-date with chart values
- **`cleanup-workflow-runs.yml`**: Maintenance workflow for cleaning old workflow runs
  - Runs daily at 1 AM UTC

### scripts/

CI/CD automation scripts used by GitHub Actions workflows:
- **`detect-changed-charts.sh`**: Detects which charts have changed
  - Used by release workflow to determine what to test/release
  - Supports both automatic detection and manual chart specification
- **`test-charts.sh`**: Comprehensive chart testing script
  - Creates Kind cluster with custom configuration
  - Runs helm lint, dry-run validation, and helm test
  - Supports multiple test value files per chart
- **`release-charts.sh`**: Packages and pushes charts to OCI registry
  - Checks for version duplicates in registry
  - Generates GitHub Actions step summaries
  - Handles atomic chart releases
- **`update-chart-catalog.sh`**: Generates chart catalog documentation
  - Reads all Chart.yaml files and creates markdown table
  - Includes version, description, and deprecation status

### templates/
Shared templates for documentation generation:
- **`README.md.gotmpl`**: helm-docs template for chart README files
  - Used by `make docs` command
  - Ensures consistent documentation format across all charts
  - Generates documentation from Chart.yaml and values.yaml

## Usage

### Running Scripts Locally

```bash
# Test specific chart like CI does
CHARTS_TO_TEST='["rbac"]' KUBERNETES_VERSION="1.33.2" .github/scripts/test-charts.sh

# Check what changes CI would detect
.github/scripts/detect-changed-charts.sh

# Update chart catalog
.github/scripts/update-chart-catalog.sh

# Generate documentation for all charts
make docs
```

### Workflow Triggers

- **Release workflow**: Push to main with Chart.yaml changes or manual dispatch
- **Documentation update**: Push to main with chart changes
- **PR validation**: On every pull request
- **Cleanup**: Daily at 1 AM UTC

## Development Guidelines

1. All CI/CD scripts should be executable and include proper error handling
2. Scripts should support both GitHub Actions environment and local execution
3. Use environment variables for configuration (with sensible defaults)
4. Include detailed logging for debugging purposes
5. Follow shellcheck recommendations for shell scripts

## Environment Variables

Key environment variables used by scripts:
- `CHARTS_TO_TEST`: JSON array of chart names to test
- `CHARTS_TO_RELEASE`: JSON array of chart names to release
- `KUBERNETES_VERSION`: Kubernetes version for testing
- `REGISTRY`: OCI registry URL (default: ghcr.io)
- `CHARTS_DIR`: Directory containing charts (default: ./charts)
