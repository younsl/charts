# Installation 

## Summary

This guide shows you how to install and use Helm charts from this repository. It includes the tools you need and basic commands to get started.

## Prerequisites

- Helm v3.8.0+ (OCI support is enabled by default) - `brew install helm`
- [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane) CLI tool for listing charts (optional) - `brew install crane`

## Usage

All charts are available as OCI artifacts on GitHub Container Registry.

> **Note**: Helm doesn't natively support listing/searching OCI registries yet. Use `crane` to discover available chart versions.

```bash
# List available versions of a chart using crane
crane ls ghcr.io/younsl/charts/squid

# Show chart information
helm show chart oci://ghcr.io/younsl/charts/squid

# Install chart with a specific version
helm install squid oci://ghcr.io/younsl/charts/squid --version 0.1.0

# Pull chart to local directory for inspection or customization
helm pull oci://ghcr.io/younsl/charts/squid --version 0.1.0 --untar
```
