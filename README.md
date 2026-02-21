# cybersecurity-pro

**Professional Cybersecurity Skill for Claude Code** | v3.3.0

สกิลระดับมืออาชีพสำหรับ Cybersecurity Operations — ครอบคลุม 16 domains ตั้งแต่ Incident Response ถึง Cross-Domain Integration พร้อม output แบบ bilingual (Thai + English)

---

## Why This Plugin (ทำไมต้องใช้ Plugin นี้)

**Problem**: Claude Code เป็น general-purpose AI — ไม่มี cybersecurity domain expertise built-in ทำให้ต้องเขียน prompt ละเอียดทุกครั้ง และผลลัพธ์อาจไม่สม่ำเสมอ

**Solution**: `cybersecurity-pro` โหลด professional templates และ framework mappings อัตโนมัติ เมื่อ prompt ตรง trigger keywords

**Value**:

- Output คุณภาพระดับ enterprise ทันที ไม่ต้อง prompt engineer เอง
- Templates map กับ frameworks จริง (NIST, MITRE ATT&CK, OWASP, ISO 27001)
- Bilingual Thai+English — พร้อมใช้ในองค์กรไทย
- On-demand loading — ไม่ overload context, โหลดเฉพาะ domain ที่ต้องการ

---

## How It Works (สถาปัตยกรรม Skill)

```
User prompt → keyword match in SKILL.md frontmatter
  → SKILL.md loaded (~2,400 tokens: language policy, frameworks, decision tree)
  → Decision tree selects domain
  → Corresponding references/*.md loaded on-demand (~3,000-5,000 tokens)
  → Output generated following templates in reference file
```

**On-demand loading**: มี 16 domains แต่โหลดแค่ 1 ต่อ request

| Component                | Tokens       | เมื่อไหร่โหลด (When Loaded)   |
| ------------------------ | ------------ | ----------------------------- |
| SKILL.md (router)        | ~3,200       | ทุก request ที่ trigger skill |
| Reference file (1 of 16) | ~3,000-5,000 | เฉพาะ domain ที่ต้องการ       |
| **Max per request**      | **~8,200**   | **< 5% ของ 200K context**     |

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

เปิด **Claude Code session ใหม่** (หรือพิมพ์ `/clear` เพื่อ reload skills) แล้วพิมพ์ prompt ที่มี trigger keywords:

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
```

```
> สร้าง SOAR playbook สำหรับ automated phishing response
```

```
> สร้าง SOC 2 Type II readiness roadmap 6 เดือน
```

Skill จะถูก trigger อัตโนมัติเมื่อ prompt ตรงกับ keywords ของ domain ใด domain หนึ่ง — ไม่ต้องเรียก skill ด้วยตัวเอง

> ดูคู่มือฉบับเต็ม: [docs/INSTALL.md](docs/INSTALL.md) | สำหรับ air-gapped server ดูหัวข้อ Manual Installation

### อัพเดท Plugin (Update)

เมื่อมี version ใหม่ ให้รันใน **terminal**:

```bash
# 1. อัพเดท marketplace cache
claude plugin marketplace update pitimon-cybersecurity

# 2. ติดตั้ง plugin ใหม่ (overwrite version เก่า)
claude plugin install cybersecurity-pro@pitimon-cybersecurity

# 3. ตรวจสอบ
claude doctor

# 4. Restart Claude Code session เพื่อโหลด skill version ใหม่
```

> สำหรับ air-gapped server ดูขั้นตอน Manual Upgrade ใน [docs/INSTALL.md](docs/INSTALL.md#manual-upgrade-air-gapped)

---

## Capabilities (ความสามารถ — 16 Domains)

### Security Operations

| Domain                      | คำอธิบาย                                                                          | Frameworks                         | Trigger Keywords                                             |
| --------------------------- | --------------------------------------------------------------------------------- | ---------------------------------- | ------------------------------------------------------------ |
| **IR Playbooks & Runbooks** | Incident response playbooks ตาม NIST 800-61 พร้อม SLA, escalation, post-mortem    | NIST SP 800-61, ISO 27035, SANS IR | `incident response`, `IR playbook`, `runbook`, `post-mortem` |
| **DFIR Reports**            | Forensic investigation reports พร้อม chain of custody และ evidence handling       | Chain of Custody, IOC, Timeline    | `forensic`, `investigation`, `evidence`, `DFIR`              |
| **SOC Operations + SOAR**   | SOC L1-L3 procedures, SIEM rules, SOAR automation playbooks, SRE security metrics | MITRE ATT&CK, Cyber Kill Chain     | `SOC`, `triage`, `alert`, `SOAR`, `threat hunting`           |

### Secure Development

| Domain                       | คำอธิบาย                                                                | Frameworks                        | Trigger Keywords                                       |
| ---------------------------- | ----------------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------ |
| **DevSecOps Pipeline**       | CI/CD security pipeline configs สำหรับ GitHub Actions / GitLab CI       | OWASP SAMM, OWASP Top 10, CIS     | `DevSecOps`, `DAST`, `CI/CD security`                  |
| **Code Security Analysis**   | Static analysis ด้วย Semgrep/CodeQL, SARIF processing, variant analysis | CWE Top 25, SARIF 2.1.0           | `Semgrep`, `CodeQL`, `SAST`, `code scan`, `SARIF`      |
| **Container & Supply Chain** | Container hardening, vulnerability scanning, SBOM, image signing        | NIST SP 800-190, CIS Docker, SLSA | `container`, `Docker`, `Trivy`, `SBOM`, `supply chain` |
| **API Security**             | OWASP API Top 10, JWT validation, OAuth 2.0 BCP, API gateway security   | OWASP API Top 10 2023, RFC 9700   | `API security`, `OWASP API`, `BOLA`, `JWT`, `OAuth`    |
| **Vulnerability Management** | Vulnerability lifecycle, CVSS/EPSS/KEV prioritization, patch management | CVSS v4.0, EPSS, CISA KEV, SSVC   | `CVSS`, `EPSS`, `KEV`, `Nessus`, `patch management`    |

### Governance

| Domain                     | คำอธิบาย                                                                        | Frameworks                                         | Trigger Keywords                                                          |
| -------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------- | ------------------------------------------------------------------------- |
| **GitOps Security**        | Policy-as-code frameworks สำหรับ ArgoCD, OPA, Falco                             | OPA/Gatekeeper, Falco, ArgoCD                      | `GitOps`, `ArgoCD`, `policy-as-code`, `OPA`                               |
| **Threat Modeling & Risk** | STRIDE/PASTA threat modeling, risk assessment, SOC 2/ISO 27001 quick references | SOC 2, ISO 27001, STRIDE, PASTA, PDPA              | `threat model`, `STRIDE`, `risk assessment`, `SOC 2`, `ISO 27001`         |
| **Compliance Frameworks**  | Detailed compliance framework assessments, gap analyses, control mappings       | NIST 800-53, PCI DSS v4.0.1, GDPR, HIPAA, CIS v8.1 | `NIST 800-53`, `PCI DSS`, `GDPR`, `HIPAA`, `CIS Controls`, `gap analysis` |

### Cloud & Architecture

| Domain                      | คำอธิบาย                                                                             | Frameworks                                          | Trigger Keywords                                                  |
| --------------------------- | ------------------------------------------------------------------------------------ | --------------------------------------------------- | ----------------------------------------------------------------- |
| **Cloud Security & CSPM**   | Cloud security audits, IAM policy reviews, CSPM configs สำหรับ AWS/Azure/GCP         | CIS Cloud Benchmarks, CSA CCM v4.1, NIST 800-144    | `cloud security`, `CSPM`, `AWS security`, `Prowler`, `ScoutSuite` |
| **Zero Trust Architecture** | Zero Trust maturity assessments, implementation roadmaps, microsegmentation policies | NIST 800-207, CISA ZT Maturity Model, Forrester ZTX | `zero trust`, `ZTA`, `ZTNA`, `NIST 800-207`, `microsegmentation`  |
| **AI/ML Security**          | AI security assessments, LLM guardrails, AI red team playbooks, AI governance        | OWASP LLM Top 10, NIST AI RMF, MITRE ATLAS          | `AI security`, `LLM security`, `prompt injection`, `MITRE ATLAS`  |

### Threat Intelligence

| Domain                  | คำอธิบาย                                                                       | Frameworks                                  | Trigger Keywords                                                 |
| ----------------------- | ------------------------------------------------------------------------------ | ------------------------------------------- | ---------------------------------------------------------------- |
| **Threat Intelligence** | TI program design, STIX/TAXII integration, IOC lifecycle, intelligence sharing | STIX 2.1, TAXII 2.1, TLP 2.0, Diamond Model | `threat intelligence`, `STIX`, `TAXII`, `IOC`, `MISP`, `OpenCTI` |

### Cross-Domain Integration

| Domain                       | คำอธิบาย                                                                              | Frameworks                          | Trigger Keywords                                                         |
| ---------------------------- | ------------------------------------------------------------------------------------- | ----------------------------------- | ------------------------------------------------------------------------ |
| **Cross-Domain Integration** | End-to-end security workflows, SOAR orchestration, multi-domain integration scenarios | NIST CSF 2.0, All domain frameworks | `cross-domain`, `integration`, `end-to-end`, `workflow`, `orchestration` |

### Frameworks & Standards

outputs ทั้งหมดอ้างอิง frameworks เหล่านี้ตามความเหมาะสม:

- **MITRE ATT&CK** / **MITRE D3FEND** — Tactic & Technique mapping
- **NIST SP 800-61 Rev.2** — Incident Response lifecycle
- **NIST CSF 2.0** / **NIST SP 800-190** — Cybersecurity & Container security
- **OWASP Top 10** / **OWASP SAMM** — Application security
- **ISO 27001:2022** / **ISO 27035** — Information security management
- **CWE Top 25** / **SARIF 2.1.0** — Code vulnerability classification
- **CIS Docker Benchmark** / **SLSA** — Container & supply chain
- **NIST SP 800-53 Rev 5** — Security and privacy control catalog
- **SOC 2** / **GDPR** / **HIPAA** / **PCI-DSS** — Compliance frameworks
- **CIS Controls v8.1** — Prioritized security best practices
- **CIS Cloud Benchmarks** / **CSA CCM v4.1** — Cloud security posture
- **NIST SP 800-207** — Zero Trust Architecture
- **CISA Zero Trust Maturity Model** — ZTA implementation guidance
- **OWASP Top 10 for LLM Apps** — AI/LLM application security
- **NIST AI RMF** / **MITRE ATLAS** — AI risk management & threat landscape
- **EU AI Act** / **ISO 42001** — AI governance and regulation
- **OWASP API Security Top 10** — API-specific vulnerability risks
- **CVSS v4.0** / **EPSS** — Vulnerability scoring and exploit prediction
- **CISA KEV** / **SSVC** — Known exploited vulnerabilities and stakeholder prioritization
- **STIX 2.1** / **TAXII 2.1** — Structured threat information expression & sharing
- **Traffic Light Protocol 2.0** — Intelligence sharing classification
- **Diamond Model** — Intrusion analysis framework
- **พ.ร.บ. ไซเบอร์ 2562** / **PDPA** — Thai cybersecurity & data privacy law

---

## Usage Examples (ตัวอย่างการใช้งาน)

ตัวอย่าง prompt ที่พิมพ์ **ใน Claude Code** — skill จะ trigger อัตโนมัติจาก keywords

### IR Playbook

```
> สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
  รวม escalation matrix และ SLA timelines
```

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

### SOC + SOAR

```
> สร้าง SOAR playbook สำหรับ automated phishing response
  รวม enrichment sources และ containment actions
```

### Threat Modeling

```
> สร้าง STRIDE threat model สำหรับ web application
  รวม risk matrix และ SOC 2 compliance mapping
```

### Compliance Frameworks

```
> สร้าง NIST 800-53 gap assessment สำหรับ cloud environment
  พร้อม PCI DSS v4.0 control mapping และ CIS Controls roadmap
```

### Cloud Security

```
> ทำ cloud security audit สำหรับ AWS environment
  ตรวจสอบ IAM policies, S3 buckets, Security Groups ตาม CIS Benchmarks
```

### Zero Trust

```
> สร้าง Zero Trust implementation roadmap ตาม NIST 800-207
  รวม maturity assessment และ microsegmentation plan
```

### AI/ML Security

```
> สร้าง AI security assessment สำหรับ LLM application
  ตรวจสอบ prompt injection defense และ OWASP LLM Top 10 compliance
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

---

## Token Budget & Performance (งบประมาณ Token)

| Component                   | Tokens       | หมายเหตุ                              |
| --------------------------- | ------------ | ------------------------------------- |
| SKILL.md (always loaded)    | ~3,200       | Router + language policy + frameworks |
| Reference file (per domain) | ~3,000-5,000 | โหลดเฉพาะ domain ที่ trigger          |
| **Max per request**         | **~8,200**   | **SKILL.md + 1 reference file**       |
| Total all files             | ~72,000      | ไม่โหลดทั้งหมดพร้อมกัน                |

เปรียบเทียบกับ context window 200K tokens: plugin ใช้ < 5% แม้ request ที่หนักที่สุด

---

## Skill Engineering Techniques (เทคนิคการจัดการ Skill)

เทคนิคที่ใช้ออกแบบ plugin นี้ — เป็นแนวทางสำหรับผู้ที่ต้องการสร้าง Claude Code skill ของตัวเอง:

1. **On-demand reference loading** — ไม่โหลด reference files ทั้งหมดพร้อมกัน โหลดเฉพาะ domain ที่ user ต้องการ ทำให้เพิ่ม domains ได้โดยไม่เพิ่ม base context cost

2. **Composite reference files** — รวม topics ที่เกี่ยวข้องเป็นไฟล์เดียว (เช่น Semgrep + CodeQL + SARIF + Variant Analysis → `code-security-analysis.md`) ลด routing complexity ใน decision tree

3. **Framework-first templates** — Templates map กับ framework controls ไว้แล้ว (NIST, MITRE ATT&CK IDs, CWE) ทำให้ output มี reference ที่ถูกต้องโดยอัตโนมัติ

4. **Bilingual output policy** — Thai prose + English terms ไม่ต้องสร้าง 2 versions แยก ลด overhead และ maintain ง่าย

5. **SKILL.md as compact router** — Decision tree ใน < 300 lines ทำหน้าที่เป็น lightweight router ที่เลือก reference file ที่เหมาะสม

---

## Repository Structure (โครงสร้าง Repository)

```
claude-cybersecurity-skill/
├── .claude-plugin/
│   ├── marketplace.json          # Marketplace metadata
│   └── plugin.json               # Plugin metadata (v3.3.0)
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
│           └── cross-domain-integration.md # End-to-end workflows/orchestration
├── docs/
│   ├── INSTALL.md                # Installation guide
│   └── TROUBLESHOOTING.md       # Troubleshooting guide
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
| **Version**     | 3.3.0                                     |
| **Category**    | Security                                  |
| **Author**      | somapa                                    |
| **Language**    | Bilingual Thai + English                  |
| **Domains**     | 16                                        |

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

---

## Troubleshooting (แก้ไขปัญหา)

| ปัญหา                                | วิธีแก้                                                           |
| ------------------------------------ | ----------------------------------------------------------------- |
| `claude doctor` แสดง "Invalid input" | ตรวจสอบ `source` ใน `known_marketplaces.json` ต้องเป็น `"github"` |
| Plugin ไม่แสดงหลังติดตั้ง            | ตรวจสอบชื่อ marketplace ใน 3 config files ต้องตรงกัน              |
| Skill ไม่ trigger                    | Restart session (`/clear`) แล้วใช้ trigger keywords               |

> ดูคู่มือแก้ไขปัญหาฉบับเต็ม: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## Links

- [Installation Guide](docs/INSTALL.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
- [Changelog](CHANGELOG.md)
- [GitHub Issues](https://github.com/pitimon/claude-cybersecurity-skill/issues)

## License

MIT
