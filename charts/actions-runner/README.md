# actions-runner

![Version: 0.4.0](https://img.shields.io/badge/Version-0.4.0-informational?style=flat-square)

A Helm chart for Kubernetes to deploy GitHub Actions runners include horizontalRunnerAutoscaler and serviceAccount

⚠️ DEPRECATION NOTICE: This chart covers the legacy mode of ARC (resources in the actions.summerwind.net namespace).
If you're looking for documentation on the newer autoscaling runner scale sets, it is available in GitHub Docs:
https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller

To understand why these resources are considered legacy (and the benefits of using the newer autoscaling runner scale sets),
read this discussion: https://github.com/actions/actions-runner-controller/discussions/2775

The gha-runner-scale-set-controller chart provides better integration with GitHub Actions and more features for managing
self-hosted runners on Kubernetes.

> **:exclamation: This Helm Chart is deprecated!**

**Homepage:** <https://github.com/actions/actions-runner-controller>

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/actions-runner
```

If you need to install crane on macOS, you can easily install it using [Homebrew](https://brew.sh/), the package manager.

```bash
brew install crane
```

### Install the chart

Install the chart with the release name `actions-runner`:

```console
helm install actions-runner oci://ghcr.io/younsl/charts/actions-runner
```

Install with custom values:

```console
helm install actions-runner oci://ghcr.io/younsl/charts/actions-runner -f values.yaml
```

Install a specific version:

```console
helm install actions-runner oci://ghcr.io/younsl/charts/actions-runner --version 0.4.0
```

### Install from local chart

Download actions-runner chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/actions-runner --untar --version 0.4.0
helm install actions-runner ./actions-runner
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade actions-runner oci://ghcr.io/younsl/charts/actions-runner
```

## Uninstall

```console
helm uninstall actions-runner
```

## Configuration

The following table lists the configurable parameters and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `nil` | Override the name of the chart |
| fullnameOverride | string | `nil` | Override the expanded name of the chart |
| runnerDeployments | list | `[{"autoscaling":{"enabled":true,"maxReplicas":16,"metrics":[{"scaleDownFactor":"0.5","scaleDownThreshold":"0.25","scaleUpFactor":"2","scaleUpThreshold":"0.75","type":"PercentageRunnersBusy"}],"minReplicas":2,"scaleDownDelaySecondsAfterScaleOut":300,"scheduledOverrides":[{"endTime":"2023-07-17T00:00:00+09:00","minReplicas":1,"recurrenceRule":{"frequency":"Weekly"},"startTime":"2023-07-15T00:00:00+09:00"}]},"dnsConfig":{},"dockerVolumeMounts":[{"mountPath":"/tmp","name":"tmp"}],"enterprise":"doge-company","group":"","labels":["DOGE-EKS-CLUSTER","m6i.xlarge","ubuntu-22.04","v2.311.0","build"],"nodeSelector":{"node.kubernetes.io/name":"basic"},"persistenceClaims":{},"podAnnotations":{},"podLabels":{},"resources":{"limits":{"cpu":"1.5","memory":"6Gi"},"requests":{"cpu":"0.5","memory":"1Gi"}},"runnerName":"doge-basic-runner","securityContext":{"fsGroup":1001},"serviceAccount":{"annotations":{},"automountServiceAccountToken":true,"create":true,"imagePullSecrets":[]},"topologySpreadConstraints":{},"volumeMounts":[{"mountPath":"/tmp","name":"tmp"}],"volumes":[{"emptyDir":{},"name":"tmp"}]}]` | Multiple runnerDeployments can be declared. |
| runnerDeployments[0] | string | `{"autoscaling":{"enabled":true,"maxReplicas":16,"metrics":[{"scaleDownFactor":"0.5","scaleDownThreshold":"0.25","scaleUpFactor":"2","scaleUpThreshold":"0.75","type":"PercentageRunnersBusy"}],"minReplicas":2,"scaleDownDelaySecondsAfterScaleOut":300,"scheduledOverrides":[{"endTime":"2023-07-17T00:00:00+09:00","minReplicas":1,"recurrenceRule":{"frequency":"Weekly"},"startTime":"2023-07-15T00:00:00+09:00"}]},"dnsConfig":{},"dockerVolumeMounts":[{"mountPath":"/tmp","name":"tmp"}],"enterprise":"doge-company","group":"","labels":["DOGE-EKS-CLUSTER","m6i.xlarge","ubuntu-22.04","v2.311.0","build"],"nodeSelector":{"node.kubernetes.io/name":"basic"},"persistenceClaims":{},"podAnnotations":{},"podLabels":{},"resources":{"limits":{"cpu":"1.5","memory":"6Gi"},"requests":{"cpu":"0.5","memory":"1Gi"}},"runnerName":"doge-basic-runner","securityContext":{"fsGroup":1001},"serviceAccount":{"annotations":{},"automountServiceAccountToken":true,"create":true,"imagePullSecrets":[]},"topologySpreadConstraints":{},"volumeMounts":[{"mountPath":"/tmp","name":"tmp"}],"volumes":[{"emptyDir":{},"name":"tmp"}]}` | The name of the runnerDeployment. |
| runnerDeployments[0].enterprise | string | `"doge-company"` | The name of the enterprise in the Github Enterprise Server. |
| runnerDeployments[0].group | string | `""` | The name of the Runner Group. |
| runnerDeployments[0].podLabels | object | `{}` | Labels for the runner pod. |
| runnerDeployments[0].podAnnotations | object | `{}` | Annotations to be added to the pod This can be used to add metadata to pods, such as for configuration or tool integrations |
| runnerDeployments[0].labels | list | `["DOGE-EKS-CLUSTER","m6i.xlarge","ubuntu-22.04","v2.311.0","build"]` | Labels assigned to the runner. In Actions Workflow, this label specifies which runner to run on, such as runs-on: [self-hosted, linux, build]. |
| runnerDeployments[0].dnsConfig | object | `{}` | DNS configuration for the runner pod. This setting allows you to customize the DNS resolution behavior of the runner pod. By default, the runner pod will use the DNS configuration defined in the Kubernetes cluster. You can override this configuration by specifying a custom DNS configuration. |
| runnerDeployments[0].securityContext | object | `{"fsGroup":1001}` | Security context for the runner pod. |
| runnerDeployments[0].dockerVolumeMounts | list | `[{"mountPath":"/tmp","name":"tmp"}]` | VolumeMounts settings for the dind container in the runner pod. |
| runnerDeployments[0].volumeMounts | list | `[{"mountPath":"/tmp","name":"tmp"}]` | VolumeMounts settings for the runner container in the runner pod. |
| runnerDeployments[0].volumes | list | `[{"emptyDir":{},"name":"tmp"}]` | Volumes settings for the runner container in the runner pod. |
| runnerDeployments[0].resources | object | `{"limits":{"cpu":"1.5","memory":"6Gi"},"requests":{"cpu":"0.5","memory":"1Gi"}}` | Resource limit, request settings for the runner pod. |
| runnerDeployments[0].nodeSelector | object | `{"node.kubernetes.io/name":"basic"}` | Node selector for the runner pod. |
| runnerDeployments[0].autoscaling | object | `{"enabled":true,"maxReplicas":16,"metrics":[{"scaleDownFactor":"0.5","scaleDownThreshold":"0.25","scaleUpFactor":"2","scaleUpThreshold":"0.75","type":"PercentageRunnersBusy"}],"minReplicas":2,"scaleDownDelaySecondsAfterScaleOut":300,"scheduledOverrides":[{"endTime":"2023-07-17T00:00:00+09:00","minReplicas":1,"recurrenceRule":{"frequency":"Weekly"},"startTime":"2023-07-15T00:00:00+09:00"}]}` | HRA (horizontal runner autoscaler) settings connected to the runner deployment. |
| runnerDeployments[0].autoscaling.enabled | bool | `true` | Whether to enable the horizontalRunnerAutoscaler. |
| runnerDeployments[0].autoscaling.scaleDownDelaySecondsAfterScaleOut | int | `300` | Scale down delay in seconds after scale out. |
| runnerDeployments[0].autoscaling.minReplicas | int | `2` | Minimum number of runner pods for the horizontalRunnerAutoscaler. |
| runnerDeployments[0].autoscaling.maxReplicas | int | `16` | Maximum number of runner pods for the horizontalRunnerAutoscaler. |
| runnerDeployments[0].autoscaling.scheduledOverrides | list | `[{"endTime":"2023-07-17T00:00:00+09:00","minReplicas":1,"recurrenceRule":{"frequency":"Weekly"},"startTime":"2023-07-15T00:00:00+09:00"}]` | Scheduled overrides for runner autoscaling. Allows you to set custom scaling rules for specific time periods. Useful for adjusting the number of replicas during known peak or low usage times, such as weekends or holidays. Each override specifies a time range and recurrence pattern for applying the custom scaling settings. Reference: https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/autoscaling-with-self-hosted-runners |
| runnerDeployments[0].autoscaling.metrics | list | `[{"scaleDownFactor":"0.5","scaleDownThreshold":"0.25","scaleUpFactor":"2","scaleUpThreshold":"0.75","type":"PercentageRunnersBusy"}]` | Metrics for autoscaling decisions. This section specifies the metrics used by the Horizontal Runner Autoscaler (HRA) to make scaling decisions. The metrics define how the autoscaler should react to the current state of the runners to adjust the number of replicas accordingly. These metrics are crucial for ensuring that the number of runner pods scales appropriately based on the actual workload and utilization. |
| runnerDeployments[0].autoscaling.metrics[0].scaleUpThreshold | string | `"0.75"` | Increase the number of runners when the percentage of busy runners exceeds this threshold. This helps to handle increased load by adding more runner pods to manage the workload effectively. |
| runnerDeployments[0].autoscaling.metrics[0].scaleDownThreshold | string | `"0.25"` | Decrease the number of runners when the percentage of busy runners falls below this threshold. This helps to reduce resource usage by scaling down the number of runner pods when the load decreases. |
| runnerDeployments[0].autoscaling.metrics[0].scaleUpFactor | string | `"2"` | When scaling up, the number of runners will be multiplied by this factor. For example, a factor of '2' means the number of runners will double when scaling up. |
| runnerDeployments[0].autoscaling.metrics[0].scaleDownFactor | string | `"0.5"` | When scaling down, the number of runners will be multiplied by this factor. For example, a factor of '0.5' means the number of runners will be halved when scaling down. |
| runnerDeployments[0].serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"create":true,"imagePullSecrets":[]}` | Kubernetes service account configuration. A service account provides authentication information used by pods to interact with the Kubernetes API server within the cluster. This configuration allows the runner pod to access necessary cluster resources by assigning appropriate permissions. Using a service account enhances cluster security and allows for the association with specific IAM roles to access AWS resources. |
| runnerDeployments[0].serviceAccount.create | bool | `true` | Determines whether to create a new service account. Setting this to 'true' will create a new service account. |
| runnerDeployments[0].serviceAccount.automountServiceAccountToken | bool | `true` | Automatically mount service account token. |
| runnerDeployments[0].serviceAccount.imagePullSecrets | list | `[]` | Image pull secrets for the service account. This allows the service account to pull images from private container registries. |
| runnerDeployments[0].serviceAccount.annotations | object | `{}` | Annotations for the service account. Supports AWS IAM integration via IRSA or EKS Pod Identity for secure access to AWS resources. |
| runnerDeployments[0].topologySpreadConstraints | object | `{}` | Topology Spread Constraints for the runner. This setting defines how pods should be spread across different topology domains, such as nodes or availability zones, to ensure high availability and fault tolerance. It helps to distribute the pods evenly across the specified topology domains to avoid overloading a single domain and to improve resiliency. Reference: https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/ |
| runnerDeployments[0].persistenceClaims | object | `{}` | Persistent Volume Claims for the runner. This setting allows you to define persistent storage for the runner pods. Multiple PVCs can be defined and will be mounted into the runner pods. Each claim can be configured to be created by this chart or reference an existing PVC. This is useful for caching dependencies, build artifacts, or other data that needs to persist across runner pod restarts. |

## Source Code

* <https://github.com/actions/actions-runner-controller>
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
