<div align="center">

# cybersecurity-pro

**Enterprise Cybersecurity Skill for Claude Code**

Generate professional cybersecurity documents in 30 seconds — IR Playbooks, DFIR Reports,
SOC Procedures, Compliance Audits, Cloud Security, AI Governance, OT/ICS, Post-Quantum Crypto,
and 14 more domains — bilingual Thai + English output mapped to NIST, MITRE ATT&CK, OWASP, ISO frameworks

[![Version](https://img.shields.io/badge/version-4.0.3-blue.svg)](CHANGELOG.md)
[![CI](https://github.com/pitimon/claude-cybersecurity-skill/actions/workflows/validate.yml/badge.svg)](https://github.com/pitimon/claude-cybersecurity-skill/actions/workflows/validate.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Domains](https://img.shields.io/badge/domains-22-orange.svg)](#-22-security-domains)
[![Frameworks](https://img.shields.io/badge/frameworks-73-brightgreen.svg)](#-frameworks--standards-73-references)

</div>

---

<div align="center">

**22 Domains** &nbsp;|&nbsp; **73 Frameworks** &nbsp;|&nbsp; **< 8% Context Budget** &nbsp;|&nbsp; **Bilingual TH+EN**

</div>

---

## Table of Contents

- [See It in Action](#-see-it-in-action)
- [Quick Start](#-quick-start)
- [Why This Plugin](#-why-this-plugin)
- [What's New in v4.0.3](#-whats-new-in-v403)
- [22 Security Domains](#-22-security-domains)
- [NIST CSF 2.0 Coverage Map](#-nist-csf-20-coverage-map)
- [Usage Examples](#-usage-examples)
- [How It Works](#-how-it-works)
- [Frameworks & Standards](#-frameworks--standards-73-references)
- [Comparison](#-comparison)
- [Repository Structure](#-repository-structure)
- [Plugin Details](#-plugin-details)
- [Contributing](#-contributing)
- [Related Plugins](#-related-plugins)
- [Support](#-support)
- [License](#license)

---

## See It in Action

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

### Escalation Matrix

| Level | Role        | Trigger Condition | MITRE ATT&CK           |
| ----- | ----------- | ----------------- | ---------------------- |
| L1    | SOC Analyst | Initial alert     | T1486 (Data Encrypted) |

...
```

Templates map กับ NIST 800-61, MITRE ATT&CK, ISO 27035 อัตโนมัติ — ไม่ต้อง prompt engineer เอง

---

## Quick Start

### Step 1: ติดตั้ง

เปิด **terminal** (ไม่ใช่ใน Claude Code prompt) แล้วรันคำสั่งทั้ง 3:

```bash
# 1. เพิ่ม marketplace
claude plugin marketplace add pitimon/claude-cybersecurity-skill

# 2. ติดตั้ง plugin
claude plugin install cybersecurity-pro@pitimon-cybersecurity

# 3. ตรวจสอบว่าติดตั้งสำเร็จ
claude doctor
# Expected: ✓ cybersecurity-pro@pitimon-cybersecurity - OK
```

### Step 2: เริ่มใช้งาน

เปิด **Claude Code session ใหม่** (หรือ `/clear`) แล้วพิมพ์:

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
```

Skill จะ trigger อัตโนมัติเมื่อ prompt ตรงกับ keywords ของ domain — ไม่ต้องเรียก skill ด้วยตัวเอง

### อัพเดท Plugin

```bash
claude plugin marketplace update pitimon-cybersecurity
claude plugin install cybersecurity-pro@pitimon-cybersecurity
claude doctor  # ตรวจสอบ version ใหม่
# Restart Claude Code session เพื่อโหลด skill version ใหม่
```

> คู่มือฉบับเต็ม: [docs/INSTALL.md](docs/INSTALL.md) &nbsp;|&nbsp; แก้ปัญหา: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## Why This Plugin

**Problem**: Claude Code เป็น general-purpose AI — ไม่มี cybersecurity domain expertise built-in ทำให้ต้องเขียน prompt ละเอียดทุกครั้ง และผลลัพธ์ไม่สม่ำเสมอ

**Solution**: `cybersecurity-pro` โหลด professional templates + framework mappings อัตโนมัติเมื่อ prompt ตรง trigger keywords

|                       | Without Plugin     | With cybersecurity-pro                  |
| --------------------- | ------------------ | --------------------------------------- |
| **Output quality**    | ขึ้นอยู่กับ prompt | Enterprise-grade templates ทุกครั้ง     |
| **Framework mapping** | ต้อง research เอง  | Auto-mapped 73 frameworks               |
| **Bilingual TH+EN**   | ต้องสั่งทุกครั้ง   | Built-in — Thai prose, English terms    |
| **Thai compliance**   | ต้องหาข้อมูลเอง    | พ.ร.บ. ไซเบอร์ / PDPA / ก.ล.ต. included |
| **SLA / Escalation**  | ต้องออกแบบเอง      | Templates พร้อม severity-based SLA      |
| **MITRE ATT&CK IDs**  | ต้องค้นเอง         | Auto-mapped ทุก attack scenario         |
| **Context cost**      | Variable           | < 8% ของ 200K window                    |

---

## What's New in v4.0.3

**v4.0.3** — Skill description compliance + version reconciliation (Issue #9)

- **SKILL.md description trimmed 4,663 → 590 chars** — เข้า cap ของ Anthropic spec (1024) และ Claude Code (`skillListingMaxDescChars` = 1536). แก้ `/doctor` warning, ป้องกัน truncation ของ trigger keywords และลด ~15k tokens/session overhead สำหรับ users ที่เปิด cap ไว้
- **Trigger keywords moved to skill body** — 15 categories (Incident Response, DevSecOps, Cloud, AI/ML, OT/ICS, PQC, Identity, Web3, Thai prompts ฯลฯ) ภายใต้ section "When This Skill Activates / เมื่อใดที่สกิลนี้ทำงาน" — Claude อ่าน body ทุกครั้งที่ skill ถูก invoke อยู่แล้ว
- **Version reconciliation** — `plugin.json` / `marketplace.json` (4.0.1 → 4.0.3) ให้ตรงกับ tag ล่าสุดที่ publish ไป (v4.0.2 issue #6 enhancements ที่ release Mar 1 ยังไม่ได้ bump manifest)

**v4.0.2** — Issue #6 Enhancements (6 items)

- **Quick Reference sections** — เพิ่มตาราง summary สำหรับ D19-D22 ให้เข้าใจ domain ได้ภายใน 30 วินาที
- **PQC ↔ Web3 cross-domain linkage** — ECDSA vulnerability timeline, 4-phase blockchain migration path, Ethereum EIP-7702
- **Real-world attack scenarios (D19)** — 4 scenarios พร้อม MITRE ATLAS + OWASP Agentic mapping และ detection templates (Splunk SPL + KQL)
- **IdP configuration templates (D21)** — Entra ID Conditional Access, Okta FIDO2 (Terraform), AWS IAM Identity Center SCIM
- **Thai Context deepening** — D20: CNSA 2.0 CII sector timeline, D21: PromptPay identity binding, D22: ก.ล.ต. regulatory updates 2025-2026
- **frameworks.json** expanded 69 → 73 entries (FIDO2/WebAuthn, SPIFFE, OAuth 2.1, Ethereum Security BP)

**v4.0.0** — Major Release (4 new domains + 11 enhancements)

- 4 new domains: Agentic AI Security (D19), Post-Quantum Cryptography (D20), Identity & Access Security (D21), Web3 & Blockchain Security (D22)
- Enhanced: NIST Cyber AI Profile in D12, NIST LEV metric in D14, CWE Top 25 (2025) in D6, Compliance Cross-Walk Matrix in D9, Cyber Resilience Metrics in D17
- Guided decision tree fallback + template variables ({ORG_NAME}, {DATE}, {INDUSTRY}, {ANALYST_NAME})

> ดู changelog ฉบับเต็ม: [CHANGELOG.md](CHANGELOG.md)

---

## 22 Security Domains

### Security Operations

| #   | Domain                      | คำอธิบาย                                                                | Key Frameworks               |
| --- | --------------------------- | ----------------------------------------------------------------------- | ---------------------------- |
| D1  | **IR Playbooks & Runbooks** | Incident response playbooks พร้อม SLA, escalation matrix, post-mortem   | NIST 800-61, ISO 27035       |
| D2  | **DFIR Reports**            | Forensic reports พร้อม chain of custody, evidence handling, timeline    | NIST 800-86, IOC             |
| D4  | **SOC Operations + SOAR**   | SOC L1-L3 procedures, SIEM rules, SOAR automation, threat hunting       | MITRE ATT&CK, Kill Chain     |
| D15 | **Threat Intelligence**     | TI program, STIX/TAXII integration, IOC lifecycle, intelligence sharing | STIX 2.1, TAXII 2.1, TLP 2.0 |

### Secure Development & AppSec

| #   | Domain                       | คำอธิบาย                                                                | Key Frameworks             |
| --- | ---------------------------- | ----------------------------------------------------------------------- | -------------------------- |
| D3  | **DevSecOps Pipeline**       | CI/CD security pipeline สำหรับ GitHub Actions / GitLab CI               | OWASP SAMM, NIST SSDF      |
| D6  | **Code Security Analysis**   | Static analysis — Semgrep/CodeQL, SARIF, variant analysis               | CWE Top 25, SARIF 2.1.0    |
| D7  | **Container & Supply Chain** | Container hardening, vulnerability scanning, SBOM, image signing        | NIST 800-190, SLSA         |
| D13 | **API Security**             | OWASP API Top 10, JWT, OAuth 2.0 BCP, API gateway security              | OWASP API Top 10, RFC 9700 |
| D14 | **Vulnerability Management** | Vulnerability lifecycle, CVSS/EPSS/KEV prioritization, patch management | CVSS v4.0, EPSS, CISA KEV  |

### Governance, Risk & Compliance

| #   | Domain                     | คำอธิบาย                                                                | Key Frameworks              |
| --- | -------------------------- | ----------------------------------------------------------------------- | --------------------------- |
| D5  | **GitOps Security**        | Policy-as-code สำหรับ ArgoCD, OPA/Gatekeeper, Falco                     | OPA, Gatekeeper, Falco      |
| D8  | **Threat Modeling & Risk** | STRIDE/PASTA threat modeling, risk assessment, risk matrix              | STRIDE, PASTA, ISO 27001    |
| D9  | **Compliance Frameworks**  | Gap analysis, control mappings, compliance roadmaps                     | NIST 800-53, PCI DSS v4.0.1 |
| D17 | **Security Governance**    | Executive governance, board reporting, maturity models, CISO/CAIO roles | NIST CSF 2.0 GOVERN, C2M2   |

### Cloud, Architecture & Identity

| #   | Domain                         | คำอธิบาย                                                  | Key Frameworks              |
| --- | ------------------------------ | --------------------------------------------------------- | --------------------------- |
| D10 | **Cloud Security & CSPM**      | Cloud audits, IAM reviews, CSPM configs (AWS/Azure/GCP)   | CIS Cloud, CSA CCM v4.1     |
| D11 | **Zero Trust Architecture**    | ZTA maturity, implementation roadmaps, microsegmentation  | NIST 800-207, CISA ZT       |
| D21 | **Identity & Access Security** | FIDO2/Passkeys, ITDR, NHI management, identity governance | NIST 800-63B, FIDO2, SPIFFE |

### AI & Emerging Technology

| #   | Domain                         | คำอธิบาย                                                              | Key Frameworks                  |
| --- | ------------------------------ | --------------------------------------------------------------------- | ------------------------------- |
| D12 | **AI/ML Security**             | AI security assessments, LLM guardrails, AI red team, AI governance   | OWASP LLM Top 10, NIST AI RMF   |
| D19 | **Agentic AI Security**        | Agent threat modeling, tool-use guardrails, multi-agent orchestration | OWASP Agentic Top 10 2026       |
| D20 | **Post-Quantum Cryptography**  | PQC migration roadmaps, hybrid key exchange, crypto-agility           | NIST FIPS 203/204/205, CNSA 2.0 |
| D22 | **Web3 & Blockchain Security** | Smart contract audits, DeFi security, wallet/bridge security          | OWASP SC Top 10 2026            |

### Industrial & OT

| #   | Domain              | คำอธิบาย                                                       | Key Frameworks         |
| --- | ------------------- | -------------------------------------------------------------- | ---------------------- |
| D18 | **OT/ICS Security** | OT assessments, Purdue Model segmentation, SCADA/PLC hardening | NIST 800-82, IEC 62443 |

### Cross-Domain

| #   | Domain                       | คำอธิบาย                                                                  | Key Frameworks |
| --- | ---------------------------- | ------------------------------------------------------------------------- | -------------- |
| D16 | **Cross-Domain Integration** | End-to-end security workflows, SOAR orchestration, multi-domain scenarios | NIST CSF 2.0   |

---

## NIST CSF 2.0 Coverage Map

22 domains ครอบคลุมทุก function ของ NIST Cybersecurity Framework 2.0:

```
┌────────────┬──────────────────────────────────────────────────────────┐
│  GOVERN    │  D17 Security Governance & Executive Leadership         │
├────────────┼──────────────────────────────────────────────────────────┤
│            │  D8  Threat Modeling & Risk    D14 Vulnerability Mgmt   │
│  IDENTIFY  │  D9  Compliance Frameworks    D15 Threat Intelligence   │
│            │  D18 OT/ICS (asset mgmt)      D21 Identity & Access     │
├────────────┼──────────────────────────────────────────────────────────┤
│            │  D3  DevSecOps    D5  GitOps     D6  Code Security      │
│            │  D7  Container    D10 Cloud      D11 Zero Trust         │
│  PROTECT   │  D12 AI/ML       D13 API        D18 OT/ICS (network)   │
│            │  D19 Agentic AI   D20 PQC       D21 Identity & Access   │
│            │  D22 Web3 & Blockchain                                  │
├────────────┼──────────────────────────────────────────────────────────┤
│  DETECT    │  D4  SOC + SOAR   D15 Threat Intelligence               │
│            │  D19 Agentic AI   D22 Web3 & Blockchain                 │
├────────────┼──────────────────────────────────────────────────────────┤
│  RESPOND   │  D1  IR Playbooks & Runbooks   D2  DFIR Reports         │
├────────────┼──────────────────────────────────────────────────────────┤
│  RECOVER   │  D1  IR Playbooks (post-mortem)  D14 Vuln Mgmt (fix)    │
├────────────┼──────────────────────────────────────────────────────────┤
│  CROSS-    │  D16 Cross-Domain Integration Scenarios                 │
│  DOMAIN    │  (orchestrates all domains via SOAR & workflows)        │
└────────────┴──────────────────────────────────────────────────────────┘
```

---

## Usage Examples

ตัวอย่าง prompt ใน Claude Code — skill trigger อัตโนมัติจาก keywords:

### Security Operations

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
  รวม escalation matrix และ SLA timelines
```

```
> สร้าง SOAR playbook สำหรับ automated phishing response
  รวม enrichment sources และ containment actions
```

### Compliance & Governance

```
> สร้าง NIST 800-53 gap assessment สำหรับ cloud environment
  พร้อม PCI DSS v4.0.1 control mapping และ CIS Controls roadmap
```

```
> สร้าง security governance framework ตาม NIST CSF 2.0 GOVERN
  พร้อม board reporting template และ CISO/CAIO RACI matrix
```

### Cloud & Architecture

```
> ทำ cloud security audit สำหรับ AWS environment
  ตรวจสอบ IAM policies, S3 buckets, Security Groups ตาม CIS Benchmarks
```

```
> สร้าง Zero Trust implementation roadmap ตาม NIST 800-207
  รวม maturity assessment และ microsegmentation plan
```

<details>
<summary><strong>ดูตัวอย่างเพิ่มเติมทั้ง 22 domains</strong></summary>

### AI & Emerging Technology

```
> สร้าง AI security assessment สำหรับ LLM application
  ตรวจสอบ prompt injection defense และ OWASP LLM Top 10 compliance
```

```
> สร้าง agentic AI security checklist ตาม OWASP Agentic Top 10 2026
  รวม agent permission models, memory security และ multi-agent orchestration controls
```

```
> สร้าง crypto-agility assessment สำหรับ PQC migration ตาม CNSA 2.0
  รวม NIST FIPS 203/204/205 readiness checklist และ hybrid key exchange roadmap
```

```
> สร้าง smart contract security audit checklist ตาม OWASP Smart Contract Top 10 2026
  รวม Solidity code analysis, DeFi security patterns และ audit methodology
```

### Identity & Access

```
> สร้าง identity security assessment ตาม NIST 800-63B Rev 4
  รวม FIDO2/Passkeys rollout plan, NHI management และ ITDR program design
```

### Secure Development

```
> สร้าง Semgrep custom rules สำหรับตรวจจับ SQL injection ด้วย taint mode
  พร้อม GitHub Actions pipeline ที่รวม CodeQL
```

```
> สร้าง Dockerfile hardening guide สำหรับ Node.js application
  รวม Trivy scanning, SBOM generation, และ cosign signing
```

```
> สร้าง API security assessment ตาม OWASP API Top 10
  ตรวจสอบ BOLA, JWT validation, rate limiting พร้อม API gateway config
```

```
> สร้าง vulnerability management program พร้อม CVSS+EPSS+KEV prioritization
  รวม SLA templates, patch management workflow, และ executive dashboard
```

### DFIR & Threat Intelligence

```
> สร้างแม่แบบ DFIR report สำหรับ memory forensics investigation
  ต้องมี chain of custody form และ evidence handling procedures
```

```
> สร้าง threat intelligence program ด้วย STIX/TAXII integration
  รวม MISP setup, IOC lifecycle management, และ TLP 2.0 sharing procedures
```

### Industrial & Cross-Domain

```
> สร้าง OT security assessment ตาม NIST 800-82 และ IEC 62443
  รวม Purdue Model network segmentation design และ PLC hardening checklist
```

```
> ออกแบบ end-to-end security workflow ตั้งแต่ threat intelligence ถึง incident response
  พร้อม SOAR orchestration template และ cross-domain metrics dashboard
```

### Threat Modeling

```
> สร้าง STRIDE threat model สำหรับ web application
  รวม risk matrix และ SOC 2 compliance mapping
```

</details>

---

## How It Works

### Architecture

```
User prompt → keyword match in SKILL.md
  → SKILL.md loaded (~5,000 tokens: language policy, frameworks, decision tree)
  → Decision tree routes to 1 of 22 domains
  → Corresponding references/*.md loaded on-demand (~2,000-10,000 tokens)
  → Output generated following domain templates + framework mappings
```

### Token Budget

**On-demand loading** — มี 22 domains แต่โหลดแค่ 1 ต่อ request:

| Component                 | Tokens            | หมายเหตุ                              |
| ------------------------- | ----------------- | ------------------------------------- |
| SKILL.md (always loaded)  | ~5,000            | Router + language policy + frameworks |
| Reference file (1 of 22)  | ~2,000-10,000     | โหลดเฉพาะ domain ที่ trigger          |
| **Per request total**     | **~7,000-15,000** | **< 8% ของ 200K context window**      |
| Total all reference files | ~120,000          | ไม่โหลดทั้งหมดพร้อมกัน                |

### Design Principles

1. **On-demand reference loading** — เพิ่ม domains ได้โดยไม่เพิ่ม base context cost
2. **Composite reference files** — รวม topics ที่เกี่ยวข้องเป็นไฟล์เดียว (เช่น Semgrep + CodeQL + SARIF → `code-security-analysis.md`)
3. **Framework-first templates** — ทุก output map กับ framework controls จริง (NIST, MITRE ATT&CK, CWE)
4. **Bilingual output policy** — Thai prose + English terms ใน output เดียว
5. **SKILL.md as compact router** — Decision tree ~500 lines เป็น lightweight router ให้ 22 domains

---

## Frameworks & Standards (73 References)

Outputs อ้างอิง 73 frameworks จัดกลุ่มตาม audience:

<details>
<summary><strong>SOC / IR Teams</strong></summary>

- **MITRE ATT&CK** / **MITRE D3FEND** — Tactic & technique mapping
- **NIST SP 800-61 Rev.2** — Incident response lifecycle
- **ISO 27035** — Incident management
- **Cyber Kill Chain** — Attack phase analysis
- **Diamond Model** — Intrusion analysis

</details>

<details>
<summary><strong>DevSecOps / AppSec</strong></summary>

- **OWASP Top 10** / **OWASP SAMM** — Application security
- **OWASP API Security Top 10 2023** — API vulnerability risks
- **CWE Top 25 (2025)** / **SARIF 2.1.0** — Code vulnerability classification
- **CIS Docker Benchmark** / **SLSA** — Container & supply chain
- **NIST SP 800-190** — Container security

</details>

<details>
<summary><strong>Compliance / GRC</strong></summary>

- **NIST SP 800-53 Rev 5** — Security & privacy controls
- **PCI DSS v4.0.1** — Payment card industry
- **GDPR** / **HIPAA** — Data protection & healthcare
- **CIS Controls v8.1** — Prioritized security practices
- **SOC 2** / **ISO 27001:2022** — Information security management
- **พ.ร.บ. ไซเบอร์ 2562** / **PDPA** — Thai cybersecurity & data privacy law

</details>

<details>
<summary><strong>Executive / Governance</strong></summary>

- **NIST CSF 2.0** — Cybersecurity framework (GOVERN function)
- **ISO 27014:2020** — Information security governance
- **C2M2** — Cybersecurity capability maturity model
- **SEC Cybersecurity Rules** — Disclosure requirements

</details>

<details>
<summary><strong>Cloud / Zero Trust</strong></summary>

- **CIS Cloud Benchmarks** / **CSA CCM v4.1** — Cloud security posture
- **NIST SP 800-207** — Zero Trust Architecture
- **CISA Zero Trust Maturity Model** — ZTA implementation
- **NIST SP 800-144** — Cloud computing guidelines

</details>

<details>
<summary><strong>AI & Agentic AI Security</strong></summary>

- **OWASP Top 10 for LLM Apps** — AI/LLM application security
- **OWASP Agentic Top 10 2026** — Agentic AI-specific risks
- **NIST AI RMF** / **MITRE ATLAS 2025** — AI risk management & threats
- **EU AI Act** / **ISO 42001** — AI governance & regulation

</details>

<details>
<summary><strong>Post-Quantum / Cryptography</strong></summary>

- **NIST FIPS 203/204/205** — ML-KEM, ML-DSA, SLH-DSA post-quantum standards
- **CNSA 2.0** — NSA Commercial National Security Algorithm Suite
- **NIST IR 8547** — Transition to post-quantum cryptography standards

</details>

<details>
<summary><strong>Identity & Access</strong></summary>

- **NIST SP 800-63B** — Digital identity guidelines (authentication)
- **FIDO2 / WebAuthn** — Passwordless authentication standards
- **NIST IR 8587** — Identity threat detection & response
- **SPIFFE / SPIRE** — Workload identity framework
- **OAuth 2.1** — Authorization framework

</details>

<details>
<summary><strong>Web3 / Blockchain</strong></summary>

- **OWASP Smart Contract Top 10 2026** — Smart contract vulnerability risks
- **Ethereum Security Best Practices** — Smart contract development security

</details>

<details>
<summary><strong>Industrial / OT</strong></summary>

- **NIST SP 800-82 Rev.3** — OT/ICS security guide
- **IEC 62443** — Industrial automation and control system security
- **Purdue Model / ISA-95** — OT network segmentation architecture
- **MITRE ATT&CK for ICS** — ICS-specific tactics, techniques, and procedures
- **NERC CIP** — North American electric grid reliability standards

</details>

<details>
<summary><strong>Threat Intelligence / Vulnerability</strong></summary>

- **STIX 2.1** / **TAXII 2.1** — Threat information expression & sharing
- **Traffic Light Protocol 2.0** — Intelligence sharing classification
- **CVSS v4.0** / **EPSS** — Vulnerability scoring & exploit prediction
- **CISA KEV** / **SSVC** — Known exploited vulnerabilities & prioritization

</details>

> ดูรายละเอียด version tracking: [`frameworks.json`](frameworks.json) (73 entries with grep patterns + staleness tracking)

---

## Comparison

| Aspect                 | Manual Prompting     | cybersecurity-pro              | Enterprise Tools |
| ---------------------- | -------------------- | ------------------------------ | ---------------- |
| **Setup time**         | 0                    | 3 commands, 30 sec             | Weeks-months     |
| **Framework mapping**  | Manual research      | Auto-mapped (73 frameworks)    | Vendor-specific  |
| **Bilingual TH+EN**    | DIY every time       | Built-in policy                | Limited/none     |
| **Thai compliance**    | Must research        | พ.ร.บ. ไซเบอร์ / PDPA / ก.ล.ต. | Varies           |
| **Output consistency** | Varies per prompt    | Standardized templates         | Standardized     |
| **Context overhead**   | Variable             | < 8% (7K-15K tokens)           | N/A              |
| **Cost**               | Free                 | Free (MIT)                     | $$$$             |
| **Domains**            | Unlimited (no depth) | 22 deep domains                | Vendor-dependent |
| **Maintenance**        | Manual updates       | Community + quarterly review   | Vendor-dependent |

---

## Repository Structure

```
claude-cybersecurity-skill/
├── .claude-plugin/
│   ├── marketplace.json              # Marketplace metadata
│   └── plugin.json                   # Plugin manifest (v4.0.3)
├── skills/
│   └── cybersecurity-pro/
│       ├── SKILL.md                  # Skill definition & decision tree (~500 lines)
│       └── references/              # Domain reference files (22 files)
│           ├── ir-playbooks.md              # D1  IR playbook + post-mortem
│           ├── dfir-reports.md              # D2  Forensic report templates
│           ├── devsecops-pipeline.md        # D3  CI/CD security configs
│           ├── soc-operations.md            # D4  SOC L1-L3 + SOAR
│           ├── gitops-security.md           # D5  GitOps security policies
│           ├── code-security-analysis.md    # D6  Semgrep/CodeQL/SARIF
│           ├── container-supply-chain.md    # D7  Container/SBOM/signing
│           ├── compliance-threat-modeling.md # D8  STRIDE/PASTA/Risk
│           ├── compliance-frameworks.md     # D9  NIST 800-53/PCI/GDPR/HIPAA
│           ├── cloud-security-cspm.md       # D10 Cloud/IAM/CSPM
│           ├── zero-trust-architecture.md   # D11 ZTA/NIST 800-207
│           ├── ai-ml-security.md            # D12 AI/ML/LLM Security
│           ├── api-security.md              # D13 OWASP API/JWT/OAuth
│           ├── vulnerability-management.md  # D14 CVSS/EPSS/KEV/Patch
│           ├── threat-intelligence.md       # D15 STIX/TAXII/IOC/MISP
│           ├── cross-domain-integration.md  # D16 End-to-end workflows
│           ├── security-governance-executive.md # D17 CISO/Board/Maturity
│           ├── ot-ics-security.md           # D18 OT/ICS/SCADA/Purdue
│           ├── agentic-ai-security.md       # D19 Agentic AI/Multi-agent
│           ├── post-quantum-cryptography.md # D20 PQC/FIPS 203-205
│           ├── identity-access-security.md  # D21 IAM/FIDO2/ITDR
│           └── web3-blockchain-security.md  # D22 Smart Contract/DeFi
├── frameworks.json                   # Framework version manifest (73 entries)
├── docs/
│   ├── INSTALL.md                    # Installation guide
│   ├── TROUBLESHOOTING.md            # Troubleshooting guide
│   ├── FRAMEWORK-UPDATE-RUNBOOK.md   # Framework update procedures
│   └── MANDAY-ESTIMATION.md          # Man-day cost estimation
├── tests/
│   ├── validate-plugin.sh            # Structural validation (68 checks)
│   ├── check-framework-updates.sh    # Framework staleness checker
│   └── smoke-test-prompts.md         # Manual functional tests (23 scenarios)
├── .github/workflows/
│   ├── validate.yml                  # CI on push/PR
│   └── framework-review.yml         # Quarterly framework review
├── CHANGELOG.md
├── CLAUDE.md
└── README.md                         # This file
```

---

## Plugin Details

| Field           | Value                                     |
| --------------- | ----------------------------------------- |
| **Plugin name** | `cybersecurity-pro`                       |
| **Marketplace** | `pitimon-cybersecurity`                   |
| **Install key** | `cybersecurity-pro@pitimon-cybersecurity` |
| **Version**     | 4.0.3                                     |
| **Category**    | Security                                  |
| **Author**      | P.Itarun                                  |
| **Language**    | Bilingual Thai + English                  |
| **Domains**     | 22                                        |
| **Frameworks**  | 73                                        |
| **License**     | MIT                                       |

---

## Contributing

1. Fork repository
2. สร้าง feature branch (`git checkout -b feat/new-domain`)
3. Commit changes (`git commit -m "feat: add new-domain reference"`)
4. Push branch (`git push origin feat/new-domain`)
5. เปิด Pull Request

### เพิ่ม Domain ใหม่

1. สร้างไฟล์ `skills/cybersecurity-pro/references/<domain-name>.md` ตามรูปแบบ reference files ที่มีอยู่
2. อัพเดท `SKILL.md` — เพิ่ม domain entry + trigger keywords + decision tree branch
3. อัพเดท `README.md` — เพิ่มใน domain table + usage examples
4. อัพเดท `CLAUDE.md` — เพิ่มใน domain table
5. เพิ่ม entry ใน `CHANGELOG.md`
6. หาก domain มี versioned frameworks ใหม่ — เพิ่ม entries ใน `frameworks.json` พร้อม grep patterns และ used_in file lists
7. รัน `bash tests/validate-plugin.sh --skip-install-check` เพื่อตรวจสอบ

---

## Related Plugins

| Plugin                                                            | คำอธิบาย                                                                                                           | Install                                                 |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------- |
| **[shannon-pentest](https://github.com/pitimon/shannon-pentest)** | Autonomous penetration testing orchestrator — configure targets, launch scans, monitor workflows, analyze findings | `claude plugin install shannon-pentest@pitimon-shannon` |

**Complementary workflow**:

```
Shannon (offensive)                    cybersecurity-pro (defensive)
─────────────────                      ──────────────────────────────
ค้นหา vulnerabilities    ──handoff──►   สร้าง remediation plans
สร้าง findings report                  IR playbooks, compliance mapping
export handoff manifest                 executive summary
```

---

## Support

| ช่องทาง            | Link                                                                          |
| ------------------ | ----------------------------------------------------------------------------- |
| Installation Guide | [docs/INSTALL.md](docs/INSTALL.md)                                            |
| Troubleshooting    | [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)                            |
| Changelog          | [CHANGELOG.md](CHANGELOG.md)                                                  |
| Report Issues      | [GitHub Issues](https://github.com/pitimon/claude-cybersecurity-skill/issues) |
| Framework Updates  | [docs/FRAMEWORK-UPDATE-RUNBOOK.md](docs/FRAMEWORK-UPDATE-RUNBOOK.md)          |

**Quick troubleshooting**:

| ปัญหา                                | วิธีแก้                                                           |
| ------------------------------------ | ----------------------------------------------------------------- |
| `claude doctor` แสดง "Invalid input" | ตรวจสอบ `source` ใน `known_marketplaces.json` ต้องเป็น `"github"` |
| Plugin ไม่แสดงหลังติดตั้ง            | ตรวจสอบชื่อ marketplace ใน 3 config files ต้องตรงกัน              |
| Skill ไม่ trigger                    | Restart session (`/clear`) แล้วใช้ trigger keywords               |

---

## License

MIT
