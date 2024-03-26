# actions-runner

Self-hosted actions runner chart include runnerDeployment, horizontalRunnerAutoscaler and serviceAccount.

Tested in EKS v1.29 based AL2 amd64 environment.

## Usage

### Install

> **Prerequisite**:
> ARC<sup>actions runner controller</sup> must first be installed in your kubernetes cluster.

```bash
helm upgrade \
  --install \
  --create-namespace \
  --namespace actions-runner \
  actions-runner . \
  --values vlaues_ops.yaml
```

### Delete

```bash
helm uninstall -n actions-runner actions-runner
```
