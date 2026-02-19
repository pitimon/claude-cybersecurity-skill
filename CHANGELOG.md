# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Threat Intelligence integration templates (STIX/TAXII)
- Cloud security incident playbooks (AWS, GCP, Azure)
- Compliance report generator (PCI-DSS, HIPAA)
- Container runtime security monitoring configs

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

[Unreleased]: https://github.com/pitimon/claude-cybersecurity-skill/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/pitimon/claude-cybersecurity-skill/releases/tag/v1.0.0
