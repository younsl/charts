# charts

[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-packages-black?style=flat-square&logo=github&logoColor=white)](https://github.com/younsl?tab=packages&repo_name=charts)
[![GitHub license](https://img.shields.io/github/license/younsl/charts?style=flat-square&color=black)](https://github.com/younsl/charts/blob/main/LICENSE)

Collection of Helm charts maintained by [@younsl](https://github.com/younsl), distributed via OCI artifacts on GitHub Container Registry.

<!-- CHARTS_TABLE_START -->
## Available Charts

This repository contains **10** Helm charts (9 active, 1 deprecated).

| Chart | Version | App Version | Status | Description |
|-------|---------|-------------|--------|-------------|
| [`actions-runner`](charts/actions-runner) | 0.4.0 | - | Deprecated | A Helm chart for Kubernetes to deploy GitHub Actions runners include horizont... |
| [`admission-policies`](charts/admission-policies) | 0.1.0 | - | Active | Kubernetes-native admission policies and bindings using ValidatingAdmissionPo... |
| [`argo-workflows-templates`](charts/argo-workflows-templates) | 0.3.0 | - | Active | A Helm chart for managing Argo Workflows Templates. |
| [`istio-envoyfilters`](charts/istio-envoyfilters) | 0.1.0 | 0.1.0 | Active | A Helm chart for managing Istio EnvoyFilter resources. This chart enables cus... |
| [`karpenter-nodepool`](charts/karpenter-nodepool) | 1.6.0 | 1.5.0 | Active | A Helm chart for Karpenter Node pool, it will create the NodePool and the Ec2... |
| [`kube-green-sleepinfos`](charts/kube-green-sleepinfos) | 0.1.1 | 0.1.1 | Active | A Helm chart for managing kube-green SleepInfo resources. kube-green-sleepinf... |
| [`netbox-ipam`](charts/netbox-ipam) | 0.1.0 | 0.1.0 | Active | A Helm chart for managing NetBox Operator IPAM resources. Creates IpAddress, ... |
| [`rbac`](charts/rbac) | 0.4.0 | 0.4.0 | Active | Helm chart to define RBAC resources in the gitops way |
| [`squid`](charts/squid) | 0.9.0 | 6.13 | Active | A Helm chart for Squid caching proxy |
| [`storage-class`](charts/storage-class) | 0.4.0 | - | Active | Declarative management of Kubernetes StorageClass and VolumeAttributesClass r... |
<!-- CHARTS_TABLE_END -->

## Documentation

- [Installation](docs/installation.md) - Prerequisites and usage instructions
- [Testing Guide](docs/testing-guide.md) - Kind-based chart testing environment setup
- [OCI Background](docs/oci-background.md) - Why we use OCI for chart distribution
