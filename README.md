# Paperless-NGX Helm Chart <img src="https://raw.githubusercontent.com/paperless-ngx/paperless-ngx/5842944d1ef817c11a47ed5c19ba8b7886c9fbfe/resources/logo/web/svg/square.svg" alt="Paperless-NGX Logo" align="right" width="100"/>

[![License](https://img.shields.io/github/license/adnoctem/helm?label=License)](https://opensource.org/licenses/GPL-3.0)
[![CI Status](https://github.com/adnoctem/helm/actions/workflows/cicd-ci.yml/badge.svg)](https://github.com/adnoctem/helm/blob/main/.github/workflows/cicd-ci.yml)

A [GPL-3.0 licensed][license] [_Helm Chart_][helm] for [Paperless-NGX][paperless-ngx] maintained by `Ad Noctem Collective` 
for use with [Kubernetes][kubernetes] `v1.26` and above.

## ✨ TL;DR

### Helm Repository Installation

```shell
helm repo add adnoctem https://adnoctem.github.io/helm
helm install paperless-ngx adnoctem/paperless-ngx
```

### OCI Installation

```shell
helm install oci://ghcr.io/adnoctem/helm/paperless-ngx:<VERSION>
```

## 📖 Chart Information

[Paperless-NGX][paperless-ngx] is a document management system that transforms your physical documents into a searchable 
online archive so you can keep, well, "less paper".

For more information about Paperless-NGX, visit the [official documentation][paperless-docs].

For detailed chart configuration and usage, see the [Chart README](charts/paperless-ngx/README.md).

## 🔃 Contributing

Refer to our [documentation for contributors](docs/CONTRIBUTING.md) for contributing guidelines, commit message
formats and versioning tips.

### Development Workflow

This repository uses GNU Make to ease development workflows. Run `make help` for available targets.

Common commands:

```bash
# Check if you have required tools
make tools-check

# Lint the chart
make lint

# Template the chart with default values
make template

# Template the chart with test values
make template VALUES=ci/test-values.yaml

# Dry-run installation
make dry-install VALUES=ci/test-values.yaml

# Generate/update README and schema
make gen

# Build the chart package
make build
```

## 📥 Maintainers

This project is owned and maintained by [Ad Noctem Collective](https://github.com/adnoctem).  
Refer to the [`AUTHORS`](.github/AUTHORS) or [`CODEOWNERS`](.github/CODEOWNERS) for more information.

## 📝 License

This project is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for more details.

<!-- External references -->
[kubernetes]: https://kubernetes.io
[helm]: https://helm.sh
[paperless-ngx]: https://github.com/paperless-ngx/paperless-ngx
[paperless-docs]: https://docs.paperless-ngx.com
[license]: https://opensource.org/licenses/GPL-3.0
