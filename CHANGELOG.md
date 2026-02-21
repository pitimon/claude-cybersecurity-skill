# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Threat Intelligence integration templates (STIX/TAXII)
- API Security domain (OWASP API Top 10, OAuth 2.0 BCP)
- Vulnerability Management & Prioritization domain (CVSS v4.0, EPSS, CISA KEV)

## [3.0.0] - 2026-02-21

### Added

- **Cloud Security & CSPM** (Domain 10) — Comprehensive cloud security audit and hardening
  - Shared responsibility model with multi-cloud comparison (AWS/Azure/GCP)
  - IAM policy templates and least privilege patterns
  - Cloud storage security checklists (S3/Blob/GCS)
  - CSPM tool configurations (Prowler, ScoutSuite, Cloud Custodian, Checkov)
  - Cloud audit logging setup (CloudTrail, Azure Monitor, GCP Audit Logs)
  - Infrastructure as Code security scanning (Terraform, CloudFormation)
  - Frameworks: CIS Cloud Benchmarks, CSA CCM v4, NIST 800-144, AWS Well-Architected

- **Zero Trust Architecture** (Domain 11) — Zero Trust implementation and maturity assessment
  - NIST SP 800-207 framework coverage (7 tenets, 3 deployment approaches)
  - 5 pillars: Identity, Device, Network, Application/Workload, Data
  - CISA Zero Trust Maturity Model (Traditional→Initial→Advanced→Optimal)
  - Microsegmentation and ZTNA migration patterns
  - Conditional access and service mesh configurations
  - Phase-by-phase implementation roadmap with KPIs
  - Frameworks: NIST 800-207, CISA ZT Maturity Model, Forrester ZTX

- **AI/ML Security** (Domain 12) — AI and LLM security assessment and governance
  - OWASP Top 10 for LLM Applications with detection and mitigation templates
  - Prompt injection defense patterns (direct/indirect, multi-layer defense)
  - MITRE ATLAS threat mapping for AI-specific attacks
  - NIST AI Risk Management Framework (Govern, Map, Measure, Manage)
  - EU AI Act risk classification and compliance requirements
  - ML-BOM (Machine Learning Bill of Materials) templates
  - AI red teaming methodology and automated testing tools
  - AI incident response playbook adapted from IR domain
  - Frameworks: OWASP LLM Top 10, NIST AI RMF, MITRE ATLAS, EU AI Act, ISO 42001

### Changed

- **SKILL.md** expanded from 9 to 12 domains with updated frontmatter, frameworks table, and decision tree
- **plugin.json** and **marketplace.json** bumped to v3.0.0 with expanded keywords
- **README.md** updated: capabilities tables, repo structure, token budget, version, usage examples
- **CLAUDE.md** updated to reflect 12-domain architecture

## [2.1.0] - 2026-02-21

### Added

- **Compliance Frameworks** (Domain 9) — Dedicated reference for 5 major compliance frameworks
  - NIST SP 800-53 Rev 5: 20 control families, impact baselines, tailoring guidance
  - PCI DSS v4.0: 12 requirements, v3.2.1→v4.0 migration, SAQ decision tree
  - GDPR (expanded): 8 data subject rights, DPIA process, 72h breach notification
  - HIPAA (expanded): Administrative/Physical/Technical safeguards, breach notification
  - CIS Controls v8: 18 control groups, Implementation Groups (IG1/IG2/IG3)
  - Cross-framework mapping table across all 5 frameworks

### Changed

- **Domain 8** narrowed to "Threat Modeling & Risk Assessment" (SOC 2, ISO 27001, STRIDE, PASTA)
- **SKILL.md** expanded from 8 to 9 domains with split compliance routing
- **plugin.json** and **marketplace.json** bumped to v2.1.0
- **README.md** updated: capabilities table, repo structure, token budget, version
- **CLAUDE.md** updated to reflect 9-domain architecture

## [2.0.0] - 2026-02-20

### Added

- **Code Security Analysis** (Domain 6) — Semgrep custom rules, CodeQL queries, SARIF 2.1.0 processing, variant analysis methodology
  - Tool selection decision tree, taint mode tracking, combined CI/CD pipeline
  - Condensed from 4 archive sources (1,599 lines → ~490 lines)
- **Container & Supply Chain Security** (Domain 7) — Dockerfile hardening, Trivy/Grype scanning, SBOM generation, cosign signing
  - Runtime security with Falco rules, Kubernetes SecurityContext, CIS Docker Benchmark
  - Pre-build/build/post-build/runtime security checklist
- **Compliance & Threat Modeling** (Domain 8) — SOC 2, ISO 27001, GDPR, HIPAA, PCI-DSS, STRIDE, PASTA
  - Compliance framework selection guide with decision tree
  - Risk assessment templates (5x5 matrix, SLE/ARO/ALE formulas)
  - Thai legal context (พ.ร.บ. ไซเบอร์ 2562, PDPA) and SRE-inspired security KPIs

### Enhanced

- **SOC Operations** — Added Section 9: SOAR Automation Patterns
  - Common SOAR playbooks (phishing, brute force, malware, ransomware, data exfiltration)
  - Enrichment sources table, SOAR architecture pattern, automation metrics
  - SRE-inspired security SLI/SLOs and severity framework mapping (SRE P1-P4 → SOC)
- **IR Playbooks** — Added Section 7: Security Incident Post-Mortem Template
  - Blameless post-mortem format with MITRE ATT&CK mapping
  - Timeline reconstruction checklist (7 source categories)
  - MTTD/MTTC/MTTR metrics tracking

### Changed

- **SKILL.md** expanded from 5 to 8 domains with updated decision tree and trigger keywords
- **plugin.json** and **marketplace.json** bumped to v2.0.0 with expanded keywords
- **README.md** professionally rewritten with architecture explanation, token budget analysis, and skill engineering techniques
- **CLAUDE.md** updated to reflect 8-domain architecture

## [1.0.0] - 2026-02-19

### Added

- **IR Playbooks & Runbooks** - 10 incident response playbooks mapped to NIST SP 800-61 Rev.2
  - Phishing, Ransomware, Data Breach, DDoS, Insider Threat
  - Supply Chain Attack, Cloud Security Incident, custom scenarios
  - SLA-based escalation workflows with severity classification
- **DFIR Reports** - Professional forensic report templates
  - Chain of custody documentation
  - Evidence handling procedures (memory, disk, network forensics)
  - Timeline reconstruction and IOC extraction templates
  - Malware analysis report structure
- **DevSecOps Pipeline** - Security-integrated CI/CD configurations
  - GitHub Actions and GitLab CI security pipeline templates
  - SAST, DAST, SCA, SBOM scanning configurations
  - OWASP compliance gates and quality gates
  - Secret detection and dependency management
- **SOC Operations L1-L3** - Complete SOC analyst procedures
  - Alert triage workflows per severity level
  - SIEM correlation rules (Splunk SPL, KQL)
  - Threat hunting query library
  - Shift handover templates and KPI dashboards
- **GitOps Security** - Policy-as-code frameworks
  - ArgoCD RBAC and security policies
  - OPA/Gatekeeper constraint templates
  - Falco runtime detection rules
  - Git-based secret management and drift detection
- **Bilingual Output** - Thai + English documentation
  - Thai prose with inline English technical terms
  - Framework references: MITRE ATT&CK, NIST CSF 2.0, OWASP, ISO 27001:2022
  - Thai Cybersecurity Act (พ.ร.บ. ไซเบอร์ 2562) compliance mapping
- **Plugin packaging** for Claude Code marketplace distribution

### Fixed

- Source type changed from `"local"` to `"github"` for Claude Code compatibility
- Marketplace name standardized from `somapa-cybersecurity` to `pitimon-cybersecurity`
- Plugin install key format corrected to `cybersecurity-pro@pitimon-cybersecurity`

[Unreleased]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/releases/tag/v1.0.0
