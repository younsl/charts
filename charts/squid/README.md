# squid

![Version: 0.7.0](https://img.shields.io/badge/Version-0.7.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.13](https://img.shields.io/badge/AppVersion-6.13-informational?style=flat-square)

A Helm chart for Squid caching proxy

**Homepage:** <https://www.squid-cache.org/>

## Requirements

Kubernetes: `>=1.21.0-0`

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/squid
```

If you need to install crane on macOS, you can easily install it using [Homebrew](https://brew.sh/), the package manager.

```bash
brew install crane
```

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
helm install squid oci://ghcr.io/younsl/charts/squid --version 0.7.0
```

### Install from local chart

Download squid chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/squid --untar --version 0.7.0
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
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| replicaCount | int | `2` |  |
| revisionHistoryLimit | int | `10` |  |
| strategy.type | string | `"RollingUpdate"` |  |
| strategy.rollingUpdate.maxSurge | string | `"25%"` |  |
| strategy.rollingUpdate.maxUnavailable | string | `"25%"` |  |
| image.repository | string | `"ubuntu/squid"` |  |
| image.tag | string | `"6.13-25.04_beta"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| imagePullSecrets | list | `[]` |  |
| commonLabels | object | `{}` |  |
| commonAnnotations.description | string | `"Squid is a HTTP/HTTPS proxy server supporting caching and domain whitelist access control."` |  |
| annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.annotations | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext.fsGroup | int | `13` |  |
| terminationGracePeriodSeconds | int | `60` |  |
| squidShutdownTimeout | int | `30` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `13` |  |
| securityContext.runAsGroup | int | `13` |  |
| env | list | `[]` |  |
| envFrom | list | `[]` |  |
| dnsPolicy | string | `"ClusterFirst"` |  |
| dnsConfig | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| service.port | int | `3128` |  |
| service.targetPort | int | `3128` |  |
| service.nodePort | string | `""` |  |
| service.externalTrafficPolicy | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.trafficDistribution | string | `""` |  |
| service.annotations | object | `{}` |  |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"squid.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Ingress configuration for external access to squid proxy |
| ingress.enabled | bool | `false` | Enable or disable Ingress resource creation |
| ingress.className | string | `""` | IngressClass name to use for this Ingress |
| ingress.hosts | list | `[{"host":"squid.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | List of hostnames and paths for Ingress routing |
| ingress.tls | list | `[]` | TLS configuration for HTTPS termination |
| resources | object | `{"limits":{"memory":"256Mi"},"requests":{"cpu":"50m","memory":"128Mi"}}` | Resource limits and requests for squid container |
| resources.limits | object | `{"memory":"256Mi"}` | Maximum resource limits (CPU and memory) |
| resources.requests | object | `{"cpu":"50m","memory":"128Mi"}` | Minimum resource requests (CPU and memory) |
| resizePolicy | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| topologySpreadConstraints | list | `[]` |  |
| config.allowedNetworks.extra | list | `[]` |  |
| config."squid.conf" | string | Default squid.conf with basic ACLs and security settings. See [values.yaml](https://github.com/younsl/younsl.github.io/blob/main/content/charts/squid/values.yaml) for full configuration. | Squid configuration file content This configuration will be mounted to /etc/squid/squid.conf inside the squid container See: https://www.squid-cache.org/Versions/v6/cfgman/ |
| config.annotations | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `2` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `70` |  |
| autoscaling.annotations | object | `{}` |  |
| autoscaling.behavior.scaleDown.stabilizationWindowSeconds | int | `600` |  |
| autoscaling.behavior.scaleDown.policies[0].type | string | `"Percent"` |  |
| autoscaling.behavior.scaleDown.policies[0].value | int | `50` |  |
| autoscaling.behavior.scaleDown.policies[0].periodSeconds | int | `60` |  |
| autoscaling.behavior.scaleDown.policies[1].type | string | `"Pods"` |  |
| autoscaling.behavior.scaleDown.policies[1].value | int | `2` |  |
| autoscaling.behavior.scaleDown.policies[1].periodSeconds | int | `60` |  |
| autoscaling.behavior.scaleDown.selectPolicy | string | `"Min"` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.initialDelaySeconds | int | `20` |  |
| livenessProbe.periodSeconds | int | `5` |  |
| livenessProbe.timeoutSeconds | int | `1` |  |
| livenessProbe.successThreshold | int | `1` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `5` |  |
| readinessProbe.timeoutSeconds | int | `1` |  |
| readinessProbe.successThreshold | int | `1` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| persistence.enabled | bool | `false` |  |
| persistence.storageClassName | string | `""` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.size | string | `"1Gi"` |  |
| persistence.volumeName | string | `""` |  |
| persistence.annotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `true` |  |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podDisruptionBudget.annotations | object | `{}` |  |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `"IfHealthyBudget"` |  |
| squidExporter.enabled | bool | `true` |  |
| squidExporter.image.repository | string | `"boynux/squid-exporter"` |  |
| squidExporter.image.tag | string | `"v1.13.0"` |  |
| squidExporter.image.pullPolicy | string | `"IfNotPresent"` |  |
| squidExporter.port | int | `9301` |  |
| squidExporter.metricsPath | string | `"/metrics"` |  |
| squidExporter.resources.limits.memory | string | `"64Mi"` |  |
| squidExporter.resources.requests.cpu | string | `"10m"` |  |
| squidExporter.resources.requests.memory | string | `"32Mi"` |  |
| squidExporter.resizePolicy | list | `[]` |  |
| squidExporter.squidHostname | string | `"localhost"` |  |
| squidExporter.squidPort | string | `nil` |  |
| squidExporter.squidLogin | string | `""` |  |
| squidExporter.squidPassword | string | `""` |  |
| squidExporter.extractServiceTimes | bool | `true` |  |
| squidExporter.customLabels | object | `{}` |  |
| dashboard.enabled | bool | `false` |  |
| dashboard.grafanaNamespace | string | `""` |  |
| dashboard.annotations | object | `{}` |  |
| extraManifests | list | `[]` | Extra manifests to deploy additional Kubernetes resources Supports tpl function for dynamic values |

## Source Code

* <https://www.squid-cache.org/>
* <https://hub.docker.com/r/ubuntu/squid>
* <https://github.com/younsl/charts>

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
