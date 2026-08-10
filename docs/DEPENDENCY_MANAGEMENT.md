# Dependency Management & Automated Releases

## Overview

This repository uses **Renovate Bot** for automated dependency management combined with GitHub Actions workflows for intelligent testing and automatic releases.

**System Design:**
- ✅ Patch updates (1.0.0 → 1.0.1) → Auto-merge → Auto-release (5 minutes)
- ✅ Minor updates (1.0 → 1.1) → PR for review → Auto-release after merge (10-30 minutes)
- ✅ Major updates (1 → 2) → Issue for manual correction → Auto-release after merge (1-2 days)
- ✅ Version consistency maintained (appVersion = image.tag)
- ✅ Release only after successful tests (quality gate)

## Update Flow

### 1. Patch Updates (Fully Automatic)

```
Monday 6 AM UTC
    ↓
Renovate detects patch update
    ↓
Renovate creates PR (auto-merge: true)
    ↓
GitHub Actions testing starts automatically
    ↓
All tests ✅ pass
    ↓
Auto-merge → Squash commit to main
    ↓
Push triggers Testing Workflow
    ├─ Lint (chart-testing)
    ├─ Version consistency check
    └─ Installation on kind cluster
    ↓
All tests ✅ pass
    ↓
Testing Workflow triggers Release Workflow
    ├─ Sync versions (appVersion ↔ image.tag)
    ├─ Update chart dependencies
    ├─ Build & sign chart
    └─ Publish to GHCR & GitHub Pages
    
⏱️ Total time: ~5 minutes (completely automatic)
```

### 2. Minor Updates (Review Required)

```
Monday 6 AM UTC
    ↓
Renovate detects minor update
    ↓
Renovate creates PR (label: requires-review: minor)
    ↓
GitHub Actions testing starts automatically
    ↓
All tests ✅ pass
    ↓
PR waits for manual review (NO auto-merge)
    ↓
👤 You review release notes and changes
    ↓
👤 You click "Merge pull request"
    ↓
Squash merge to main (same flow as patch)
    ↓
Testing → Release Workflow runs
    ↓
Chart published
    
⏱️ Total time: ~10-30 minutes (depends on review time)
```

### 3. Major Updates (Manual Correction Required)

```
Monday 6 AM UTC
    ↓
Renovate detects major update
    ↓
Renovate creates GitHub Issue (label: requires-review: breaking-change)
    ↓
❌ NO automatic PR created
    ↓
👤 You read the issue and breaking change details
    ↓
👤 You evaluate if upgrade is safe
    ↓
👤 If safe: Create PR manually
    ├─ Edit Chart.yaml version
    ├─ Update values.yaml if needed
    ├─ Fix chart templates if needed
    └─ Push branch
    ↓
GitHub creates PR automatically
    ↓
Testing Workflow runs
    ├─ Lint (chart-testing)
    ├─ Version consistency check
    └─ Installation test
    ↓
Tests result: ✅ pass or ❌ fail
    ↓
If ❌ fail: Fix issues, push again, re-run tests
    ↓
If ✅ pass: PR ready for merge
    ↓
👤 You review changes and click "Merge pull request"
    ↓
Release Workflow runs (same as patch)
    ↓
Chart published
    
⏱️ Total time: 1-2 days (depends on evaluation and fixes)
```

## Version Consistency

### How It Works

**Chart versions across files:**
- `Chart.yaml` - `appVersion:` should match container image
- `values.yaml` - `image.tag:` should match appVersion
- Both should stay in sync at all times

### Testing Phase
```bash
# In cicd-ci.yml workflow:
appVersion=$(yq '.appVersion' charts/paperless-ngx/Chart.yaml)
imageTag=$(yq '.image.tag' charts/paperless-ngx/values.yaml)

if [[ "$appVersion" != "$imageTag" ]]; then
  echo "⚠️ Version mismatch (will sync in release)"
else
  echo "✅ Versions are consistent"
fi
```

### Release Phase
```bash
# In cicd-release.yml workflow:
if [[ "$imageTag" != "$appVersion" ]]; then
  echo "Syncing image.tag = appVersion"
  yq -i ".image.tag = \"$APP_VERSION\"" values.yaml
  git commit -m "chore(release): sync image.tag to match appVersion"
fi
```

## Quality Gates

### Before Testing
- ✅ Chart file exists
- ✅ Valid YAML syntax

### During Testing
- ✅ Helm lint (chart-testing)
- ✅ Version consistency validation
- ✅ ArtifactHub validation
- ✅ Installation test on kind cluster
- ✅ Template rendering

### Before Release
- ✅ Testing Workflow must pass
- ✅ Version consistency check
- ✅ Chart dependencies updated
- ✅ GPG signing key available

### During Release
- ✅ Build chart package
- ✅ Sign with GPG
- ✅ Publish to GitHub Pages
- ✅ Push to GHCR

## Dependency Sources

### Chart Dependencies (in Chart.yaml)
```yaml
dependencies:
  - name: postgresql
    repository: https://charts.bitnami.com/bitnami
    version: ~15.5
  
  - name: redis
    repository: https://charts.bitnami.com/bitnami
    version: ~19.5
  
  - name: tika
    repository: https://apache.jfrog.io/artifactory/tika
    version: ~2.9
  
  - name: gotenberg
    repository: oci://ghcr.io/adnoctem/helm
    version: ~0.3.0
```

### Container Image (in values.yaml)
```yaml
image:
  registry: ghcr.io
  repository: paperless-ngx/paperless-ngx
  tag: "2.10.1"  # Should match Chart.appVersion
```

## Configuration Files

### `renovate.json` - Central Configuration
Controls all dependency scanning:
- What to scan (Helm charts, container images, GitHub Actions)
- When to scan (Monday 6 AM UTC)
- Auto-merge strategies (patch only)
- Version grouping (Bitnami together)
- Security alerting

### `.github/workflows/cicd-ci.yml` - Quality Assurance
Runs on chart changes:
- Helm linting with chart-testing
- Version consistency check
- Installation test on kind cluster
- ArtifactHub validation
- Only proceeds to release if all ✅ pass

### `.github/workflows/cicd-release.yml` - Publishing
Runs after successful testing:
- Verifies test success (quality gate)
- Updates chart dependencies
- Syncs versions
- Builds and signs chart
- Publishes to GHCR and GitHub Pages

## Troubleshooting

### Patch Update Stuck
**Possible causes:**
1. Testing failed (check Actions tab)
2. Auto-merge disabled in renovate.json
3. Branch protection rules requiring reviews

**Solution:**
- Check **Actions → Testing** logs
- Verify `automerge: true` in renovate.json
- Remove review requirement for patch updates

### Minor Update Not Auto-Merging (Expected)
This is intentional - minor updates require manual review.

**What to do:**
1. Read the PR description and release notes
2. Verify tests passed (green checkmark)
3. Click "Merge pull request"
4. Release workflow runs automatically

### Major Update Issue Not Appearing
**Possible causes:**
1. Renovate hasn't run yet (schedule: Monday 6 AM UTC)
2. Major version is not actually an update (already at that version)
3. Update is disabled in renovate.json

**Solution:**
- Wait for next scheduled run
- Check if update is actually available
- Manually create PR if update is available

### Release Failed
**Check the logs:**
1. Go to **Actions → Release → Logs**
2. Look for errors in these steps:
   - "Check if tests passed" - Tests failed
   - "Verify version consistency" - Version issues
   - "Run chart-releaser" - Build/sign failed
   - "Push charts to GHCR" - Authentication failed

**Common fixes:**
- Re-run failed job
- Check GPG secrets are configured
- Verify GHCR credentials

## Best Practices

### For Chart Maintainers

1. **Use semantic versioning in Chart.yaml**
   ```yaml
   version: 0.3.1          # Chart version (increment on release)
   appVersion: 2.10.1      # App version (match container image)
   ```

2. **Keep image tag in sync**
   - Always set `image.tag` in values.yaml to match appVersion
   - Renovate and workflows will enforce this

3. **Document breaking changes**
   - When merging major updates, update CHANGELOG.md
   - Document what changed and why

4. **Review minor updates carefully**
   - Read release notes for deprecated features
   - Check if chart templates need updates

5. **Test major updates locally**
   - Before merging, run `helm install` locally
   - Verify chart works with new dependencies

### For CI/CD Operations

1. **Monitor Renovate PRs**
   - Check **Pull Requests** tab daily
   - Merge patch updates immediately
   - Review minor updates within 24 hours

2. **Watch for Breaking Changes**
   - Check **Issues** tab for breaking change notices
   - Evaluate and create PRs within 48 hours
   - Don't let major updates accumulate

3. **Keep Release Secrets Updated**
   - Verify GPG_KEYRING_BASE64 is current
   - Verify GPG_PASSPHRASE is correct
   - Test release workflow monthly

## Version Update Strategy Summary

| Update Type | Automatic Action | Your Action | Timeline |
|---|---|---|---|
| Patch (1.0.0→1.0.1) | Auto-merge | None | 5 min |
| Minor (1.0→1.1) | Create PR | Review & merge | 10-30 min |
| Major (1→2) | Create issue | Evaluate, fix, create PR | 1-2 days |

## Next Steps

1. ✅ Enable Renovate Bot: https://github.com/apps/renovate
2. ✅ Configure GitHub Secrets (GPG credentials)
3. ✅ Set up branch protection rules
4. ✅ Monitor first patch update
5. ✅ Review first minor update
6. ✅ Evaluate first major update

---

**Questions?** Check the workflow logs or see [SETUP_DEPENDENCY_MANAGEMENT.md](SETUP_DEPENDENCY_MANAGEMENT.md) for quick start guide.
