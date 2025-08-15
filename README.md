# charts

Collection of Helm charts maintained by @younsl

## Prerequisites

- Helm v3.8.0+ (OCI support is enabled by default)
- [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane) CLI tool for listing charts (optional)

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
