# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Helm charts repository that distributes charts via OCI artifacts on GitHub Container Registry (ghcr.io). The repository contains production-ready Helm charts for Kubernetes deployments.

## Available Charts

- **actions-runner**: GitHub Actions self-hosted runner for Kubernetes
- **argocd-apps**: Management of ArgoCD Applications and AppProjects via ApplicationSet
- **backup-utils**: Kubernetes backup utilities with persistent state management
- **karpenter-nodepool**: AWS Karpenter NodePool and EC2NodeClass resources for autoscaling
- **kube-green-sleepinfos**: SleepInfo resources for kube-green to schedule resource hibernation
- **rbac**: Kubernetes RBAC resources (ServiceAccount, ClusterRole, ClusterRoleBinding)
- **squid**: Squid caching proxy with Grafana dashboard integration

## Common Development Commands

### Documentation
```bash
# Generate documentation for all charts
make docs

# Generate docs for specific chart
helm-docs charts/<chart-name>
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

# Test with specific values
helm install test-release charts/<chart-name> -f charts/<chart-name>/ci/test-values.yaml
```

### Building and Publishing
```bash
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
1. **Pull Request Validation**: Lints and tests charts on PR
2. **Release Process**: Packages and pushes charts to OCI registry on tagged releases
3. **Documentation**: Auto-generates chart documentation using helm-docs

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

### Special Considerations
- **actions-runner**: Requires GitHub PAT for runner registration
- **argocd-apps**: Manages ArgoCD CRDs, requires ArgoCD to be installed
- **karpenter-nodepool**: AWS-specific, requires Karpenter controller
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

When working with this repository:
1. Always validate charts with `helm lint` before committing
2. Update chart version in Chart.yaml when making changes
3. Run `make docs` after modifying chart values or templates
4. Test installation with dry-run before actual deployment
5. Use OCI registry commands for distribution, not traditional repo commands