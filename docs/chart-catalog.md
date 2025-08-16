# Helm Charts Catalog

This catalog provides an overview of all Helm charts available in this repository. Charts are distributed via OCI artifacts on GitHub Container Registry (ghcr.io).

## Installation

All charts can be installed using:

```bash
helm install <release-name> oci://ghcr.io/younsl/charts/<chart-name> --version <version>
```

## Available Charts

| Chart Name | Version | App Version | Status | Description |
|------------|---------|-------------|--------|-------------|
| [actions-runner](https://github.com/younsl/charts/tree/main/charts/actions-runner) | 0.1.4 | - | ⚠️ Deprecated | GitHub Actions self-hosted runner for Kubernetes (Legacy ARC mode) |
| [argocd-apps](https://github.com/younsl/charts/tree/main/charts/argocd-apps) | 1.7.0 | - | ✅ Active | Management of ArgoCD Applications and Projects |
| [backup-utils](https://github.com/younsl/charts/tree/main/charts/backup-utils) | 0.4.2 | 3.15.1 | ⚠️ Deprecated | GitHub Enterprise Backup Utilities |
| [karpenter-nodepool](https://github.com/younsl/charts/tree/main/charts/karpenter-nodepool) | 1.5.1 | 1.5.0 | ✅ Active | AWS Karpenter NodePool and EC2NodeClass resources |
| [kube-green-sleepinfos](https://github.com/younsl/charts/tree/main/charts/kube-green-sleepinfos) | 0.1.1 | 0.1.1 | ✅ Active | SleepInfo resources for kube-green operator |
| [rbac](https://github.com/younsl/charts/tree/main/charts/rbac) | 0.2.1 | 0.2.1 | ✅ Active | Kubernetes RBAC resources management |
| [squid](https://github.com/younsl/charts/tree/main/charts/squid) | 0.4.0 | 6.10 | ✅ Active | Squid caching proxy with Grafana dashboard |

## Chart Details

### actions-runner
**Status:** ⚠️ Deprecated  
**Version:** 0.1.4  
**Keywords:** -  

A Helm chart for deploying GitHub Actions runners with horizontalRunnerAutoscaler and serviceAccount support.

> **Deprecation Notice:** This chart covers the legacy mode of ARC. Please use the newer [autoscaling runner scale sets](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller) instead.

### argocd-apps
**Status:** ✅ Active  
**Version:** 1.7.0  
**Keywords:** argoproj, argocd, gitops  

A comprehensive Helm chart for managing additional Argo CD Applications and Projects. Supports ApplicationSets and progressive sync strategies.

### backup-utils
**Status:** ⚠️ Deprecated  
**Version:** 0.4.2  
**App Version:** 3.15.1  
**Keywords:** github-enterprise-server, github-enterprise, backup-utils, backup, disaster-recovery  

GitHub Enterprise Backup Utilities for disaster recovery.

> **Deprecation Notice:** GitHub Enterprise Server 3.17 introduced a Built-in Backup Service. The Built-in Backup Service is recommended over backup-utils.

### karpenter-nodepool
**Status:** ✅ Active  
**Version:** 1.5.1  
**App Version:** 1.5.0  
**Keywords:** cluster, node, autoscaling, karpenter, karpenter-crds, nodepool, ec2nodeclass  

A Helm chart for creating Karpenter NodePool and EC2NodeClass resources for AWS autoscaling.

### kube-green-sleepinfos
**Status:** ✅ Active  
**Version:** 0.1.1  
**App Version:** 0.1.1  
**Keywords:** kube-green-operator, kube-green, sleepinfo, custom-resources, scale-to-zero  

Manages kube-green SleepInfo resources for scheduling resource hibernation and scale-to-zero operations.

### rbac
**Status:** ✅ Active  
**Version:** 0.2.1  
**App Version:** 0.2.1  
**Keywords:** cluster-security, rbac, clusterRole, clusterRoleBinding, role, roleBinding  

Define and manage Kubernetes RBAC resources in a GitOps-friendly way.

### squid
**Status:** ✅ Active  
**Version:** 0.4.0  
**App Version:** 6.10  
**Keywords:** squid-cache, squid, proxy, forward-proxy, cache  

Deploy Squid caching proxy with built-in Grafana dashboard integration for monitoring.

## Requirements

- Helm 3.8.0+
- Kubernetes 1.21.0+

## Contributing

For contributing to these charts, please refer to the [main repository](https://github.com/younsl/charts).

---

*Last updated: 2025-08-16*