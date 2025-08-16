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
| [actions-runner](https://github.com/younsl/charts/tree/main/charts/actions-runner) | 0.1.4 | - | ⚠️ Deprecated | A Helm chart for Kubernetes to deploy GitHub Actions runners include horizont... |
| [argocd-apps](https://github.com/younsl/charts/tree/main/charts/argocd-apps) | 1.7.0 | - | ✅ Active | A Helm chart for managing additional Argo CD Applications and Projects |
| [backup-utils](https://github.com/younsl/charts/tree/main/charts/backup-utils) | 0.4.2 | 3.15.1 | ⚠️ Deprecated | GitHub Enterprise Backup Utilities |
| [karpenter-nodepool](https://github.com/younsl/charts/tree/main/charts/karpenter-nodepool) | 1.5.1 | 1.5.0 | ✅ Active | A Helm chart for Karpenter Node pool, it will create the NodePool and the Ec2... |
| [kube-green-sleepinfos](https://github.com/younsl/charts/tree/main/charts/kube-green-sleepinfos) | 0.1.1 | 0.1.1 | ✅ Active | A Helm chart for managing kube-green SleepInfo resources. kube-green-sleepinf... |
| [rbac](https://github.com/younsl/charts/tree/main/charts/rbac) | 0.2.1 | 0.2.1 | ✅ Active | Helm chart to define RBAC resources in the gitops way |
| [squid](https://github.com/younsl/charts/tree/main/charts/squid) | 0.4.0 | 6.10 | ✅ Active | A Helm chart for Squid caching proxy |

## Chart Details

### actions-runner
**Status:** ⚠️ Deprecated  
**Version:** 0.1.4  

A Helm chart for Kubernetes to deploy GitHub Actions runners include horizontalRunnerAutoscaler and serviceAccount

> **Deprecation Notice:** This chart is deprecated. Please use the official Actions Runner Controller (ARC) instead:

### argocd-apps
**Status:** ✅ Active  
**Version:** 1.7.0  
**Keywords:** argoproj, argocd, gitops  

A Helm chart for managing additional Argo CD Applications and Projects

### backup-utils
**Status:** ⚠️ Deprecated  
**Version:** 0.4.2  
**App Version:** 3.15.1  
**Keywords:** github-enterprise-server, github-enterprise, backup-utils, backup, disaster-recovery  

GitHub Enterprise Backup Utilities

> **Deprecation Notice:** GitHub Enterprise Server 3.17 introduced a Built-in Backup Service as a Preview Feature. 

### karpenter-nodepool
**Status:** ✅ Active  
**Version:** 1.5.1  
**App Version:** 1.5.0  
**Keywords:** cluster, node, autoscaling, karpenter, karpenter-crds, nodepool, ec2nodeclass  

A Helm chart for Karpenter Node pool, it will create the NodePool and the Ec2NodeClass.

### kube-green-sleepinfos
**Status:** ✅ Active  
**Version:** 0.1.1  
**App Version:** 0.1.1  
**Keywords:** kube-green-operator, kube-green, sleepinfo, custom-resources, scale-to-zero  

A Helm chart for managing kube-green SleepInfo resources. kube-green-sleepinfos chart is used to create SleepInfo resources for kube-green operator.

### rbac
**Status:** ✅ Active  
**Version:** 0.2.1  
**App Version:** 0.2.1  
**Keywords:** cluster-security, rbac, clusterRole, clusterRoleBinding, role, roleBinding  

Helm chart to define RBAC resources in the gitops way

### squid
**Status:** ✅ Active  
**Version:** 0.4.0  
**App Version:** 6.10  
**Keywords:** squid-cache, squid, proxy, forward-proxy, cache  

A Helm chart for Squid caching proxy

## Requirements

- Helm 3.8.0+
- Kubernetes 1.21.0+

## Contributing

For contributing to these charts, please refer to the [main repository](https://github.com/younsl/charts).

---

*Last updated: 2025-08-16*
