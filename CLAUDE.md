# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code **plugin skill** (`cybersecurity-pro`) distributed via the `pitimon-cybersecurity` marketplace. It generates professional cybersecurity documents (IR playbooks, DFIR reports, DevSecOps configs, SOC procedures, GitOps policies, compliance frameworks, cloud security audits, zero trust architecture, AI/ML security, API security, vulnerability management) in bilingual Thai + English format.

There are no build, lint, or test commands — this is a pure markdown/JSON skill definition repository.

## Architecture

The plugin system has two layers:

1. **Plugin metadata** (`.claude-plugin/`) — Defines the marketplace and plugin identity for Claude Code's plugin installer
2. **Skill definition** (`skills/cybersecurity-pro/`) — The actual skill content loaded at runtime

### How it works at runtime

When a user's prompt matches trigger keywords in `SKILL.md`'s frontmatter, Claude Code loads the skill. The skill's decision tree routes to one of 14 reference files, which provide templates and frameworks for generating output.

```
User prompt → keyword match in SKILL.md frontmatter
  → SKILL.md loaded (language policy, frameworks, output rules)
  → Decision tree selects domain → corresponding references/*.md loaded
  → Output generated following templates in reference file
```

### Key files

| File                                       | Role                                                                                         |
| ------------------------------------------ | -------------------------------------------------------------------------------------------- |
| `.claude-plugin/marketplace.json`          | Marketplace registry entry (name, owner, plugins list)                                       |
| `.claude-plugin/plugin.json`               | Plugin manifest (name, version, author, skills path)                                         |
| `skills/cybersecurity-pro/SKILL.md`        | Skill definition: trigger keywords, language policy, frameworks, decision tree, output rules |
| `skills/cybersecurity-pro/references/*.md` | Domain-specific templates and framework mappings (14 files, one per domain)                  |

### The 14 domains

| Domain                   | Reference file                             | Frameworks                                     |
| ------------------------ | ------------------------------------------ | ---------------------------------------------- |
| IR Playbooks             | `references/ir-playbooks.md`               | NIST 800-61, ISO 27035                         |
| DFIR Reports             | `references/dfir-reports.md`               | Chain of Custody, IOC, Timeline                |
| DevSecOps Pipeline       | `references/devsecops-pipeline.md`         | OWASP SAMM/Top 10, CIS                         |
| SOC Operations + SOAR    | `references/soc-operations.md`             | MITRE ATT&CK, Cyber Kill Chain                 |
| GitOps Security          | `references/gitops-security.md`            | OPA/Gatekeeper, Falco, ArgoCD                  |
| Code Security Analysis   | `references/code-security-analysis.md`     | CWE Top 25, SARIF, Semgrep/CodeQL              |
| Container & Supply Chain | `references/container-supply-chain.md`     | NIST SP 800-190, CIS Docker, SLSA              |
| Threat Modeling & Risk   | `references/compliance-threat-modeling.md` | SOC 2, ISO 27001, STRIDE, PASTA                |
| Compliance Frameworks    | `references/compliance-frameworks.md`      | NIST 800-53, PCI DSS, GDPR, HIPAA, CIS v8      |
| Cloud Security & CSPM    | `references/cloud-security-cspm.md`        | CIS Cloud Benchmarks, CSA CCM v4, NIST 800-144 |
| Zero Trust Architecture  | `references/zero-trust-architecture.md`    | NIST 800-207, CISA ZT Maturity Model           |
| AI/ML Security           | `references/ai-ml-security.md`             | OWASP LLM Top 10, NIST AI RMF, MITRE ATLAS     |
| API Security             | `references/api-security.md`               | OWASP API Top 10, OAuth 2.0 BCP                |
| Vulnerability Management | `references/vulnerability-management.md`   | CVSS v4.0, EPSS, CISA KEV, SSVC                |

## Critical Naming Conventions

These identifiers must stay consistent across all config files and documentation. Mismatches cause `claude doctor` failures:

| Identifier       | Value                                     | Used in                                                 |
| ---------------- | ----------------------------------------- | ------------------------------------------------------- |
| Marketplace name | `pitimon-cybersecurity`                   | marketplace.json key, install key suffix                |
| Plugin name      | `cybersecurity-pro`                       | plugin.json, SKILL.md frontmatter                       |
| Install key      | `cybersecurity-pro@pitimon-cybersecurity` | installed_plugins.json, settings.json                   |
| GitHub path      | `pitimon/claude-cybersecurity-skill`      | marketplace.json source                                 |
| Source type      | `"github"` (never `"local"`)              | known_marketplaces.json — Claude Code rejects `"local"` |

## Contributing a New Domain

1. Create `skills/cybersecurity-pro/references/<domain-name>.md` with templates following the pattern of existing reference files
2. Add the domain entry and trigger keywords to `skills/cybersecurity-pro/SKILL.md` (both the Output Domains section and the Quick Decision Tree)
3. Update the capabilities table in `README.md`
4. Add a CHANGELOG.md entry

## Bilingual Output Policy

All skill output uses Thai prose with inline English technical terms. Section headers use format: `## Thai (English)`. Technical terms (tool names, commands, framework names, acronyms) stay in English — never translated.
