<div align="center">

# cybersecurity-pro

**Enterprise Cybersecurity Skill for Claude Code**

สร้างเอกสาร Cybersecurity ระดับมืออาชีพใน 30 วินาที — IR Playbooks, SOC Procedures,
Compliance Audits, Cloud Security, AI Governance, OT/ICS Security และอีก 12 domains
พร้อม output แบบ bilingual Thai + English ที่ map กับ NIST, MITRE ATT&CK, OWASP, ISO frameworks

[![Version](https://img.shields.io/badge/version-3.6.1-blue.svg)](CHANGELOG.md)
[![CI](https://github.com/pitimon/claude-cybersecurity-skill/actions/workflows/validate.yml/badge.svg)](https://github.com/pitimon/claude-cybersecurity-skill/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Domains](https://img.shields.io/badge/domains-18-orange.svg)](#capabilities-ความสามารถ--18-domains)
[![Language](https://img.shields.io/badge/language-Thai%20%2B%20English-blueviolet.svg)](#bilingual-output-policy)

</div>

---

<div align="center">

**18 Domains** | **50+ Frameworks** | **< 5% Context Budget**

ครอบคลุม 18 security domains ตั้งแต่ Incident Response ถึง OT/ICS Security —
map กับ 50+ international frameworks — ใช้ context เพียง ~8,600 tokens ต่อ request (< 5% ของ 200K window)

</div>

---

## See It in Action (ลองใช้ใน 30 วินาที)

พิมพ์ prompt เดียว — ได้ IR playbook ระดับ enterprise ทันที:

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
  รวม escalation matrix และ SLA timelines
```

**Output ที่ได้** (ตัวอย่างบางส่วน):

```markdown
## 1. การเตรียมพร้อม (Preparation)

### 1.1 Ransomware-Specific Preparation Checklist

- [ ] Offline backup verification (3-2-1 rule) — ทดสอบ restore ทุก 90 วัน
- [ ] Network segmentation — isolate critical assets ตาม NIST SP 800-41
- [ ] EDR deployment — verify coverage ≥ 95% endpoints
      ...

## 3. การควบคุมและกำจัด (Containment & Eradication)

### SLA Timeline

| Severity    | Detection → Triage | Triage → Containment | Containment → Eradication |
| ----------- | ------------------ | -------------------- | ------------------------- |
| P1-Critical | ≤ 15 min           | ≤ 1 hour             | ≤ 4 hours                 |

...

### Escalation Matrix

| Level | Role        | Trigger Condition | MITRE ATT&CK           |
| ----- | ----------- | ----------------- | ---------------------- |
| L1    | SOC Analyst | Initial alert     | T1486 (Data Encrypted) |

...
```

ไม่ต้อง prompt engineer เอง — templates map กับ NIST 800-61, MITRE ATT&CK, ISO 27035 ให้อัตโนมัติ

---

## Quick Start (เริ่มต้นใช้งาน)

### Step 1: ติดตั้ง — รันใน Terminal Shell

เปิด **terminal** (ไม่ใช่ใน Claude Code prompt) แล้วรันคำสั่งทั้ง 3 ตามลำดับ:

```bash
# 1. เพิ่ม marketplace
claude plugin marketplace add pitimon/claude-cybersecurity-skill

# 2. ติดตั้ง plugin
claude plugin install cybersecurity-pro@pitimon-cybersecurity

# 3. ตรวจสอบว่าติดตั้งสำเร็จ
claude doctor
# Expected: ✓ cybersecurity-pro@pitimon-cybersecurity - OK
```

### Step 2: เริ่มใช้งาน — พิมพ์ใน Claude Code Prompt

เปิด **Claude Code session ใหม่** (หรือพิมพ์ `/clear` เพื่อ reload skills) แล้วพิมพ์:

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
```

Skill จะถูก trigger อัตโนมัติเมื่อ prompt ตรงกับ keywords ของ domain ใด domain หนึ่ง — ไม่ต้องเรียก skill ด้วยตัวเอง

### อัพเดท Plugin

```bash
claude plugin marketplace update pitimon-cybersecurity
claude plugin install cybersecurity-pro@pitimon-cybersecurity
claude doctor  # ตรวจสอบ version ใหม่
# Restart Claude Code session เพื่อโหลด skill version ใหม่
```

> ดูคู่มือฉบับเต็ม: [docs/INSTALL.md](docs/INSTALL.md) | สำหรับ air-gapped server ดู Manual Installation

---

## Why This Plugin (ทำไมต้องใช้ Plugin นี้)

**Problem**: Claude Code เป็น general-purpose AI — ไม่มี cybersecurity domain expertise built-in ทำให้ต้องเขียน prompt ละเอียดทุกครั้ง และผลลัพธ์ไม่สม่ำเสมอ

**Solution**: `cybersecurity-pro` โหลด professional templates และ framework mappings อัตโนมัติเมื่อ prompt ตรง trigger keywords

### Value Propositions

- **Enterprise-quality output ทันที** — Templates ออกแบบโดย security professionals พร้อม SLA, escalation, RACI matrices ในตัว ไม่ต้อง prompt engineer เอง
- **Framework-mapped templates** — ทุก output map กับ frameworks จริง (NIST, MITRE ATT&CK, OWASP, ISO 27001, CIS) — ไม่ต้องตรวจสอบความถูกต้องของ references เอง
- **Bilingual Thai + English** — พร้อมใช้ในองค์กรไทย รองรับ พ.ร.บ. การรักษาความมั่นคงปลอดภัยไซเบอร์ พ.ศ. 2562 และ PDPA ใน compliance templates
- **On-demand loading — ไม่กิน context** — มี 18 domains แต่โหลดแค่ 1 ต่อ request ใช้ context < 5% ของ 200K window

---

## NIST CSF 2.0 Coverage Map

18 domains ครอบคลุมทุก function ของ NIST Cybersecurity Framework 2.0:

```
┌─────────────────────────────────────────────────────────────────┐
│                      NIST CSF 2.0 FUNCTIONS                     │
├────────────┬────────────────────────────────────────────────────┤
│            │                                                    │
│  GOVERN    │  D17 Security Governance & Executive Leadership    │
│            │                                                    │
├────────────┼────────────────────────────────────────────────────┤
│            │  D8  Threat Modeling & Risk                        │
│  IDENTIFY  │  D9  Compliance Frameworks                        │
│            │  D14 Vulnerability Management                      │
│            │  D15 Threat Intelligence                           │
│            │  D18 OT/ICS Security (OT asset management)        │
├────────────┼────────────────────────────────────────────────────┤
│            │  D3  DevSecOps Pipeline                            │
│            │  D5  GitOps Security                               │
│            │  D6  Code Security Analysis                        │
│  PROTECT   │  D7  Container & Supply Chain                     │
│            │  D10 Cloud Security & CSPM                         │
│            │  D11 Zero Trust Architecture                       │
│            │  D12 AI/ML Security                                │
│            │  D13 API Security                                  │
│            │  D18 OT/ICS Security (OT network protection)      │
├────────────┼────────────────────────────────────────────────────┤
│  DETECT    │  D4  SOC Operations + SOAR                        │
│            │  D15 Threat Intelligence                           │
├────────────┼────────────────────────────────────────────────────┤
│  RESPOND   │  D1  IR Playbooks & Runbooks                      │
│            │  D2  DFIR Reports                                  │
├────────────┼────────────────────────────────────────────────────┤
│  RECOVER   │  D1  IR Playbooks (post-mortem & lessons learned)  │
│            │  D14 Vulnerability Management (remediation)        │
├────────────┼────────────────────────────────────────────────────┤
│            │                                                    │
│  CROSS-    │  D16 Cross-Domain Integration Scenarios            │
│  DOMAIN    │  (orchestrates all domains via SOAR & workflows)   │
│            │                                                    │
└────────────┴────────────────────────────────────────────────────┘
```

---

## Capabilities (ความสามารถ — 18 Domains)

### Security Operations

| Domain                           | คำอธิบาย                                                                           | Frameworks                         |
| -------------------------------- | ---------------------------------------------------------------------------------- | ---------------------------------- |
| **D1 — IR Playbooks & Runbooks** | Incident response playbooks พร้อม SLA, escalation matrix, post-mortem templates    | NIST SP 800-61, ISO 27035, SANS IR |
| **D2 — DFIR Reports**            | Forensic investigation reports พร้อม chain of custody, evidence handling, timeline | Chain of Custody, IOC, Timeline    |
| **D4 — SOC Operations + SOAR**   | SOC L1-L3 procedures, SIEM rules, SOAR automation playbooks, threat hunting        | MITRE ATT&CK, Cyber Kill Chain     |

### Secure Development

| Domain                             | คำอธิบาย                                                                | Frameworks                        |
| ---------------------------------- | ----------------------------------------------------------------------- | --------------------------------- |
| **D3 — DevSecOps Pipeline**        | CI/CD security pipeline configs สำหรับ GitHub Actions / GitLab CI       | OWASP SAMM, OWASP Top 10, CIS     |
| **D6 — Code Security Analysis**    | Static analysis ด้วย Semgrep/CodeQL, SARIF processing, variant analysis | CWE Top 25, SARIF 2.1.0           |
| **D7 — Container & Supply Chain**  | Container hardening, vulnerability scanning, SBOM, image signing        | NIST SP 800-190, CIS Docker, SLSA |
| **D13 — API Security**             | OWASP API Top 10, JWT validation, OAuth 2.0 BCP, API gateway security   | OWASP API Top 10 2023, RFC 9700   |
| **D14 — Vulnerability Management** | Vulnerability lifecycle, CVSS/EPSS/KEV prioritization, patch management | CVSS v4.0, EPSS, CISA KEV, SSVC   |

### Governance & Compliance

| Domain                          | คำอธิบาย                                                                      | Frameworks                                         |
| ------------------------------- | ----------------------------------------------------------------------------- | -------------------------------------------------- |
| **D5 — GitOps Security**        | Policy-as-code frameworks สำหรับ ArgoCD, OPA, Falco                           | OPA/Gatekeeper, Falco, ArgoCD                      |
| **D8 — Threat Modeling & Risk** | STRIDE/PASTA threat modeling, risk assessment, SOC 2/ISO 27001                | SOC 2, ISO 27001, STRIDE, PASTA, PDPA              |
| **D9 — Compliance Frameworks**  | Compliance assessments, gap analyses, control mappings                        | NIST 800-53, PCI DSS v4.0.1, GDPR, HIPAA, CIS v8.1 |
| **D17 — Security Governance**   | Executive governance, board reporting, maturity models, CISO/CAIO/CAISO roles | NIST CSF 2.0 GOVERN, ISO 27014, C2M2               |

### Cloud & Architecture

| Domain                            | คำอธิบาย                                                             | Frameworks                                          |
| --------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------- |
| **D10 — Cloud Security & CSPM**   | Cloud security audits, IAM reviews, CSPM configs (AWS/Azure/GCP)     | CIS Cloud Benchmarks, CSA CCM v4.1, NIST 800-144    |
| **D11 — Zero Trust Architecture** | ZTA maturity assessments, implementation roadmaps, microsegmentation | NIST 800-207, CISA ZT Maturity Model, Forrester ZTX |
| **D12 — AI/ML Security**          | AI security assessments, LLM guardrails, AI red team, AI governance  | OWASP LLM Top 10, NIST AI RMF, MITRE ATLAS          |

### Industrial & OT

| Domain                    | คำอธิบาย                                                                    | Frameworks                                        |
| ------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------- |
| **D18 — OT/ICS Security** | OT/ICS security assessments, Purdue Model segmentation, SCADA/PLC hardening | NIST SP 800-82 Rev.3, IEC 62443, MITRE ATT&CK ICS |

### Intelligence & Integration

| Domain                             | คำอธิบาย                                                                       | Frameworks                                  |
| ---------------------------------- | ------------------------------------------------------------------------------ | ------------------------------------------- |
| **D15 — Threat Intelligence**      | TI program design, STIX/TAXII integration, IOC lifecycle, intelligence sharing | STIX 2.1, TAXII 2.1, TLP 2.0, Diamond Model |
| **D16 — Cross-Domain Integration** | End-to-end security workflows, SOAR orchestration, multi-domain scenarios      | NIST CSF 2.0, All domain frameworks         |

---

## Usage Examples (ตัวอย่างการใช้งาน)

ตัวอย่าง prompt ที่พิมพ์ **ใน Claude Code** — skill จะ trigger อัตโนมัติจาก keywords

### IR Playbook

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
  รวม escalation matrix และ SLA timelines
```

### SOC + SOAR

```
> สร้าง SOAR playbook สำหรับ automated phishing response
  รวม enrichment sources และ containment actions
```

### Compliance

```
> สร้าง NIST 800-53 gap assessment สำหรับ cloud environment
  พร้อม PCI DSS v4.0 control mapping และ CIS Controls roadmap
```

### Cloud Security

```
> ทำ cloud security audit สำหรับ AWS environment
  ตรวจสอบ IAM policies, S3 buckets, Security Groups ตาม CIS Benchmarks
```

### AI/ML Security

```
> สร้าง AI security assessment สำหรับ LLM application
  ตรวจสอบ prompt injection defense และ OWASP LLM Top 10 compliance
```

### Security Governance

```
> สร้าง security governance framework ตาม NIST CSF 2.0 GOVERN
  พร้อม board reporting template, CISO/CAIO/CAISO RACI matrix, และ C2M2 maturity assessment
```

<details>
<summary>ดูตัวอย่างเพิ่มเติมทั้ง 18 domains →</summary>

### DFIR Report

```
> สร้างแม่แบบ DFIR report สำหรับ memory forensics investigation
  ต้องมี chain of custody form และ evidence handling procedures
```

### Code Security Analysis

```
> สร้าง Semgrep custom rules สำหรับตรวจจับ SQL injection ด้วย taint mode
  พร้อม GitHub Actions pipeline ที่รวม CodeQL
```

### Container Security

```
> สร้าง Dockerfile hardening guide สำหรับ Node.js application
  รวม Trivy scanning, SBOM generation, และ cosign signing
```

### Threat Modeling

```
> สร้าง STRIDE threat model สำหรับ web application
  รวม risk matrix และ SOC 2 compliance mapping
```

### Zero Trust

```
> สร้าง Zero Trust implementation roadmap ตาม NIST 800-207
  รวม maturity assessment และ microsegmentation plan
```

### API Security

```
> สร้าง API security assessment ตาม OWASP API Top 10
  ตรวจสอบ BOLA, JWT validation, rate limiting พร้อม API gateway config
```

### Vulnerability Management

```
> สร้าง vulnerability management program พร้อม CVSS+EPSS+KEV prioritization
  รวม SLA templates, patch management workflow, และ executive dashboard
```

### Threat Intelligence

```
> สร้าง threat intelligence program ด้วย STIX/TAXII integration
  รวม MISP setup, IOC lifecycle management, และ TLP 2.0 sharing procedures
```

### Cross-Domain Integration

```
> ออกแบบ end-to-end security workflow ตั้งแต่ threat intelligence ถึง incident response
  พร้อม SOAR orchestration template และ cross-domain metrics dashboard
```

### OT/ICS Security

```
> สร้าง OT security assessment ตาม NIST 800-82 และ IEC 62443
  รวม Purdue Model network segmentation design และ PLC hardening checklist
```

</details>

---

## Architecture & Token Budget (สถาปัตยกรรมและงบ Token)

### How It Works

```
User prompt → keyword match in SKILL.md frontmatter
  → SKILL.md loaded (~3,400 tokens: language policy, frameworks, decision tree)
  → Decision tree selects domain
  → Corresponding references/*.md loaded on-demand (~3,000-5,000 tokens)
  → Output generated following templates in reference file
```

### Token Budget

**On-demand loading**: มี 18 domains แต่โหลดแค่ 1 ต่อ request

| Component                | Tokens       | หมายเหตุ                              |
| ------------------------ | ------------ | ------------------------------------- |
| SKILL.md (always loaded) | ~3,600       | Router + language policy + frameworks |
| Reference file (1 of 18) | ~3,000-5,000 | โหลดเฉพาะ domain ที่ trigger          |
| **Max per request**      | **~8,600**   | **< 5% ของ 200K context window**      |
| Total all files          | ~82,000      | ไม่โหลดทั้งหมดพร้อมกัน                |

### Skill Engineering Techniques

เทคนิคที่ใช้ออกแบบ plugin นี้ — เป็นแนวทางสำหรับผู้ที่ต้องการสร้าง Claude Code skill ของตัวเอง:

1. **On-demand reference loading** — โหลดเฉพาะ domain ที่ user ต้องการ เพิ่ม domains ได้โดยไม่เพิ่ม base context cost (ปัจจุบัน 18 domains)
2. **Composite reference files** — รวม topics ที่เกี่ยวข้องเป็นไฟล์เดียว (เช่น Semgrep + CodeQL + SARIF → `code-security-analysis.md`)
3. **Framework-first templates** — Templates map กับ framework controls (NIST, MITRE ATT&CK IDs, CWE) ทำให้ output มี reference ที่ถูกต้อง
4. **Bilingual output policy** — Thai prose + English terms ใน output เดียว ไม่ต้องสร้าง 2 versions
5. **SKILL.md as compact router** — Decision tree ใน < 300 lines ทำหน้าที่เป็น lightweight router

---

## Comparison (เปรียบเทียบ)

| Aspect                 | Manual Prompting  | cybersecurity-pro              | Enterprise Tools |
| ---------------------- | ----------------- | ------------------------------ | ---------------- |
| **Setup time**         | 0                 | 3 commands, 30 sec             | Weeks-months     |
| **Framework mapping**  | Manual research   | Auto-mapped (50+ frameworks)   | Vendor-specific  |
| **Bilingual TH+EN**    | DIY every time    | Built-in policy                | Limited/none     |
| **Thai compliance**    | Must research     | พ.ร.บ. ไซเบอร์ / PDPA included | Varies           |
| **Output consistency** | Varies per prompt | Standardized templates         | Standardized     |
| **Context overhead**   | Variable          | < 5% (8,600 tokens)            | N/A              |
| **Cost**               | Free              | Free (MIT)                     | $$$$             |
| **Maintenance**        | Manual updates    | Community-maintained           | Vendor-dependent |

---

## Frameworks & Standards

Outputs อ้างอิง frameworks เหล่านี้ตามความเหมาะสม — จัดกลุ่มตาม audience:

### SOC / IR Teams

- **MITRE ATT&CK** / **MITRE D3FEND** — Tactic & technique mapping
- **NIST SP 800-61 Rev.2** — Incident response lifecycle
- **ISO 27035** — Incident management
- **Cyber Kill Chain** — Attack phase analysis
- **Diamond Model** — Intrusion analysis

### DevSecOps / AppSec

- **OWASP Top 10** / **OWASP SAMM** — Application security
- **OWASP API Security Top 10** — API vulnerability risks
- **CWE Top 25** / **SARIF 2.1.0** — Code vulnerability classification
- **CIS Docker Benchmark** / **SLSA** — Container & supply chain
- **NIST SP 800-190** — Container security

### Compliance / GRC

- **NIST SP 800-53 Rev 5** — Security & privacy controls
- **PCI DSS v4.0.1** — Payment card industry
- **GDPR** / **HIPAA** — Data protection & healthcare
- **CIS Controls v8.1** — Prioritized security practices
- **SOC 2** / **ISO 27001:2022** — Information security management
- **พ.ร.บ. ไซเบอร์ 2562** / **PDPA** — Thai cybersecurity & data privacy law

### Executive / Governance

- **NIST CSF 2.0** — Cybersecurity framework (GOVERN function)
- **ISO 27014:2020** — Information security governance
- **C2M2** — Cybersecurity capability maturity model
- **SEC Cybersecurity Rules** — Disclosure requirements

### Cloud / Zero Trust

- **CIS Cloud Benchmarks** / **CSA CCM v4.1** — Cloud security posture
- **NIST SP 800-207** — Zero Trust Architecture
- **CISA Zero Trust Maturity Model** — ZTA implementation
- **NIST SP 800-144** — Cloud computing guidelines

### AI Security

- **OWASP Top 10 for LLM Apps** — AI/LLM application security
- **NIST AI RMF** / **MITRE ATLAS** — AI risk management & threats
- **EU AI Act** / **ISO 42001** — AI governance & regulation

### Industrial / OT

- **NIST SP 800-82 Rev.3** — OT/ICS security guide
- **IEC 62443** (ISA/IEC) — Industrial automation and control system security
- **Purdue Model / ISA-95** — OT network segmentation architecture
- **MITRE ATT&CK for ICS** — ICS-specific tactics, techniques, and procedures
- **NERC CIP** — North American electric grid reliability standards

### Threat Intelligence

- **STIX 2.1** / **TAXII 2.1** — Threat information expression & sharing
- **Traffic Light Protocol 2.0** — Intelligence sharing classification
- **CVSS v4.0** / **EPSS** — Vulnerability scoring & exploit prediction
- **CISA KEV** / **SSVC** — Known exploited vulnerabilities & prioritization

---

## Repository Structure (โครงสร้าง Repository)

```
claude-cybersecurity-skill/
├── .claude-plugin/
│   ├── marketplace.json          # Marketplace metadata
│   └── plugin.json               # Plugin metadata (v3.7.0)
├── skills/
│   └── cybersecurity-pro/
│       ├── SKILL.md              # Skill definition & decision tree
│       └── references/
│           ├── ir-playbooks.md              # IR playbook + post-mortem templates
│           ├── dfir-reports.md              # Forensic report templates
│           ├── devsecops-pipeline.md        # CI/CD security configs
│           ├── soc-operations.md            # SOC L1-L3 + SOAR automation
│           ├── gitops-security.md           # GitOps security policies
│           ├── code-security-analysis.md    # Semgrep/CodeQL/SARIF/Variant
│           ├── container-supply-chain.md    # Container hardening/SBOM/signing
│           ├── compliance-threat-modeling.md # STRIDE/PASTA/Risk/SOC2/ISO27001
│           ├── compliance-frameworks.md     # NIST 800-53/PCI DSS/GDPR/HIPAA/CIS
│           ├── cloud-security-cspm.md       # Cloud Security/IAM/CSPM/Multi-cloud
│           ├── zero-trust-architecture.md   # ZTA/NIST 800-207/Microsegmentation
│           ├── ai-ml-security.md            # AI/ML/LLM Security/MITRE ATLAS
│           ├── api-security.md              # OWASP API Top 10/JWT/OAuth/Gateway
│           ├── vulnerability-management.md  # CVSS/EPSS/KEV/Patch Management
│           ├── threat-intelligence.md       # STIX/TAXII/IOC/TLP/MISP/OpenCTI
│           ├── cross-domain-integration.md  # End-to-end workflows/orchestration
│           ├── security-governance-executive.md # CISO/CAIO/CAISO/Board/Maturity
│           └── ot-ics-security.md          # OT/ICS/SCADA/Purdue/IEC 62443
├── frameworks.json                # Framework version manifest (54 entries)
├── docs/
│   ├── INSTALL.md                # Installation guide
│   ├── TROUBLESHOOTING.md        # Troubleshooting guide
│   └── FRAMEWORK-UPDATE-RUNBOOK.md # Framework update procedures
├── tests/
│   ├── validate-plugin.sh        # Structural validation (61+ checks)
│   └── check-framework-updates.sh # Ad-hoc framework staleness checker
├── .github/
│   └── workflows/
│       ├── validate.yml          # CI on push/PR
│       └── framework-review.yml  # Quarterly framework review
├── CHANGELOG.md                  # Version history
├── CLAUDE.md                     # Claude Code guidance
└── README.md                     # This file
```

---

## Plugin Details

| Field           | Value                                     |
| --------------- | ----------------------------------------- |
| **Plugin name** | `cybersecurity-pro`                       |
| **Marketplace** | `pitimon-cybersecurity`                   |
| **Install key** | `cybersecurity-pro@pitimon-cybersecurity` |
| **Version**     | 3.6.1                                     |
| **Category**    | Security                                  |
| **Author**      | P.Itarun                                  |
| **Language**    | Bilingual Thai + English                  |
| **Domains**     | 18                                        |

---

## Contributing

1. Fork repository
2. สร้าง feature branch (`git checkout -b feat/new-domain`)
3. Commit changes (`git commit -m "feat: add new-domain reference"`)
4. Push branch (`git push origin feat/new-domain`)
5. เปิด Pull Request

### เพิ่ม Domain ใหม่

1. สร้างไฟล์ `skills/cybersecurity-pro/references/<domain-name>.md`
2. อัพเดท `SKILL.md` — เพิ่ม domain entry + trigger keywords + decision tree branch
3. อัพเดท `README.md` — เพิ่มใน capabilities table
4. อัพเดท `CLAUDE.md` — เพิ่มใน domain table
5. เพิ่ม entry ใน `CHANGELOG.md`
6. หาก domain มี versioned frameworks ใหม่ — เพิ่ม entries ใน `frameworks.json` พร้อม grep patterns และ used_in file lists

---

## Troubleshooting (แก้ไขปัญหา)

| ปัญหา                                | วิธีแก้                                                           |
| ------------------------------------ | ----------------------------------------------------------------- |
| `claude doctor` แสดง "Invalid input" | ตรวจสอบ `source` ใน `known_marketplaces.json` ต้องเป็น `"github"` |
| Plugin ไม่แสดงหลังติดตั้ง            | ตรวจสอบชื่อ marketplace ใน 3 config files ต้องตรงกัน              |
| Skill ไม่ trigger                    | Restart session (`/clear`) แล้วใช้ trigger keywords               |

> ดูคู่มือแก้ไขปัญหาฉบับเต็ม: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## Related Plugins

| Plugin                                                            | คำอธิบาย                                                                                                                                                                                                                                          | Install                                                 |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **[shannon-pentest](https://github.com/pitimon/shannon-pentest)** | Autonomous penetration testing orchestrator — configure targets, launch Docker-based multi-agent scans, monitor Temporal workflows, and analyze security findings. ใช้ร่วมกับ cybersecurity-pro เพื่อ remediation guidance หลังพบ vulnerabilities | `claude plugin install shannon-pentest@pitimon-shannon` |

> **Complementary workflow**: Shannon ค้นหา vulnerabilities (offensive) → cybersecurity-pro สร้าง remediation plans, IR playbooks, compliance mapping (defensive)

---

## Links

- [Installation Guide](docs/INSTALL.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [Changelog](CHANGELOG.md)
- [GitHub Issues](https://github.com/pitimon/claude-cybersecurity-skill/issues)

## License

MIT
