# AGENTS.md

## Repository overview

This repository contains the Paperless-NGX Helm chart under [charts/paperless-ngx](charts/paperless-ngx). The chart is self-contained and includes:

- [Chart.yaml](charts/paperless-ngx/Chart.yaml) for chart metadata and version
- [values.yaml](charts/paperless-ngx/values.yaml) and [values.schema.json](charts/paperless-ngx/values.schema.json)
- [templates](charts/paperless-ngx/templates) for Kubernetes manifests
- [ci/test-values.yaml](charts/paperless-ngx/ci/test-values.yaml) for chart-testing input

## Working conventions

- Follow existing chart structure and naming patterns instead of introducing new conventions.
- Any chart change should include a version bump in [Chart.yaml](charts/paperless-ngx/Chart.yaml), even for documentation-only updates.
- Prefer small, focused changes that preserve Helm best practices and existing template behavior.
- When editing chart docs or values, update the generated README/schema with the `make gen` target rather than editing generated files by hand.

## Common commands

- Review repository workflow in [README.md](README.md) and [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).
- Check available tooling with:
  - `make tools-check`
- Render or validate the chart with:
  - `make template` - Template with default values
  - `make template VALUES=ci/test-values.yaml` - Template with test values
  - `make lint` - Run linting checks
  - `make dry-install VALUES=ci/test-values.yaml` - Dry-run installation
- Regenerate README/schema:
  - `make gen`
- Build the chart package:
  - `make build`

## Preferred workflow for agents

1. Inspect the chart directory and its existing templates/values before making changes.
2. Make the smallest change that solves the task while preserving compatibility.
3. Update generated documentation/schema when chart content changes with `make gen`.
4. Validate with the appropriate make target before finishing.

## Notes

- The repository uses Makefile-driven workflows from [Makefile](Makefile).
- Commit messages should follow the conventions documented in [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

