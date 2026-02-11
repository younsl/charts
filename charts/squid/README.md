# squid

![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 6.13](https://img.shields.io/badge/AppVersion-6.13-informational?style=flat-square)

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
helm install squid oci://ghcr.io/younsl/charts/squid --version 0.8.0
```

### Install from local chart

Download squid chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/squid --untar --version 0.8.0
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
| nameOverride | string | `""` | Override the name of the chart |
| fullnameOverride | string | `""` | Override the fullname of the chart |
| replicaCount | int | `2` | Number of squid replicas to deploy |
| revisionHistoryLimit | int | `10` | Number of old ReplicaSets to retain for rollback |
| strategy.type | string | `"RollingUpdate"` | Deployment strategy type |
| strategy.rollingUpdate.maxSurge | string | `"25%"` | Maximum number of pods that can be created above the desired number of pods during the update Can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%) |
| strategy.rollingUpdate.maxUnavailable | string | `"25%"` | Maximum number of pods that can be unavailable during the update Can be an absolute number (ex: 5) or a percentage of desired pods (ex: 10%) |
| image | object | See below values | Container image configuration |
| image.repository | string | `"ubuntu/squid"` | Container image repository |
| image.tag | string | `"6.13-25.04_beta"` | Container image tag |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries |
| commonLabels | object | `{}` | Common labels to add to all kubernetes resources (will be merged with resource-specific labels) |
| commonAnnotations | object | `{"description":"Squid is a HTTP/HTTPS proxy server supporting caching and domain whitelist access control."}` | Common annotations to add to all kubernetes resources (will be merged with resource-specific annotations) |
| annotations | object | `{}` | A resource-specific annotations for Deployment |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set, defaults to a name generated using the fullname template |
| serviceAccount.automountServiceAccountToken | bool | `false` | Set to false for better security unless your application needs to access Kubernetes API |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets to attach to the service account |
| podAnnotations | object | `{}` | Annotations to add to the pod |
| podSecurityContext | object | `{"fsGroup":13}` | Pod security context configuration |
| podSecurityContext.fsGroup | int | `13` | FSGroup that owns the pod's volumes |
| terminationGracePeriodSeconds | int | `60` | Grace period for pod termination (should be longer than squid shutdown_lifetime) |
| squidShutdownTimeout | int | `30` | Squid shutdown timeout (used in shutdown_lifetime and preStop hook timing) |
| securityContext | object | See below values | Security context for the container |
| securityContext.capabilities | object | `{"drop":["ALL"]}` | Linux capabilities to drop or add |
| securityContext.readOnlyRootFilesystem | bool | `false` | Whether to mount the root filesystem as read-only |
| securityContext.runAsNonRoot | bool | `true` | Set to true to run as non-root user |
| securityContext.runAsUser | int | `13` | User 'proxy' is pre-defined in squid container image |
| securityContext.runAsGroup | int | `13` | Group 'proxy' is pre-defined in squid container image |
| env | list | `[]` | Environment variables for squid container |
| envFrom | list | `[]` | Environment variables from existing ConfigMaps and Secrets for squid container |
| dnsPolicy | string | `"ClusterFirst"` | DNS policy for the pod |
| dnsConfig | object | `{}` | DNS configuration for the pod |
| service | object | See below values | Kubernetes service configuration |
| service.type | string | `"ClusterIP"` | Available service types: ClusterIP, NodePort, LoadBalancer |
| service.port | int | `3128` | Squid normally listens to port 3128, but you can change it to any port you want |
| service.targetPort | int | `3128` | Squid normally listens to port 3128, but you can change it to any port you want |
| service.nodePort | string | `""` | Dedicated node port for NodePort service |
| service.externalTrafficPolicy | string | `""` | External traffic policy for LoadBalancer and NodePort services |
| service.loadBalancerIP | string | `""` | Load balancer IP address |
| service.loadBalancerSourceRanges | list | `[]` | Load balancer source IP ranges |
| service.trafficDistribution | string | `""` | Controls how traffic is distributed across the service endpoints Optional field - if not set, Kubernetes uses default load balancing (random distribution) Available values: PreferClose (topology-aware routing), null (disabled) |
| service.annotations | object | `{}` | A resource-specific annotations for Service |
| ingress | object | See below values | Ingress configuration for external access to squid proxy |
| ingress.enabled | bool | `false` | Enable or disable Ingress resource creation |
| ingress.className | string | `""` | IngressClass name to use for this Ingress |
| ingress.annotations | object | `{}` | A resource-specific annotations for Ingress |
| ingress.hosts | list | `[{"host":"squid.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | List of hostnames and paths for Ingress routing |
| ingress.tls | list | `[]` | TLS configuration for HTTPS termination |
| resources | object | See below values | Resource limits and requests for squid container |
| resources.limits | object | `{"memory":"256Mi"}` | Maximum resource limits (CPU and memory) |
| resources.requests | object | `{"cpu":"50m","memory":"128Mi"}` | Minimum resource requests (CPU and memory) |
| resizePolicy | list | `[]` | Container resize policy for in-place resource updates See: https://kubernetes.io/docs/tasks/configure-pod-container/resize-container-resources/ |
| nodeSelector | object | `{}` | Node selector for pod assignment |
| tolerations | list | `[]` | Tolerations for pod assignment |
| affinity | object | `{}` | Affinity rules for pod assignment |
| topologySpreadConstraints | list | `[]` | Pod topology spread constraints (modern approach for pod distribution) |
| config | object | `{"allowedNetworks":{"extra":[]},"annotations":{},"squid.conf":"## Squid normally listens to port {{ .Values.service.targetPort | default 3128 }}\nhttp_port {{ .Values.service.targetPort | default 3128 }}\n\n## PID file location (writable by proxy user)\npid_filename /var/spool/squid/squid.pid\n\n## Log rotation setting\nlogfile_rotate 0\n\n## Reduce log verbosity for health checks\ndebug_options ALL,1\n\n## Uncomment and adjust the following to add a disk cache directory.\n# cache_dir ufs /var/spool/squid 100 16 256\n\n## To disable caching completely, uncomment the following line:\n# cache deny all\n\n## Leave coredumps in the first cache dir\ncoredump_dir /var/spool/squid\n\n## =============================================================================\n## TIMEOUT CONFIGURATION\n## =============================================================================\n## Connection timeouts\nconnect_timeout 10 seconds          # Timeout for server connections\nread_timeout 15 minutes             # Timeout for reading from servers\nrequest_timeout 1 minutes           # Timeout for client requests\nclient_lifetime 1 day               # Maximum time a client connection is kept alive\n\n## Persistent connection timeouts\npconn_timeout 1 minute              # Timeout for persistent connections to servers\nhalf_closed_clients off             # Don't wait for clients to close connections\n\n## Shutdown timeout\nshutdown_lifetime {{ .Values.squidShutdownTimeout }} seconds\n    \n## Add any of your own refresh_pattern entries above these.\nrefresh_pattern ^ftp:           1440    20%     10080\nrefresh_pattern ^gopher:        1440    0%      1440\nrefresh_pattern -i (/cgi-bin/|\\?) 0     0%      0\nrefresh_pattern .               0       20%     4320\n\n## =============================================================================\n## SECURITY CONFIGURATION\n## =============================================================================\n## Port security ACLs and rules\nacl SSL_ports port 443 563\nacl Safe_ports port 80 21 443 70 210 1025-65535 280 488 591 777\nacl CONNECT method CONNECT\n\n## Security rules (processed first)\nhttp_access deny !Safe_ports\nhttp_access deny CONNECT !SSL_ports\n\n## =============================================================================\n## NETWORK ACCESS CONTROL\n## =============================================================================\n## Allowed networks definition\nacl allowed_nets src 10.0.0.0/8\nacl allowed_nets src 172.16.0.0/12\nacl allowed_nets src 192.168.0.0/16\nacl allowed_nets src fc00::/7\nacl allowed_nets src fe80::/10\nacl allowed_nets src 127.0.0.1\nacl allowed_nets src localhost\n\n## Additional allowed networks\n{{- if .Values.config.allowedNetworks.extra }}\n{{- range $network := .Values.config.allowedNetworks.extra }}\nacl allowed_nets src {{ $network.cidr }}  # {{ $network.description }}\n{{- end }}\n{{- end }}\n\n## =============================================================================\n## DOMAIN FILTERING (OPTIONAL)\n## =============================================================================\n## Domain whitelist definition (uncomment to enable domain filtering)\n# acl allowed_domains dstdomain .example.com\n# acl allowed_domains dstdomain .google.com\n# acl allowed_domains dstdomain .github.com\n# acl allowed_domains dstdomain .kubernetes.io\n\n## =============================================================================\n## ACCESS RULES\n## =============================================================================\n## Option 1: Allow all domains for trusted networks (default)\nhttp_access allow allowed_nets\n\n## Option 2: Domain filtering (uncomment below and comment above)\n## Step 1: Uncomment domain ACLs above\n## Step 2: Comment out \"http_access allow allowed_nets\" above  \n## Step 3: Uncomment the line below\n# http_access allow allowed_nets allowed_domains\n\n## Cache Manager access control (allow localhost and pod-internal access)\nhttp_access allow localhost manager\nhttp_access deny manager\n\n## Deny everything else\nhttp_access deny all\n"}` | Squid configuration |
| config.allowedNetworks | object | `{"extra":[]}` | Allowed networks configuration |
| config.allowedNetworks.extra | list | `[]` | Additional networks that can access the proxy |
| config."squid.conf" | string | Default squid.conf with basic ACLs and security settings. See [values.yaml](https://github.com/younsl/younsl.github.io/blob/main/content/charts/squid/values.yaml) for full configuration. | Squid configuration file content This configuration will be mounted to /etc/squid/squid.conf inside the squid container See: https://www.squid-cache.org/Versions/v6/cfgman/ |
| config.annotations | object | `{}` | A resource-specific annotations for ConfigMap |
| autoscaling | object | See below values | Horizontal Pod Autoscaler See: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| autoscaling.enabled | bool | `false` | Enable or disable horizontal pod autoscaling |
| autoscaling.minReplicas | int | `2` | Minimum number of replicas |
| autoscaling.maxReplicas | int | `10` | Maximum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `70` | Target CPU utilization percentage for autoscaling |
| autoscaling.annotations | object | `{}` | A resource-specific annotations for HorizontalPodAutoscaler |
| autoscaling.behavior | object | `{"scaleDown":{"policies":[{"periodSeconds":60,"type":"Percent","value":50},{"periodSeconds":60,"type":"Pods","value":2}],"selectPolicy":"Min","stabilizationWindowSeconds":600}}` | Autoscaling behavior configuration See: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior |
| livenessProbe | object | See below values | Liveness probe determines if the container is running properly If it fails, Kubernetes will restart the container |
| livenessProbe.enabled | bool | `true` | Enable or disable the liveness probe |
| livenessProbe.initialDelaySeconds | int | `20` | Delay before the first probe is initiated after container starts (seconds) Give Squid enough time to initialize before checking |
| livenessProbe.periodSeconds | int | `5` | How often to perform the probe (seconds) More frequent checks = faster failure detection but higher overhead |
| livenessProbe.timeoutSeconds | int | `1` | Number of seconds after which the probe times out (seconds) Should be less than periodSeconds |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed Lower values mean faster recovery detection |
| livenessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the container Higher values prevent restarts during temporary network issues |
| readinessProbe | object | See below values | Readiness probe determines if the container is ready to receive traffic If it fails, the pod is removed from service endpoints but not restarted |
| readinessProbe.enabled | bool | `true` | Enable or disable the readiness probe |
| readinessProbe.initialDelaySeconds | int | `5` | Delay before the first probe is initiated after container starts (seconds) Can be lower than liveness probe since we want to detect readiness quickly |
| readinessProbe.periodSeconds | int | `5` | How often to perform the probe (seconds) Frequent checks ensure traffic is only sent to ready pods |
| readinessProbe.timeoutSeconds | int | `1` | Number of seconds after which the probe times out (seconds) Keep it short for quick detection |
| readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed Set to 1 for quick recovery |
| readinessProbe.failureThreshold | int | `3` | Number of consecutive failures before marking the pod as not ready Pod stays alive but doesn't receive traffic |
| persistence | object | See below values | Persistence for cache |
| persistence.enabled | bool | `false` | Enable or disable persistent volume for cache |
| persistence.storageClassName | string | `""` | Storage class name for the persistent volume |
| persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the persistent volume |
| persistence.size | string | `"1Gi"` | Size of the persistent volume |
| persistence.volumeName | string | `""` | Name of an existing persistent volume to use |
| persistence.annotations | object | `{}` | A resource-specific annotations for PersistentVolumeClaim |
| podDisruptionBudget | object | See below values | Pod Disruption Budget |
| podDisruptionBudget.enabled | bool | `true` | Enable or disable pod disruption budget |
| podDisruptionBudget.minAvailable | int | `1` | Use minAvailable or maxUnavailable, not both If both are set, minAvailable takes priority |
| podDisruptionBudget.annotations | object | `{}` | A resource-specific annotations for PodDisruptionBudget |
| podDisruptionBudget.unhealthyPodEvictionPolicy | string | `"IfHealthyBudget"` | unhealthyPodEvictionPolicy controls when unhealthy pods are evicted Valid values: IfHealthyBudget (default), AlwaysAllow IfHealthyBudget: Unhealthy pods can be disrupted only if minimum available pods are met AlwaysAllow: Always allow eviction of unhealthy pods (best effort availability) |
| squidExporter | object | See below values | Squid Exporter for Prometheus metrics See: https://github.com/boynux/squid-exporter |
| squidExporter.enabled | bool | `true` | Enable or disable squid exporter sidecar |
| squidExporter.image | object | See below values | Container image configuration for squid exporter |
| squidExporter.image.repository | string | `"boynux/squid-exporter"` | Container image repository |
| squidExporter.image.tag | string | `"v1.13.0"` | Container image tag |
| squidExporter.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| squidExporter.port | int | `9301` | Port for exposing metrics |
| squidExporter.metricsPath | string | `"/metrics"` | Metrics endpoint path |
| squidExporter.resources | object | `{"limits":{"memory":"64Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Resource limits and requests for squid exporter container |
| squidExporter.resizePolicy | list | `[]` | Container resize policy for in-place resource updates See: https://kubernetes.io/docs/tasks/configure-pod-container/resize-container-resources/ |
| squidExporter.squidHostname | string | `"localhost"` | Squid hostname to connect to |
| squidExporter.squidPort | int | `nil` | If not specified squidPort, defaults to .Values.service.targetPort |
| squidExporter.squidLogin | string | `""` | Authentication username (if squid requires basic auth) |
| squidExporter.squidPassword | string | `""` | Authentication password (if squid requires basic auth) |
| squidExporter.extractServiceTimes | bool | `true` | Extract service times from squid |
| squidExporter.customLabels | object | `{}` | Additional custom labels for prometheus metrics by squid-exporter By default, customLabels values are passed to squid-exporter as command line arguments (e.g. "-label=environment=development -label=cluster=dev") |
| dashboard | object | See below values | Squid grafana dashboard provided by squid-exporter |
| dashboard.enabled | bool | `false` | Whether to create squid grafana dashboard configmap |
| dashboard.grafanaNamespace | string | `""` | Namespace where grafana is installed Dashboard configmap need to be in the same namespace as grafana |
| dashboard.annotations | object | `{}` | A resource-specific annotations for ConfigMap |
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
