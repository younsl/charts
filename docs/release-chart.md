# Release chart

Helm Chart release guide for Helm Chart maintainers.

## Prerequisite

Before releasing helm charts, ensure the following prerequisite are met:

- **helm CLI**: Make sure `helm` is installed on your local environment. You can download and install it from the [official Helm website](https://helm.sh/docs/intro/install/).

If you are using macOS, you can install Helm using Homebrew with the following `brew` command:

```bash
# helm install using homebrew
brew install helm

# Verify that helm CLI is available
helm version
```

## Release charts

### helm package

Navigate to the directory containing your Helm charts:

```console
$ pwd
/Users/younsung.lee/github/younsl/charts
```

Package each helm chart into a `.tgz` archive and save it to the specified destination directory:

```bash
helm package charts/actions-runner --destination charts/
helm package charts/backup-utils --destination charts/
helm package charts/argocd-apps --destination charts/
helm package charts/karpenter-nodepool --destination charts/
helm package charts/rbac --destination charts/
```

For example, you can use the following `helm package` command to package the `backup-utils` chart as a `.tgz` file.

```console
$ helm package charts/backup-utils --destination charts/
Successfully packaged chart and saved it to: charts/github-backup-utils-0.3.0.tgz
```

### helm index

Creates an `index.yaml` file for a local Helm chart repository. This command scans the current directory for chart packages `.tgz` and generates an `index.yaml` file that Helm uses to identify available charts.

```bash
helm repo index .
```
