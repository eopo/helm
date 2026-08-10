# Ad Noctem Collective - `helm` Repository Contributing Guidelines

Contributions are welcome via GitHub's Pull Requests. This document outlines the process to help get your contribution
accepted.

## ⚒️ Building

The project uses the `Make` build tool with targets defined in the projects top-level [`Makefile`](../Makefile).

Before running any other target you should run the `tools-check` target which verifies that all required executables are installed:

```shell
make tools-check
```

### Core Development Tasks

When developing the chart, the [`Makefile`](../Makefile) provides these handy targets:

- **Template**: Render the Helm chart to see the generated Kubernetes manifests
  ```shell
  make template VALUES=ci/test-values.yaml
  ```

- **Lint**: Validate the chart structure and syntax
  ```shell
  make lint
  ```

- **Generate**: Update `values.schema.json` and `README.md` from chart definitions
  ```shell
  make gen
  ```

- **Dry-Install**: Test installation without applying changes
  ```shell
  make dry-install VALUES=ci/test-values.yaml
  ```

- **Build**: Package the chart as a `.tgz` artifact
  ```shell
  make build
  ```

### Local Kubernetes Testing (Optional)

For local testing with a Kubernetes cluster, you can create a temporary development environment:

```shell
make env
```

This creates a local `kind` cluster with pre-configured ingress and cert-manager. To clean up:

```shell
make prune
```

Run `make help` for a full list of available targets.

## ℹ️ Commit Message Format

This specification is inspired by and supersedes the **AngularJS commit message format**.

We have very precise rules over how our Git commit messages must be formatted.
This format leads to **easier to read commit history**.

Each commit message consists of a **header**, a **body**, and a **footer**.

```text
<header>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The `header` is mandatory and must conform to the [Commit Message Header](#commit-header) format.

The `body` is mandatory for all commits except for those of type "docs".
When the body is present it must be at least 20 characters long and must conform to
the [Commit Message Body](#commit-body) format.

The `footer` is optional. The [Commit Message Footer](#commit-footer) format describes what the footer is used for and
the structure it must have.

### <a name="commit-header"></a>Commit Message Header

```text
<type>(<scope>): <short summary>
  │       │             │
  │       │             └─⫸ Summary in present tense. Not capitalized. No period at the end.
  │       │
  │       └─⫸ Commit Scope: charts|make|scripts|docs
  │
  └─⫸ Commit Type: build|ci|docs|feat|fix|perf|refactor|test
```

The `<type>` and `<summary>` fields are mandatory, the `(<scope>)` field is optional.

#### Type

Must be one of the following:

- **feat**: New features
- **fix**: bugfixes
- **docs**: Documentation changes
- **refactor**: Code changes which neither add features nor fix bugs
- **test**: Adding tests or improving upon existing tests
- **chore**: Miscellaneous maintenance tasks which can generally be ignored
- **build**: Changes or improvements to the build tool or to the projects dependencies (_supported Scopes_: `make`)
- **ci**: Changes to CI configuration files and scripts (_supported Scopes_: `actions`)

#### Scopes

The following is the list of supported scopes:

- `paperless-ngx` - Changes to the Paperless-NGX chart
- `k8s` - Changes to Kubernetes manifests (development setup)
- `make` - Changes affecting the Make-based build tool
- `config` - Changes to configuration files

#### Summary

Use the summary field to provide a succinct description of the change:

- use the imperative, present tense: "change" not "changed" nor "changes"
- don't capitalize the first letter
- no dot (.) at the end

#### <a name="commit-body"></a>Commit Message Body

Just as in the summary, use the imperative, present tense: "fix" not "fixed" nor "fixes".

Explain the motivation for the change in the commit message body. This commit message should explain _why_ you are
making the change.
You can include a comparison of the previous behavior with the new behavior in order to illustrate the impact of the
change.

#### <a name="commit-footer"></a>Commit Message Footer

The footer can contain information about breaking changes and deprecations and is also the place to reference GitHub
issues, Jira tickets, and other PRs that this commit closes or is related to.
For example:

```text
BREAKING CHANGE: <breaking change summary>
<BLANK LINE>
<breaking change description + migration instructions>
<BLANK LINE>
<BLANK LINE>
Fixes #<issue number>
```

or

```text
DEPRECATED: <what is deprecated>
<BLANK LINE>
<deprecation description + recommended update path>
<BLANK LINE>
<BLANK LINE>
Closes #<pr number>
```

Breaking Change section should start with the phrase "BREAKING CHANGE: " followed by a summary of the breaking change, a
blank line, and a detailed description of the breaking change that also includes migration instructions.

Similarly, a Deprecation section should start with "DEPRECATED: " followed by a short description of what is deprecated,
a blank line, and a detailed description of the deprecation that also mentions the recommended update path.

#### Revert commits

If the commit reverts a previous commit, it should begin with `revert:`, followed by the header of the reverted commit.

The content of the commit message body should contain:

- information about the SHA of the commit being reverted in the following format: `This reverts commit <SHA>`,
- a clear description of the reason for reverting the commit message.

## ✅ How to Contribute

1. Fork this repository, develop, and test your changes
2. Add your GitHub username to the [`AUTHORS`](../.github/AUTHORS) and [`CODEOWNERS`](../.github/CODEOWNERS) files
3. Submit a pull request

_**NOTE**_: Please submit any changes in a single PR.

### Technical Requirements

- Must follow [Charts best practices](https://helm.sh/docs/topics/chart_best_practices/)
- Must pass CI jobs for linting and installing changed charts with
- Must pass CI jobs for linting and installing the chart with
  the [chart-testing](https://github.com/helm/chart-testing) tool
- Any change to the chart requires a version bump following [SemVer](https://semver.org/).
  See [Immutability](#immutability) and [Versioning](#versioning) below

Once changes have been merged, the release job will automatically run to package and release the chart.
### Immutability

Chart releases must be immutable. Any change to a chart warrants a chart version bump even if it is only changed to the
documentation.

### Versioning

The chart `version` should follow [SemVer](https://semver.org/).

New charts should start at `0.1.0`. They will be upgraded to a _stable_ `1.0.0` after they have been used in production
clusters for more than a month without issues. This is obviously hard to do, but as [I](https://github.com/mvprowess)
operate a cluster myself I will be taking care of this.

Any breaking (backwards incompatible) changes to a chart should:

1. Bump the MAJOR version
2. In the README, under a section called "Upgrading", describe the manual steps necessary to upgrade to the new (
   specified) MAJOR version
