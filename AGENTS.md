# AGENTS.md

## Repository overview

This repository contains multiple Helm charts under [charts](charts). Each chart is self-contained and typically includes:

- [Chart.yaml](charts/*/Chart.yaml) for chart metadata and version
- [values.yaml](charts/*/values.yaml) and [values.schema.json](charts/*/values.schema.json)
- [templates](charts/*/templates) for Kubernetes manifests
- [ci/test-values.yaml](charts/*/ci/test-values.yaml) for chart-testing input

## Working conventions

- Follow existing chart structure and naming patterns instead of introducing new conventions.
- Keep chart-specific changes inside the relevant chart directory unless the change truly affects the whole repository.
- Any chart change should include a version bump in the chart's [Chart.yaml](charts/*/Chart.yaml), even for documentation-only updates.
- Prefer small, focused changes that preserve Helm best practices and existing template behavior.
- When editing chart docs or values, update the generated README/schema with the chart-specific generation target rather than editing generated files by hand.

## Common commands

- Review repository workflow in [README.md](README.md) and [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).
- Check available tooling with:
  - `make tools-check`
- Render or validate a single chart with:
  - `make template CHART=charts/<chart-name> VALUES=ci/test-values.yaml RELEASE_NAME=<release-name>`
  - `make lint CHART=charts/<chart-name>`
- Regenerate README/schema for one chart:
  - `make gen CHART=charts/<chart-name>`
- If a change affects multiple charts, consider the broader repository workflow described in [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

## Preferred workflow for agents

1. Inspect the relevant chart directory and its existing templates/values before making changes.
2. Make the smallest change that solves the task while preserving compatibility.
3. Update generated documentation/schema when chart content changes.
4. Validate with the appropriate make target before finishing.

## Notes

- The repository uses Makefile-driven workflows from [Makefile](Makefile).
- Commit messages should follow the conventions documented in [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).
