# karpenter-nodepool

![Version: 1.6.0](https://img.shields.io/badge/Version-1.6.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.5.0](https://img.shields.io/badge/AppVersion-1.5.0-informational?style=flat-square)

A Helm chart for Karpenter Node pool, it will create the NodePool and the Ec2NodeClass.

**Homepage:** <https://karpenter.sh/>

## Installation

### List available versions

This chart is distributed via OCI registry, so you need to use [crane](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md) instead of `helm search repo` to discover available versions:

```console
crane ls ghcr.io/younsl/charts/karpenter-nodepool
```

If you need to install crane on macOS, you can easily install it using [Homebrew](https://brew.sh/), the package manager.

```bash
brew install crane
```

### Install the chart

Install the chart with the release name `karpenter-nodepool`:

```console
helm install karpenter-nodepool oci://ghcr.io/younsl/charts/karpenter-nodepool
```

Install with custom values:

```console
helm install karpenter-nodepool oci://ghcr.io/younsl/charts/karpenter-nodepool -f values.yaml
```

Install a specific version:

```console
helm install karpenter-nodepool oci://ghcr.io/younsl/charts/karpenter-nodepool --version 1.6.0
```

### Install from local chart

Download karpenter-nodepool chart and install from local directory:

```console
helm pull oci://ghcr.io/younsl/charts/karpenter-nodepool --untar --version 1.6.0
helm install karpenter-nodepool ./karpenter-nodepool
```

The `--untar` option downloads and unpacks the chart files into a directory for easy viewing and editing.

## Upgrade

```console
helm upgrade karpenter-nodepool oci://ghcr.io/younsl/charts/karpenter-nodepool
```

## Uninstall

```console
helm uninstall karpenter-nodepool
```

## Configuration

The following table lists the configurable parameters and their default values.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | Override the name of the chart |
| globalLabels | object | `{}` | Labels to apply to all resources |
| globalAnnotations | object | `{}` | Annotations to apply to all resources |
| nodePool | object | `{"default":{"annotations":{},"disruption":{"consolidationPolicy":"WhenUnderutilized"},"enabled":false,"expireAfter":"720h","labels":{},"limits":{"cpu":1000,"memory":"1000Gi"},"nodeClassRef":{},"overprovisioning":{"enabled":false,"nodes":1,"podAnnotations":{"description":"Overprovisioning pod for maintaining spare capacity"},"podLabels":{},"resources":{"requests":{"cpu":"1000m","memory":"1Gi"}},"tolerations":[{"operator":"Exists"}],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"overprovisioning"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"DoNotSchedule"}]},"requirements":[],"startupTaints":[],"taints":[],"terminationGracePeriod":null}}` | NodePool configuration for Karpenter |
| nodePool.default | object | `{"annotations":{},"disruption":{"consolidationPolicy":"WhenUnderutilized"},"enabled":false,"expireAfter":"720h","labels":{},"limits":{"cpu":1000,"memory":"1000Gi"},"nodeClassRef":{},"overprovisioning":{"enabled":false,"nodes":1,"podAnnotations":{"description":"Overprovisioning pod for maintaining spare capacity"},"podLabels":{},"resources":{"requests":{"cpu":"1000m","memory":"1Gi"}},"tolerations":[{"operator":"Exists"}],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"overprovisioning"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"DoNotSchedule"}]},"requirements":[],"startupTaints":[],"taints":[],"terminationGracePeriod":null}` | Default NodePool configuration |
| nodePool.default.enabled | bool | `false` | Enable or disable this NodePool resource |
| nodePool.default.labels | object | `{}` | Labels are arbitrary key-values that are applied to all nodes |
| nodePool.default.annotations | object | `{}` | Annotations are arbitrary key-values that are applied to all nodes |
| nodePool.default.nodeClassRef | object | `{}` | References the Cloud Provider's NodeClass resource, see your cloud provider specific documentation |
| nodePool.default.taints | list | `[]` | Provisioned nodes will have these taints. Taints may prevent pods from scheduling if they are not tolerated by the pod. |
| nodePool.default.startupTaints | list | `[]` | Provisioned nodes will have these taints, but pods do not need to tolerate these taints to be provisioned by this NodePool. These taints are expected to be temporary and some other entity (e.g. a DaemonSet) is responsible for removing the taint after it has finished initializing the node. |
| nodePool.default.terminationGracePeriod | string | `nil` | The amount of time that a node can be draining before it's forcibly deleted. A node begins draining when a delete call is made against it, starting its finalization flow. Pods with TerminationGracePeriodSeconds will be deleted preemptively before this terminationGracePeriod ends to give as much time to cleanup as possible. Note: changing this value in the nodepool will drift the nodeclaims. |
| nodePool.default.requirements | list | `[]` | Requirements that constrain the parameters of provisioned nodes. These requirements are combined with pod.spec.topologySpreadConstraints, pod.spec.affinity.nodeAffinity, pod.spec.affinity.podAffinity, and pod.spec.nodeSelector rules. Operators { In, NotIn, Exists, DoesNotExist, Gt, and Lt } are supported. https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#operators |
| nodePool.default.expireAfter | string | `"720h"` | The amount of time a Node can live on the cluster before being removed. Avoiding long-running Nodes helps to reduce security vulnerabilities as well as to reduce the chance of issues that can plague Nodes with long uptimes such as file fragmentation or memory leaks from system processes. You can choose to disable expiration entirely by setting the string value 'Never' here. |
| nodePool.default.disruption | object | `{"consolidationPolicy":"WhenUnderutilized"}` | Disruption section which describes the ways in which Karpenter can disrupt and replace Nodes. Configuration in this section constrains how aggressive Karpenter can be with performing operations like rolling Nodes due to them hitting their maximum lifetime (expiry) or scaling down nodes to reduce cluster cost. |
| nodePool.default.disruption.consolidationPolicy | string | `"WhenUnderutilized"` | Describes which types of Nodes Karpenter should consider for consolidation. If using 'WhenUnderutilized', Karpenter will consider all nodes for consolidation and attempt to remove or replace Nodes when it discovers that the Node is underutilized and could be changed to reduce cost. If using 'WhenEmpty', Karpenter will only consider nodes for consolidation that contain no workload pods. |
| nodePool.default.limits | object | `{"cpu":1000,"memory":"1000Gi"}` | Resource limits constrain the total size of the cluster. Limits prevent Karpenter from creating new instances once the limit is exceeded. |
| nodePool.default.limits.cpu | int | `1000` | Maximum total CPU cores for the NodePool |
| nodePool.default.limits.memory | string | `"1000Gi"` | Maximum total memory for the NodePool |
| nodePool.default.overprovisioning | object | `{"enabled":false,"nodes":1,"podAnnotations":{"description":"Overprovisioning pod for maintaining spare capacity"},"podLabels":{},"resources":{"requests":{"cpu":"1000m","memory":"1Gi"}},"tolerations":[{"operator":"Exists"}],"topologySpreadConstraints":[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"overprovisioning"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"DoNotSchedule"}]}` | Overprovisioning configuration for pre-scaling nodes. This helps reduce pod startup time by keeping spare capacity available. |
| nodePool.default.overprovisioning.enabled | bool | `false` | Enable overprovisioning for this nodepool |
| nodePool.default.overprovisioning.nodes | int | `1` | Number of nodes to keep as spare capacity |
| nodePool.default.overprovisioning.resources | object | `{"requests":{"cpu":"1000m","memory":"1Gi"}}` | Resource requests for overprovisioning pods. These pods will consume resources to maintain spare capacity. |
| nodePool.default.overprovisioning.resources.requests.cpu | string | `"1000m"` | CPU request for overprovisioning pods |
| nodePool.default.overprovisioning.resources.requests.memory | string | `"1Gi"` | Memory request for overprovisioning pods |
| nodePool.default.overprovisioning.topologySpreadConstraints | list | `[{"labelSelector":{"matchLabels":{"app.kubernetes.io/component":"overprovisioning"}},"maxSkew":1,"topologyKey":"kubernetes.io/hostname","whenUnsatisfiable":"DoNotSchedule"}]` | Topology spread constraints for overprovisioning pods. Ensures dummy pods are spread across different nodes. |
| nodePool.default.overprovisioning.tolerations | list | `[{"operator":"Exists"}]` | Tolerations for overprovisioning pods. Default tolerates all taints to ensure pods can be scheduled on any node. |
| nodePool.default.overprovisioning.podLabels | object | `{}` | Additional labels for overprovisioning pods |
| nodePool.default.overprovisioning.podAnnotations | object | `{"description":"Overprovisioning pod for maintaining spare capacity"}` | Additional annotations for overprovisioning pods |
| nodePool.default.overprovisioning.podAnnotations.description | string | `"Overprovisioning pod for maintaining spare capacity"` | Description annotation for overprovisioning pods |
| ec2NodeClass | object | `{"default":{"amiFamily":"AL2","amiSelectorTerms":[],"associatePublicIPAddress":false,"blockDeviceMappings":[],"capacityReservationSelectorTerms":[],"detailedMonitoring":false,"enabled":false,"instanceProfile":"","instanceStorePolicy":null,"kubelet":{},"metadataOptions":{},"role":"","securityGroupSelectorTerms":[],"subnetSelectorTerms":[],"tags":{},"userData":""}}` | EC2NodeClass configuration for AWS Karpenter |
| ec2NodeClass.default | object | `{"amiFamily":"AL2","amiSelectorTerms":[],"associatePublicIPAddress":false,"blockDeviceMappings":[],"capacityReservationSelectorTerms":[],"detailedMonitoring":false,"enabled":false,"instanceProfile":"","instanceStorePolicy":null,"kubelet":{},"metadataOptions":{},"role":"","securityGroupSelectorTerms":[],"subnetSelectorTerms":[],"tags":{},"userData":""}` | Default EC2NodeClass configuration |
| ec2NodeClass.default.enabled | bool | `false` | Enable or disable this EC2NodeClass resource |
| ec2NodeClass.default.amiFamily | string | `"AL2"` | Dictates UserData generation and default block device mappings. May be omitted when using an `alias` amiSelectorTerm, otherwise required. Valid values: AL2, AL2023, Bottlerocket, Custom, Windows2019, Windows2022 |
| ec2NodeClass.default.subnetSelectorTerms | list | `[]` | Discovers subnets to attach to instances. Each term in the array of subnetSelectorTerms is ORed together. Within a single term, all conditions are ANDed. |
| ec2NodeClass.default.securityGroupSelectorTerms | list | `[]` | Discovers security groups to attach to instances. Each term in the array of securityGroupSelectorTerms is ORed together. Within a single term, all conditions are ANDed. |
| ec2NodeClass.default.role | string | `""` | IAM role to use for the node identity. The "role" field is immutable after EC2NodeClass creation. Must specify one of "role" or "instanceProfile" for Karpenter to launch nodes. |
| ec2NodeClass.default.instanceProfile | string | `""` | IAM instance profile to use for the node identity. Must specify one of "role" or "instanceProfile" for Karpenter to launch nodes. |
| ec2NodeClass.default.amiSelectorTerms | list | `[]` | AMI selector terms. Each term in the array of amiSelectorTerms is ORed together. Within a single term, all conditions are ANDed. |
| ec2NodeClass.default.userData | string | `""` | Overrides autogenerated userdata with a merge semantic |
| ec2NodeClass.default.capacityReservationSelectorTerms | list | `[]` | Capacity reservation selector terms. Each term in the array of capacityReservationSelectorTerms is ORed together. |
| ec2NodeClass.default.tags | object | `{}` | Propagates tags to underlying EC2 resources |
| ec2NodeClass.default.metadataOptions | object | `{}` | Configures IMDS for the instance |
| ec2NodeClass.default.blockDeviceMappings | list | `[]` | Configures storage devices for the instance |
| ec2NodeClass.default.instanceStorePolicy | string | `nil` | Use instance-store volumes for node ephemeral-storage. Valid values: RAID0 |
| ec2NodeClass.default.detailedMonitoring | bool | `false` | Configures detailed monitoring for the instance |
| ec2NodeClass.default.associatePublicIPAddress | bool | `false` | Configures if the instance should be launched with an associated public IP address. If not specified, the default value depends on the subnet's public IP auto-assign setting. |
| ec2NodeClass.default.kubelet | object | `{}` | Karpenter provides the ability to specify a few additional Kubelet args. These are all optional and provide support for additional customization and use cases. Kubelet configuration is now managed by EC2NodeClass (moved from NodePool in Karpenter v1.0+). |

## Source Code

* <https://karpenter.sh/>
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
