# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Helm charts repository that distributes charts via OCI artifacts on GitHub Container Registry (ghcr.io). The repository contains production-ready Helm charts for Kubernetes deployments.

## Available Charts

### Active Charts
- **argocd-apps** (v1.7.0): Management of ArgoCD Applications and AppProjects via ApplicationSet
- **karpenter-nodepool** (v1.5.1): AWS Karpenter NodePool and EC2NodeClass resources for autoscaling
- **kube-green-sleepinfos** (v0.1.1): SleepInfo resources for kube-green to schedule resource hibernation
- **rbac** (v0.2.1): Kubernetes RBAC resources (ServiceAccount, ClusterRole, ClusterRoleBinding)
- **squid** (v0.4.0): Squid caching proxy with Grafana dashboard integration

### Deprecated Charts
- **actions-runner** (v0.1.4): GitHub Actions self-hosted runner for Kubernetes (deprecated - use Actions Runner Controller)
- **backup-utils** (v0.5.0): GitHub Enterprise Server backup utilities (deprecated - use built-in backup service)

## Common Development Commands

### Documentation
```bash
# Generate documentation for all charts using shared template
make docs

# Generate docs for specific chart (uses ci/README.md.gotmpl template)
helm-docs --chart-search-root charts/<chart-name> --template-files=ci/README.md.gotmpl
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
CHARTS_TO_TEST='["<chart-name>"]' KUBERNETES_VERSION="1.32.5" scripts/ci/test-charts.sh
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
scripts/ci/detect-changed-charts.sh

# Run chart release process
scripts/ci/release-charts.sh

# Update chart catalog documentation
scripts/ci/update-chart-catalog.sh
```

## Architecture and Structure

### Directory Layout
- `charts/`: Contains all Helm charts, each in its own directory
- `.github/workflows/`: CI/CD pipelines for automated testing and releases
- Each chart follows standard Helm structure:
  - `Chart.yaml`: Chart metadata and dependencies
  - `values.yaml`: Default configuration values
  - `templates/`: Kubernetes resource templates
  - `ci/`: Test values for CI testing
  - `README.md`: Chart-specific documentation

### CI/CD Pipeline
The repository uses GitHub Actions for:
1. **Pull Request Validation**: PR title format enforcement (`[charts/<chart-name>] description`)
2. **Release Process**: Triggered by Chart.yaml changes or manual dispatch
   - Multi-version testing on Kubernetes 1.30.13, 1.31.9, 1.32.5
   - Packages and pushes charts to OCI registry (ghcr.io/younsl/charts)
   - Smart change detection via `scripts/ci/detect-changed-charts.sh`
3. **Documentation**: Auto-generates chart catalog and README files using helm-docs

### Chart Development Guidelines
- All charts require Helm 3.8.0+ and Kubernetes 1.21.0+
- Charts are distributed via OCI registry, not traditional Helm repositories
- Each chart includes comprehensive values documentation
- Test values are provided in `ci/` directory for validation
- Charts follow semantic versioning

## Key Technical Details

### OCI Registry Usage
Charts are published to `ghcr.io/younsl/charts` as OCI artifacts. This provides:
- Better security with container registry authentication
- Improved performance with parallel layer downloads
- Integration with existing container workflows

### Testing Strategy
- Unit tests: Template rendering validation
- Integration tests: Installation in Kind clusters
- CI tests: Automated validation on pull requests

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
3. Creates Kind cluster with custom configuration
4. Performs dry-run validation
5. Installs chart using ci/test-values.yaml (if present)
6. Runs `helm test` if test resources exist
7. Cleans up test resources

### Special Considerations
- **actions-runner**: Requires GitHub PAT for runner registration (deprecated)
- **argocd-apps**: Manages ArgoCD CRDs, requires ArgoCD to be installed
- **karpenter-nodepool**: AWS-specific, requires Karpenter controller
- **kube-green-sleepinfos**: Requires kube-green operator
- **squid**: Includes Grafana dashboard ConfigMap for monitoring

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
7. CI will automatically test on Kubernetes 1.30.13, 1.31.9, 1.32.5

## Troubleshooting

### Common Issues
- **Chart testing fails**: Check if chart has skip-test annotation or requires external dependencies
- **Documentation not updating**: Ensure `make docs` was run and ci/README.md.gotmpl template is correct
- **Release pipeline fails**: Verify Chart.yaml version bump and OCI registry authentication
- **PR validation fails**: Check PR title format matches `[charts/<chart-name>] description`

### Debugging Commands
```bash
# Test specific chart locally like CI does
CHARTS_TO_TEST='["chart-name"]' KUBERNETES_VERSION="1.32.5" scripts/ci/test-charts.sh

# Check what changes CI would detect
scripts/ci/detect-changed-charts.sh

# Verify chart can be packaged
helm package charts/<chart-name> --destination /tmp
```