# OCI Background

## Summary

This guide explains why we use OCI to share Helm charts instead of the old way. It talks about the benefits and how other popular projects are doing the same thing.

## Helm OCI Support

The Helm CLI has supported OCI-based registries since version 3.8.0. For more details, see the [official Helm documentation on registries](https://helm.sh/docs/topics/registries/).

## Why OCI?

This repository uses [OCI (Open Container Initiative)](https://opencontainers.org/) artifacts for [Helm chart distribution](https://helm.sh/docs/topics/registries/) instead of traditional Helm repositories. OCI provides better security through immutable artifacts and content signing, improved performance via global CDN distribution and efficient caching, and a unified developer experience using the same registry infrastructure for both container images and Helm charts. As the cloud-native ecosystem moves toward OCI standards, this approach ensures future compatibility while leveraging the robust features of modern container registries.

Major Kubernetes projects like **Grafana**, **Prometheus**, **Istio**, and **cert-manager** have already migrated to OCI-based chart distribution, demonstrating the industry-wide adoption of this modern approach.