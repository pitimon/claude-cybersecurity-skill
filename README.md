# cybersecurity-pro

**Professional Cybersecurity Skill for Claude Code**

สกิลระดับมืออาชีพสำหรับ Cybersecurity Operations — ครอบคลุม Incident Response, Digital Forensics, DevSecOps, SOC Operations และ GitOps Security พร้อม output แบบ bilingual (Thai + English)

---

## Overview (ภาพรวม)

`cybersecurity-pro` เป็น Claude Code plugin skill ที่ช่วยสร้างเอกสาร cybersecurity ระดับ professional โดยอัตโนมัติ ออกแบบมาสำหรับ:

- **SOC Analysts (L1-L3)** -- สร้าง triage procedures, escalation workflows, SIEM rules
- **DFIR Investigators** -- สร้าง forensic reports, chain of custody docs, evidence handling procedures
- **DevSecOps Engineers** -- สร้าง CI/CD security pipeline configs, OWASP compliance gates
- **Security Architects** -- สร้าง GitOps security policies, policy-as-code frameworks

ทุก output เป็น **bilingual Thai + English** — ใช้ภาษาไทยสำหรับคำอธิบาย และ English สำหรับ technical terms

---

## Quick Start (เริ่มต้นใช้งาน)

```bash
# 1. เพิ่ม marketplace
claude plugin marketplace add pitimon/claude-cybersecurity-skill

# 2. ติดตั้ง plugin
claude plugin install cybersecurity-pro@pitimon-cybersecurity

# 3. ตรวจสอบ
claude doctor

# 4. Restart session เพื่อ load skill
# ใช้ /clear ใน Claude Code หรือเปิด terminal ใหม่
```

> ดูคู่มือฉบับเต็ม: [docs/INSTALL.md](docs/INSTALL.md)

---

## Capabilities (ความสามารถ)

| Domain                      | คำอธิบาย                                                                    | Frameworks                               | Trigger Keywords                                |
| --------------------------- | --------------------------------------------------------------------------- | ---------------------------------------- | ----------------------------------------------- |
| **IR Playbooks & Runbooks** | Incident response playbooks ตาม NIST 800-61 พร้อม SLA และ escalation matrix | NIST SP 800-61, ISO 27035, SANS IR       | `incident response`, `IR playbook`, `runbook`   |
| **DFIR Reports**            | Forensic investigation reports พร้อม chain of custody และ evidence handling | Chain of Custody, IOC, Timeline Analysis | `forensic`, `investigation`, `evidence`, `DFIR` |
| **DevSecOps Pipeline**      | CI/CD security pipeline configs สำหรับ GitHub Actions / GitLab CI           | OWASP SAMM, OWASP Top 10, CIS Benchmarks | `DevSecOps`, `SAST`, `DAST`, `CI/CD security`   |
| **SOC Operations L1-L3**    | SOC operating procedures พร้อม SIEM rules (Splunk SPL, KQL)                 | MITRE ATT&CK, Cyber Kill Chain           | `SOC`, `triage`, `alert`, `threat hunting`      |
| **GitOps Security**         | Policy-as-code frameworks สำหรับ ArgoCD, OPA, Falco                         | OPA/Gatekeeper, Falco, ArgoCD RBAC       | `GitOps`, `ArgoCD`, `policy-as-code`, `OPA`     |

### Frameworks & Standards

outputs ทั้งหมดอ้างอิง frameworks เหล่านี้ตามความเหมาะสม:

- **MITRE ATT&CK** / **MITRE D3FEND** -- Tactic & Technique mapping
- **NIST SP 800-61 Rev.2** -- Incident Response lifecycle
- **NIST CSF 2.0** -- Cybersecurity Framework
- **OWASP Top 10** / **OWASP SAMM** -- Application security
- **ISO 27001:2022** / **ISO 27035** -- Information security management
- **พ.ร.บ. การรักษาความมั่นคงปลอดภัยไซเบอร์ พ.ศ. 2562** -- Thai Cybersecurity Act

---

## Usage Examples (ตัวอย่างการใช้งาน)

### 1. สร้าง Incident Response Playbook

```
สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
รวม escalation matrix และ SLA timelines
```

### 2. สร้าง Forensic Report Template

```
สร้างแม่แบบ DFIR report สำหรับ memory forensics investigation
ต้องมี chain of custody form และ evidence handling procedures
```

### 3. สร้าง DevSecOps Pipeline

```
สร้าง GitHub Actions workflow สำหรับ DevSecOps pipeline
รวม SAST, DAST, SCA, SBOM scanning พร้อม OWASP compliance gates
```

### 4. สร้าง SOC Triage Procedure

```
สร้าง SOC L1 triage procedure สำหรับ phishing alert
รวม SIEM correlation rules (Splunk SPL) และ escalation criteria
```

---

## Repository Structure (โครงสร้าง Repository)

```
claude-cybersecurity-skill/
├── .claude-plugin/
│   ├── marketplace.json          # Marketplace metadata
│   └── plugin.json               # Plugin metadata
├── skills/
│   └── cybersecurity-pro/
│       ├── SKILL.md              # Skill definition & trigger config
│       ├── cybersecurity-pro.skill  # Packaged skill archive
│       └── references/
│           ├── ir-playbooks.md       # IR playbook templates (NIST 800-61)
│           ├── dfir-reports.md       # Forensic report templates
│           ├── devsecops-pipeline.md # CI/CD security configs
│           ├── soc-operations.md     # SOC L1-L3 procedures
│           └── gitops-security.md    # GitOps security policies
├── docs/
│   ├── INSTALL.md                # Installation guide
│   └── TROUBLESHOOTING.md       # Troubleshooting guide
├── CHANGELOG.md                  # Version history
└── README.md                     # This file
```

---

## Troubleshooting (แก้ไขปัญหา)

| ปัญหา                                | วิธีแก้                                                                            |
| ------------------------------------ | ---------------------------------------------------------------------------------- |
| `claude doctor` แสดง "Invalid input" | ตรวจสอบ `source` ใน `known_marketplaces.json` ต้องเป็น `"github"` ไม่ใช่ `"local"` |
| Plugin ไม่แสดงหลังติดตั้ง            | ตรวจสอบชื่อ marketplace ใน 3 config files ต้องตรงกัน                               |
| Skill ไม่ trigger                    | Restart Claude Code session (`/clear`) แล้วใช้ trigger keywords                    |

> ดูคู่มือแก้ไขปัญหาฉบับเต็ม: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## Plugin Details

| Field           | Value                                     |
| --------------- | ----------------------------------------- |
| **Plugin name** | `cybersecurity-pro`                       |
| **Marketplace** | `pitimon-cybersecurity`                   |
| **Install key** | `cybersecurity-pro@pitimon-cybersecurity` |
| **Version**     | 1.0.0                                     |
| **Category**    | Security                                  |
| **Author**      | somapa                                    |
| **Language**    | Bilingual Thai + English                  |

---

## Contributing

1. Fork repository
2. สร้าง feature branch (`git checkout -b feat/new-playbook`)
3. Commit changes (`git commit -m "feat: add cloud IR playbook"`)
4. Push branch (`git push origin feat/new-playbook`)
5. เปิด Pull Request

### Reference Files

เพื่อเพิ่ม domain ใหม่หรืออัพเดท reference:

- เพิ่มไฟล์ `.md` ใน `skills/cybersecurity-pro/references/`
- อัพเดท `skills/cybersecurity-pro/SKILL.md` เพื่อเพิ่ม domain entry และ trigger keywords
- อัพเดท CHANGELOG.md

---

## License

MIT

---

## Links

- [Installation Guide](docs/INSTALL.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [Changelog](CHANGELOG.md)
- [GitHub Issues](https://github.com/pitimon/claude-cybersecurity-skill/issues)
