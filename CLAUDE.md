# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Helm charts repository that distributes charts via OCI artifacts on GitHub Container Registry (ghcr.io). The repository contains production-ready Helm charts for Kubernetes deployments.

## Available Charts

### Active Charts
- **argocd-apps** (v1.7.0): Management of ArgoCD Applications and AppProjects via ApplicationSet
- **karpenter-nodepool** (v1.5.1): AWS Karpenter NodePool and EC2NodeClass resources for autoscaling with overprovisioning support
- **kube-green-sleepinfos** (v0.1.1): SleepInfo resources for kube-green to schedule resource hibernation
- **rbac** (v0.3.0): Kubernetes RBAC resources (ServiceAccount, ClusterRole, ClusterRoleBinding) - only chart with CI tests enabled
- **squid** (v0.6.0): Squid caching proxy with Grafana dashboard integration and extra manifests support

### Deprecated Charts
- **actions-runner** (v0.1.4): GitHub Actions self-hosted runner for Kubernetes (deprecated - use Actions Runner Controller)
- **backup-utils** (v0.5.0): GitHub Enterprise Server backup utilities (deprecated - use built-in backup service)

## Common Development Commands

### Documentation
```bash
# Generate documentation for all charts using shared template
make docs

# Generate docs for specific chart (uses .github/templates/README.md.gotmpl template)
helm-docs --chart-search-root charts/<chart-name> --template-files=.github/templates/README.md.gotmpl

# Update chart catalog documentation
.github/scripts/update-chart-catalog.sh
```

### Linting and Validation
```bash
# Lint a specific chart
helm lint charts/<chart-name>

# Template a chart to validate rendering
helm template <release-name> charts/<chart-name>

# Dry-run installation to validate against cluster
helm install <release-name> charts/<chart-name> --dry-run --debug
```

### Testing
```bash
# Run local tests with Kind cluster
kind create cluster
helm install test-release charts/<chart-name>
helm test test-release

# Test with specific CI values (if chart has ci/test-values.yaml)
helm install test-release charts/<chart-name> -f charts/<chart-name>/ci/test-values.yaml

# Use CI script for comprehensive testing (mimics GitHub Actions)
CHARTS_TO_TEST='["<chart-name>"]' KUBERNETES_VERSION="1.33.2" .github/scripts/test-charts.sh
```

### Chart Discovery and Registry Operations
```bash
# List available chart versions in registry
crane ls ghcr.io/younsl/charts/<chart-name>

# Show chart information
helm show chart oci://ghcr.io/younsl/charts/<chart-name>
helm show values oci://ghcr.io/younsl/charts/<chart-name>

# Package a chart
helm package charts/<chart-name>

# Push to OCI registry (requires authentication)
helm push <chart-name>-<version>.tgz oci://ghcr.io/younsl/charts
```

### Installing Charts
```bash
# Install from OCI registry
helm install <release-name> oci://ghcr.io/younsl/charts/<chart-name> --version <version>

# Install with custom values
helm install <release-name> oci://ghcr.io/younsl/charts/<chart-name> \
  --version <version> \
  --values custom-values.yaml
```

### CI/CD Operations
```bash
# Detect changed charts (like CI does)
.github/scripts/detect-changed-charts.sh

# Run chart release process
.github/scripts/release-charts.sh

# Update chart catalog documentation
.github/scripts/update-chart-catalog.sh

# Clean commit history (maintenance utility)
scripts/commit-history-cleaner.sh
```

## Architecture and Structure

### Directory Layout
- `charts/`: Contains all Helm charts, each in its own directory
- `.github/workflows/`: CI/CD pipelines for automated testing and releases
- `.github/scripts/`: Automation scripts for testing, releasing, and documentation
- `.github/templates/`: Shared templates for documentation generation (helm-docs)
- `scripts/`: Utility scripts (e.g., commit history cleaner)
- `docs/`: Repository documentation including chart catalog and OCI background
- Each chart follows standard Helm structure:
  - `Chart.yaml`: Chart metadata and dependencies
  - `values.yaml`: Default configuration values
  - `templates/`: Kubernetes resource templates
  - `ci/`: Test values for CI testing
  - `README.md`: Chart-specific documentation

### CI/CD Pipeline
The repository uses GitHub Actions for:
1. **Pull Request Validation**: 
   - PR title format enforcement (`[charts/<chart-name>] description`)
   - Automated commenting on invalid PR titles
   - Regex validation: `^\\[charts\\/[a-z0-9-]+\\]`

2. **Release Process**: Triggered by Chart.yaml changes or manual dispatch
   - Multi-version testing on Kubernetes 1.31.9, 1.32.5, 1.33.2
   - Packages and pushes charts to OCI registry (ghcr.io/younsl/charts)
   - Smart change detection via `.github/scripts/detect-changed-charts.sh`
   - Version duplicate checking against OCI registry
   - GitHub Actions step summaries for release tracking
   - Atomic installations with automatic rollback on failure

3. **Documentation**: 
   - Auto-generates chart catalog and README files using helm-docs
   - Chart catalog workflow runs on push to main branch
   - Uses shared gotmpl template (.github/templates/README.md.gotmpl) for consistent documentation

4. **Maintenance**:
   - Automated workflow run cleanup (daily at 1 AM UTC)
   - Dependabot for dependency updates with automatic reviewer assignment

### Chart Development Guidelines
- All charts require Helm 3.8.0+ and Kubernetes 1.21.0+
- Charts are distributed via OCI registry, not traditional Helm repositories
- Each chart includes comprehensive values documentation
- Test values are provided in `ci/` directory for validation
- Charts follow semantic versioning
- CI uses Helm v3.18.0 and yq v4.47.1 for processing

## Key Technical Details

### OCI Registry Usage
Charts are published to `ghcr.io/younsl/charts` as OCI artifacts. This provides:
- Better security with container registry authentication
- Improved performance with parallel layer downloads
- Integration with existing container workflows
- Version duplicate prevention via registry queries

### Testing Strategy
- Unit tests: Template rendering validation
- Integration tests: Installation in Kind clusters with custom API server tuning
- CI tests: Automated validation on pull requests
- Only `rbac` chart has full CI tests enabled (other charts require external dependencies)

### Chart Testing and CI Behavior
Charts can control CI testing behavior using annotations in Chart.yaml:
```yaml
annotations:
  "helm.sh/skip-test": "true"
  "helm.sh/skip-test-reason": "Requires external dependencies"
```

The CI testing process:
1. Detects changed charts via git diff on Chart.yaml files
2. Runs `helm lint` validation
3. Creates Kind cluster with custom configuration (API server performance tuning)
4. Performs dry-run validation
5. Discovers and runs all test files matching `charts/<chart-name>/ci/*.yaml`
6. Installs chart using discovered test values
7. Runs `helm test` if test resources exist and skip-test is false
8. Captures comprehensive logs and results
9. Cleans up test resources

### Special Considerations
- **actions-runner**: Requires GitHub PAT for runner registration (deprecated)
- **argocd-apps**: Manages ArgoCD CRDs, requires ArgoCD to be installed
- **karpenter-nodepool**: AWS-specific, requires Karpenter controller, includes overprovisioning with dummy deployments
- **kube-green-sleepinfos**: Requires kube-green operator
- **rbac**: Only chart with full CI testing enabled (skip-test: false)
- **squid**: Includes Grafana dashboard ConfigMap and extra-manifests.yaml template for additional resources

## Best Practice References

When developing or improving charts in this repository, use the following repositories as best practice references:
- **Bitnami Charts** (https://github.com/bitnami/charts): Industry-standard patterns for chart structure, templating, and documentation
- **Delivery Hero Helm Charts** (https://github.com/deliveryhero/helm-charts): Production-grade examples of complex chart implementations and CI/CD workflows

Study these repositories for guidance on:
- Chart templating patterns and helper functions
- Values schema design and validation
- Testing strategies and CI pipelines
- Documentation standards and README structure
- Security best practices and RBAC patterns

## Development Workflow

When working with this repository:
1. Always validate charts with `helm lint` before committing
2. Update chart version in Chart.yaml when making changes
3. Run `make docs` after modifying chart values or templates
4. Test installation with dry-run before actual deployment
5. Use OCI registry commands for distribution, not traditional repo commands
6. For PRs, ensure title follows format: `[charts/<chart-name>] description`
7. CI will automatically test on Kubernetes 1.31.9, 1.32.5, 1.33.2
8. Check for version duplicates in OCI registry before releasing

## Troubleshooting

### Common Issues
- **Chart testing fails**: Check if chart has skip-test annotation or requires external dependencies
- **Documentation not updating**: Ensure `make docs` was run and .github/templates/README.md.gotmpl template is correct
- **Release pipeline fails**: Verify Chart.yaml version bump and OCI registry authentication
- **PR validation fails**: Check PR title format matches `[charts/<chart-name>] description`
- **Version already exists**: Chart version already published to OCI registry, bump version in Chart.yaml

### Debugging Commands
```bash
# Test specific chart locally like CI does
CHARTS_TO_TEST='["chart-name"]' KUBERNETES_VERSION="1.33.2" .github/scripts/test-charts.sh

# Check what changes CI would detect
.github/scripts/detect-changed-charts.sh

# Verify chart can be packaged
helm package charts/<chart-name> --destination /tmp

# Check if version exists in registry
crane ls ghcr.io/younsl/charts/<chart-name> | grep <version>
```

## Repository Maintenance

### Automated Processes
- **Workflow cleanup**: Runs daily at 1 AM UTC to clean old workflow runs
- **Dependabot updates**: Automatic dependency updates for GitHub Actions
- **Chart catalog generation**: Auto-updates on push to main branch

### Manual Maintenance
- **Commit history cleanup**: Use `scripts/commit-history-cleaner.sh` for git history maintenance
- **Chart deprecation**: Update Chart.yaml with deprecated: true and update documentation