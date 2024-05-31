# charts

[![Badge - License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/younsl/charts/blob/main/LICENSE)

Helm charts in production

## Usage

Adding my helm chart repository

```bash
$ helm repo add younsl https://raw.githubusercontent.com/younsl/charts/main
"younsl" has been added to your repositories
$ helm repo update
```

Browse all helm charts in repository

```bash
$ helm search repo younsl
NAME                       CHART VERSION  APP VERSION  DESCRIPTION
younsl/actions-runner      0.1.0                       A Helm chart for Kubernetes to deploy GitHub Ac...
younsl/argocd-apps         1.6.1                       A Helm chart for managing additional Argo CD Ap...
younsl/github-backup-utils 0.2.0          3.10.0       GitHub Enterprise Backup Utilities
younsl/karpenter-nodepool  0.1.0          0.1.0        A Helm chart for Karpenter nodepool, it will cr...
```

## License

[MIT License](https://github.com/younsl/charts/blob/main/LICENSE).
