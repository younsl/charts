# backup-utils

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.15.4](https://img.shields.io/badge/AppVersion-3.15.4-informational?style=flat-square)

GitHub Enterprise Backup Utilities

⚠️ DEPRECATION NOTICE: GitHub Enterprise Server 3.17 introduced a Built-in Backup Service as a Preview Feature.

The Built-in Backup Service is recommended over backup-utils. Note that backup-utils may be deprecated in future releases.

See: https://docs.github.com/en/enterprise-server@latest/admin/backing-up-and-restoring-your-instance/backup-service-for-github-enterprise-server/about-the-backup-service-for-github-enterprise-server

> **:exclamation: This Helm Chart is deprecated!**

**Homepage:** <https://github.com/github/backup-utils>

## Installation

### Add Helm repository

```console
helm repo add younsl https://younsl.github.io/
helm repo update
```

### Install the chart

Install the chart with the release name `backup-utils`:

```console
helm install backup-utils younsl/backup-utils
```

Install with custom values:

```console
helm install backup-utils younsl/backup-utils -f values.yaml
```

Install a specific version:

```console
helm install backup-utils younsl/backup-utils --version 0.5.0
```

### Install from local chart

Download backup-utils chart and install from local directory:

```console
helm pull younsl/backup-utils --untar --version 0.5.0
helm install backup-utils ./backup-utils
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade backup-utils younsl/backup-utils
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
| backupUtils | object | `{"affinity":{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/arch","operator":"In","values":["amd64"]},{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}},"backupConfig":{"extraCommandOptions":"-i /ghe-ssh/id_ed25519 -o UserKnownHostsFile=/ghe-ssh/known_hosts","githubEnterpriseHostname":"github.example.com","snapshotRententionNumber":72,"stagingInstance":false,"verboseLogFile":"/data/backup-verbose.log"},"command":["/bin/bash","-c","/backup-utils/backup.sh"],"concurrencyPolicy":"Forbid","dnsConfig":{},"enabled":true,"env":[{"name":"GHE_BACKUP_CONFIG","value":"/backup-utils/backup.config"}],"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/younsl/backup-utils","tag":null},"knownHosts":"[github.example.com]:122 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPHiBn7ko/8AE2Mwa01HB3Ef+ZZ92fg2PDjM/180eAXCYo0II9JeUVJO1hFXk6W10WfsHPabQgx8zV0ddaL9RzI=","nodeSelector":{},"persistentVolume":{"accessModes":["ReadWriteOnce"],"annotations":{},"finalizers":["kubernetes.io/pvc-protection"],"labels":{},"size":"500Gi","storageClass":"gp3"},"podAnnotations":{},"podLabels":{},"resources":{"limits":{"cpu":"1000m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"512Mi"}},"schedule":"*/30 * * * *","suspend":false,"timeZone":"Asia/Seoul"}` | backupUtils Spec configuration for the backup utility |
| backupUtils.affinity | object | `{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/arch","operator":"In","values":["amd64"]},{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}}` | affinity Affinity rules to specify on which nodes the job should run Node affinity allows for more complex node selection criteria than nodeSelector |
| backupUtils.backupConfig.extraCommandOptions | string | `"-i /ghe-ssh/id_ed25519 -o UserKnownHostsFile=/ghe-ssh/known_hosts"` | extraCommandOptions Extra SSH options for backup-utils pod to connect to GHE instances We usually recommend not to modify the default value for stability reasons |
| backupUtils.backupConfig.githubEnterpriseHostname | string | `"github.example.com"` | githubEnterpriseHostname IP address or hostname of Github Enterprise server |
| backupUtils.backupConfig.snapshotRententionNumber | int | `72` | snapshotRententionNumber Maximum number of snapshots to keep |
| backupUtils.backupConfig.stagingInstance | bool | `false` | stagingInstance If true, the backup utility will mount the staging instance's SSH private key |
| backupUtils.backupConfig.verboseLogFile | string | `"/data/backup-verbose.log"` | verboseLogFile Absolute path where detailed backup logs are stored |
| backupUtils.command | list | `["/bin/bash","-c","/backup-utils/backup.sh"]` | command Command to execute within the backup-utils container Use an array format for command to ensure proper handling of arguments |
| backupUtils.concurrencyPolicy | string | `"Forbid"` | concurrencyPolicy Specifies how to treat concurrent executions of a Job Valid values: Allow, Forbid, Replace Allow: allows CronJobs to run concurrently Forbid: forbids concurrent runs, skipping the next run if the previous hasn't finished yet Replace: cancels the currently running job and replaces it with a new one |
| backupUtils.dnsConfig | object | `{}` | dnsConfig DNS config for backup-utils pod |
| backupUtils.enabled | bool | `true` | enabled Enable or disable the backup utility This allows you to easily toggle the backup functionality without removing existing configurations |
| backupUtils.env | list | `[{"name":"GHE_BACKUP_CONFIG","value":"/backup-utils/backup.config"}]` | env Environment variables for the application If you need to specify a configuration file for backup utility commands, modify the `GHE_BACKUP_CONFIG` environment variable. |
| backupUtils.image.pullPolicy | string | `"IfNotPresent"` | pullPolicy Image pull policy (Always, Never, IfNotPresent) |
| backupUtils.image.tag | string | `nil` | tag Image tag for backup-utils cronjob If not specified or set to null, reference chart appVersion to set the image tag |
| backupUtils.knownHosts | string | `"[github.example.com]:122 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPHiBn7ko/8AE2Mwa01HB3Ef+ZZ92fg2PDjM/180eAXCYo0II9JeUVJO1hFXk6W10WfsHPabQgx8zV0ddaL9RzI="` | known_hosts data "[github.example.com]:122 ecdsa-sha2-nistp256 AAA............I="   ------------------      ------------------- -----------------    GHES Hostname or          Host key type     Host public key    IP Address |
| backupUtils.nodeSelector | object | `{}` | nodeSelector Node selector to specify on which nodes the job should run If not declared, the job can run on any node |
| backupUtils.persistentVolume.accessModes[0] | string | `"ReadWriteOnce"` | ReadWriteOnce The volume can be mounted as read-write by a single node |
| backupUtils.persistentVolume.annotations | object | `{}` | annotations Extra annotations for persistentVolumeClaim |
| backupUtils.persistentVolume.finalizers | list | `["kubernetes.io/pvc-protection"]` | finalizers Extra finalizers to protect deletion persistentVolumeClaim ref: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolume-deletion-protection-finalizer |
| backupUtils.persistentVolume.labels | object | `{}` | labels Extra labels for persistentVolumeClaim |
| backupUtils.persistentVolume.size | string | `"500Gi"` | size Volume size where snapshot backups are stored volume size vary based on current Git repository disk usage and growth patterns of your GitHub appliance at least 5x the amount of storage allocated to the primary GitHub appliance for historical snapshots and growth over time ref: https://github.com/github/backup-utils/blob/master/docs/requirements.md#storage-requirements |
| backupUtils.persistentVolume.storageClass | string | `"gp3"` | storageClass If EKS cluster does not have the EBS CSI Driver installed, use gp2 instead of gp3. Check whether gp3 is installed by using `kubectl get storageclass -A` command. |
| backupUtils.podAnnotations | object | `{}` | podAnnotations Annotations to be added to the pod This can be used to add metadata to pods, such as for configuration or tool integrations |
| backupUtils.podLabels | object | `{}` | podLabels Labels to be added to the pod This can be used to categorize and organize pods, such as by app or environment |
| backupUtils.resources | object | `{"limits":{"cpu":"1000m","memory":"2Gi"},"requests":{"cpu":"500m","memory":"512Mi"}}` | resources Resource requests and limits for github-backup-utils container ref: https://github.com/github/backup-utils/blob/master/docs/requirements.md#backup-host-requirements |
| backupUtils.schedule | string | `"*/30 * * * *"` | schedule Cron expression for scheduled backups backup-utils team recommends hourly backups at the least ref: https://github.com/github/backup-utils/blob/master/docs/scheduling-backups.md#scheduling-backups |
| backupUtils.suspend | bool | `false` | suspend Suspend or resume deploying the backup utility by cronjob Suspending the cronjob will not stop jobs that have already been deployed. `spec.suspend` allows you to easily pause the backup functionality without removing existing configurations |
| backupUtils.timeZone | string | `"Asia/Seoul"` | timeZone Timezone for scheduled backups executed by cronjob ref: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#time-zones |
| labels | object | `{}` | labels Global labels for all resources |

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
