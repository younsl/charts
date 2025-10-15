# storage-class

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

Declarative management of Kubernetes StorageClass resources with support for AWS EBS CSI driver, encryption, and multiple storage tiers

**Homepage:** <https://github.com/younsl/charts>

## Requirements

Kubernetes: `>=1.21.0-0`

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/storage-class
```

If you need to install crane on macOS, you can easily install it using [Homebrew](https://brew.sh/), the package manager.

```bash
brew install crane
```

### Install the chart

Install the chart with the release name `storage-class`:

```console
helm install storage-class oci://ghcr.io/younsl/charts/storage-class
```

Install with custom values:

```console
helm install storage-class oci://ghcr.io/younsl/charts/storage-class -f values.yaml
```

Install a specific version:

```console
helm install storage-class oci://ghcr.io/younsl/charts/storage-class --version 0.1.0
```

### Install from local chart

Download storage-class chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/storage-class --untar --version 0.1.0
helm install storage-class ./storage-class
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade storage-class oci://ghcr.io/younsl/charts/storage-class
```

## Uninstall

```console
helm uninstall storage-class
```

## Configuration

The following table lists the configurable parameters and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| globalAnnotations | object | `{}` | Global annotations to apply to all StorageClasses |
| globalLabels | object | `{}` | Global labels to apply to all StorageClasses |
| defaultStorageClass | string | `"gp3"` | Name of the default StorageClass (must match one of the keys in storageClasses) Set to empty string to not set any default |
| storageClasses | object | See [values.yaml](https://github.com/younsl/charts/blob/main/charts/storage-class/values.yaml) | Map of StorageClass configurations to create |
| storageClasses.gp3.enabled | bool | `true` | Enable this StorageClass |
| storageClasses.gp3.annotations | object | `{}` | Annotations for the StorageClass |
| storageClasses.gp3.labels | object | `{}` | Labels for the StorageClass |
| storageClasses.gp3.provisioner | string | `"ebs.csi.aws.com"` | Provisioner for the StorageClass (AWS EBS CSI driver) |
| storageClasses.gp3.reclaimPolicy | string | `"Delete"` | Reclaim policy for PersistentVolumes (Delete or Retain) |
| storageClasses.gp3.volumeBindingMode | string | `"WaitForFirstConsumer"` | Volume binding mode (Immediate or WaitForFirstConsumer) |
| storageClasses.gp3.allowVolumeExpansion | bool | `true` | Allow volume expansion |
| storageClasses.gp3.parameters | object | `{"type":"gp3"}` | Parameters specific to the provisioner |
| storageClasses.gp3.allowedTopologies | list | `[]` | Allowed topologies for volume provisioning |
| storageClasses.gp3.mountOptions | list | `[]` | Mount options for volumes |
| storageClasses.gp3-encrypted.enabled | bool | `false` | Enable this StorageClass |
| storageClasses.gp3-encrypted.annotations | object | `{}` | Annotations for the StorageClass |
| storageClasses.gp3-encrypted.labels | object | `{}` | Labels for the StorageClass |
| storageClasses.gp3-encrypted.provisioner | string | `"ebs.csi.aws.com"` | Provisioner for the StorageClass (AWS EBS CSI driver) |
| storageClasses.gp3-encrypted.reclaimPolicy | string | `"Delete"` | Reclaim policy for PersistentVolumes (Delete or Retain) |
| storageClasses.gp3-encrypted.volumeBindingMode | string | `"WaitForFirstConsumer"` | Volume binding mode (Immediate or WaitForFirstConsumer) |
| storageClasses.gp3-encrypted.allowVolumeExpansion | bool | `true` | Allow volume expansion |
| storageClasses.gp3-encrypted.parameters | object | `{"encrypted":"true","type":"gp3"}` | Parameters specific to the provisioner |
| storageClasses.gp3-encrypted.allowedTopologies | list | `[]` | Allowed topologies for volume provisioning |
| storageClasses.gp3-encrypted.mountOptions | list | `[]` | Mount options for volumes |

## Source Code

* <https://github.com/younsl/charts/tree/main/charts/storage-class>
* <https://kubernetes.io/docs/concepts/storage/storage-classes/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| younsl |  |  |

## License

This chart is licensed under the Apache License 2.0. See [LICENSE](https://github.com/younsl/younsl.github.io/blob/main/LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a [Pull Request](https://github.com/younsl/younsl.github.io/pulls).

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
