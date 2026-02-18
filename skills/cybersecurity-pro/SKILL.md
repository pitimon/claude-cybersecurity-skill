---
name: cybersecurity-pro
description: >
  Professional cybersecurity skill: DevSecOps, SOC L1-L3, DFIR, GitOps security.
  Trigger on: incident response, IR playbook, runbook, SOC triage, alert investigation,
  threat hunting, digital forensics, malware analysis, DFIR, DevSecOps, SAST, DAST,
  SCA, SBOM, CI/CD security, GitOps, security-as-code, vulnerability management,
  MITRE ATT&CK, NIST 800-61, ISO 27035, OWASP, escalation workflow, forensic report,
  chain of custody, evidence handling, memory/disk/network forensics, log analysis,
  SIEM correlation, compliance reports, threat modeling, security architecture.
  Trigger for Thai: การตอบสนองต่อเหตุการณ์, วิเคราะห์ภัยคุกคาม, ความปลอดภัยไซเบอร์,
  SOC, DevSecOps, นิติวิทยาศาสตร์ดิจิทัล. Outputs bilingual Thai+English docs.
---

# Cybersecurity Pro Skill

สกิลระดับมืออาชีพสำหรับ Cybersecurity Operations ครอบคลุม DevSecOps, SOC L1-L3,
Digital Forensics & Incident Response (DFIR) และ GitOps Security

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

| Domain | Primary Framework | Supporting Standards |
|--------|------------------|---------------------|
| Incident Response | NIST SP 800-61 Rev.2 | ISO 27035, SANS IR Process |
| Threat Analysis | MITRE ATT&CK, MITRE D3FEND | Cyber Kill Chain, Diamond Model |
| DevSecOps | OWASP SAMM, OWASP Top 10 | CIS Benchmarks, NIST SSDF |
| Governance | NIST CSF 2.0 | ISO 27001:2022, พ.ร.บ. ไซเบอร์ 2562 |

When producing any output, map actions to relevant framework controls. For incident analysis, always include MITRE ATT&CK Tactic/Technique IDs (e.g., T1566.001).

## Output Domains

This skill produces outputs across 5 domains. Identify which domain(s) the user needs and read the corresponding reference file BEFORE generating output:

### 1. Incident Response Playbooks & Runbooks
→ Read `references/ir-playbooks.md`

Produce structured IR playbooks and operational runbooks for specific incident types.
Covers: Phishing, Ransomware, Data Breach, DDoS, Insider Threat, Supply Chain Attack,
Cloud Security Incident, and custom scenarios.

### 2. Security Analysis Reports & Forensic Reports
→ Read `references/dfir-reports.md`

Produce professional forensic investigation reports, threat analysis reports,
malware analysis reports, and root cause analysis documents.
Covers: Evidence handling, chain of custody, timeline reconstruction, IOC extraction,
memory/disk/network forensics documentation.

### 3. DevSecOps Pipeline Configs
→ Read `references/devsecops-pipeline.md`

Produce security-integrated CI/CD pipeline configurations, security-as-code templates,
and DevSecOps maturity assessments.
Covers: SAST, DAST, SCA, SBOM, container security, IaC scanning, secret detection,
dependency management, and compliance gates.

### 4. SOC Triage Procedures & Escalation Workflows
→ Read `references/soc-operations.md`

Produce SOC operational procedures for L1/L2/L3 analysts, escalation matrices,
alert handling workflows, and shift handover templates.
Covers: Alert triage, investigation procedures, threat hunting queries, SIEM
correlation rules, and KPI/metrics dashboards.

### 5. GitOps Security Workflows
→ Read `references/gitops-security.md`

Produce GitOps-native security configurations, policy-as-code frameworks,
and automated security remediation workflows.
Covers: ArgoCD/Flux security policies, OPA/Gatekeeper constraints, Git-based
secret management, drift detection, and compliance automation.

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
├── mentions "incident" / "เหตุการณ์" / "IR" / "playbook" / "runbook"
│   → Domain 1: IR Playbooks (read references/ir-playbooks.md)
│
├── mentions "forensic" / "นิติวิทยาศาสตร์" / "investigation" / "evidence" / "malware analysis"
│   → Domain 2: DFIR Reports (read references/dfir-reports.md)
│
├── mentions "pipeline" / "CI/CD" / "SAST" / "DAST" / "DevSecOps" / "shift-left"
│   → Domain 3: DevSecOps (read references/devsecops-pipeline.md)
│
├── mentions "SOC" / "triage" / "alert" / "escalation" / "L1" / "L2" / "L3" / "analyst"
│   → Domain 4: SOC Operations (read references/soc-operations.md)
│
├── mentions "GitOps" / "ArgoCD" / "Flux" / "policy-as-code" / "OPA" / "drift"
│   → Domain 5: GitOps Security (read references/gitops-security.md)
│
└── unclear / multiple domains
    → Ask user to clarify, or combine relevant domains
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
