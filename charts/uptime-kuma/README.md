# uptime-kuma

![Version: 2.25.0](https://img.shields.io/badge/Version-2.25.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.23.16](https://img.shields.io/badge/AppVersion-1.23.16-informational?style=flat-square)

A self-hosted Monitoring tool like "Uptime-Robot".

**Homepage:** <https://github.com/younsl/charts>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | 21.0.7 |

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/uptime-kuma
```

If you need to install crane on macOS, you can easily install it using [Homebrew](https://brew.sh/), the package manager.

```bash
brew install crane
```

### Install the chart

Install the chart with the release name `uptime-kuma`:

```console
helm install uptime-kuma oci://ghcr.io/younsl/charts/uptime-kuma
```

Install with custom values:

```console
helm install uptime-kuma oci://ghcr.io/younsl/charts/uptime-kuma -f values.yaml
```

Install a specific version:

```console
helm install uptime-kuma oci://ghcr.io/younsl/charts/uptime-kuma --version 2.25.0
```

### Install from local chart

Download uptime-kuma chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/uptime-kuma --untar --version 2.25.0
helm install uptime-kuma ./uptime-kuma
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade uptime-kuma oci://ghcr.io/younsl/charts/uptime-kuma
```

## Uninstall

```console
helm uninstall uptime-kuma
```

## Configuration

The following table lists the configurable parameters and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override the name of the chart |
| fullnameOverride | string | `""` | Override the full name of the chart |
| namespaceOverride | string | `""` | A custom namespace to override the default namespace for the deployed resources |
| image | object | Omitted for brevity | Container image configuration |
| image.repository | string | `"louislam/uptime-kuma"` | Uptime Kuma container image repository |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.tag | string | `"1.23.16-debian"` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` | Image pull secrets to avoid DockerHub rate limits or access private registries |
| useDeploy | bool | `true` | If this option is set to false a StatefulSet instead of a Deployment is used |
| serviceAccount | object | Omitted for brevity | ServiceAccount configuration |
| serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| serviceAccount.automountServiceAccountToken | bool | `true` | Automatically mount a ServiceAccount's API credentials |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets to attach to the service account |
| podAnnotations | object | `{}` | Annotations to add to the pod |
| podLabels | object | `{}` | Labels to add to the pod |
| podEnv | list | `[]` | Optional additional environment variables for the pod |
| podSecurityContext | object | `{}` | Security context for the pod |
| securityContext | object | `{}` | Security context for the container |
| service | object | Omitted for brevity | Service configuration |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| service.port | int | `3001` | Service port |
| service.nodePort | int | `nil` | Node port (only used if type is NodePort) |
| service.annotations | object | `{}` | Annotations to add to the service |
| ingress | object | Omitted for brevity | Ingress configuration |
| ingress.enabled | bool | `false` | Enable ingress controller resource |
| ingress.extraLabels | object | `{}` | Additional labels to add to the ingress |
| ingress.annotations | object | Omitted for brevity | Annotations to add to the ingress (includes default NGINX configuration for WebSocket support) |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Ingress host configuration |
| ingress.tls | list | `[]` | TLS configuration for the ingress |
| resources | object | `{}` | Resource limits and requests for the container |
| resizePolicy | list | `[]` | Container resize policy for the uptime-kuma container Ref: https://kubernetes.io/docs/tasks/configure-pod-container/resize-container-resources/ |
| nodeSelector | object | `{}` | Node labels for pod assignment |
| tolerations | list | `[]` | Tolerations for pod assignment |
| affinity | object | `{}` | Affinity for pod assignment |
| livenessProbe.enabled | bool | `true` | Enable liveness probe |
| livenessProbe.failureThreshold | int | `3` | Number of consecutive failures before considering the probe as failed |
| livenessProbe.initialDelaySeconds | int | `180` | Initial delay before liveness probe is initiated (Uptime Kuma recommends 180 seconds) https://github.com/louislam/uptime-kuma/blob/ae224f9e188b1fc32ed8729818710975589cdce7/extra/healthcheck.go#L3 |
| livenessProbe.periodSeconds | int | `10` | How often to perform the probe |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful |
| livenessProbe.timeoutSeconds | int | `2` | Probe timeout |
| livenessProbe.exec | object | `{"command":["extra/healthcheck"]}` | Execute command for liveness probe (uses Go-based healthcheck) The NodeJS Version of this Healthcheck is no longer supported https://github.com/louislam/uptime-kuma/blob/ae224f9e188b1fc32ed8729818710975589cdce7/extra/healthcheck.js#L6 |
| readinessProbe.enabled | bool | `true` | Enable readiness probe |
| readinessProbe.initialDelaySeconds | int | `10` | Initial delay before readiness probe is initiated |
| readinessProbe.periodSeconds | int | `10` | How often to perform the probe |
| readinessProbe.timeoutSeconds | int | `1` | Probe timeout |
| readinessProbe.failureThreshold | int | `3` | Number of consecutive failures before considering the probe as failed |
| readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful |
| readinessProbe.exec | object | `{"command":[]}` | Execute command for readiness probe |
| readinessProbe.httpGet | object | `{"httpHeaders":[],"path":"/","port":3001,"scheme":"HTTP"}` | HTTP GET request for readiness probe |
| volume.enabled | bool | `true` | Enable persistent volume for storage |
| volume.accessMode | string | `"ReadWriteOnce"` | Access mode for the persistent volume |
| volume.size | string | `"4Gi"` | Size of the persistent volume |
| volume.storageClassName | string | `"gp3"` | Storage class name for the persistent volume |
| volume.existingClaim | string | `""` | Reuse your own pre-existing PVC |
| additionalVolumes | list | `[]` | A list of additional volumes to be added to the pod |
| additionalVolumeMounts | list | `[]` | A list of additional volumeMounts to be added to the pod |
| strategy | object | `{"type":"Recreate"}` | Deployment strategy configuration |
| strategy.type | string | `"Recreate"` | Type of deployment strategy |
| serviceMonitor.enabled | bool | `false` | Enable Prometheus ServiceMonitor |
| serviceMonitor.interval | string | `"60s"` | Scrape interval. If not set, the Prometheus default scrape interval is used |
| serviceMonitor.scrapeTimeout | string | `"10s"` | Timeout if metrics can't be retrieved in given time interval |
| serviceMonitor.scheme | string | `nil` | Scheme to use when scraping, e.g. http (default) or https |
| serviceMonitor.tlsConfig | object | `{}` | TLS configuration to use when scraping, only applicable for scheme https |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector, only select Prometheus instances with these labels (if not set, select any Prometheus) |
| serviceMonitor.namespace | string | `nil` | Namespace where the ServiceMonitor resource should be created, default is the same as the release namespace |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels to add to the ServiceMonitor |
| serviceMonitor.annotations | object | `{}` | Additional annotations to add to the ServiceMonitor |
| dnsPolicy | string | `""` | Use this option to set a custom DNS policy to the created deployment |
| dnsConfig | object | `{}` | Use this option to set custom DNS configurations to the created deployment |
| priorityClassName | string | `""` | Use this option to set custom PriorityClass to the created deployment ref: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass |
| networkPolicy.enabled | bool | `false` | Enable/disable Network Policy |
| networkPolicy.ingress | bool | `true` | Enable/disable Ingress policy type |
| networkPolicy.egress | bool | `true` | Enable/disable Egress policy type |
| networkPolicy.allowExternal | bool | `true` | Allow incoming connections only from specific Pods. When set to true, the server will accept connections from any source. When false, only Pods with the label {{ include "uptime-kuma.fullname" . }}-client=true will have network access |
| networkPolicy.namespaceSelector | object | `{}` | Selects particular namespaces for which all Pods are allowed as ingress sources |
| mariadb | object | Omitted for brevity | MariaDB subchart configuration (from Bitnami) |
| mariadb.enabled | bool | `false` | Enable MariaDB subchart |
| mariadb.architecture | string | `"standalone"` | MariaDB architecture (standalone or replication) |
| mariadb.auth | object | Omitted for brevity | MariaDB authentication configuration |
| mariadb.auth.database | string | `"uptime_kuma"` | Database name to create |
| mariadb.auth.username | string | `"uptime_kuma"` | Database username to create |
| mariadb.auth.password | string | `""` | Password for the database user |
| mariadb.auth.rootPassword | string | `""` | MariaDB root password |

## Source Code

* <https://github.com/louislam/uptime-kuma>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| younsl | <cysl@kakao.com> |  |

## License

This chart is licensed under the Apache License 2.0. See [LICENSE](https://github.com/younsl/younsl.github.io/blob/main/LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a [Pull Request](https://github.com/younsl/younsl.github.io/pulls).

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
