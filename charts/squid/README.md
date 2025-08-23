# squid

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.10](https://img.shields.io/badge/AppVersion-6.10-informational?style=flat-square)

A Helm chart for Squid caching proxy

**Homepage:** <https://www.squid-cache.org/>

## Requirements

Kubernetes: `>=1.21.0-0`

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use `crane` instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/squid
```

If you don't have `crane` installed, you can install it with: `brew install crane`

### Install the chart

Install the chart with the release name `squid`:

```console
helm install squid oci://ghcr.io/younsl/charts/squid
```

Install with custom values:

```console
helm install squid oci://ghcr.io/younsl/charts/squid -f values.yaml
```

Install a specific version:

```console
helm install squid oci://ghcr.io/younsl/charts/squid --version 0.5.0
```

### Install from local chart

Download squid chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/squid --untar --version 0.5.0
helm install squid ./squid
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade squid oci://ghcr.io/younsl/charts/squid
```

## Uninstall

```console
helm uninstall squid
```

## Configuration

The following table lists the configurable parameters and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| annotations | object | `{}` |  |
| autoscaling.annotations | object | `{}` |  |
| autoscaling.behavior.scaleDown.policies[0].periodSeconds | int | `60` |  |
| autoscaling.behavior.scaleDown.policies[0].type | string | `"Percent"` |  |
| autoscaling.behavior.scaleDown.policies[0].value | int | `50` |  |
| autoscaling.behavior.scaleDown.policies[1].periodSeconds | int | `60` |  |
| autoscaling.behavior.scaleDown.policies[1].type | string | `"Pods"` |  |
| autoscaling.behavior.scaleDown.policies[1].value | int | `2` |  |
| autoscaling.behavior.scaleDown.selectPolicy | string | `"Min"` |  |
| autoscaling.behavior.scaleDown.stabilizationWindowSeconds | int | `600` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `2` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| commonAnnotations.description | string | `"Squid is a HTTP/HTTPS proxy server supporting caching and domain whitelist access control."` |  |
| commonLabels | object | `{}` |  |
| config."squid.conf" | string | Default squid.conf with basic ACLs and security settings. See [values.yaml](https://github.com/younsl/younsl.github.io/blob/main/content/charts/squid/values.yaml) for full configuration. | Squid configuration file content This configuration will be mounted to /etc/squid/squid.conf inside the squid container See: https://www.squid-cache.org/Versions/v6/cfgman/ |
| config.allowedNetworks.extra | list | `[]` |  |
| config.annotations | object | `{}` |  |
| dashboard.annotations | object | `{}` |  |
| dashboard.enabled | bool | `false` |  |
| dashboard.grafanaNamespace | string | `""` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| extraManifests | list | `[]` | Extra manifests to deploy additional Kubernetes resources Supports tpl function for dynamic values |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ubuntu/squid"` |  |
| image.tag | string | `"6.10-24.10_beta"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"squid.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `20` |  |
| livenessProbe.periodSeconds | int | `5` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.timeoutSeconds | int | `1` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.storageClassName | string | `""` |  |
| persistence.volumeName | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podDisruptionBudget.annotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `true` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `"IfHealthyBudget"` |  |
| podSecurityContext.fsGroup | int | `13` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| replicaCount | int | `2` |  |
| resources.limits.memory | string | `"256Mi"` |  |
| resources.requests.cpu | string | `"50m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| revisionHistoryLimit | int | `10` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsGroup | int | `13` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `13` |  |
| service.annotations | object | `{}` |  |
| service.externalTrafficPolicy | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.nodePort | string | `""` |  |
| service.port | int | `3128` |  |
| service.targetPort | int | `3128` |  |
| service.trafficDistribution | string | `""` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| squidExporter.customLabels | object | `{}` |  |
| squidExporter.enabled | bool | `true` |  |
| squidExporter.extractServiceTimes | bool | `true` |  |
| squidExporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| squidExporter.image.repository | string | `"boynux/squid-exporter"` |  |
| squidExporter.image.tag | string | `"v1.13.0"` |  |
| squidExporter.metricsPath | string | `"/metrics"` |  |
| squidExporter.port | int | `9301` |  |
| squidExporter.resources.limits.memory | string | `"64Mi"` |  |
| squidExporter.resources.requests.cpu | string | `"10m"` |  |
| squidExporter.resources.requests.memory | string | `"32Mi"` |  |
| squidExporter.squidHostname | string | `"localhost"` |  |
| squidExporter.squidLogin | string | `""` |  |
| squidExporter.squidPassword | string | `""` |  |
| squidExporter.squidPort | string | `nil` |  |
| squidShutdownTimeout | int | `30` |  |
| strategy.rollingUpdate.maxSurge | string | `"25%"` |  |
| strategy.rollingUpdate.maxUnavailable | string | `"25%"` |  |
| strategy.type | string | `"RollingUpdate"` |  |
| terminationGracePeriodSeconds | int | `60` |  |
| tolerations | list | `[]` |  |
| topologySpreadConstraints | list | `[]` |  |

## Source Code

* <https://www.squid-cache.org/>
* <https://github.com/younsl/younsl.github.io>
* <https://younsl.github.io/charts/>

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
