# uptime-kuma

![Version: 2.23.0](https://img.shields.io/badge/Version-2.23.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.23.16](https://img.shields.io/badge/AppVersion-1.23.16-informational?style=flat-square)

A self-hosted Monitoring tool like "Uptime-Robot".

**Homepage:** <https://github.com/younsl/charts>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb | 21.0.7 |

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use `crane` instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/uptime-kuma
```

If you don't have `crane` installed, you can install it with: `brew install crane`

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
helm install uptime-kuma oci://ghcr.io/younsl/charts/uptime-kuma --version 2.23.0
```

### Install from local chart

Download uptime-kuma chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/uptime-kuma --untar --version 2.23.0
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
| image.repository | string | `"louislam/uptime-kuma"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `"1.23.16-debian"` |  |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| namespaceOverride | string | `""` | A custom namespace to override the default namespace for the deployed resources. |
| useDeploy | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.name | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podEnv | list | `[]` |  |
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `3001` |  |
| service.nodePort | string | `nil` |  |
| service.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.extraLabels | object | `{}` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-read-timeout" | string | `"3600"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/proxy-send-timeout" | string | `"3600"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/server-snippets" | string | `"location / {\n  proxy_set_header Upgrade $http_upgrade;\n  proxy_http_version 1.1;\n  proxy_set_header X-Forwarded-Host $http_host;\n  proxy_set_header X-Forwarded-Proto $scheme;\n  proxy_set_header X-Forwarded-For $remote_addr;\n  proxy_set_header Host $host;\n  proxy_set_header Connection \"upgrade\";\n  proxy_set_header X-Real-IP $remote_addr;\n  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n  proxy_set_header   Upgrade $http_upgrade;\n  proxy_cache_bypass $http_upgrade;\n}\n"` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| resources | object | `{}` |  |
| resizePolicy | list | `[]` | Container resize policy for the uptime-kuma container Ref: https://kubernetes.io/docs/tasks/configure-pod-container/resize-container-resources/ |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `180` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `2` |  |
| livenessProbe.exec.command[0] | string | `"extra/healthcheck"` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.initialDelaySeconds | int | `10` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.exec.command | list | `[]` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | int | `3001` |  |
| readinessProbe.httpGet.scheme | string | `"HTTP"` |  |
| readinessProbe.httpGet.httpHeaders | list | `[]` |  |
| volume.enabled | bool | `true` |  |
| volume.accessMode | string | `"ReadWriteOnce"` |  |
| volume.size | string | `"4Gi"` |  |
| volume.storageClassName | string | `"gp3"` |  |
| volume.existingClaim | string | `""` |  |
| additionalVolumes | list | `[]` | A list of additional volumes to be added to the pod |
| additionalVolumeMounts | list | `[]` | A list of additional volumeMounts to be added to the pod |
| strategy.type | string | `"Recreate"` |  |
| mariadb.enabled | bool | `false` |  |
| mariadb.architecture | string | `"standalone"` |  |
| mariadb.auth.database | string | `"uptime_kuma"` |  |
| mariadb.auth.username | string | `"uptime_kuma"` |  |
| mariadb.auth.password | string | `""` |  |
| mariadb.auth.rootPassword | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| serviceMonitor.interval | string | `"60s"` | Scrape interval. If not set, the Prometheus default scrape interval is used. |
| serviceMonitor.scrapeTimeout | string | `"10s"` | Timeout if metrics can't be retrieved in given time interval |
| serviceMonitor.scheme | string | `nil` | Scheme to use when scraping, e.g. http (default) or https. |
| serviceMonitor.tlsConfig | object | `{}` | TLS configuration to use when scraping, only applicable for scheme https. |
| serviceMonitor.relabelings | list | `[]` | Prometheus [RelabelConfigs] to apply to samples before scraping |
| serviceMonitor.metricRelabelings | list | `[]` | Prometheus [MetricRelabelConfigs] to apply to samples before ingestion |
| serviceMonitor.selector | object | `{}` | Prometheus ServiceMonitor selector, only select Prometheus's with these labels (if not set, select any Prometheus) |
| serviceMonitor.namespace | string | `nil` | Namespace where the ServiceMonitor resource should be created, default is the same as the release namespace |
| serviceMonitor.additionalLabels | object | `{}` | Additional labels to add to the ServiceMonitor |
| serviceMonitor.annotations | object | `{}` | Additional annotations to add to the ServiceMonitor |
| dnsPolicy | string | `""` | Use this option to set a custom DNS policy to the created deployment |
| dnsConfig | object | `{}` | Use this option to set custom DNS configurations to the created deployment |
| priorityClassName | string | `""` | Use this option to set custom PriorityClass to the created deployment ref: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass |
| networkPolicy | object | `{"allowExternal":true,"egress":true,"enabled":false,"ingress":true,"namespaceSelector":{}}` | Create a NetworkPolicy |
| networkPolicy.enabled | bool | `false` | Enable/disable Network Policy |
| networkPolicy.ingress | bool | `true` | Enable/disable Ingress policy type |
| networkPolicy.egress | bool | `true` | Enable/disable Egress policy type |
| networkPolicy.allowExternal | bool | `true` | Allow incoming connections only from specific Pods When set to true, the geoserver will accept connections from any source. When false, only Pods with the label {{ include "geoserver.fullname" . }}-client=true will have network access |
| networkPolicy.namespaceSelector | object | `{}` | Selects particular namespaces for which all Pods are allowed as ingress sources |

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
