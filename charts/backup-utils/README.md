# backup-utils

![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.17.2](https://img.shields.io/badge/AppVersion-3.17.2-informational?style=flat-square)

GitHub Enterprise Backup Utilities

⚠️ DEPRECATION NOTICE: GitHub Enterprise Server 3.17 introduced a Built-in Backup Service as a Preview Feature.

The Built-in Backup Service is recommended over backup-utils. Note that backup-utils may be deprecated in future releases.

See: https://docs.github.com/en/enterprise-server@latest/admin/backing-up-and-restoring-your-instance/backup-service-for-github-enterprise-server/about-the-backup-service-for-github-enterprise-server

> **:exclamation: This Helm Chart is deprecated!**

**Homepage:** <https://github.com/github/backup-utils>

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/backup-utils
```

If you need to install crane on macOS, you can easily install it using [Homebrew](https://brew.sh/), the package manager.

```bash
brew install crane
```

### Install the chart

Install the chart with the release name `backup-utils`:

```console
helm install backup-utils oci://ghcr.io/younsl/charts/backup-utils
```

Install with custom values:

```console
helm install backup-utils oci://ghcr.io/younsl/charts/backup-utils -f values.yaml
```

Install a specific version:

```console
helm install backup-utils oci://ghcr.io/younsl/charts/backup-utils --version 0.8.0
```

### Install from local chart

Download backup-utils chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/backup-utils --untar --version 0.8.0
helm install backup-utils ./backup-utils
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade backup-utils oci://ghcr.io/younsl/charts/backup-utils
```

## Uninstall

```console
helm uninstall backup-utils
```

## Configuration

The following table lists the configurable parameters and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| labels | object | `{}` | Global labels for all resources |
| backupUtils | object | `{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/arch","operator":"In","values":["amd64"]},{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}},"backupConfig":{"extraCommandOptions":"-i /ghe-ssh/id_ed25519 -o UserKnownHostsFile=/ghe-ssh/known_hosts","githubEnterpriseHostname":"github.example.com","snapshotRententionNumber":72,"stagingInstance":false,"verboseLogFile":"/data/backup-verbose.log"},"command":["/bin/bash","-c","/backup-utils/backup.sh"],"concurrencyPolicy":"Forbid","dnsConfig":{},"enabled":true,"env":[{"name":"GHE_BACKUP_CONFIG","value":"/backup-utils/backup.config"}],"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/younsl/backup-utils","tag":null},"imagePullSecrets":[],"knownHosts":"[github.example.com]:122 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPHiBn7ko/8AE2Mwa01HB3Ef+ZZ92fg2PDjM/180eAXCYo0II9JeUVJO1hFXk6W10WfsHPabQgx8zV0ddaL9RzI=","nodeSelector":{},"persistentVolume":{"accessModes":["ReadWriteOnce"],"annotations":{},"finalizers":["kubernetes.io/pvc-protection"],"labels":{},"size":"500Gi","storageClass":"gp3","volumeAttributesClassName":""},"podAnnotations":{},"podLabels":{},"resources":{"limits":{"cpu":"1000m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"512Mi"}},"schedule":"*/30 * * * *","suspend":false,"timeZone":"Asia/Seoul"}` | backupUtils Spec configuration for the backup utility |
| backupUtils.enabled | bool | `true` | Enable or disable the backup utility This allows you to easily toggle the backup functionality without removing existing configurations |
| backupUtils.suspend | bool | `false` | Suspend or resume deploying the backup utility by cronjob Suspending the cronjob will not stop jobs that have already been deployed. `spec.suspend` allows you to easily pause the backup functionality without removing existing configurations |
| backupUtils.podLabels | object | `{}` | Labels to be added to the pod This can be used to categorize and organize pods, such as by app or environment |
| backupUtils.podAnnotations | object | `{}` | Annotations to be added to the pod This can be used to add metadata to pods, such as for configuration or tool integrations |
| backupUtils.dnsConfig | object | `{}` | DNS config for backup-utils pod |
| backupUtils.timeZone | string | `"Asia/Seoul"` | Timezone for scheduled backups executed by cronjob ref: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#time-zones |
| backupUtils.schedule | string | `"*/30 * * * *"` | Cron expression for scheduled backups backup-utils team recommends hourly backups at the least ref: https://github.com/github/backup-utils/blob/master/docs/scheduling-backups.md#scheduling-backups |
| backupUtils.concurrencyPolicy | string | `"Forbid"` | Specifies how to treat concurrent executions of a Job Valid values: Allow, Forbid, Replace Allow: allows CronJobs to run concurrently Forbid: forbids concurrent runs, skipping the next run if the previous hasn't finished yet Replace: cancels the currently running job and replaces it with a new one |
| backupUtils.knownHosts | string | `"[github.example.com]:122 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPHiBn7ko/8AE2Mwa01HB3Ef+ZZ92fg2PDjM/180eAXCYo0II9JeUVJO1hFXk6W10WfsHPabQgx8zV0ddaL9RzI="` | known_hosts data "[github.example.com]:122 ecdsa-sha2-nistp256 AAA............I="   ------------------      ------------------- -----------------    GHES Hostname or          Host key type     Host public key    IP Address |
| backupUtils.backupConfig.githubEnterpriseHostname | string | `"github.example.com"` | IP address or hostname of Github Enterprise server |
| backupUtils.backupConfig.snapshotRententionNumber | int | `72` | Maximum number of snapshots to keep |
| backupUtils.backupConfig.verboseLogFile | string | `"/data/backup-verbose.log"` | Absolute path where detailed backup logs are stored |
| backupUtils.backupConfig.extraCommandOptions | string | `"-i /ghe-ssh/id_ed25519 -o UserKnownHostsFile=/ghe-ssh/known_hosts"` | Extra SSH options for backup-utils pod to connect to GHE instances We usually recommend not to modify the default value for stability reasons |
| backupUtils.backupConfig.stagingInstance | bool | `false` | If true, the backup utility will mount the staging instance's SSH private key |
| backupUtils.image.repository | string | `"ghcr.io/younsl/backup-utils"` | Container image repository |
| backupUtils.image.tag | string | `nil` | Image tag for backup-utils cronjob If not specified or set to null, reference chart appVersion to set the image tag |
| backupUtils.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy (Always, Never, IfNotPresent) |
| backupUtils.imagePullSecrets | list | `[]` | Names of secrets in the same namespace for pulling images from private registries |
| backupUtils.command | list | `["/bin/bash","-c","/backup-utils/backup.sh"]` | Command to execute within the backup-utils container Use an array format for command to ensure proper handling of arguments |
| backupUtils.env | list | `[{"name":"GHE_BACKUP_CONFIG","value":"/backup-utils/backup.config"}]` | Environment variables for the application If you need to specify a configuration file for backup utility commands, modify the `GHE_BACKUP_CONFIG` environment variable. |
| backupUtils.persistentVolume.storageClass | string | `"gp3"` | If EKS cluster does not have the EBS CSI Driver installed, use gp2 instead of gp3. Check whether gp3 is installed by using `kubectl get storageclass -A` command. |
| backupUtils.persistentVolume.volumeAttributesClassName | string | `""` | Name of the VolumeAttributesClass to apply to this PersistentVolumeClaim Allows modification of mutable volume properties like EBS volume type, IOPS, throughput, and tags ref: https://kubernetes.io/docs/concepts/storage/volume-attributes-classes/ |
| backupUtils.persistentVolume.size | string | `"500Gi"` | Volume size where snapshot backups are stored volume size vary based on current Git repository disk usage and growth patterns of your GitHub appliance at least 5x the amount of storage allocated to the primary GitHub appliance for historical snapshots and growth over time ref: https://github.com/github/backup-utils/blob/master/docs/requirements.md#storage-requirements |
| backupUtils.persistentVolume.accessModes | list | `["ReadWriteOnce"]` | The volume can be mounted as read-write by a single node |
| backupUtils.persistentVolume.labels | object | `{}` | Extra labels for persistentVolumeClaim |
| backupUtils.persistentVolume.annotations | object | `{}` | Extra annotations for persistentVolumeClaim |
| backupUtils.persistentVolume.finalizers | list | `["kubernetes.io/pvc-protection"]` | Extra finalizers to protect deletion persistentVolumeClaim ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolume-deletion-protection-finalizer |
| backupUtils.resources | object | `{"limits":{"cpu":"1000m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | Resource requests and limits for github-backup-utils container ref: https://github.com/github/backup-utils/blob/master/docs/requirements.md#backup-host-requirements |
| backupUtils.nodeSelector | object | `{}` | Node selector to specify on which nodes the job should run If not declared, the job can run on any node |
| backupUtils.affinity | object | `{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/arch","operator":"In","values":["amd64"]},{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}}` | Affinity rules to specify on which nodes the job should run Node affinity allows for more complex node selection criteria than nodeSelector |

## Source Code

* <https://github.com/github/backup-utils>
* <https://github.com/younsl/younsl.github.io>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| younsl | <cysl@kakao.com> | <https://github.com/younsl> |

## License

This chart is licensed under the Apache License 2.0. See [LICENSE](https://github.com/younsl/younsl.github.io/blob/main/LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a [Pull Request](https://github.com/younsl/younsl.github.io/pulls).

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
