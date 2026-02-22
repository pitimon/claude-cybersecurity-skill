# Threat Modeling & Risk Assessment Reference

คู่มือ Threat Modeling, Risk Assessment และ Compliance Quick References (SOC 2, ISO 27001)

> สำหรับ compliance frameworks เชิงลึก (NIST 800-53, PCI DSS, GDPR, HIPAA, CIS Controls) → ดู references/compliance-frameworks.md
> สำหรับ end-to-end workflow orchestration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 9: Compliance Frameworks → `references/compliance-frameworks.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 17: Security Governance & Executive Leadership → `references/security-governance-executive.md`

## Table of Contents

1. SOC 2 Quick Reference
2. ISO 27001 Quick Reference
3. STRIDE Threat Modeling
4. PASTA & Attack Trees
5. Risk Assessment
6. Thai Legal Context

---

## 1. SOC 2 Quick Reference

### Trust Service Criteria (TSC)

```
1. Security (Common Criteria — จำเป็นสำหรับทุก SOC 2)
   ├── Access controls (logical + physical)
   ├── System operations + change management
   ├── Risk mitigation
   └── Network + data protection

2. Availability (Optional)
   └── Uptime, DR, BCP

3. Processing Integrity (Optional)
   └── Data accuracy, error detection

4. Confidentiality (Optional)
   └── Data classification, secure disposal

5. Privacy (Optional)
   └── PII collection, consent, data subject rights
```

### SOC 2 Readiness Roadmap (6 เดือน)

| ระยะเวลา (Timeline)          | กิจกรรม (Activities)                                                                                                |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **เดือน 6-4 ก่อน audit**     | Scoping: กำหนด in-scope systems, เลือก TSC, engage auditor                                                          |
|                              | Gap Assessment: ตรวจสอบ controls vs SOC 2 requirements                                                              |
|                              | Policy Development: Information Security, Access Control, Change Management, IR, Risk Assessment, Vendor Management |
| **เดือน 4-2 ก่อน audit**     | Control Implementation: MFA, encryption, logging, vulnerability scanning                                            |
|                              | Evidence Preparation: ตั้งระบบ evidence collection อัตโนมัติ                                                        |
| **เดือน 2-0 (Audit Period)** | Observation Period: 3-12 เดือน operate controls consistently                                                        |
|                              | Audit Execution: ส่ง evidence, interviews, respond to findings                                                      |

### SOC 2 Key Control Areas

| Control Area            | ตัวอย่าง Evidence                                     |
| ----------------------- | ----------------------------------------------------- |
| CC6.1 Logical Access    | MFA enrollment report, access review certifications   |
| CC7.2 System Monitoring | SIEM configuration, alert triage records              |
| CC8.1 Change Management | Change request tickets with approval, deployment logs |

---

## 2. ISO 27001 Quick Reference

### PDCA Cycle (Plan-Do-Check-Act)

```
┌─────────────┐     ┌─────────────┐
│   Plan       │ ──▶ │   Do         │
│ ISMS scope   │     │ Implement    │
│ Risk assess  │     │ controls     │
│ SOA          │     │ Training     │
└──────┬──────┘     └──────┬──────┘
       ▲                    ▼
┌──────┴──────┐     ┌──────┴──────┐
│   Act        │ ◀── │   Check      │
│ Corrective   │     │ Internal     │
│ actions      │     │ audit        │
│ Improvement  │     │ Management   │
└─────────────┘     │ review       │
                    └─────────────┘
```

### Annex A Domains (ISO 27001:2022)

| Domain             | คำอธิบาย (Description)            | จำนวน Controls  |
| ------------------ | --------------------------------- | --------------- |
| A.5 Organizational | Policies, roles, responsibilities | 37 controls     |
| A.6 People         | Screening, awareness, terms       | 8 controls      |
| A.7 Physical       | Physical security, equipment      | 14 controls     |
| A.8 Technological  | Access, cryptography, operations  | 34 controls     |
| **Total**          |                                   | **93 controls** |

### Statement of Applicability (SOA) Format

```markdown
| Control ID | Control Name                      | Applicable? | Justification              | Implementation Status |
| ---------- | --------------------------------- | ----------- | -------------------------- | --------------------- |
| A.5.1      | Policies for information security | Yes         | Required by ISMS           | Implemented           |
| A.5.2      | Information security roles        | Yes         | Define ownership           | Implemented           |
| A.7.4      | Physical security monitoring      | No          | Cloud-only, no physical DC | Justified exclusion   |
```

---

## 3. STRIDE Threat Modeling

### STRIDE Categories

```
S - Spoofing Identity
    ปลอมตัวเป็นผู้ใช้/ระบบอื่น
    Mitigation: Strong authentication (MFA), certificate validation

T - Tampering with Data
    แก้ไขข้อมูลโดยไม่ได้รับอนุญาต
    Mitigation: Input validation, encryption, digital signatures

R - Repudiation
    ปฏิเสธว่าไม่ได้ทำ
    Mitigation: Audit logging, digital signatures

I - Information Disclosure
    เปิดเผยข้อมูลที่เป็นความลับ
    Mitigation: Encryption, access controls, DLP

D - Denial of Service
    ทำให้ระบบไม่สามารถใช้งานได้
    Mitigation: Rate limiting, load balancing, DDoS protection

E - Elevation of Privilege
    ได้สิทธิ์เกินที่ควรมี
    Mitigation: Least privilege, input validation, RBAC
```

### STRIDE Process (5 Steps)

**Step 1**: สร้าง Data Flow Diagram (DFD)

```
┌──────────┐     HTTPS      ┌──────────┐     SQL      ┌──────────┐
│   User   │ ──────────────▶│   Web    │ ────────────▶│ Database │
│ (Browser)│                 │  Server  │               │  Server  │
└──────────┘                 └────┬─────┘               └──────────┘
                                  │ HTTPS
                                  ▼
                            ┌──────────┐
                            │   Auth   │
                            │  Service │
                            └──────────┘
```

**Step 2**: ระบุ Trust Boundaries

- ระหว่าง User กับ Web Server (internet)
- ระหว่าง Web Server กับ Database (internal network)
- ระหว่าง Web Server กับ Auth Service

**Step 3**: ใช้ STRIDE กับทุก element และ data flow

**Step 4**: จัดทำ Threat Register

```markdown
| Threat ID | STRIDE | คำอธิบาย (Description)                 | Risk Level | มาตรการ (Mitigation)       | สถานะ (Status) |
| --------- | ------ | -------------------------------------- | ---------- | -------------------------- | -------------- |
| T-001     | S      | Attacker ดัก credentials ระหว่าง login | High       | Implement MFA              | Implemented    |
| T-002     | T      | SQL injection ใน search field          | Critical   | Parameterized queries, WAF | Implemented    |
| T-003     | I      | Database credentials ใน config file    | High       | ใช้ secrets manager        | Pending        |
| T-004     | E      | User escalate เป็น admin               | High       | RBAC, input validation     | Implemented    |
```

**Step 5**: Review และ update เป็นประจำ

---

## 4. PASTA & Attack Trees

### PASTA (Process for Attack Simulation and Threat Analysis)

PASTA เป็น risk-centric threat modeling framework 7 ขั้นตอน:

| Stage                         | คำอธิบาย (Description)                                 |
| ----------------------------- | ------------------------------------------------------ |
| 1. Define Business Objectives | ระบุเป้าหมายทางธุรกิจและ security objectives           |
| 2. Define Technical Scope     | ระบุ software components, infrastructure, actors       |
| 3. Application Decomposition  | สร้าง DFD, ระบุ trust boundaries                       |
| 4. Threat Analysis            | ระบุ threat actors, attack vectors                     |
| 5. Vulnerability Analysis     | Review CVEs, code review findings, pentest results     |
| 6. Attack Modeling            | สร้าง attack trees, simulate attack paths              |
| 7. Risk & Impact Analysis     | คำนวณ risk scores, จัดลำดับ, recommend countermeasures |

### Attack Trees

```
                [Steal Customer Data]
                        │
        ┌───────────────┼───────────────┐
        │               │               │
   [Network Attack]  [App Vuln]    [Physical]
        │               │               │
    ┌───┴───┐       ┌───┴───┐      ┌───┴───┐
  [MITM] [Sniff]  [SQLi]  [XSS] [Steal] [Social
                                  Laptop]  Eng.]

AND node: ทุก children ต้องสำเร็จ
OR node: children ใดก็ได้สำเร็จ (default)
```

สำหรับทุก leaf node ให้ประเมิน:

- **Likelihood**: โอกาสที่จะเกิด (Low/Medium/High)
- **Cost**: ต้นทุนของ attacker (Low/Medium/High)
- **Impact**: ผลกระทบต่อองค์กร (1-10 scale)

---

## 5. Risk Assessment (การประเมินความเสี่ยง)

### 5x5 Risk Matrix

```
Impact ↑
  5 │  5  10  [15] [20] [25]    [25] = Critical: ดำเนินการทันที
  4 │  4   8  [12] [16] [20]    [15-24] = High: ภายใน 30 วัน
  3 │  3   6   9   [12] [15]    [5-14] = Medium: ภายใน 90 วัน
  2 │  2   4   6    8   [10]    [1-4] = Low: monitor and accept
  1 │  1   2   3    4    5
    └──────────────────────→
      1   2   3    4    5   Likelihood

Likelihood: 1=Rare (<5%), 2=Unlikely (5-25%), 3=Possible (25-50%),
            4=Likely (50-75%), 5=Almost Certain (>75%)

Impact: 1=Minimal (<$10K), 2=Minor ($10K-$100K), 3=Moderate ($100K-$1M),
        4=Major ($1M-$10M), 5=Catastrophic (>$10M)
```

### Quantitative Risk Formulas

```
SLE (Single Loss Expectancy) = Asset Value x Exposure Factor
ARO (Annualized Rate of Occurrence) = จำนวนครั้งที่คาดว่าจะเกิดต่อปี
ALE (Annualized Loss Expectancy) = SLE x ARO

ตัวอย่าง:
- Asset Value: $5,000,000 (Customer database)
- Exposure Factor: 0.8 (80% value lost in breach)
- SLE = $5,000,000 x 0.8 = $4,000,000
- ARO = 0.2 (1 breach per 5 years)
- ALE = $4,000,000 x 0.2 = $800,000/year

Cost-Benefit = ALE(before) - ALE(after) - Cost of Control
```

### Risk Register Template

```markdown
| Risk ID | คำอธิบาย (Description) | Likelihood | Impact | Score         | Response                              | Owner    | Status      |
| ------- | ---------------------- | ---------- | ------ | ------------- | ------------------------------------- | -------- | ----------- |
| R-001   | Data breach via SQLi   | 3          | 5      | 15 (Critical) | Mitigate: WAF + parameterized queries | AppSec   | In Progress |
| R-002   | Insider data theft     | 2          | 4      | 8 (Medium)    | Mitigate: DLP + access review         | SecOps   | Planned     |
| R-003   | DDoS on public API     | 4          | 3      | 12 (High)     | Mitigate: CDN + rate limiting         | Platform | Implemented |

Risk Response Options:

- Mitigate: ใช้ controls ลดความเสี่ยง
- Accept: ยอมรับ (ถ้าอยู่ใน risk tolerance)
- Transfer: โอน (เช่น ซื้อ cyber insurance)
- Avoid: หลีกเลี่ยง (ยกเลิกกิจกรรมที่สร้างความเสี่ยง)
```

---

## 6. บริบทกฎหมายไทย (Thai Legal Context)

### พ.ร.บ. การรักษาความมั่นคงปลอดภัยไซเบอร์ พ.ศ. 2562

| ข้อกำหนด      | รายละเอียด                                                                |
| ------------- | ------------------------------------------------------------------------- |
| หน่วยงานกำกับ | สกมช. (NCSA) — สำนักงานคณะกรรมการการรักษาความมั่นคงปลอดภัยไซเบอร์แห่งชาติ |
| ขอบเขต        | องค์กรที่เป็น Critical Information Infrastructure (CII)                   |
| การแจ้งเหตุ   | ต้องแจ้ง สกมช. ภายใน 72 ชั่วโมง สำหรับ Critical incidents ที่กระทบ CII    |
| มาตรฐาน       | ต้องมีมาตรฐานรักษาความมั่นคงปลอดภัยตาม sector-specific guidelines         |

### PDPA (พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562)

| ข้อกำหนด              | รายละเอียด                                                          |
| --------------------- | ------------------------------------------------------------------- |
| หน่วยงานกำกับ         | สคส. (PDPC) — สำนักงานคณะกรรมการคุ้มครองข้อมูลส่วนบุคคล             |
| สิทธิของเจ้าของข้อมูล | เข้าถึง, แก้ไข, ลบ, โอนย้าย, คัดค้าน                                |
| Breach notification   | ต้องแจ้ง สคส. ภายใน 72 ชั่วโมง, แจ้งเจ้าของข้อมูลถ้ามีความเสี่ยงสูง |
| บทลงโทษ               | ปรับสูงสุด 5 ล้านบาท, จำคุกไม่เกิน 1 ปี                             |
