---
name: cybersecurity-pro
description: >
  Generate professional cybersecurity documents: IR playbooks, DFIR forensic reports,
  DevSecOps pipeline configs, SOC L1-L3 triage procedures, GitOps security policies,
  code security analysis, container/supply chain security, compliance/threat modeling,
  cloud security & CSPM, zero trust architecture, AI/ML security, API security,
  vulnerability management, threat intelligence, cross-domain integration,
  and security governance & executive leadership.
  Use when asked about incident response, IR playbook, runbook, SOC triage, alert investigation,
  threat hunting, digital forensics, malware analysis, DFIR, DevSecOps, SAST, DAST, SCA, SBOM,
  CI/CD security, GitOps, security-as-code, vulnerability management, MITRE ATT&CK, NIST 800-61,
  ISO 27035, OWASP, escalation workflow, forensic report, chain of custody, evidence handling,
  log analysis, SIEM correlation, compliance reports, threat modeling, security architecture,
  Semgrep, CodeQL, SARIF, variant analysis, code scanning, static analysis,
  container security, Trivy, Grype, Dockerfile hardening, image scanning, supply chain, cosign, SLSA,
  SOC 2, ISO 27001, GDPR, HIPAA, PCI-DSS, STRIDE, PASTA, risk assessment, PDPA,
  NIST 800-53, CIS Controls, CIS Benchmarks, gap analysis, control mapping, compliance audit,
  SOAR, security orchestration, automation, post-mortem,
  cloud security, CSPM, AWS security, Azure security, GCP security, IAM policy, cloud misconfiguration,
  Prowler, ScoutSuite, CSA CCM, NIST 800-144, CIS Cloud Benchmarks,
  zero trust, ZTA, ZTNA, NIST 800-207, microsegmentation, SDP, never trust always verify,
  CISA Zero Trust, conditional access,
  AI security, LLM security, prompt injection, AI red team, MITRE ATLAS, AI governance,
  model security, AI risk, EU AI Act, AI RMF, OWASP LLM Top 10, ML-BOM,
  API security, OWASP API, BOLA, API gateway, rate limiting, JWT security, OAuth security,
  API authentication, API inventory, API fuzzing, ความปลอดภัย API,
  vulnerability management, CVSS, EPSS, KEV, patch management, vulnerability scan,
  Nessus, Qualys, vulnerability prioritization, SSVC, การจัดการช่องโหว่,
  threat intelligence, STIX, TAXII, IOC, indicator of compromise, threat feed,
  MISP, OpenCTI, TLP, threat hunting, intelligence sharing, ข่าวกรองภัยคุกคาม,
  cross-domain, integration, end-to-end, workflow, lifecycle, orchestration, security pipeline,
  การบูรณาการ, cross-domain integration, multi-domain,
  security governance, CISO, CAIO, CAISO, board reporting, cyber risk governance,
  SEC disclosure, NIST CSF GOVERN, ISO 27014, C2M2, NACD, board oversight,
  governance framework, security maturity, executive leadership, ธรรมาภิบาลความปลอดภัย,
  OT security, ICS, SCADA, PLC, operational technology, NIST 800-82, IEC 62443,
  Purdue model, industrial control, OT/IT convergence, ความปลอดภัย OT,
  โครงสร้างพื้นฐานสำคัญ, DCS, RTU, HMI, Modbus, DNP3, OPC UA, BACnet,
  NERC CIP, MITRE ATT&CK for ICS, OT incident response,
  การตอบสนองต่อเหตุการณ์, วิเคราะห์ภัยคุกคาม, ความปลอดภัยไซเบอร์, นิติวิทยาศาสตร์ดิจิทัล,
  การวิเคราะห์ code, ความปลอดภัย container, การปฏิบัติตามกฎระเบียบ, การจำลองภัยคุกคาม,
  ความปลอดภัยบนคลาวด์, สถาปัตยกรรม Zero Trust, ความปลอดภัย AI.
  Outputs bilingual Thai+English documents mapped to NIST, MITRE ATT&CK, OWASP frameworks.
user-invocable: true
allowed-tools: Read, Grep, Glob, Write
---

# Cybersecurity Pro Skill

สกิลระดับมืออาชีพสำหรับ Cybersecurity Operations ครอบคลุม 18 domains:
IR, DFIR, DevSecOps, SOC+SOAR, GitOps, Code Security Analysis, Container & Supply Chain, Threat Modeling & Risk, Compliance Frameworks, Cloud Security & CSPM, Zero Trust Architecture, AI/ML Security, API Security, Vulnerability Management, Threat Intelligence, Cross-Domain Integration, Security Governance & Executive Leadership, OT/ICS Security

## Language Policy / นโยบายภาษา

Output all documents in **bilingual format**:

- Use **Thai** as the primary prose language for descriptions, explanations, procedures
- Use **English** for all technical terms, tool names, commands, code, framework references
- Format: Thai prose with inline English technical terms (ไม่ต้องแปลคำศัพท์เทคนิค)
- Section headers: Thai followed by English in parentheses, e.g. `## การจัดการเหตุการณ์ (Incident Handling)`

Example style:

> เมื่อได้รับ alert จาก SIEM ให้ทำการ triage ตาม severity level โดยตรวจสอบ
> IOC (Indicators of Compromise) ผ่าน Threat Intelligence platform ก่อน escalate

## Frameworks & Standards

All outputs MUST reference the appropriate framework(s):

| Domain                   | Primary Framework                  | Supporting Standards                         |
| ------------------------ | ---------------------------------- | -------------------------------------------- |
| Incident Response        | NIST SP 800-61 Rev.2               | ISO 27035, SANS IR Process                   |
| DFIR / Forensics         | Chain of Custody, IOC              | NIST 800-86, SANS DFIR                       |
| Threat Analysis          | MITRE ATT&CK, MITRE D3FEND         | Cyber Kill Chain, Diamond Model              |
| DevSecOps                | OWASP SAMM, OWASP Top 10           | CIS Benchmarks, NIST SSDF                    |
| Governance               | NIST CSF 2.0                       | ISO 27001:2022, พ.ร.บ. ไซเบอร์ 2562          |
| Code Security            | CWE Top 25, OWASP Top 10           | SARIF 2.1.0, Semgrep, CodeQL                 |
| Container/Supply Chain   | NIST SP 800-190, CIS Docker        | SLSA, Sigstore, CycloneDX                    |
| Threat Modeling & Risk   | NIST CSF, ISO 27001, STRIDE        | SOC 2, PASTA, PDPA                           |
| Compliance Frameworks    | NIST SP 800-53 Rev 5               | PCI DSS v4.0.1, CIS Controls v8.1            |
| Cloud Security & CSPM    | CIS Cloud Benchmarks, CSA CCM v4.1 | NIST 800-144, AWS Well-Architected           |
| Zero Trust               | NIST SP 800-207                    | CISA ZT Maturity Model, Forrester ZTX        |
| AI/ML Security           | OWASP LLM Top 10, NIST AI RMF      | MITRE ATLAS, EU AI Act, ISO 42001            |
| API Security             | OWASP API Top 10 2023              | OAuth 2.0 BCP (RFC 9700), OpenAPI            |
| Vulnerability Mgmt       | CVSS v4.0, EPSS                    | CISA KEV, SSVC, FIRST VRDX                   |
| Threat Intelligence      | STIX 2.1, TAXII 2.1                | MITRE ATT&CK, TLP 2.0, Diamond Model         |
| Cross-Domain Integration | NIST CSF 2.0                       | All domain frameworks                        |
| Security Governance      | NIST CSF 2.0 GOVERN, ISO 27014     | C2M2, NACD, SEC Rules, NIST AI RMF           |
| OT/ICS Security          | NIST SP 800-82 Rev.3, IEC 62443    | Purdue Model, MITRE ATT&CK for ICS, NERC CIP |

When producing any output, map actions to relevant framework controls. For incident analysis, always include MITRE ATT&CK Tactic/Technique IDs (e.g., T1566.001).

## Output Domains

This skill produces outputs across 18 domains. Identify which domain(s) the user needs and read the corresponding reference file BEFORE generating output:

### 1. Incident Response Playbooks & Runbooks

> Read `references/ir-playbooks.md`

Produce structured IR playbooks and operational runbooks for specific incident types.
Covers: Phishing, Ransomware, Data Breach, DDoS, Insider Threat, Supply Chain Attack,
Cloud Security Incident, and custom scenarios.

### 2. Security Analysis Reports & Forensic Reports

> Read `references/dfir-reports.md`

Produce professional forensic investigation reports, threat analysis reports,
malware analysis reports, and root cause analysis documents.
Covers: Evidence handling, chain of custody, timeline reconstruction, IOC extraction,
memory/disk/network forensics documentation.

### 3. DevSecOps Pipeline Configs

> Read `references/devsecops-pipeline.md`

Produce security-integrated CI/CD pipeline configurations, security-as-code templates,
and DevSecOps maturity assessments.
Covers: SAST, DAST, SCA, SBOM, container security, IaC scanning, secret detection,
dependency management, and compliance gates.

### 4. SOC Triage Procedures & Escalation Workflows

> Read `references/soc-operations.md`

Produce SOC operational procedures for L1/L2/L3 analysts, escalation matrices,
alert handling workflows, and shift handover templates.
Covers: Alert triage, investigation procedures, threat hunting queries, SIEM
correlation rules, and KPI/metrics dashboards.

### 5. GitOps Security Workflows

> Read `references/gitops-security.md`

Produce GitOps-native security configurations, policy-as-code frameworks,
and automated security remediation workflows.
Covers: ArgoCD/Flux security policies, OPA/Gatekeeper constraints, Git-based
secret management, drift detection, and compliance automation.

### 6. Code Security Analysis

> Read `references/code-security-analysis.md`

Produce static code security analysis configurations, custom scanning rules,
and vulnerability hunting methodologies.
Covers: Semgrep rules and rulesets, CodeQL queries and taint tracking, SARIF result
processing and aggregation, variant analysis methodology, combined CI/CD security pipelines.

### 7. Container & Supply Chain Security

> Read `references/container-supply-chain.md`

Produce container security hardening guides, vulnerability scanning configurations,
SBOM generation workflows, and supply chain security checklists.
Covers: Dockerfile hardening, Trivy/Grype scanning, Syft SBOM generation, cosign image
signing, runtime SecurityContext, Falco rules, CIS Docker Benchmark compliance.

### 8. Threat Modeling & Risk Assessment

> Read `references/compliance-threat-modeling.md`

Produce threat modeling documents, risk assessment reports, and compliance quick references.
Covers: SOC 2 readiness, ISO 27001 ISMS, STRIDE threat modeling, PASTA attack trees,
risk registers, risk matrices, Thai legal requirements (พ.ร.บ. ไซเบอร์, PDPA).

### 9. Compliance Frameworks

> Read `references/compliance-frameworks.md`

Produce detailed compliance framework assessments, gap analyses, control mappings,
and compliance roadmaps for major regulatory frameworks.
Covers: NIST SP 800-53 Rev 5 (20 control families, impact baselines), PCI DSS v4.0
(12 requirements, SAQ decision tree), GDPR (data subject rights, DPIA, breach notification),
HIPAA (administrative/physical/technical safeguards), CIS Controls v8.1 (18 control groups, IGs),
cross-framework mapping tables.

### 10. Cloud Security & CSPM

> Read `references/cloud-security-cspm.md`

Produce cloud security audit checklists, IAM policy reviews, CSPM configurations,
and cloud hardening guides for AWS, Azure, and GCP environments.
Covers: Shared responsibility model, IAM policy templates, storage security audits,
network security controls, CSPM tool configurations (Prowler, ScoutSuite, Cloud Custodian),
cloud audit logging, IaC security scanning, CIS Cloud Benchmarks compliance.

### 11. Zero Trust Architecture

> Read `references/zero-trust-architecture.md`

Produce Zero Trust maturity assessments, implementation roadmaps, microsegmentation
policies, and ZTNA migration guides.
Covers: NIST SP 800-207 framework, 5 pillars (Identity, Device, Network, App, Data),
CISA Zero Trust Maturity Model, conditional access policies, service mesh configurations,
identity-aware proxy patterns, ZTA implementation roadmaps.

### 12. AI/ML Security

> Read `references/ai-ml-security.md`

Produce AI security assessments, LLM guardrail configurations, AI red team playbooks,
and AI governance policy templates.
Covers: OWASP Top 10 for LLM Applications, prompt injection defense, MITRE ATLAS
threat mapping, NIST AI Risk Management Framework, EU AI Act compliance, model supply
chain security (ML-BOM), AI incident response procedures, AI red teaming methodology.

### 13. API Security

> Read `references/api-security.md`

Produce API security assessments, authentication architecture reviews, API gateway
configurations, and API security testing plans.
Covers: OWASP API Security Top 10 2023, JWT validation, OAuth 2.0 BCP (RFC 9700),
API gateway security patterns (Kong/APISIX), API inventory & discovery, API fuzzing,
API security CI/CD integration.

### 14. Vulnerability Management & Prioritization

> Read `references/vulnerability-management.md`

Produce vulnerability management programs, prioritization frameworks, SLA templates,
patch management workflows, and vulnerability metrics dashboards.
Covers: CVSS v4.0 scoring, EPSS exploit prediction, CISA KEV catalog, SSVC decision
trees, scanning tool configurations (Nessus/Qualys/OpenVAS/Nuclei/Trivy), patch
management automation, risk acceptance workflows, vulnerability reporting.

### 15. Threat Intelligence & IOC Management

> Read `references/threat-intelligence.md`

Produce threat intelligence program designs, STIX/TAXII integration templates,
IOC lifecycle management workflows, and intelligence sharing procedures.
Covers: STIX 2.1 object model (SDO/SRO/SCO), TAXII 2.1 server/client configuration,
TI platform setup (MISP, OpenCTI), IOC lifecycle management, threat feed integration,
intelligence sharing (TLP 2.0, ISACs), TI-driven detection and hunting, SOAR automation.

### 16. Cross-Domain Integration Scenarios

> Read `references/cross-domain-integration.md`

Produce end-to-end security workflow designs, cross-domain SOAR playbooks,
integration architecture diagrams, and multi-domain orchestration templates.
Covers: IR lifecycle (TI→SOC→IR→DFIR), vulnerability-to-exploit pipeline,
supply chain security pipeline (Code→Container→DevSecOps→GitOps→SOC),
cloud compliance posture (Compliance→Cloud→ZeroTrust→VulnMgmt),
AI/API threat surface (API→AI/ML→ThreatModel→Code), integration orchestration
patterns, cross-domain metrics and KPIs, NIST CSF 2.0 mapping.

### 17. Security Governance & Executive Leadership

> Read `references/security-governance-executive.md`

Produce security governance frameworks, board reporting templates, maturity assessments,
and executive leadership role definitions.
Covers: NIST CSF 2.0 GOVERN function (6 categories), ISO 27014 governance processes,
C2M2 maturity model, CISO/CAIO/CAISO role definitions and RACI matrices, SEC 8-K/10-K
cybersecurity disclosure, board KPI dashboards, AI governance at executive level,
governance program implementation roadmaps.

### 18. OT/ICS Security

> Read `references/ot-ics-security.md`

Produce OT/ICS security assessments, network segmentation designs, SCADA hardening guides,
OT incident response plans, and industrial control system security checklists.
Covers: NIST SP 800-82 Rev.3 framework, IEC 62443 zones and conduits, Purdue Model (ISA-95)
network architecture, OT asset discovery (passive/active), industrial protocol security
(Modbus, DNP3, OPC UA, BACnet), MITRE ATT&CK for ICS technique mapping, OT-specific incident
response (safety-first), PLC/HMI/SCADA hardening, Thai CII requirements under พ.ร.บ. ไซเบอร์ 2562.

## General Output Rules

1. **Structure**: Use consistent document templates per domain (defined in reference files)
2. **Severity Classification**: Always use a standard severity scale:
   - Critical (วิกฤต) / High (สูง) / Medium (ปานกลาง) / Low (ต่ำ) / Informational (ข้อมูล)
3. **Actionable Steps**: Every procedure must have clear, numbered steps that a SOC analyst can follow
4. **Tool References**: When mentioning tools, include both commercial and open-source alternatives
5. **MITRE Mapping**: For any attack/threat scenario, include ATT&CK Tactic + Technique IDs
6. **Time-Sensitivity Markers**: Mark steps with SLA expectations where applicable
   - e.g., `⏱ SLA: ตอบสนองภายใน 15 นาที (Critical), 1 ชั่วโมง (High)`
7. **Output Format**: Default to `.docx` for formal reports, `.md` for operational docs.
   If the user requests a specific format, use that instead.

## Quick Decision Tree

```
User request
├── mentions "incident" / "เหตุการณ์" / "IR" / "playbook" / "runbook" / "post-mortem"
│   → Domain 1: IR Playbooks (read references/ir-playbooks.md)
│
├── mentions "forensic" / "นิติวิทยาศาสตร์" / "investigation" / "evidence" / "malware analysis"
│   → Domain 2: DFIR Reports (read references/dfir-reports.md)
│
├── mentions "pipeline" / "CI/CD" / "DAST" / "DevSecOps" / "shift-left"
│   → Domain 3: DevSecOps (read references/devsecops-pipeline.md)
│
├── mentions "SOC" / "triage" / "alert" / "escalation" / "L1" / "L2" / "L3" / "SOAR"
│   → Domain 4: SOC Operations (read references/soc-operations.md)
│
├── mentions "GitOps" / "ArgoCD" / "Flux" / "policy-as-code" / "OPA" / "drift"
│   → Domain 5: GitOps Security (read references/gitops-security.md)
│
├── mentions "Semgrep" / "CodeQL" / "SARIF" / "SAST" / "code scan" / "variant analysis" / "วิเคราะห์ code"
│   → Domain 6: Code Security Analysis (read references/code-security-analysis.md)
│
├── mentions "container" / "Docker" / "Trivy" / "Grype" / "SBOM" / "image scan" / "supply chain" / "Dockerfile"
│   → Domain 7: Container & Supply Chain (read references/container-supply-chain.md)
│
├── mentions "threat model" / "STRIDE" / "PASTA" / "risk assessment" / "risk matrix"
│   / "SOC 2" / "ISO 27001" / "PDPA" / "การจำลองภัยคุกคาม"
│   → Domain 8: Threat Modeling & Risk (read references/compliance-threat-modeling.md)
│
├── mentions "NIST 800-53" / "PCI DSS" / "PCI-DSS" / "GDPR" / "HIPAA" / "CIS Controls"
│   / "gap analysis" / "gap assessment" / "control mapping" / "compliance audit"
│   / "compliance roadmap" / "compliance framework" / "การปฏิบัติตามกฎระเบียบ"
│   → Domain 9: Compliance Frameworks (read references/compliance-frameworks.md)
│
├── mentions "cloud security" / "CSPM" / "AWS security" / "Azure security" / "GCP security"
│   / "IAM policy" / "cloud misconfiguration" / "Prowler" / "ScoutSuite" / "CSA CCM"
│   / "cloud audit" / "cloud hardening" / "ความปลอดภัยบนคลาวด์"
│   → Domain 10: Cloud Security & CSPM (read references/cloud-security-cspm.md)
│
├── mentions "zero trust" / "ZTA" / "ZTNA" / "NIST 800-207" / "microsegmentation"
│   / "SDP" / "never trust always verify" / "conditional access"
│   / "สถาปัตยกรรม Zero Trust"
│   → Domain 11: Zero Trust Architecture (read references/zero-trust-architecture.md)
│
├── mentions "AI security" / "LLM security" / "prompt injection" / "AI red team"
│   / "MITRE ATLAS" / "AI governance" / "model security" / "AI risk" / "EU AI Act"
│   / "AI RMF" / "OWASP LLM" / "ML-BOM" / "ความปลอดภัย AI"
│   → Domain 12: AI/ML Security (read references/ai-ml-security.md)
│
├── mentions "API security" / "OWASP API" / "BOLA" / "API gateway" / "rate limiting"
│   / "JWT security" / "OAuth security" / "API authentication" / "API inventory"
│   / "API fuzzing" / "ความปลอดภัย API"
│   → Domain 13: API Security (read references/api-security.md)
│
├── mentions "vulnerability management" / "CVSS" / "EPSS" / "KEV" / "patch management"
│   / "vulnerability scan" / "Nessus" / "Qualys" / "SSVC" / "vulnerability prioritization"
│   / "การจัดการช่องโหว่"
│   → Domain 14: Vulnerability Management (read references/vulnerability-management.md)
│
├── mentions "threat intelligence" / "STIX" / "TAXII" / "IOC" / "threat feed"
│   / "MISP" / "OpenCTI" / "TLP" / "intelligence sharing" / "indicator of compromise"
│   / "ข่าวกรองภัยคุกคาม"
│   → Domain 15: Threat Intelligence (read references/threat-intelligence.md)
│
├── mentions "integration" / "end-to-end" / "cross-domain" / "workflow" / "lifecycle"
│   / "orchestration" / "การบูรณาการ" / "security pipeline" / "multi-domain"
│   → Domain 16: Cross-Domain Integration (read references/cross-domain-integration.md)
│
├── mentions "security governance" / "CISO role" / "CISO reporting" / "CAIO" / "CAISO" / "board reporting"
│   / "cyber risk governance" / "SEC disclosure" / "NIST CSF GOVERN" / "ISO 27014"
│   / "C2M2" / "NACD" / "board oversight" / "governance framework"
│   / "security maturity" / "executive leadership" / "ธรรมาภิบาลความปลอดภัย"
│   → Domain 17: Security Governance (read references/security-governance-executive.md)
│
├── mentions "OT security" / "ICS" / "SCADA" / "PLC" / "Purdue" / "operational technology"
│   / "industrial control" / "NIST 800-82" / "IEC 62443" / "OT/IT convergence"
│   / "HMI" / "RTU" / "DCS" / "Modbus" / "DNP3" / "OPC UA" / "BACnet"
│   / "NERC CIP" / "ATT&CK for ICS" / "ความปลอดภัย OT" / "โครงสร้างพื้นฐานสำคัญ"
│   → Domain 18: OT/ICS Security (read references/ot-ics-security.md)
│
└── unclear / multiple domains
    → Ask user to clarify, or if multi-domain workflow → Domain 16
```

## File Output Strategy

- **Formal Reports** (forensic reports, compliance docs): Use the `docx` skill to produce `.docx`
- **Operational Docs** (playbooks, runbooks, triage procedures): Produce as `.md` files
- **Pipeline Configs**: Produce as appropriate config files (`.yml`, `.yaml`, `.json`, `.rego`, `.tf`)
- **Combined Packages**: When producing a complete set (e.g., full IR package), create a folder structure with all relevant files

## Quality Checklist

Before finalizing any output, verify:

- [ ] ภาษาไทยถูกต้อง ใช้คำศัพท์เทคนิคเป็นภาษาอังกฤษ
- [ ] Framework references are accurate and specific (not generic)
- [ ] MITRE ATT&CK IDs are real and correctly mapped
- [ ] Procedures are step-by-step and actionable
- [ ] Severity levels and SLAs are defined
- [ ] Tool recommendations include open-source options
- [ ] Templates are complete and ready to use (ไม่มี placeholder ที่ไม่จำเป็น)
