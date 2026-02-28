# Compliance Frameworks Reference

คู่มือ Compliance Frameworks เชิงลึก — NIST 800-53, PCI DSS, GDPR, HIPAA, CIS Controls
พร้อม cross-framework mapping และ implementation templates

> สำหรับ threat modeling (STRIDE, PASTA), risk assessment, SOC 2, ISO 27001 → ดู references/compliance-threat-modeling.md
> สำหรับ end-to-end compliance posture workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 8: Threat Modeling & Risk → `references/compliance-threat-modeling.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 17: Security Governance & Executive Leadership → `references/security-governance-executive.md`
- Domain 20: Post-Quantum Cryptography → `references/post-quantum-cryptography.md`

## Table of Contents

1. Framework Selection Matrix
2. NIST SP 800-53 Rev 5
3. PCI DSS v4.0.1
4. GDPR (General Data Protection Regulation)
5. HIPAA (Health Insurance Portability and Accountability Act)
6. CIS Controls v8
7. Cross-Framework Mapping
8. Compliance Assessment Templates
9. Compliance Cross-Walk Matrix (Framework Mapping)

---

## 1. Framework Selection Matrix (การเลือก Framework เชิงลึก)

```
ต้องการ framework ไหน?

├── Government / Federal (US)
│   ├── Federal agency → NIST 800-53 (จำเป็น, FISMA mandate)
│   ├── Government contractor → NIST 800-53 Moderate baseline
│   ├── Defense / DoD → NIST 800-53 High + CMMC
│   └── State/Local government → NIST 800-53 Low/Moderate
│
├── Healthcare
│   ├── US healthcare provider → HIPAA (จำเป็น)
│   ├── Health tech / SaaS → HIPAA + SOC 2
│   ├── Clinical research → HIPAA + 21 CFR Part 11
│   └── EU healthcare → HIPAA + GDPR
│
├── Payment / Financial
│   ├── รับชำระบัตรเครดิต → PCI DSS v4.0.1 (จำเป็น)
│   ├── Payment processor → PCI DSS Level 1 (QSA audit)
│   ├── E-commerce → PCI DSS + SOC 2
│   └── Fintech → PCI DSS + SOC 2 + ISO 27001
│
├── Data Privacy
│   ├── EU data subjects → GDPR (จำเป็น)
│   ├── Thai data subjects → PDPA
│   ├── California residents → CCPA/CPRA
│   └── Multiple jurisdictions → GDPR as baseline + local laws
│
├── General Security Baseline
│   ├── เริ่มต้นองค์กรเล็ก → CIS Controls IG1 (essential)
│   ├── องค์กรขนาดกลาง → CIS Controls IG2
│   ├── องค์กรขนาดใหญ่ → CIS Controls IG3 + ISO 27001
│   └── Critical infrastructure → NIST 800-53 + CIS Controls
│
└── Multi-Framework Strategy
    ├── Foundation: CIS Controls IG1 → สร้าง security baseline
    ├── Layer 1: NIST 800-53 หรือ ISO 27001 → comprehensive ISMS
    ├── Layer 2: Industry-specific (PCI DSS, HIPAA)
    └── Layer 3: Privacy (GDPR, PDPA, CCPA)
```

### Framework Comparison Summary

| Feature                 | NIST 800-53     | PCI DSS v4.0.1  | GDPR             | HIPAA            | CIS Controls v8.1 |
| ----------------------- | --------------- | --------------- | ---------------- | ---------------- | ----------------- |
| Type                    | Control catalog | Standard        | Regulation       | Regulation       | Best practices    |
| Mandatory for           | US Federal      | Card payments   | EU data          | US healthcare    | Voluntary         |
| Controls/Requirements   | 1,189 controls  | 12 requirements | 99 articles      | 3 safeguard sets | 18 control groups |
| Certification available | FedRAMP         | QSA/SAQ         | No formal cert   | No formal cert   | CIS SecureSuite   |
| Prescriptive level      | High (detailed) | High (specific) | Principles-based | Moderate         | Actionable        |
| Best for                | Comprehensive   | Payment scope   | Privacy-first    | PHI protection   | Quick baseline    |

---

## 2. NIST SP 800-53 Rev 5 (Security and Privacy Controls)

### Overview

NIST SP 800-53 เป็น comprehensive catalog ที่มี 1,189 controls จัดเป็น 20 control families
ใช้เป็น foundation สำหรับ FedRAMP, FISMA, และ federal information systems ทุกประเภท

### 20 Control Families

| ID  | Family Name                              | คำอธิบาย (Description)                             | Controls |
| --- | ---------------------------------------- | -------------------------------------------------- | -------- |
| AC  | Access Control                           | การควบคุมการเข้าถึงระบบและข้อมูล                   | 74       |
| AT  | Awareness and Training                   | การฝึกอบรมและสร้างความตระหนัก                      | 6        |
| AU  | Audit and Accountability                 | การบันทึก log และ audit trail                      | 16       |
| CA  | Assessment, Authorization and Monitoring | การประเมิน, อนุมัติระบบ, และ continuous monitoring | 9        |
| CM  | Configuration Management                 | การจัดการ configuration และ baseline               | 14       |
| CP  | Contingency Planning                     | แผนสำรอง, BCP, DR                                  | 13       |
| IA  | Identification and Authentication        | การยืนยันตัวตนผู้ใช้และ devices                    | 13       |
| IR  | Incident Response                        | การตอบสนองต่อ incidents                            | 10       |
| MA  | Maintenance                              | การดูแลรักษาระบบ                                   | 7        |
| MP  | Media Protection                         | การปกป้อง media (USB, disk, tape)                  | 8        |
| PE  | Physical and Environmental Protection    | ความปลอดภัยทางกายภาพ                               | 23       |
| PL  | Planning                                 | Security planning และ system security plans        | 11       |
| PM  | Program Management                       | การบริหารจัดการ program ระดับ organization         | 32       |
| PS  | Personnel Security                       | ความปลอดภัยด้านบุคลากร                             | 9        |
| PT  | PII Processing and Transparency          | การประมวลผล PII และความโปร่งใส (ใหม่ใน Rev 5)      | 8        |
| RA  | Risk Assessment                          | การประเมินความเสี่ยง                               | 10       |
| SA  | System and Services Acquisition          | การจัดซื้อระบบและบริการ, supply chain              | 23       |
| SC  | System and Communications Protection     | การปกป้องระบบและการสื่อสาร                         | 51       |
| SI  | System and Information Integrity         | ความถูกต้องของระบบและข้อมูล                        | 23       |
| SR  | Supply Chain Risk Management             | การจัดการความเสี่ยง supply chain (ใหม่ใน Rev 5)    | 12       |

### Impact Baselines (Low / Moderate / High)

NIST 800-53 กำหนด control baselines ตาม impact level ของระบบ:

| Impact Level | คำอธิบาย                                  | จำนวน Controls (โดยประมาณ) | ตัวอย่างระบบ                         |
| ------------ | ----------------------------------------- | -------------------------- | ------------------------------------ |
| **Low**      | ผลกระทบจำกัดต่อ operations                | ~170 controls              | Public websites, non-sensitive data  |
| **Moderate** | ผลกระทบร้ายแรงต่อ operations              | ~325 controls              | Financial data, PII, most enterprise |
| **High**     | ผลกระทบรุนแรง/catastrophic ต่อ operations | ~421 controls              | National security, critical infra    |

### Key Control Families Detail

#### AC — Access Control (สำคัญที่สุด, 74 controls)

| Control | ชื่อ                        | Baseline | คำอธิบาย                                        |
| ------- | --------------------------- | -------- | ----------------------------------------------- |
| AC-2    | Account Management          | L/M/H    | จัดการ accounts: สร้าง, enable, disable, remove |
| AC-3    | Access Enforcement          | L/M/H    | บังคับใช้ access policies ที่ approved          |
| AC-5    | Separation of Duties        | M/H      | แยกหน้าที่เพื่อป้องกัน conflict of interest     |
| AC-6    | Least Privilege             | M/H      | ให้สิทธิ์เท่าที่จำเป็น                          |
| AC-7    | Unsuccessful Logon Attempts | L/M/H    | จำกัดจำนวนครั้งที่ login ผิด                    |
| AC-11   | Device Lock                 | M/H      | Lock session หลัง inactivity                    |
| AC-17   | Remote Access               | L/M/H    | ควบคุม remote access ด้วย encryption            |

#### SC — System and Communications Protection (51 controls)

| Control | ชื่อ                              | Baseline | คำอธิบาย                               |
| ------- | --------------------------------- | -------- | -------------------------------------- |
| SC-7    | Boundary Protection               | L/M/H    | Firewall, DMZ, network segmentation    |
| SC-8    | Transmission Confidentiality      | M/H      | Encryption in transit (TLS 1.2+)       |
| SC-12   | Cryptographic Key Management      | L/M/H    | จัดการ cryptographic keys อย่างปลอดภัย |
| SC-13   | Cryptographic Protection          | L/M/H    | ใช้ FIPS-validated cryptography        |
| SC-28   | Protection of Information at Rest | M/H      | Encryption at rest (AES-256)           |

#### SI — System and Information Integrity (23 controls)

| Control | ชื่อ                             | Baseline | คำอธิบาย                                    |
| ------- | -------------------------------- | -------- | ------------------------------------------- |
| SI-2    | Flaw Remediation                 | L/M/H    | Patch management ตาม severity SLA           |
| SI-3    | Malicious Code Protection        | L/M/H    | Anti-malware, EDR, application allowlisting |
| SI-4    | System Monitoring                | L/M/H    | SIEM, IDS/IPS, continuous monitoring        |
| SI-5    | Security Alerts and Advisories   | L/M/H    | ติดตาม security advisories จาก vendors/CERT |
| SI-7    | Software/Firmware/Info Integrity | M/H      | File integrity monitoring (FIM), SBOM       |

#### SR — Supply Chain Risk Management (ใหม่ใน Rev 5, 12 controls)

| Control | ชื่อ                                | Baseline | คำอธิบาย                                            |
| ------- | ----------------------------------- | -------- | --------------------------------------------------- |
| SR-1    | Supply Chain Risk Management Policy | L/M/H    | นโยบาย supply chain risk                            |
| SR-3    | Supply Chain Controls and Processes | M/H      | Controls สำหรับ third-party components              |
| SR-5    | Acquisition Strategies              | M/H      | กลยุทธ์จัดซื้อที่คำนึงถึง supply chain risk         |
| SR-11   | Component Authenticity              | M/H      | ตรวจสอบความถูกต้องของ components (SBOM, provenance) |

### Tailoring Guidance (การปรับแต่ง Baselines)

```markdown
## NIST 800-53 Tailoring Process

### Step 1: เลือก Initial Baseline ตาม Impact Level

- ใช้ FIPS 199 categorize system → Low/Moderate/High

### Step 2: Apply Scoping Guidance

- ตัด controls ที่ไม่เกี่ยวข้อง (เช่น PE controls สำหรับ cloud-only)
- Document justification สำหรับทุก control ที่ตัด

### Step 3: Apply Overlays

- Industry-specific overlays (FedRAMP, DoD, Intelligence)
- Organization-specific requirements

### Step 4: Document ใน System Security Plan (SSP)

- ทุก control ต้องระบุ: Implemented / Planned / Not Applicable
- Not Applicable ต้องมี justification
```

---

## 3. PCI DSS v4.0.1.1 (Payment Card Industry Data Security Standard)

### Overview

PCI DSS v4.0.1.1 เผยแพร่มิถุนายน 2024 (limited revision แก้ไข errata จาก v4.0)
v4.0 retired 31 ธันวาคม 2024 — v4.0.1 เป็น active version เพียงฉบับเดียว
Future-dated requirements มีผลบังคับ 31 มีนาคม 2025

### 12 Requirements

| Req | กลุ่ม                                   | คำอธิบาย (Description)                                               |
| --- | --------------------------------------- | -------------------------------------------------------------------- |
| 1   | Build and Maintain Secure Network       | Install and maintain network security controls                       |
| 2   |                                         | Apply secure configurations to all system components                 |
| 3   | Protect Account Data                    | Protect stored account data (encryption at rest)                     |
| 4   |                                         | Protect cardholder data with strong cryptography during transmission |
| 5   | Maintain a Vulnerability Mgmt Prog      | Protect all systems and networks from malicious software             |
| 6   |                                         | Develop and maintain secure systems and software                     |
| 7   | Implement Access Control Measures       | Restrict access to system components by business need-to-know        |
| 8   |                                         | Identify users and authenticate access to system components          |
| 9   |                                         | Restrict physical access to cardholder data                          |
| 10  | Monitor and Test Networks               | Log and monitor all access to system components and cardholder data  |
| 11  |                                         | Test security of systems and networks regularly                      |
| 12  | Maintain an Information Security Policy | Support information security with organizational policies            |

### Key Changes: v3.2.1 → v4.0

| Area                   | v3.2.1                    | v4.0                                                  |
| ---------------------- | ------------------------- | ----------------------------------------------------- |
| Authentication         | MFA for admin access only | MFA for ALL access to CDE (Req 8.4.2)                 |
| Password requirements  | Min 7 chars, complexity   | Min 12 chars (or 8 if system doesn't support 12)      |
| Targeted risk analysis | Annual risk assessment    | Targeted risk analysis per requirement (Req 12.3.1)   |
| Client-side security   | ไม่มีข้อกำหนดเฉพาะ        | Req 6.4.3: manage payment page scripts                |
| Anti-phishing          | Security awareness only   | Req 5.4.1: anti-phishing mechanisms                   |
| Change detection       | File integrity monitoring | Req 11.6.1: change/tamper detection on payment pages  |
| Customized approach    | ไม่มี                     | Alternative compliance path (ต้อง document objective) |
| Encryption             | TLS 1.1+ allowed          | TLS 1.2+ required (TLS 1.0/1.1 deprecated)            |

### PCI DSS v4.0.1.1 Timeline

```
มี.ค. 2022 ──── PCI DSS v4.0.1 เผยแพร่
มิ.ย. 2024 ──── PCI DSS v4.0.1.1 เผยแพร่ (limited revision, errata fixes)
ธ.ค. 2024 ──── v4.0 retired, v4.0.1 เป็น active version เพียงฉบับเดียว
มี.ค. 2025 ──── Future-dated requirements มีผลบังคับ
                 (Req 5.4.1, 6.4.3, 8.4.2, 11.6.1, 12.3.1 ฯลฯ)
```

### SAQ Decision Tree (Self-Assessment Questionnaire)

```
องค์กรของคุณเป็นแบบไหน?

├── ไม่จัดเก็บ/ประมวลผล/ส่ง cardholder data
│   └── SAQ A (e-commerce redirect, hosted payment page)
│
├── ใช้ payment terminal เท่านั้น (no e-commerce)
│   ├── Connected via IP → SAQ B-IP
│   └── Dial-out terminal → SAQ B
│
├── Virtual payment terminal (web-based)
│   └── SAQ C-VT
│
├── Payment application system (no CDE storage)
│   └── SAQ C
│
├── E-commerce merchant (partial outsource)
│   └── SAQ A-EP
│
├── Service provider with < 300K transactions
│   └── SAQ D for Service Providers
│
└── ทุกกรณีอื่น
    └── SAQ D for Merchants (comprehensive, all requirements)
```

### Top Failed Requirements (จากข้อมูล QSA audits)

| Requirement | คำอธิบาย                                 | สาเหตุที่ fail บ่อย                              |
| ----------- | ---------------------------------------- | ------------------------------------------------ |
| 6.4.3       | Manage payment page scripts              | ไม่มี inventory ของ third-party scripts          |
| 11.6.1      | Change/tamper detection on payment pages | ไม่มี monitoring สำหรับ client-side changes      |
| 8.4.2       | MFA for all CDE access                   | MFA เฉพาะ admin แต่ไม่ครอบคลุมทุก user           |
| 6.2.4       | Software engineering to prevent vulns    | ไม่มี secure coding training                     |
| 12.3.1      | Targeted risk analysis                   | ใช้ generic risk assessment ไม่เฉพาะ per-req     |
| 3.4.1       | Render PAN unreadable when stored        | PAN ใน logs, temp files, or backup ไม่ encrypted |

### Gap Assessment Checklist

```markdown
## PCI DSS v4.0.1 Gap Assessment

### Scope Definition

- [ ] Network diagram แสดง CDE (Cardholder Data Environment)
- [ ] Data flow diagram แสดง cardholder data flows ทั้งหมด
- [ ] Inventory ของ in-scope systems, applications, people
- [ ] Third-party service providers ที่เข้าถึง cardholder data

### High-Priority Checks (Future-Dated Requirements)

- [ ] Req 5.4.1: Anti-phishing mechanisms deployed
- [ ] Req 6.4.3: Payment page script inventory and management
- [ ] Req 8.4.2: MFA for ALL access into CDE
- [ ] Req 11.6.1: Change/tamper detection on payment pages
- [ ] Req 12.3.1: Targeted risk analysis documented per requirement

### Data Protection

- [ ] PAN rendered unreadable everywhere stored (Req 3.4.1)
- [ ] TLS 1.2+ for all cardholder data transmission (Req 4.2.1)
- [ ] No PAN in logs, debug output, temp files
- [ ] Cryptographic key management procedures documented

### Access Control

- [ ] Unique IDs for all users (no shared accounts)
- [ ] MFA for remote access AND CDE access
- [ ] Password minimum 12 characters
- [ ] Access reviews every 6 months

### Monitoring

- [ ] Audit logs for all CDE access (Req 10)
- [ ] Log review daily (automated or manual)
- [ ] File integrity monitoring on critical files
- [ ] IDS/IPS on CDE network perimeter
```

---

## 4. GDPR — General Data Protection Regulation (ฉบับเต็ม)

### 7 Principles (หลักการสำคัญ)

| หลักการ (Principle)                | คำอธิบาย (Description)                  | Article      |
| ---------------------------------- | --------------------------------------- | ------------ |
| Lawfulness, fairness, transparency | ประมวลผลอย่างถูกกฎหมาย เป็นธรรม โปร่งใส | Art. 5(1)(a) |
| Purpose limitation                 | เก็บเฉพาะวัตถุประสงค์ที่แจ้งไว้         | Art. 5(1)(b) |
| Data minimisation                  | เก็บเท่าที่จำเป็น                       | Art. 5(1)(c) |
| Accuracy                           | ข้อมูลต้องถูกต้อง เป็นปัจจุบัน          | Art. 5(1)(d) |
| Storage limitation                 | เก็บไม่นานเกินจำเป็น                    | Art. 5(1)(e) |
| Integrity and confidentiality      | ปกป้องด้วยมาตรการรักษาความปลอดภัย       | Art. 5(1)(f) |
| Accountability                     | พิสูจน์ได้ว่าปฏิบัติตาม                 | Art. 5(2)    |

### 8 Data Subject Rights (สิทธิของเจ้าของข้อมูล)

| Right                        | Article    | คำอธิบาย                                   | SLA           |
| ---------------------------- | ---------- | ------------------------------------------ | ------------- |
| Right to be informed         | Art. 13-14 | แจ้ง data subject ก่อนเก็บข้อมูล           | At collection |
| Right of access              | Art. 15    | เข้าถึงข้อมูลของตนเอง                      | 1 เดือน       |
| Right to rectification       | Art. 16    | แก้ไขข้อมูลที่ไม่ถูกต้อง                   | 1 เดือน       |
| Right to erasure             | Art. 17    | ลบข้อมูล ("right to be forgotten")         | 1 เดือน       |
| Right to restrict processing | Art. 18    | จำกัดการประมวลผล                           | 1 เดือน       |
| Right to data portability    | Art. 20    | โอนย้ายข้อมูลในรูปแบบ machine-readable     | 1 เดือน       |
| Right to object              | Art. 21    | คัดค้านการประมวลผล (รวม direct marketing)  | ทันที         |
| Automated decision-making    | Art. 22    | ไม่ถูก profiling อัตโนมัติที่มีผลทางกฎหมาย | ตาม request   |

### Key Articles Grouped (บทความสำคัญจัดกลุ่ม)

| กลุ่ม                   | Articles   | เนื้อหา                                                 |
| ----------------------- | ---------- | ------------------------------------------------------- |
| Principles & Lawfulness | Art. 5-11  | หลักการ 7 ข้อ, legal bases 6 ประเภท, consent conditions |
| Data Subject Rights     | Art. 12-23 | สิทธิ 8 ประการของ data subjects                         |
| Controller & Processor  | Art. 24-43 | หน้าที่ controller/processor, DPO, DPIA, records        |
| International Transfers | Art. 44-50 | การส่งข้อมูลข้ามประเทศ (SCCs, adequacy, BCRs)           |
| Supervisory Authorities | Art. 51-76 | DPA authorities, cooperation, consistency mechanism     |
| Remedies & Penalties    | Art. 77-84 | สิทธิร้องเรียน, administrative fines                    |

### Legal Bases for Processing

| Legal Basis          | ใช้เมื่อ (Use When)                                 | ตัวอย่าง                           |
| -------------------- | --------------------------------------------------- | ---------------------------------- |
| Consent              | ขอ consent ชัดเจน, ถอนได้                           | Marketing emails, cookies          |
| Contract             | จำเป็นต่อการทำสัญญา                                 | Shipping address for delivery      |
| Legal obligation     | กฎหมายบังคับ                                        | Tax reporting, AML compliance      |
| Vital interests      | จำเป็นต่อชีวิต                                      | Medical emergency processing       |
| Public interest      | ภารกิจสาธารณะ                                       | Public health, archiving           |
| Legitimate interests | ประโยชน์โดยชอบ (ต้อง balance กับสิทธิ data subject) | Fraud prevention, network security |

### DPIA Process (Data Protection Impact Assessment)

ต้องทำ DPIA เมื่อ:

- Automated decision-making / profiling
- Large-scale processing of special category data
- Systematic monitoring of public area
- New technologies ที่มีความเสี่ยงสูง

```markdown
## DPIA Template

### 1. คำอธิบายการประมวลผล (Processing Description)

- วัตถุประสงค์: [purpose]
- ข้อมูลที่ประมวลผล: [data categories]
- Data subjects: [who]
- Retention period: [how long]
- Recipients: [who receives the data]

### 2. ความจำเป็นและสัดส่วน (Necessity & Proportionality)

- Legal basis: [basis + justification]
- Data minimization measures: [measures]
- Purpose limitation controls: [controls]

### 3. การประเมินความเสี่ยง (Risk Assessment)

| ความเสี่ยง (Risk)   | โอกาส (Likelihood) | ผลกระทบ (Impact) | มาตรการ (Mitigation) |
| ------------------- | ------------------ | ---------------- | -------------------- |
| Unauthorized access | Medium             | High             | Encryption + MFA     |
| Data loss           | Low                | High             | Backup + DR plan     |
| Purpose creep       | Medium             | Medium           | Access controls      |

### 4. มาตรการรักษาความปลอดภัย (Security Measures)

- Technical: [encryption, access controls, pseudonymization]
- Organizational: [policies, training, DPO oversight]

### 5. DPO Opinion

- [DPO assessment and recommendations]

### 6. Decision

- [ ] Processing may proceed with mitigations
- [ ] Consult supervisory authority (Art. 36)
- [ ] Processing should not proceed
```

### Breach Notification — กฎ 72 ชั่วโมง

| ขั้นตอน                    | Timeline              | ต้องแจ้งใคร               | เนื้อหาที่ต้องแจ้ง                                                                       |
| -------------------------- | --------------------- | ------------------------- | ---------------------------------------------------------------------------------------- |
| แจ้ง Supervisory Authority | ภายใน 72 ชม.          | Data Protection Authority | Nature of breach, categories/numbers affected, DPO contact, consequences, measures taken |
| แจ้ง Data Subjects         | "without undue delay" | บุคคลที่ได้รับผลกระทบ     | Nature of breach, DPO contact, consequences, measures taken/proposed                     |
| Document internally        | ทันที                 | Internal records          | ทุก breach รวมทั้งที่ไม่ต้องแจ้ง (Art. 33(5))                                            |

### Common GDPR Violations & Fines

| Violation                       | Max Fine                     | ตัวอย่างจริง                              |
| ------------------------------- | ---------------------------- | ----------------------------------------- |
| Insufficient legal basis        | 4% annual turnover หรือ €20M | Meta: €1.2B (2023, data transfers)        |
| Insufficient consent            | 4% annual turnover หรือ €20M | Google: €150M (2022, cookie consent)      |
| Insufficient technical measures | 2% annual turnover หรือ €10M | British Airways: €22M (2020, data breach) |
| Failure to notify breach        | 2% annual turnover หรือ €10M | Multiple DPAs, typically €50K-€500K       |
| No DPO when required            | 2% annual turnover หรือ €10M | Various smaller fines                     |

---

## 5. HIPAA — Health Insurance Portability and Accountability Act (ฉบับเต็ม)

### Overview

HIPAA ปกป้อง Protected Health Information (PHI) ครอบคลุม covered entities (healthcare providers, health plans, clearinghouses) และ business associates

### Administrative Safeguards (§164.308) — 7 Areas

| Standard                         | คำอธิบาย                                                      | Required/Addressable   |
| -------------------------------- | ------------------------------------------------------------- | ---------------------- |
| Security Management Process      | Risk analysis, risk management, sanctions, info system review | Required               |
| Assigned Security Responsibility | กำหนด Security Officer                                        | Required               |
| Workforce Security               | Authorization/supervision, termination, clearance procedures  | Addressable            |
| Information Access Management    | Access authorization, establishment, modification             | Required + Addressable |
| Security Awareness and Training  | Security reminders, malware protection, login monitoring      | Addressable            |
| Security Incident Procedures     | Response and reporting procedures                             | Required               |
| Contingency Plan                 | Data backup, DR plan, emergency mode, testing, criticality    | Required + Addressable |

### Physical Safeguards (§164.310) — 3 Areas

| Standard                  | คำอธิบาย                                                       | Required/Addressable   |
| ------------------------- | -------------------------------------------------------------- | ---------------------- |
| Facility Access Controls  | Contingency operations, facility security plan, access control | Addressable            |
| Workstation Use           | Policies for workstation use                                   | Required               |
| Workstation Security      | Physical safeguards for workstations                           | Required               |
| Device and Media Controls | Disposal, media re-use, accountability, data backup/storage    | Required + Addressable |

### Technical Safeguards (§164.312) — 5 Areas

| Standard                        | คำอธิบาย                                                  | Required/Addressable   |
| ------------------------------- | --------------------------------------------------------- | ---------------------- |
| Access Control                  | Unique user ID, emergency access, auto-logoff, encryption | Required + Addressable |
| Audit Controls                  | Hardware/software/procedural audit mechanisms             | Required               |
| Integrity                       | Mechanisms to authenticate ePHI hasn't been altered       | Addressable            |
| Person or Entity Authentication | Verify identity of person/entity seeking access           | Required               |
| Transmission Security           | Integrity controls, encryption of ePHI in transit         | Addressable            |

### HIPAA Breach Notification Rules

| Breach Size          | แจ้ง Individuals             | แจ้ง HHS                             | แจ้ง Media                     |
| -------------------- | ---------------------------- | ------------------------------------ | ------------------------------ |
| < 500 individuals    | ภายใน 60 วัน                 | Annual log (ภายใน 60 วัน หลังสิ้นปี) | ไม่ต้อง                        |
| ≥ 500 individuals    | ภายใน 60 วัน                 | ภายใน 60 วัน                         | ภายใน 60 วัน (prominent media) |
| Unsecured PHI breach | "without unreasonable delay" | ตาม size                             | ตาม size                       |

### Common HIPAA Violations

| Violation                              | Typical Penalty            | ตัวอย่าง                               |
| -------------------------------------- | -------------------------- | -------------------------------------- |
| No risk analysis conducted             | $100K - $2M                | หลาย covered entities ถูกปรับจากข้อนี้ |
| No BAA (Business Associate Agreement)  | $50K - $1.5M               | Sharing PHI without proper BAA         |
| Insufficient access controls           | $100K - $3M                | Excess access to patient records       |
| Failure to encrypt ePHI                | $100K - $5.5M              | Lost/stolen unencrypted devices        |
| Impermissible disclosures              | $50K - $1.5M per violation | Sharing PHI beyond minimum necessary   |
| Failure to provide breach notification | $100K - $1.5M              | Late or missing notifications          |

### HIPAA Compliance Checklist

```markdown
## HIPAA Compliance Assessment

### Administrative Safeguards

- [ ] Risk Analysis completed and documented (annual)
- [ ] Risk Management plan with remediation timeline
- [ ] Security Officer designated
- [ ] Workforce security procedures (onboarding/offboarding)
- [ ] Security awareness training (annual, with phishing simulation)
- [ ] Incident response procedures documented and tested
- [ ] Contingency plan: backup, DR, emergency mode procedures
- [ ] BAAs in place with ALL business associates

### Physical Safeguards

- [ ] Facility access controls (badge, biometric)
- [ ] Workstation use policies (clean desk, screen lock)
- [ ] Device disposal procedures (NIST 800-88 media sanitization)
- [ ] Visitor policies and access logs

### Technical Safeguards

- [ ] Unique user identification (no shared accounts)
- [ ] Automatic session timeout (15 min or per policy)
- [ ] Encryption at rest (AES-256 for ePHI)
- [ ] Encryption in transit (TLS 1.2+ for all ePHI transmission)
- [ ] Audit logging enabled for all ePHI access
- [ ] Integrity controls (hashing, digital signatures)
- [ ] MFA for remote access to ePHI systems

### Organizational Requirements

- [ ] Privacy policies posted and accessible
- [ ] Notice of Privacy Practices (NPP) provided to patients
- [ ] Minimum Necessary standard applied
- [ ] Right of access honored within 30 days
- [ ] Breach notification procedures tested
```

---

## 6. CIS Controls v8.1 (Center for Internet Security)

### Overview

CIS Controls v8.1 (มิถุนายน 2024) มี 18 control groups จัดกลุ่มเป็น 3 Implementation Groups (IG)
อัปเดตจาก v8.0 ด้วย alignment กับ NIST CSF 2.0, revised asset classes, และ expanded glossary
ออกแบบให้ actionable — บอกชัดเจนว่าต้องทำอะไร ต่างจาก NIST 800-53 ที่เป็น comprehensive catalog

### 18 Control Groups

| CIS # | Control Group                               | IG1 | IG2 | IG3 | Safeguards |
| ----- | ------------------------------------------- | --- | --- | --- | ---------- |
| 1     | Inventory and Control of Enterprise Assets  | Y   | Y   | Y   | 5          |
| 2     | Inventory and Control of Software Assets    | Y   | Y   | Y   | 7          |
| 3     | Data Protection                             | Y   | Y   | Y   | 14         |
| 4     | Secure Configuration of Assets and Software | Y   | Y   | Y   | 12         |
| 5     | Account Management                          | Y   | Y   | Y   | 6          |
| 6     | Access Control Management                   | Y   | Y   | Y   | 8          |
| 7     | Continuous Vulnerability Management         | Y   | Y   | Y   | 7          |
| 8     | Audit Log Management                        | Y   | Y   | Y   | 12         |
| 9     | Email and Web Browser Protections           | Y   | Y   | Y   | 7          |
| 10    | Malware Defenses                            | Y   | Y   | Y   | 7          |
| 11    | Data Recovery                               | Y   | Y   | Y   | 5          |
| 12    | Network Infrastructure Management           |     | Y   | Y   | 8          |
| 13    | Network Monitoring and Defense              |     | Y   | Y   | 11         |
| 14    | Security Awareness and Skills Training      | Y   | Y   | Y   | 9          |
| 15    | Service Provider Management                 |     | Y   | Y   | 7          |
| 16    | Application Software Security               |     | Y   | Y   | 14         |
| 17    | Incident Response Management                | Y   | Y   | Y   | 9          |
| 18    | Penetration Testing                         |     | Y   | Y   | 5          |

### Implementation Groups (IGs)

| IG        | เหมาะกับ                                             | Safeguard Count            | คำอธิบาย                                               |
| --------- | ---------------------------------------------------- | -------------------------- | ------------------------------------------------------ |
| IG1       | องค์กรเล็ก, IT จำกัด, ข้อมูล sensitivity ต่ำ         | 56 safeguards              | Essential cyber hygiene — สิ่งที่ทุกองค์กรต้องมี       |
| IG2       | องค์กรที่มี IT team, ข้อมูล sensitivity ปานกลาง      | 74 safeguards (IG1 + 74)   | Extended hygiene — เพิ่ม monitoring, incident response |
| IG3       | องค์กรใหญ่, ข้อมูล sensitivity สูง, มี security team | 23 safeguards (IG1+IG2+23) | Advanced — penetration testing, advanced defenses      |
| **Total** |                                                      | **153 safeguards**         |                                                        |

### CIS Controls vs CIS Benchmarks — ความแตกต่าง

| Feature   | CIS Controls                     | CIS Benchmarks                           |
| --------- | -------------------------------- | ---------------------------------------- |
| ระดับ     | Organization-level               | System/platform-level                    |
| เนื้อหา   | "What to do" — 18 control groups | "How to configure" — specific settings   |
| ตัวอย่าง  | "Manage audit logs" (Control 8)  | "Set MaxAuthTries 4 in sshd_config"      |
| แพลตฟอร์ม | Platform-agnostic                | Specific (Windows, Linux, Docker, K8s)   |
| ใช้คู่กัน | เลือก controls ที่ต้อง implement | ใช้ benchmark configurations ของแต่ละ OS |

### Implementation Roadmap

```
Phase 1: Essential Hygiene (IG1) — เดือน 1-3
├── CIS 1: Asset inventory (hardware + cloud)
├── CIS 2: Software inventory + allowlist
├── CIS 3: Data classification + protection basics
├── CIS 4: Secure configurations (CIS Benchmarks)
├── CIS 5: Account management + offboarding
├── CIS 6: Access control + MFA
├── CIS 7: Vulnerability scanning (monthly)
├── CIS 8: Audit logging enabled
├── CIS 9: Email + browser protections
├── CIS 10: Anti-malware / EDR
├── CIS 11: Backup + tested recovery
├── CIS 14: Security awareness training
└── CIS 17: Incident response plan

Phase 2: Extended Hygiene (IG2) — เดือน 4-8
├── CIS 12: Network segmentation + management
├── CIS 13: Network monitoring (IDS/IPS, NetFlow)
├── CIS 15: Service provider management + SLA
├── CIS 16: Application security (SAST, DAST)
└── CIS 18: Penetration testing (internal scope)

Phase 3: Advanced (IG3) — เดือน 9-12
├── Advanced threat detection (EDR + behavioral)
├── Full penetration testing (external + internal)
├── Red team / purple team exercises
├── Advanced data loss prevention
└── Continuous improvement and metrics
```

### CIS v8.1 Asset Class Mapping

CIS Controls v8.1 กำหนด 5 asset classes สำหรับ scope controls ให้เหมาะสมกับ asset type:

| Asset Class  | คำอธิบาย                                  | Key Controls                                                    | OT Relevance                               |
| ------------ | ----------------------------------------- | --------------------------------------------------------------- | ------------------------------------------ |
| **Devices**  | Hardware assets ทั้ง physical และ virtual | CIS 1 (inventory), CIS 4 (secure config), CIS 10 (malware)      | PLCs, RTUs, HMIs, SCADA servers            |
| **Software** | Applications, OS, firmware                | CIS 2 (software inventory), CIS 7 (vuln mgmt), CIS 16 (appsec)  | SCADA software, PLC firmware               |
| **Data**     | ข้อมูลทุกรูปแบบ                           | CIS 3 (data protection), CIS 11 (recovery)                      | Process data, historian data, PLC programs |
| **Users**    | Accounts, identities, privileges          | CIS 5 (account mgmt), CIS 6 (access control), CIS 14 (training) | Operators, engineers, admin accounts       |
| **Network**  | Network infrastructure                    | CIS 12 (network mgmt), CIS 13 (monitoring)                      | IT/OT segmentation, industrial protocols   |

> สำหรับ OT/ICS-specific asset inventory → ดู references/ot-ics-security.md (Domain 18)
> CIS Controls ใช้ได้กับ OT โดยเพิ่ม fields สำหรับ firmware version, Purdue level, safety classification

---

## 7. Cross-Framework Mapping (ตาราง Mapping ข้าม Framework)

ใช้ตารางนี้เพื่อ map controls ระหว่าง frameworks — ลดงานซ้ำเมื่อองค์กรต้อง comply หลาย frameworks

| Control Area           | NIST 800-53         | PCI DSS v4.0.1 | GDPR           | HIPAA              | CIS Controls v8.1 |
| ---------------------- | ------------------- | -------------- | -------------- | ------------------ | ----------------- |
| **Access Control**     | AC-2, AC-3, AC-6    | Req 7, 8       | Art. 32        | §164.312(a)        | CIS 5, 6          |
| **Encryption**         | SC-8, SC-12, SC-28  | Req 3, 4       | Art. 32        | §164.312(a)(2)(iv) | CIS 3.6-3.11      |
| **Audit Logging**      | AU-2, AU-3, AU-6    | Req 10         | Art. 30        | §164.312(b)        | CIS 8             |
| **Vuln Management**    | SI-2, RA-5          | Req 5, 6, 11   | Art. 32        | §164.308(a)(1)     | CIS 7, 16         |
| **Incident Response**  | IR-1 through IR-8   | Req 12.10      | Art. 33, 34    | §164.308(a)(6)     | CIS 17            |
| **Risk Assessment**    | RA-1 through RA-5   | Req 12.3.1     | Art. 35 (DPIA) | §164.308(a)(1)(ii) | CIS 1, 2          |
| **Asset Management**   | CM-8, PM-5          | Req 2, 12.5.1  | Art. 30        | §164.310(d)        | CIS 1, 2          |
| **Personnel Security** | PS-1 through PS-8   | Req 12.6       | Art. 39        | §164.308(a)(3-4)   | CIS 14            |
| **Vendor Management**  | SA-9, SR-1 to SR-6  | Req 12.8, 12.9 | Art. 28        | §164.308(b)(1)     | CIS 15            |
| **Data Protection**    | MP-2 to MP-7, SC-28 | Req 3, 9       | Art. 5, 25, 32 | §164.312(c-e)      | CIS 3             |

### วิธีใช้ Cross-Framework Mapping

1. **เลือก primary framework** ตาม regulatory requirement
2. **Map controls** ที่ implement แล้วไปยัง frameworks อื่น — identify overlaps
3. **Gap analysis**: controls ที่ยังไม่ครอบคลุมใน secondary frameworks
4. **Prioritize gaps** ตาม risk และ regulatory deadline
5. **Single control, multiple frameworks**: implement ครั้งเดียว, document mapping

---

## 8. Compliance Assessment Templates (แม่แบบการประเมิน)

### Universal Compliance Readiness Template

```markdown
## Compliance Readiness Assessment: [Framework Name]

### Assessment Information

- **Organization**: [name]
- **Assessment Date**: [date]
- **Assessor**: [name/team]
- **Scope**: [systems, departments, data types in scope]
- **Target Framework**: [NIST 800-53 / PCI DSS v4.0.1 / GDPR / HIPAA / CIS v8]

### Executive Summary

- **Overall Readiness Score**: [X]% (controls implemented / total controls)
- **Critical Gaps**: [count]
- **High Gaps**: [count]
- **Estimated Remediation Time**: [X months]

### Control Assessment Matrix

| Control ID | Control Name | Status                              | Gap Description | Priority             | Remediation Owner | Target Date |
| ---------- | ------------ | ----------------------------------- | --------------- | -------------------- | ----------------- | ----------- |
| [ID]       | [name]       | Implemented/Partial/Not Implemented | [gap detail]    | Critical/High/Medium | [owner]           | [date]      |

### Risk Summary

| Risk Area      | Current State   | Target State | Gap Level |
| -------------- | --------------- | ------------ | --------- |
| Access Control | Partial         | Full         | Medium    |
| Encryption     | Implemented     | Implemented  | None      |
| Audit Logging  | Not Implemented | Full         | Critical  |

### Remediation Roadmap

| Phase   | Timeline  | Activities                       | Resources Required |
| ------- | --------- | -------------------------------- | ------------------ |
| Phase 1 | เดือน 1-2 | Address Critical gaps            | [resources]        |
| Phase 2 | เดือน 3-4 | Address High gaps                | [resources]        |
| Phase 3 | เดือน 5-6 | Address Medium gaps + validation | [resources]        |

### Sign-Off

- [ ] CISO / Security Leader approval
- [ ] Business Owner acknowledgment
- [ ] Remediation budget approved
```

### Evidence Collection Plan

| Evidence Type             | Source                          | Collection Method       | Frequency    | Owner       |
| ------------------------- | ------------------------------- | ----------------------- | ------------ | ----------- |
| Access reviews            | IAM system, AD/LDAP             | Export access reports   | Quarterly    | IT Security |
| Vulnerability scans       | Scanner (Nessus, Qualys, Trivy) | Automated scan exports  | Monthly      | SecOps      |
| Configuration baselines   | CM tools (Ansible, Terraform)   | Config drift reports    | Weekly       | Platform    |
| Audit logs                | SIEM (Splunk, Elastic)          | Log export/dashboard    | Continuous   | SOC         |
| Training records          | LMS platform                    | Completion reports      | Annual       | HR/Security |
| Incident reports          | Ticketing system (Jira, SNOW)   | Incident report export  | Per incident | IR team     |
| Penetration test reports  | Third-party / internal team     | Report delivery         | Annual       | Security    |
| Policy documents          | Document management system      | Version control export  | Per change   | GRC         |
| BAA / vendor agreements   | Contract management             | Agreement copies        | Per vendor   | Legal       |
| Change management records | Ticketing system                | Approved change tickets | Per change   | IT Ops      |

### Compliance Metrics Dashboard

| Metric                        | Formula                                        | เป้าหมาย (Target) | Frequency   |
| ----------------------------- | ---------------------------------------------- | ----------------- | ----------- |
| Control Implementation Rate   | Controls Implemented / Total Controls x 100    | > 95%             | Monthly     |
| Audit Finding Closure Rate    | Findings Closed on Time / Total Findings x 100 | > 90%             | Monthly     |
| Policy Acknowledgment Rate    | Employees Acknowledged / Total Employees x 100 | 100%              | Quarterly   |
| Training Completion Rate      | Trained Employees / Total Employees x 100      | > 95%             | Annual      |
| Mean Time to Remediate (MTTR) | Sum(Remediation Time) / Count(Findings)        | Critical: <48h    | Per finding |
| Compliance Score by Framework | Weighted score across all control areas        | > 90%             | Quarterly   |
| Exception/Waiver Count        | Active exceptions + waivers                    | < 5               | Monthly     |
| Third-Party Risk Score        | Average vendor security rating                 | > 80/100          | Quarterly   |

---

## 9. Compliance Cross-Walk Matrix (Framework Mapping)

ตาราง mapping ระหว่าง 5 frameworks หลัก — ใช้เมื่อองค์กรต้อง comply กับหลาย frameworks พร้อมกัน
ช่วยลด duplicate effort โดย map control areas ข้ามกัน

> สำหรับ Encryption & Key Mgmt row → ดู references/post-quantum-cryptography.md (Domain 20) สำหรับ post-quantum migration roadmap

### Cross-Walk Table (20 Control Areas)

| Control Area              | NIST 800-53 Rev 5 | ISO 27001:2022 | CIS v8.1  | SOC 2        | PCI DSS v4.0.1  |
| ------------------------- | ----------------- | -------------- | --------- | ------------ | --------------- |
| Access Control            | AC-1 to AC-25     | A.5.15-A.5.18  | CIS 5, 6  | CC6.1-CC6.3  | Req 7, 8        |
| Audit & Accountability    | AU-1 to AU-16     | A.8.15         | CIS 8     | CC7.1-CC7.4  | Req 10          |
| Risk Assessment           | RA-1 to RA-7      | A.5.1, A.8.8   | —         | CC3.1-CC3.4  | Req 6.3, 12.3.2 |
| Incident Response         | IR-1 to IR-10     | A.5.24-A.5.28  | CIS 17    | CC7.3-CC7.5  | Req 12.10       |
| Configuration Management  | CM-1 to CM-14     | A.8.9          | CIS 4     | CC8.1        | Req 2, 6.3      |
| Identification & Auth     | IA-1 to IA-12     | A.5.16-A.5.17  | CIS 5, 6  | CC6.1        | Req 8           |
| System & Comms Protection | SC-1 to SC-45     | A.8.20-A.8.24  | CIS 3     | CC6.6-CC6.8  | Req 4           |
| Personnel Security        | PS-1 to PS-9      | A.6.1-A.6.6    | —         | CC1.4        | Req 12.6        |
| Physical Protection       | PE-1 to PE-23     | A.7.1-A.7.14   | —         | CC6.4-CC6.5  | Req 9           |
| System & Info Integrity   | SI-1 to SI-20     | A.8.25-A.8.34  | CIS 7, 10 | CC7.1-CC7.2  | Req 5, 6, 11    |
| Awareness & Training      | AT-1 to AT-6      | A.6.3          | CIS 14    | CC1.4        | Req 12.6        |
| Contingency Planning      | CP-1 to CP-13     | A.5.29-A.5.30  | CIS 11    | A1.1-A1.3    | Req 12.10       |
| Media Protection          | MP-1 to MP-8      | A.7.10, A.8.10 | CIS 3     | CC6.7        | Req 3, 9.4      |
| Planning                  | PL-1 to PL-11     | A.5.1          | —         | CC3.1        | Req 12.1        |
| Program Management        | PM-1 to PM-32     | A.5.2-A.5.4    | —         | CC1.1-CC1.2  | Req 12          |
| Supply Chain Risk Mgmt    | SR-1 to SR-12     | A.5.19-A.5.23  | CIS 15    | CC9.1-CC9.2  | Req 12.8        |
| Data Classification       | RA-2, SC-16       | A.5.12-A.5.14  | CIS 3     | CC6.1        | Req 3           |
| Vulnerability Management  | RA-5, SI-2        | A.8.8          | CIS 7     | CC7.1        | Req 6, 11       |
| Encryption & Key Mgmt     | SC-12, SC-13      | A.8.24         | CIS 3     | CC6.1, CC6.7 | Req 3, 4        |
| Logging & Monitoring      | AU-2, AU-6, SI-4  | A.8.15-A.8.16  | CIS 8     | CC7.2-CC7.3  | Req 10          |

### How to Use This Matrix

1. **Gap Analysis**: ระบุ framework หลักที่องค์กรต้อง comply → ใช้ matrix เพื่อ map controls
2. **Control Consolidation**: สำหรับ control areas ที่ overlap → implement ครั้งเดียว collect evidence ครั้งเดียว
3. **Audit Preparation**: ใช้ matrix เพื่อเตรียม evidence mapping สำหรับ multi-framework audits
4. **Priority**: เริ่มจาก control areas ที่ appear ในทุก frameworks (Access Control, Audit, Incident Response)

### Thai Compliance Integration

| Thai Requirement                      | Maps To                                            |
| ------------------------------------- | -------------------------------------------------- |
| PDPA (พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล) | ISO 27001 A.5.34, NIST 800-53 SI-12, PCI DSS Req 3 |
| พ.ร.บ. ไซเบอร์ 2562                   | NIST 800-53 IR family, ISO A.5.24-A.5.28, CIS 17   |
| พ.ร.บ. คอมพิวเตอร์ 2560               | NIST 800-53 AU family, ISO A.8.15                  |
| BoT IT Risk Guidelines                | NIST 800-53 RA, CM, SC families, PCI DSS           |
