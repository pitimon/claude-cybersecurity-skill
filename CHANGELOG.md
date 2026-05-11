# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.3] - 2026-05-12

### Fixed

- **SKILL.md description trimmed from ~4,663 → 590 characters** (#9) — within Anthropic spec cap (1024) and Claude Code per-entry cap (`skillListingMaxDescChars` = 1536). Eliminates `/doctor` warning, silent truncation of trailing trigger keywords, and ~15k tokens/session overhead for users who raised the cap. Full trigger keyword list (15 categories) moved to the skill body under "When This Skill Activates / เมื่อใดที่สกิลนี้ทำงาน" — Claude reads the body once the skill is invoked.
- Version bump correction — v4.0.2 release tag/release on GitHub was created on 2026-03-01 for Issue #6 D19-D22 enhancements, but `plugin.json` / `marketplace.json` were not bumped at the time. This release reconciles the version files (4.0.1 → 4.0.3) so the manifest matches the latest tag.

### Changed

- README.md rework — improved structure (TOC, NIST CSF coverage map, Frameworks badge, Related Plugins, Support table), Thai/English consistency pass

## [4.0.0] - 2026-02-28

### Added

- **Agentic AI Security** (Domain 19) — OWASP Agentic Top 10 2026, agent permission models, memory & context security, multi-agent orchestration, MITRE ATLAS 2025 agent techniques
- **Post-Quantum Cryptography Migration** (Domain 20) — NIST FIPS 203/204/205, CNSA 2.0 timeline, crypto-agility assessment, hybrid cryptography patterns, NIST IR 8547
- **Identity & Access Security** (Domain 21) — NIST 800-63B, FIDO2/Passkeys, non-human identity management, ITDR, NIST IR 8587 token protection, SPIFFE/SPIRE
- **Web3 & Blockchain Security** (Domain 22) — OWASP Smart Contract Top 10 2026, smart contract audit methodology, DeFi security patterns, wallet & key management
- **NIST Cyber AI Profile** (NISTIR 8596) added to D12 — 3 focus areas mapped to CSF 2.0
- **MITRE ATLAS 2025** agent techniques (14 new) added to D12
- **NIST LEV metric** (CSWP 41) added to D14 — LEV vs EPSS vs KEV comparison
- **CWE Top 25 (2025)** rankings updated in D6
- **Claude Code Security** reasoning-based scanner reference added to D6
- **Cyber Resilience Metrics** section added to D17 — prevention→resilience shift KPIs
- **Security Workforce Development** section added to D17 — skills gap assessment, competency matrix
- **Compliance Cross-Walk Matrix** added to D9 — NIST↔ISO↔CIS↔SOC2↔PCI mapping (20 control areas)
- **Guided decision tree fallback** in SKILL.md — asks 2-3 clarifying questions if keyword match fails
- **Template variables** ({ORG_NAME}, {DATE}, {INDUSTRY}, {ANALYST_NAME}) for all output
- **frameworks.json** expanded from 54 to 69 entries with 15 new framework references

### Changed

- SKILL.md expanded from 18 to 22 domains with updated frontmatter, frameworks table, and decision tree
- plugin.json and marketplace.json bumped to v4.0.0 with D19-D22 keywords
- README.md updated: domain count 18→22, NIST CSF 2.0 map, capabilities, token budget
- CLAUDE.md updated to reflect 22-domain architecture
- validate-plugin.sh updated to expect 22 reference files and ~69 frameworks
- smoke-test-prompts.md expanded with 4 new domain tests + guided fallback test

## [3.7.0] - 2026-02-28

### Added

- **Shannon post-pentest integration** — automated defensive document generation from Shannon pentest findings
  - Handoff manifest reading and multi-domain orchestration
  - Post-pentest mode in SKILL.md decision tree

### Changed

- **plugin.json** bumped to v3.7.0

## [3.6.1] - 2026-02-28

### Added

- **shannon-pentest cross-references** in 3 domain reference files:
  - `vulnerability-management.md` — Automated Penetration Testing link
  - `cross-domain-integration.md` — Shannon section in Vulnerability-to-Exploit Pipeline
  - `code-security-analysis.md` — Runtime Exploitation Testing link
- **Related Plugins** section in README.md — points to `shannon-pentest@pitimon-shannon`

### Changed

- **plugin.json** and **marketplace.json** bumped to v3.6.1
- **README.md** version badge updated to v3.6.1
- **docs/INSTALL.md** cache path and version references updated

## [3.6.0] - 2026-02-22

### Added

- **OT/ICS Security** (Domain 18) — Operational Technology and Industrial Control System security
  - OT Security Landscape & IT/OT Convergence — OT vs IT comparison, convergence challenges, safety-first priority hierarchy
  - NIST SP 800-82 Rev.3 — OT system categories (SCADA, DCS, PLC, RTU, HMI, SIS), defense-in-depth layers, OT risk assessment matrix
  - IEC 62443 — Security Levels (SL 1-4), zones and conduits model with ASCII diagram, component security requirements, ISASecure certification
  - Purdue Model / ISA-95 — 6-level architecture diagram (Level 0-5), firewall/DMZ placement table, dual-firewall and data diode design patterns
  - OT Asset Discovery & Inventory — Passive vs active discovery comparison, asset classification by Purdue level, YAML inventory template, tool comparison (Claroty, Nozomi, Dragos, Tenable.ot, Malcolm)
  - OT Network Monitoring & Threat Detection — OT vs IT monitoring differences, industrial protocol analysis (Modbus, DNP3, OPC UA, BACnet, EtherNet/IP, PROFINET), MITRE ATT&CK for ICS technique mapping, anomaly detection baseline
  - OT Incident Response — Safety-first IR considerations, OT IR decision tree, ICS-CERT coordination table, containment strategies (network isolation, VLAN, manual mode, data diode, air-gap), PLC/SCADA recovery checklist
  - SCADA/PLC/HMI Hardening — PLC security configuration checklist, HMI hardening table, SCADA communication security enhancements per protocol, firmware update change management workflow
  - Thai Context — CII categories under พ.ร.บ. ไซเบอร์ 2562, สกมช. (NCSA) reporting requirements and severity levels, Thai energy/transport/water/rail sector OT landscape
  - Framework References & OT Security Checklist — Quick Win / Standard / Advanced checklists
  - Frameworks: NIST SP 800-82 Rev.3, IEC 62443, Purdue Model/ISA-95, MITRE ATT&CK for ICS, NERC CIP, API 1164
- **SIEM/XDR Platform Options** added to D4 (SOC Operations) — comparison table for Splunk, Elastic, Microsoft Sentinel, Defender XDR, Chronicle, Wazuh, QRadar
- **MCRA reference** added to D11 (Zero Trust) — vendor-specific implementation note alongside NIST 800-207
- **CIS v8.1 Asset Class Mapping** added to D9 (Compliance Frameworks) — 5 asset classes (Devices, Software, Data, Users, Network) with OT relevance column
- **frameworks.json** expanded from 50 to 54 entries — NIST 800-82, IEC 62443, Purdue Model/ISA-95, MITRE ATT&CK for ICS

### Changed

- **SKILL.md** expanded from 17 to 18 domains with updated frontmatter (OT/ICS keywords), frameworks table, and decision tree
- **plugin.json** and **marketplace.json** bumped to v3.6.0 with OT/ICS keywords
- **README.md** updated: version badge, domain count 17→18, NIST CSF 2.0 map (D18 in IDENTIFY+PROTECT), new "Industrial & OT" capabilities group, "Industrial / OT" framework audience, repo structure, token budget, usage example
- **CLAUDE.md** updated to reflect 18-domain architecture
- **validate-plugin.sh** updated to expect 18 reference files
- **smoke-test-prompts.md** updated with D18 test prompt and 8 pass criteria, quick regression test expanded to 10 items
- Cross-references added to 5 existing domain reference files (D4, D9, D10, D11, D16 → D18 link)

## [3.5.0] - 2026-02-22

### Added

- **Framework Version Maintenance Workflow** — automated tracking and update process for 50 versioned framework references
  - `frameworks.json` — single source of truth for all framework versions, grep patterns, file locations, update frequency, and staleness tracking
  - `tests/check-framework-updates.sh` — ad-hoc CLI tool showing color-coded staleness report (CRITICAL/DUE/OK) with thresholds by update frequency
  - `.github/workflows/framework-review.yml` — quarterly scheduled CI (Jan/Apr/Jul/Oct) that auto-creates GitHub Issues with framework review checklists
  - `docs/FRAMEWORK-UPDATE-RUNBOOK.md` — step-by-step procedure for version-string and substantive content updates, with post-update checklist and versioning convention
  - `tests/validate-plugin.sh` Section 5 — framework version consistency checks: JSON validity, grep pattern matching in declared files, staleness warnings
- **Documentation completeness update** — all docs synced with v3.4.2 framework maintenance features
  - `README.md` — repo structure updated with 4 new files (frameworks.json, check-framework-updates.sh, FRAMEWORK-UPDATE-RUNBOOK.md, framework-review.yml), framework count 30+ → 50+, contributing guide adds frameworks.json step, validation count 55+ → 58+
  - `docs/INSTALL.md` — version refs updated, cache directory structure includes new files
  - `docs/TROUBLESHOOTING.md` — new section for framework validation errors (Section 5 FAIL, stale WARN, JSON syntax)
  - `tests/smoke-test-prompts.md` — new meta-test section for framework maintenance validation (staleness check, Section 5, frameworks.json integrity)
  - `CLAUDE.md` — contributing guide adds frameworks.json step for new domains

### Changed

- **README.md** professionally redesigned for adoption — hero section with badges, NIST CSF 2.0 coverage map, quick-win demo, comparison table, frameworks regrouped by audience, usage examples trimmed to top 6 with collapsible full list, architecture and token budget merged into single section
- **plugin.json** and **marketplace.json** bumped to v3.5.0

## [3.4.0] - 2026-02-22

### Added

- **Security Governance & Executive Leadership** (Domain 17) — Executive-level security governance
  - Security Governance Landscape & Role Architecture — governance vs management distinction, hierarchy diagram, role evolution timeline
  - NIST CSF 2.0 GOVERN Function (GV) — all 6 categories (GV.OC/RM/RR/PO/OV/SC) with 32 subcategories and artifact mapping
  - ISO 27014:2020 — 5 governance processes (Evaluate/Direct/Monitor/Communicate/Assure), NACD 6 principles
  - Security Maturity Models — C2M2 (10 domains, MIL 0-3), CMMI Cybermaturity, NIST CSF Tiers, 12-month roadmap
  - Executive Roles: CISO, CAIO, CAISO — role definitions, RACI matrix, reporting structure patterns, "when to create CAISO" decision tree, AISOC concept
  - Board Reporting & SEC Disclosure — SEC 8-K/10-K rules, materiality assessment template, board KPI dashboard (3 components), quarterly report structure
  - AI Governance at Executive Level — NIST AI RMF GOVERN, ISO 42001 management view, EU AI Act obligations, AI Ethics Board charter, Singapore IMDA framework
  - Governance Program Implementation Roadmap — 5-phase 12-month plan, implementation KPIs, operating model diagram
  - Framework References & Governance Checklist — 10 framework references with URLs, Quick Win/Standard/Advanced checklist
  - Frameworks: NIST CSF 2.0 GOVERN, ISO 27014:2020, C2M2, NACD Handbook, SEC Cybersecurity Rules, NIST AI RMF, ISO 42001, EU AI Act

### Changed

- **SKILL.md** expanded from 16 to 17 domains with updated frontmatter, frameworks table, and decision tree
- **plugin.json** and **marketplace.json** bumped to v3.4.0 with expanded keywords
- **README.md** updated: capabilities tables, repo structure, token budget, version, usage examples
- **CLAUDE.md** updated to reflect 17-domain architecture
- **validate-plugin.sh** updated to expect 17 reference files
- Cross-references added to 5 existing domain reference files (D4, D8, D9, D12, D16 → D17 link)

## [3.3.0] - 2026-02-21

### Added

- **Cross-Domain Integration Scenarios** (Domain 16) — End-to-end security workflow orchestration
  - Domain Dependency Map — ASCII visualization of all 16 domain relationships mapped to NIST CSF 2.0
  - Integration Maturity Model — 5-level maturity progression from Siloed to Unified
  - Scenario: Incident Response Lifecycle — TI(D15) → SOC(D4) → IR(D1) → DFIR(D2) → Vuln(D14) with SOAR orchestration
  - Scenario: Vulnerability-to-Exploit Pipeline — Vuln(D14) → TI(D15) → SOC(D4) → IR(D1) with CVE enrichment and Sigma/YARA generation
  - Scenario: Supply Chain Security Pipeline — Code(D6) → Container(D7) → DevSecOps(D3) → GitOps(D5) → SOC(D4) with SARIF→SBOM→gate→deploy→runtime flow
  - Scenario: Cloud Compliance Posture — Compliance(D9) → Cloud(D10) → ZeroTrust(D11) → Vuln(D14) with CSPM and evidence collection
  - Scenario: AI/API Threat Surface — API(D13) → AI/ML(D12) → ThreatModel(D8) → Code(D6) with ATLAS+OWASP mapping
  - Integration Orchestration Patterns — SOAR backbone, data format standards (STIX/SARIF/CycloneDX), shared severity/SLA taxonomy
  - Cross-Domain Metrics & KPIs — E2E MTTD/MTTR, TI-to-detection latency, pipeline block rate, compliance score
  - Framework References & Integration Checklist — NIST CSF 2.0 orchestration mapping, Quick Win/Standard/Advanced checklist
  - Each scenario includes: data flow diagram, exchange table, SOAR template, MITRE ATT&CK flow, handoff checklist
  - Frameworks: NIST CSF 2.0, MITRE ATT&CK, STIX 2.1, SARIF 2.1.0, CycloneDX, SLSA

### Changed

- **SKILL.md** expanded from 15 to 16 domains with updated frontmatter, frameworks table, and decision tree
- **plugin.json** and **marketplace.json** bumped to v3.3.0 with expanded keywords
- **README.md** updated: capabilities tables, repo structure, token budget, version, usage examples
- **CLAUDE.md** updated to reflect 16-domain architecture
- **validate-plugin.sh** updated to expect 16 reference files
- Cross-references backfilled in all 15 existing domain reference files (Domain 16 link + natural neighbor links)

## [3.2.0] - 2026-02-21

### Added

- **Threat Intelligence & IOC Management** (Domain 15) — Comprehensive threat intelligence program
  - STIX 2.1 Object Model — SDO, SRO, SCO object types with JSON examples and patterning language
  - TAXII 2.1 Protocol — Server/client architecture, API endpoints, polling and push configuration
  - Threat Intelligence Platforms — MISP setup/feeds/sharing groups, OpenCTI architecture/connectors, commercial comparison
  - IOC Lifecycle Management — Collection → validation → enrichment → dissemination → expiration workflows
  - Threat Feed Integration — Open-source feeds (AlienVault OTX, Abuse.ch, PhishTank, CIRCL), SIEM integration patterns
  - Intelligence Sharing & ISACs — TLP 2.0 protocol, FIRST CSIRT framework, Thai context (ThaiCERT, PDPA)
  - TI-Driven Detection & Hunting — MITRE ATT&CK mapping, Sigma/YARA rule generation from IOCs
  - TI Automation & SOAR Integration — Automated IOC ingestion, enrichment playbooks, Python automation
  - Frameworks: STIX 2.1 (OASIS), TAXII 2.1 (OASIS), MITRE ATT&CK, TLP 2.0, Diamond Model, FIRST CSIRT

### Changed

- **SKILL.md** expanded from 14 to 15 domains with updated frontmatter, frameworks table, and decision tree
- **plugin.json** and **marketplace.json** bumped to v3.2.0 with expanded keywords
- **README.md** updated: capabilities tables, repo structure, token budget, version, usage examples
- **CLAUDE.md** updated to reflect 15-domain architecture
- **validate-plugin.sh** updated to expect 15 reference files

## [3.1.0] - 2026-02-21

### Added

- **API Security** (Domain 13) — Comprehensive API security assessment and hardening
  - OWASP API Security Top 10 2023 — all 10 risks with detection and mitigation templates
  - API Authentication Matrix — API Key vs OAuth 2.0 vs mTLS vs JWT comparison
  - JWT Validation Checklist — algorithm, claims, expiry, key management with code examples
  - OAuth 2.0 Security Best Practices (RFC 9700) — PKCE, token rotation, redirect validation
  - API Gateway Security Patterns — Kong configuration templates, mTLS termination
  - API Inventory & Discovery — OpenAPI validation, shadow API detection, schema drift
  - API Fuzzing & Security Testing — ZAP, Nuclei, Burp Suite, Postman security tests
  - API Security CI/CD Pipeline — Spectral linting, SAST, DAST integration
  - Frameworks: OWASP API Top 10 2023, OAuth 2.0 BCP (RFC 9700), OpenAPI 3.1.0

- **Vulnerability Management & Prioritization** (Domain 14) — End-to-end vulnerability lifecycle
  - Vulnerability Lifecycle Workflow — discover → assess → prioritize → remediate → verify → report
  - Scoring & Prioritization — CVSS v4.0, EPSS, CISA KEV, SSVC decision trees
  - Combined Prioritization Matrix — CVSS + EPSS + KEV workflow with SLA mapping
  - SLA Templates — severity-based response/remediation SLAs with escalation paths
  - Scanning Tool Comparison — Nessus, Qualys, OpenVAS, Nuclei, Trivy with command examples
  - Patch Management Workflow — testing → staging → production, rollback, Ansible automation
  - Exception & Risk Acceptance — templates for accepted risks, compensating controls
  - Vulnerability Metrics & Reporting — MTTD, MTTR, SLA compliance, executive dashboards
  - Frameworks: CVSS v4.0, EPSS, CISA KEV, SSVC 2.0, FIRST VRDX

### Changed

- **SKILL.md** expanded from 12 to 14 domains with updated frontmatter, frameworks table, and decision tree
- **plugin.json** and **marketplace.json** bumped to v3.1.0 with expanded keywords
- **README.md** updated: capabilities tables, repo structure, token budget, version, usage examples
- **CLAUDE.md** updated to reflect 14-domain architecture
- **validate-plugin.sh** updated to expect 14 reference files

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

[4.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.7.0...v4.0.0
[3.7.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.6.1...v3.7.0
[3.6.1]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.6.0...v3.6.1
[3.6.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.5.0...v3.6.0
[3.5.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.4.0...v3.5.0
[3.4.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/releases/tag/v1.0.0
