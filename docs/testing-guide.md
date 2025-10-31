# Helm Chart Testing Guide

Guide for setting up and using Kind-based chart testing environment.

## Table of Contents

- [Test Environment](#test-environment)
- [Local Testing](#local-testing)
- [CI Testing](#ci-testing)
- [Test Configuration](#test-configuration)
- [Troubleshooting](#troubleshooting)

## Test Environment

### CI Environment

| Component | Version | Notes |
|-----------|---------|-------|
| **Runner OS** | ubuntu-24.04 | GitHub Actions runner |
| **Helm** | v3.18.0 | Chart packaging and installation |
| **Kind** | v0.30.0 | Kubernetes in Docker |
| **yq** | v4.48.1 | YAML parsing |
| **jq** | latest | JSON parsing |

### Kubernetes Test Matrix

All charts are tested against the latest 3 minor versions of Kubernetes to ensure compatibility.

| Kubernetes Version | Node Image   | Status    |
|--------------------|--------------|-----------|
| **1.32.8** | kindest/node:v1.32.8 | ✅ Active |
| **1.33.4** | kindest/node:v1.33.4 | ✅ Active |
| **1.34.0** | kindest/node:v1.34.0 | ✅ Active |

### Kind Cluster Configuration

Kind's default API server limits are too low for automated testing. Without these overrides, you may encounter `429 Too Many Requests` errors or random test failures when helm polls the API server repeatedly with `--wait` flag.

**Custom Settings:**

| Setting | Value | Default | Why Override |
|---------|-------|---------|--------------|
| **max-requests-inflight** | 1000 | 400 | Prevent API throttling during helm operations |
| **max-mutating-requests-inflight** | 500 | 200 | Handle concurrent resource creation |

## Local Testing

### Prerequisites

```bash
brew install helm kind yq jq
```

### Quick Start

**1. Create Kind Cluster**

```bash
cat << EOF > /tmp/kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiServer:
      extraArgs:
        max-requests-inflight: "1000"
        max-mutating-requests-inflight: "500"
EOF

kind create cluster --name test --image kindest/node:v1.34.0 --config /tmp/kind-config.yaml
```

**2. Test Chart**

```bash
# Lint
helm lint charts/storage-class

# Dry-run
helm install test charts/storage-class --dry-run --debug

# Install and test
helm install test charts/storage-class \
  --namespace test \
  --create-namespace \
  --wait --timeout 5m

# Cleanup
helm uninstall test -n test
kubectl delete namespace test
```

**3. Using CI Script**

```bash
# Test single chart
CHARTS_TO_TEST='["storage-class"]' \
KUBERNETES_VERSION="1.34.0" \
.github/scripts/test-charts.sh

# Test multiple charts
CHARTS_TO_TEST='["storage-class","rbac"]' \
KUBERNETES_VERSION="1.34.0" \
.github/scripts/test-charts.sh
```

### Test with CI Values Files

```bash
# Test specific scenario
helm install test charts/storage-class \
  -f charts/storage-class/ci/multiple-classes-values.yaml \
  --namespace test --create-namespace --wait
```

## CI Testing

### Automatic Triggers

1. **Push to main** - When Chart.yaml is modified
2. **Manual dispatch** - Manually triggered via GitHub Actions

### Test Flow

```
Detect Chart.yaml changes
    ↓
Run Helm Lint
    ↓
Create Kind cluster (3 versions in parallel)
    ↓
Install and test charts
    ↓
Release to OCI Registry
```

### CI Execution Steps

```bash
# 1. Detect changed charts
.github/scripts/detect-changed-charts.sh

# 2. Lint
helm lint charts/<chart-name>

# 3. Create Kind cluster
kind create cluster --config /tmp/kind-config.yaml

# 4. Run tests
.github/scripts/test-charts.sh
```

## Test Configuration

### Skip CI Tests

Charts requiring external dependencies can skip CI tests by adding annotations to `Chart.yaml`:

```yaml
annotations:
  "helm.sh/skip-test": "true"
  "helm.sh/skip-test-reason": "Requires ArgoCD CRDs and controller"
```

**Example usage:**

```yaml
apiVersion: v2
name: argocd-apps
version: 1.7.0
annotations:
  "helm.sh/skip-test": "true"
  "helm.sh/skip-test-reason": "Requires ArgoCD CRDs and controller"
```

When tests run, the following output appears:

```
[SKIP] Skipping test for argocd-apps: Requires ArgoCD CRDs and controller
```

### CI Test File Structure

```
charts/<chart-name>/ci/
├── default-values.yaml
├── multiple-resources-values.yaml
└── disabled-values.yaml
```

- All `.yaml` files in the `ci/` directory are automatically tested
- Each file represents a separate test scenario
- If `ci/` directory doesn't exist, tests use default values

**Example: storage-class chart**

```
charts/storage-class/ci/
├── multiple-classes-values.yaml  # Test multiple StorageClass resources
└── disabled-values.yaml          # Test disabled scenario
```

## Troubleshooting

### Common Issues

**Installation Failed**
```bash
helm template test charts/storage-class  # Check template rendering
helm lint charts/storage-class           # Validate lint
```

**Timeout**
```bash
helm install test charts/storage-class --timeout 10m
kubectl get pods -n test-namespace
kubectl logs -n test-namespace <pod-name>
```

**Kind Cluster Creation Failed**
```bash
docker ps                        # Check Docker
kind delete cluster --name test  # Delete existing cluster
df -h                            # Check disk space
```

### Debug Commands

```bash
# Helm debug
helm install test charts/storage-class --dry-run --debug

# Cluster status
kind get clusters
kubectl cluster-info

# Check resources
kubectl get all -n test-namespace
helm list -n test-namespace
```

## Chart Development Workflow

```bash
# 1. Modify chart
vim charts/storage-class/values.yaml
vim charts/storage-class/Chart.yaml  # Update version

# 2. Lint
helm lint charts/storage-class

# 3. Local test
kind create cluster
CHARTS_TO_TEST='["storage-class"]' KUBERNETES_VERSION="1.34.0" .github/scripts/test-charts.sh

# 4. Update documentation
make docs

# 5. Commit & Push
git add charts/storage-class/
git commit -m "[charts/storage-class] Add new feature"
git push origin main
```

## References

- [Kind Documentation](https://kind.sigs.k8s.io/)
- [Helm Chart Tests](https://helm.sh/docs/topics/chart_tests/)
- [OCI Registry Guide](./oci-background.md)
