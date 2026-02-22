# Framework Update Runbook

Step-by-step procedure for updating versioned framework references in the `cybersecurity-pro` plugin.

## Prerequisites

- `frameworks.json` at repo root (single source of truth for all framework versions)
- `bash tests/validate-plugin.sh` passes before you start
- `bash tests/check-framework-updates.sh` to identify what needs updating

## Procedure A: Version-String-Only Update

Use this for errata, point releases, or version bumps with no content changes (e.g., PCI DSS v4.0 to v4.0.1).

### Steps

1. **Update `frameworks.json`**
   - Change `version` to the new version string
   - Update `released` to the new release date
   - Set `last_checked` to today's date (YYYY-MM-DD)
   - Update `notes` if relevant

2. **Find and replace old version strings**

   ```bash
   # Example: PCI DSS v4.0 -> v4.0.1
   grep -rn "PCI DSS v4\.0[^.]" skills/cybersecurity-pro/
   grep -rn "PCI DSS v4\.0[^.]" SKILL.md README.md CLAUDE.md
   ```

   Replace in every file listed in the framework's `used_in` array.

3. **Run validation**

   ```bash
   bash tests/validate-plugin.sh --skip-install-check
   ```

   All Section 5 checks must pass.

4. **Commit**
   ```
   fix: update FRAMEWORK from vOLD to vNEW
   ```

## Procedure B: Substantive Content Update

Use this when a new edition changes controls, risks, or structure (e.g., OWASP Top 10 2021 to 2025, CIS Controls v8 to v8.1).

### Steps

1. **All of Procedure A** (version string replacement)

2. **Update content in the primary reference file**
   - Revise risk lists, control mappings, or structural changes
   - Update any code/config examples that reference old content
   - Preserve bilingual format (Thai prose + English technical terms)

3. **Update cross-references in related domains**
   - Check other reference files that mention this framework
   - Update any outdated cross-reference details
   - Review the cross-domain-integration.md for affected scenarios

4. **Update SKILL.md**
   - Revise the frameworks table (lines ~68-86) if version string changed
   - Update decision tree routing if the domain scope changed

5. **Commit**
   ```
   feat: update FRAMEWORK from vOLD to vNEW
   ```

## Post-Update Checklist

After either procedure:

- [ ] `frameworks.json` — version, released, last_checked all updated
- [ ] No old version string remains (except in historical context like CHANGELOG)
- [ ] `bash tests/validate-plugin.sh --skip-install-check` passes (Section 5 included)
- [ ] `bash tests/check-framework-updates.sh` shows the framework as OK
- [ ] CHANGELOG.md entry added under `[Unreleased]`
- [ ] README.md frameworks table updated (if version appears there)
- [ ] CLAUDE.md domain table updated (if version appears there)

## Versioning Convention

| Change Type                        | Version Bump  | Commit Type |
| ---------------------------------- | ------------- | ----------- |
| Version-string-only (errata/point) | Patch (x.y.Z) | `fix:`      |
| Substantive content changes        | Minor (x.Y.0) | `feat:`     |
| Multiple framework updates (batch) | Minor (x.Y.0) | `feat:`     |

## Quarterly Review Process

Every quarter (Jan/Apr/Jul/Oct), the CI workflow `.github/workflows/framework-review.yml` automatically:

1. Reads `frameworks.json` and checks staleness thresholds
2. Creates a GitHub Issue with a checklist of frameworks to review
3. Labels: `maintenance`, `framework-update`

Thresholds by update frequency:

| Frequency  | Threshold | Examples                             |
| ---------- | --------- | ------------------------------------ |
| `rare`     | 180 days  | NIST SPs, ISO standards, GDPR, HIPAA |
| `annual`   | 90 days   | OWASP lists, CIS Controls, PCI DSS   |
| `frequent` | 30 days   | MITRE ATT&CK, CISA KEV               |

## Ad-Hoc Checking

Run anytime to check current staleness status:

```bash
# Show only CRITICAL and DUE frameworks
bash tests/check-framework-updates.sh

# Show all frameworks including OK
bash tests/check-framework-updates.sh --all
```

## Adding a New Framework

When a new domain or framework is introduced:

1. Add an entry to `frameworks.json` with all required fields
2. Ensure `grep_patterns` actually match in every file listed in `used_in`
3. Run `bash tests/validate-plugin.sh --skip-install-check` to verify
4. Add a note in CHANGELOG.md
