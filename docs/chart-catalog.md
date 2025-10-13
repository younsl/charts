# Helm Charts Catalog

This catalog provides an overview of all Helm charts available in this repository. Charts are distributed via OCI artifacts on GitHub Container Registry (ghcr.io).

## Installation

### Install directly from OCI registry

```bash
helm install <release-name> oci://ghcr.io/younsl/charts/<chart-name> --version <version>
```

### Download chart locally

First, query available versions using crane:

```bash
# List all available versions for a chart
crane ls ghcr.io/younsl/charts/<chart-name>
```

Then download the desired version to local storage:

```bash
# Download and extract the chart
helm pull oci://ghcr.io/younsl/charts/<chart-name> --version <version> --untar
```

## Available Charts

This repository contains **9** Helm charts (7 active, 2 deprecated).

| Chart Name | Version | App Version | Status | Description |
|------------|---------|-------------|--------|-------------|
| [actions-runner](../charts/actions-runner) | 0.1.4 | - | ⚠️ Deprecated | A Helm chart for Kubernetes to deploy GitHub Actions runners include horizont... |
| [argo-workflows-templates](../charts/argo-workflows-templates) | 0.2.0 | - | ✅ Active | A Helm chart for managing Argo Workflows Templates. |
| [argocd-apps](../charts/argocd-apps) | 1.7.0 | - | ✅ Active | A Helm chart for managing additional Argo CD Applications and Projects |
| [backup-utils](../charts/backup-utils) | 0.8.0 | 3.17.2 | ⚠️ Deprecated | GitHub Enterprise Backup Utilities |
| [karpenter-nodepool](../charts/karpenter-nodepool) | 1.5.1 | 1.5.0 | ✅ Active | A Helm chart for Karpenter Node pool, it will create the NodePool and the Ec2... |
| [kube-green-sleepinfos](../charts/kube-green-sleepinfos) | 0.1.1 | 0.1.1 | ✅ Active | A Helm chart for managing kube-green SleepInfo resources. kube-green-sleepinf... |
| [rbac](../charts/rbac) | 0.4.0 | 0.4.0 | ✅ Active | Helm chart to define RBAC resources in the gitops way |
| [squid](../charts/squid) | 0.7.0 | 6.13 | ✅ Active | A Helm chart for Squid caching proxy |
| [uptime-kuma](../charts/uptime-kuma) | 2.24.1 | 1.23.16 | ✅ Active | A self-hosted Monitoring tool like Uptime-Robot. |

## Chart Details

### actions-runner
**Status:** ⚠️ Deprecated  
**Version:** 0.1.4  

A Helm chart for Kubernetes to deploy GitHub Actions runners include horizontalRunnerAutoscaler and serviceAccount

> **Deprecation Notice:** This chart is deprecated. Please use the official Actions Runner Controller (ARC) instead:

### argo-workflows-templates
**Status:** ✅ Active  
**Version:** 0.2.0  
**Keywords:** argoproj, argo-workflows, workflows, workflow-templates, gitops  

A Helm chart for managing Argo Workflows Templates.

### argocd-apps
**Status:** ✅ Active  
**Version:** 1.7.0  
**Keywords:** argoproj, argocd, gitops  

A Helm chart for managing additional Argo CD Applications and Projects

### backup-utils
**Status:** ⚠️ Deprecated  
**Version:** 0.8.0  
**App Version:** 3.17.2  
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
**Version:** 0.4.0  
**App Version:** 0.4.0  
**Keywords:** cluster-security, rbac, clusterRole, clusterRoleBinding, role, roleBinding  

Helm chart to define RBAC resources in the gitops way

### squid
**Status:** ✅ Active  
**Version:** 0.7.0  
**App Version:** 6.13  
**Keywords:** squid-cache, squid, proxy, forward-proxy, cache  

A Helm chart for Squid caching proxy

### uptime-kuma
**Status:** ✅ Active  
**Version:** 2.24.1  
**App Version:** 1.23.16  

A self-hosted Monitoring tool like "Uptime-Robot".

## Requirements

- Helm 3.8.0+
- Kubernetes 1.21.0+

## Contributing

For contributing to these charts, please refer to the [main repository](https://github.com/younsl/charts).

---

*Last updated: 2025-10-13*
