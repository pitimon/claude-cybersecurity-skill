# Security Governance & Executive Leadership

ธรรมาภิบาลด้านความปลอดภัยไซเบอร์ระดับผู้บริหาร — ครอบคลุมโครงสร้างการกำกับดูแล (Governance),
บทบาท C-suite (CISO, CAIO, CAISO), กรอบความพร้อมของคณะกรรมการ (Board Reporting),
แบบจำลองวุฒิภาวะ (Maturity Models), และการกำกับดูแล AI ระดับองค์กร

> **Scope note**: Domain 17 ครอบคลุม executive/organizational governance — "who decides" and "why"
> สำหรับ technical controls ดู Domain-specific references (D1-D16)
> สำหรับ AI technical security → ดู references/ai-ml-security.md (Domain 12)
> สำหรับ operational compliance frameworks → ดู references/compliance-frameworks.md (Domain 9)
> สำหรับ end-to-end workflow orchestration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 8: Threat Modeling & Risk → `references/compliance-threat-modeling.md`
- Domain 9: Compliance Frameworks → `references/compliance-frameworks.md`
- Domain 12: AI/ML Security → `references/ai-ml-security.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 21: Identity & Access Security → `references/identity-access-security.md`

---

## Table of Contents

1. [Security Governance Landscape & Role Architecture](#1-security-governance-landscape--role-architecture)
2. [NIST CSF 2.0 GOVERN Function (GV)](#2-nist-csf-20-govern-function-gv)
3. [ISO 27014:2020 — Information Security Governance](#3-iso-270142020--information-security-governance)
4. [Security Maturity Models](#4-security-maturity-models)
5. [Executive Roles: CISO, CAIO, CAISO](#5-executive-roles-ciso-caio-caiso)
6. [Board Reporting & SEC Disclosure](#6-board-reporting--sec-disclosure)
7. [AI Governance at Executive Level](#7-ai-governance-at-executive-level)
8. [Governance Program Implementation Roadmap](#8-governance-program-implementation-roadmap)
9. [Framework References & Governance Checklist](#9-framework-references--governance-checklist)
10. [Cyber Resilience Metrics (Prevention → Resilience Shift)](#10-cyber-resilience-metrics-prevention--resilience-shift)
11. [Security Workforce Development](#11-security-workforce-development)

---

## 1. Security Governance Landscape & Role Architecture

### 1.1 Governance vs Management (ธรรมาภิบาล vs การจัดการ)

| Dimension          | Governance (ธรรมาภิบาล)              | Management (การจัดการ)               |
| ------------------ | ------------------------------------ | ------------------------------------ |
| **Focus**          | Direction, oversight, accountability | Planning, execution, operations      |
| **Who**            | Board, C-suite, committees           | CISO, security team, SOC analysts    |
| **Question**       | "Are we doing the right things?"     | "Are we doing things right?"         |
| **Framework**      | NIST CSF 2.0 GOVERN, ISO 27014       | NIST 800-53, ISO 27001 Annex A       |
| **Output**         | Policies, risk appetite, budget      | Controls, procedures, configurations |
| **Accountability** | Fiduciary, regulatory, shareholders  | Operational, SLA, incident metrics   |

### 1.2 Governance Hierarchy (โครงสร้างลำดับชั้นธรรมาภิบาล)

```
┌─────────────────────────────────────────────────────────────────┐
│                     BOARD OF DIRECTORS                          │
│   Risk Committee │ Audit Committee │ Technology/Cyber Committee │
├─────────────────────────────────────────────────────────────────┤
│                     C-SUITE LAYER                               │
│       CEO ──── CISO ──── CIO ──── CAIO ──── CAISO              │
│              │          │        │          │                   │
│         Security    IT Infra   AI Strategy  AI Security         │
│         Program     Operations  & Ethics    Convergence         │
├─────────────────────────────────────────────────────────────────┤
│                 GOVERNANCE COMMITTEES                           │
│   Security Steering │ Risk Management │ AI Ethics Board         │
│   Committee         │ Committee       │                         │
├─────────────────────────────────────────────────────────────────┤
│                 MANAGEMENT LAYER                                │
│   Security Ops │ GRC Team │ SOC │ AppSec │ Cloud Security       │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3 Role Evolution Timeline (วิวัฒนาการของบทบาท)

| Era       | Role                | Focus                                        |
| --------- | ------------------- | -------------------------------------------- |
| 2000s     | IT Security Mgr     | Perimeter defense, firewall management       |
| 2010s     | CISO                | Enterprise risk, compliance, board reporting |
| 2020-2023 | CISO + vCISO        | Cloud, zero trust, supply chain              |
| 2023-2024 | CISO + CAIO         | AI strategy, responsible AI, AI governance   |
| 2025+     | CISO + CAIO + CAISO | AI security convergence, dual governance     |

> **Note**: ผลสำรวจปี 2025 พบว่า 26% ขององค์กรมี CAIO อย่างเป็นทางการ (เพิ่มจาก 11% ในปี 2023)
> CAISO เป็นบทบาทใหม่ที่ยังมีน้อยกว่า 5% ขององค์กร แต่กำลังเติบโตเร็ว

---

## 2. NIST CSF 2.0 GOVERN Function (GV)

### 2.1 Overview (ภาพรวม GOVERN Function)

NIST CSF 2.0 (เผยแพร่ กุมภาพันธ์ 2024) เพิ่ม **GOVERN (GV)** เป็น function ที่ 6 ซึ่งเป็น cross-cutting function
ที่ส่งผลต่อทุก function อื่น (Identify, Protect, Detect, Respond, Recover)

```
                    ┌──────────┐
                    │  GOVERN  │ ← Cross-cutting
                    └────┬─────┘
        ┌────────┬───────┼───────┬──────────┐
   ┌────┴───┐┌───┴──┐┌───┴──┐┌───┴──┐┌──────┴──┐
   │IDENTIFY││PROTECT││DETECT││RESPOND││ RECOVER │
   └────────┘└──────┘└──────┘└──────┘└─────────┘
```

### 2.2 GOVERN Categories & Subcategories

| Category  | Name                       | คำอธิบาย                                                  | Subcategories        |
| --------- | -------------------------- | --------------------------------------------------------- | -------------------- |
| **GV.OC** | Organizational Context     | บริบทองค์กร — mission, stakeholders, legal, risk appetite | GV.OC-01 to GV.OC-05 |
| **GV.RM** | Risk Management Strategy   | กลยุทธ์การบริหารความเสี่ยง — risk appetite, tolerance     | GV.RM-01 to GV.RM-07 |
| **GV.RR** | Roles, Responsibilities    | บทบาทและความรับผิดชอบ — accountability, authority         | GV.RR-01 to GV.RR-04 |
| **GV.PO** | Policy                     | นโยบาย — established, communicated, enforced              | GV.PO-01 to GV.PO-02 |
| **GV.OV** | Oversight                  | การกำกับดูแล — review, adjust, accountability             | GV.OV-01 to GV.OV-03 |
| **GV.SC** | Cybersecurity Supply Chain | การจัดการห่วงโซ่อุปทานไซเบอร์ — third-party risk          | GV.SC-01 to GV.SC-10 |

### 2.3 Key Subcategory Details

#### GV.OC — Organizational Context

| ID       | Subcategory                                                   | Artifacts                         |
| -------- | ------------------------------------------------------------- | --------------------------------- |
| GV.OC-01 | Organizational mission understood and informs risk management | Mission statement, strategic plan |
| GV.OC-02 | Internal and external stakeholders determined                 | Stakeholder register              |
| GV.OC-03 | Legal, regulatory, contractual requirements understood        | Compliance register, legal matrix |
| GV.OC-04 | Critical objectives, capabilities, services understood        | BIA, asset inventory              |
| GV.OC-05 | Outcomes, capabilities, services depend on other orgs         | Dependency map, vendor register   |

#### GV.RM — Risk Management Strategy

| ID       | Subcategory                                                     | Artifacts                   |
| -------- | --------------------------------------------------------------- | --------------------------- |
| GV.RM-01 | Risk management objectives agreed upon by leaders               | Risk appetite statement     |
| GV.RM-02 | Risk appetite and risk tolerance statements established         | Risk tolerance matrix       |
| GV.RM-03 | Risk management activities and outcomes include cybersecurity   | ERM integration document    |
| GV.RM-04 | Strategic direction for cybersecurity risk response established | Risk response strategy      |
| GV.RM-05 | Lines of communication for risk reporting established           | Reporting escalation paths  |
| GV.RM-06 | Standard risk model and analytic approaches established         | Risk assessment methodology |
| GV.RM-07 | Strategic opportunities identified from risk changes            | Opportunity register        |

#### GV.RR — Roles, Responsibilities, and Authorities

| ID       | Subcategory                                               | Artifacts                    |
| -------- | --------------------------------------------------------- | ---------------------------- |
| GV.RR-01 | Organizational leadership accountable for risk decisions  | RACI matrix, charter         |
| GV.RR-02 | Roles for entire workforce established and communicated   | Role descriptions, org chart |
| GV.RR-03 | Adequate resources allocated (people, budget, technology) | Budget plan, headcount plan  |
| GV.RR-04 | Cybersecurity included in human resources practices       | Security awareness program   |

#### GV.PO — Policy

| ID       | Subcategory                                         | Artifacts                         |
| -------- | --------------------------------------------------- | --------------------------------- |
| GV.PO-01 | Policy for managing cybersecurity risks established | Cyber risk policy, AUP            |
| GV.PO-02 | Policy reviewed, updated, and communicated          | Policy review schedule, changelog |

#### GV.OV — Oversight

| ID       | Subcategory                                                         | Artifacts                     |
| -------- | ------------------------------------------------------------------- | ----------------------------- |
| GV.OV-01 | Cybersecurity risk management strategy outcomes reviewed            | Board review minutes          |
| GV.OV-02 | Cybersecurity risk management strategy adjusted as needed           | Strategy update document      |
| GV.OV-03 | Organizational cybersecurity performance evaluated and communicated | KPI dashboard, metrics report |

#### GV.SC — Cybersecurity Supply Chain Risk Management

| ID       | Subcategory                                                       | Artifacts                          |
| -------- | ----------------------------------------------------------------- | ---------------------------------- |
| GV.SC-01 | Supply chain risk management program established                  | SCRM policy                        |
| GV.SC-02 | Suppliers identified, prioritized by criticality                  | Vendor tier classification         |
| GV.SC-03 | Supply chain requirements established and integrated              | Security requirements in contracts |
| GV.SC-04 | Supplier assessments conducted                                    | Assessment questionnaires, reports |
| GV.SC-05 | Planning and due diligence performed on prospective suppliers     | Due diligence checklist            |
| GV.SC-06 | Planning and due diligence integrated in supply chain operations  | Procurement security gates         |
| GV.SC-07 | Risk management activities include supply chain issues            | SCRM risk register                 |
| GV.SC-08 | Relevant suppliers included in incident response plans            | IR contact list, comm plan         |
| GV.SC-09 | Supply chain security practices continuously improved             | Annual review, maturity assessment |
| GV.SC-10 | Supply chain security practices included in cybersecurity program | Integration documentation          |

---

## 3. ISO 27014:2020 — Information Security Governance

### 3.1 Governance Processes (5 กระบวนการหลัก)

| Process         | คำอธิบาย                                             | Key Activities                                             |
| --------------- | ---------------------------------------------------- | ---------------------------------------------------------- |
| **Evaluate**    | ประเมินสถานะปัจจุบันและอนาคตของ information security | Current state assessment, gap analysis, benchmarking       |
| **Direct**      | กำหนดทิศทางผ่านนโยบาย วัตถุประสงค์ และกลยุทธ์        | Policy issuance, strategic objectives, resource allocation |
| **Monitor**     | ติดตามผลการดำเนินงานเทียบกับวัตถุประสงค์             | KPI tracking, audit results, compliance status             |
| **Communicate** | สื่อสารระหว่าง stakeholders ทุกระดับ                 | Board reports, awareness, external disclosure              |
| **Assure**      | รับรองว่าผลลัพธ์ตรงตามวัตถุประสงค์                   | Independent audits, third-party attestations               |

### 3.2 ISO 27014 Governance Model

```
┌─────────────────────────────────────────────────────┐
│            GOVERNING BODY (Board/C-suite)           │
│                                                     │
│   EVALUATE ──→ DIRECT ──→ MONITOR                   │
│       ↑           │           │                     │
│       │      COMMUNICATE      │                     │
│       │           │           ↓                     │
│       └─────── ASSURE ←──────┘                      │
│                                                     │
├─────────────────────────────────────────────────────┤
│            MANAGEMENT (CISO / Security Team)        │
│                                                     │
│   Plan → Implement → Operate → Monitor → Improve    │
└─────────────────────────────────────────────────────┘
```

### 3.3 NACD Director's Handbook — 6 Principles for Board Cyber-Risk Oversight

| #   | Principle                                       | Board Action                                    |
| --- | ----------------------------------------------- | ----------------------------------------------- |
| 1   | Cybersecurity เป็น strategic enterprise risk    | ให้ agenda ใน board meeting ทุกไตรมาส           |
| 2   | เข้าใจ legal implications ของ cyber risk        | Review regulatory landscape, SEC requirements   |
| 3   | Board access to cybersecurity expertise         | CISO presents quarterly, external advisors      |
| 4   | Set expectation for management framework        | Adopt NIST CSF, mandate risk appetite statement |
| 5   | Board-management discussion of cyber risk       | Define risk tolerance, approve risk treatment   |
| 6   | Encourage systemic resilience and collaboration | Participate in ISACs, share threat intelligence |

### 3.4 Comparison: NIST CSF 2.0 GV vs ISO 27014

| Aspect              | NIST CSF 2.0 GOVERN                                     | ISO 27014:2020                  |
| ------------------- | ------------------------------------------------------- | ------------------------------- |
| **Scope**           | Cybersecurity-specific governance                       | Information security governance |
| **Structure**       | 6 categories, 31 subcategories                          | 5 processes                     |
| **Supply chain**    | Dedicated category (GV.SC, 10 items)                    | Referenced but not dedicated    |
| **Risk appetite**   | Explicit (GV.RM-01, GV.RM-02)                           | Embedded in Evaluate/Direct     |
| **Board oversight** | GV.OV (3 items)                                         | Evaluate + Monitor processes    |
| **Best for**        | US-centric, CSF-aligned organizations                   | ISO 27001-aligned organizations |
| **Complementary**   | Use together — CSF for categories, ISO for process flow |

---

## 4. Security Maturity Models

### 4.1 C2M2 — Cybersecurity Capability Maturity Model

C2M2 พัฒนาโดย US DOE — ใช้ได้กับทุกอุตสาหกรรม ไม่ใช่แค่ energy sector

#### 4.1.1 Maturity Indicator Levels (MIL)

| Level | Name          | คำอธิบาย                                          |
| ----- | ------------- | ------------------------------------------------- |
| MIL 0 | Not Performed | ไม่มีกิจกรรม — ad hoc                             |
| MIL 1 | Initiated     | มีการดำเนินการเบื้องต้น แต่ไม่ consistent         |
| MIL 2 | Performed     | มีกระบวนการที่กำหนดและ documented — repeatable    |
| MIL 3 | Managed       | กระบวนการ managed, measured, reviewed — optimized |

#### 4.1.2 C2M2 Domains (10 domains)

| Domain    | Name                                   | Key Practices                                   |
| --------- | -------------------------------------- | ----------------------------------------------- |
| ASSET     | Asset, Change, Configuration Mgmt      | Asset inventory, change control, configuration  |
| THREAT    | Threat and Vulnerability Mgmt          | Threat identification, vulnerability management |
| RISK      | Risk Management                        | Risk identification, assessment, response       |
| IDENTITY  | Identity and Access Management         | IAM policies, privileged access, MFA            |
| SITUATE   | Situational Awareness                  | Logging, monitoring, threat intelligence        |
| EVENT     | Event and Incident Response            | Detection, response, recovery procedures        |
| CONOPS    | Continuity of Operations               | BCP, DRP, testing and exercises                 |
| PROGRAM   | Cybersecurity Program Management       | Strategy, governance, resources, workforce      |
| SUPPLY    | Supply Chain and External Dependencies | Third-party risk, vendor management             |
| WORKFORCE | Workforce Management                   | Training, awareness, skills development         |

#### 4.1.3 Self-Assessment Matrix Template

```
Domain    │ MIL 0 │ MIL 1 │ MIL 2 │ MIL 3 │ Target │ Gap
──────────┼───────┼───────┼───────┼───────┼────────┼─────
ASSET     │       │  ●    │       │       │ MIL 2  │ +1
THREAT    │       │  ●    │       │       │ MIL 2  │ +1
RISK      │  ●    │       │       │       │ MIL 2  │ +2
IDENTITY  │       │       │  ●    │       │ MIL 3  │ +1
SITUATE   │       │  ●    │       │       │ MIL 2  │ +1
EVENT     │       │       │  ●    │       │ MIL 2  │  0
CONOPS    │  ●    │       │       │       │ MIL 1  │ +1
PROGRAM   │       │  ●    │       │       │ MIL 2  │ +1
SUPPLY    │  ●    │       │       │       │ MIL 2  │ +2
WORKFORCE │       │  ●    │       │       │ MIL 2  │ +1
```

### 4.2 CMMI Cybermaturity Platform

| Level | CMMI Maturity          | คำอธิบาย                                   |
| ----- | ---------------------- | ------------------------------------------ |
| 1     | Initial                | กระบวนการ unpredictable, poorly controlled |
| 2     | Managed                | กระบวนการ managed at project level         |
| 3     | Defined                | กระบวนการ standardized across organization |
| 4     | Quantitatively Managed | กระบวนการ measured and controlled          |
| 5     | Optimizing             | Focus on continuous improvement            |

### 4.3 NIST CSF 2.0 Implementation Tiers

| Tier | Name          | Characteristics                                 |
| ---- | ------------- | ----------------------------------------------- |
| 1    | Partial       | Risk management ad hoc, limited awareness       |
| 2    | Risk Informed | Risk-aware but not organization-wide            |
| 3    | Repeatable    | Formal risk management, regularly updated       |
| 4    | Adaptive      | Risk management adapts based on lessons learned |

### 4.4 12-Month Maturity Improvement Roadmap

| Month | Phase                   | Key Activities                                          | Target               |
| ----- | ----------------------- | ------------------------------------------------------- | -------------------- |
| 1-2   | Baseline Assessment     | C2M2 self-assessment, identify current MIL per domain   | Current state map    |
| 3-4   | Gap Analysis & Planning | Define target MIL, prioritize gaps, estimate budget     | Improvement plan     |
| 5-7   | Quick Wins              | MFA rollout, policy documentation, asset inventory      | MIL 1 across all     |
| 8-10  | Process Formalization   | Documented procedures, RACI matrices, metrics framework | MIL 2 target domains |
| 11-12 | Measurement & Review    | KPI tracking, board reporting, external assessment      | Validated progress   |

---

## 5. Executive Roles: CISO, CAIO, CAISO

### 5.1 Role Definitions (คำจำกัดความบทบาท)

#### CISO — Chief Information Security Officer

| Attribute         | Detail                                                                |
| ----------------- | --------------------------------------------------------------------- |
| **Primary Focus** | Enterprise cybersecurity strategy, risk management, compliance        |
| **Reports to**    | CEO (40%), CIO (30%), Board/Risk Committee (20%), Other (10%)         |
| **Key Metrics**   | MTTD, MTTR, compliance score, risk reduction %, security budget ROI   |
| **Scope**         | All IT/OT security, incident response, GRC, vendor risk, security ops |
| **Evolution**     | Traditional IT security → Enterprise risk → Business enablement       |

#### CAIO — Chief AI Officer

| Attribute         | Detail                                                                   |
| ----------------- | ------------------------------------------------------------------------ |
| **Primary Focus** | AI strategy, responsible AI, AI governance, AI value creation            |
| **Reports to**    | CEO (50%), CTO (30%), Board (20%)                                        |
| **Key Metrics**   | AI ROI, model deployment count, AI ethics compliance, bias metrics       |
| **Scope**         | AI strategy, data governance, model lifecycle, AI ethics, AI talent      |
| **Context**       | EU AI Act (Art. 4) requires "AI literacy" — 26% of orgs have CAIO (2025) |

#### CAISO — Chief AI Security Officer

| Attribute         | Detail                                                                 |
| ----------------- | ---------------------------------------------------------------------- |
| **Primary Focus** | Convergence of AI security and traditional cybersecurity               |
| **Reports to**    | CEO (40%), CISO (30%), Board (30%)                                     |
| **Key Metrics**   | AI threat coverage, prompt injection block rate, AI model compliance   |
| **Scope**         | AI-specific threats, AI supply chain, AI red teaming, AISOC operations |
| **Context**       | Emerging role (<5% of orgs, 2025) — bridges CISO + CAIO security gaps  |

### 5.2 Responsibility Matrix (RACI)

| Activity                        | CISO  | CAIO  | CAISO | CIO | CEO   | Board |
| ------------------------------- | ----- | ----- | ----- | --- | ----- | ----- |
| Cybersecurity strategy          | **A** | C     | C     | C   | I     | I     |
| AI strategy & governance        | C     | **A** | C     | C   | I     | I     |
| AI security controls            | C     | C     | **A** | I   | I     | I     |
| Enterprise risk management      | **R** | C     | C     | C   | **A** | I     |
| Incident response (traditional) | **A** | I     | C     | C   | I     | I     |
| AI incident response            | C     | C     | **A** | I   | I     | I     |
| Compliance & regulatory         | **A** | R     | R     | C   | I     | I     |
| Board reporting (security)      | **R** | C     | C     | C   | C     | **A** |
| Vendor/supply chain security    | **A** | C     | R     | C   | I     | I     |
| Security awareness & training   | **A** | C     | R     | C   | I     | I     |
| AI ethics & responsible AI      | C     | **A** | C     | I   | I     | I     |
| Security budget                 | **R** | C     | C     | C   | **A** | I     |

> **RACI**: R = Responsible (ดำเนินการ), A = Accountable (รับผิดชอบ), C = Consulted (ปรึกษา), I = Informed (รับทราบ)

### 5.3 CISO Reporting Structure Patterns

```
Pattern A: CISO → CEO (Independent)
┌──────┐
│ CEO  │
├──┬───┤
│CISO│CIO│  ← CISO independent from IT, direct board access
└──┴───┘
Best for: Regulated industries, large enterprises

Pattern B: CISO → CIO (Aligned)
┌──────┐
│ CEO  │
├──────┤
│ CIO  │
├──────┤
│ CISO │  ← CISO under IT umbrella
└──────┘
Best for: Smaller orgs, IT-centric security

Pattern C: CISO → CEO + CAISO → CISO (Converged)
┌──────────┐
│   CEO    │
├────┬─────┤
│CISO│ CAIO│
├────┤     │
│CAISO│    │  ← CAISO bridges security + AI
└─────┘    │
           │
```

### 5.4 When to Create a CAISO Role (Decision Tree)

```
Does your org deploy AI/ML in production?
├── No → CISO handles AI security as part of portfolio
│        (add AI security to CISO responsibility)
│
├── Yes
│   ├── Is AI a core product/revenue driver?
│   │   ├── No → Assign AI security lead under CISO
│   │   │        (Sr. Director level, not C-suite)
│   │   │
│   │   └── Yes
│   │       ├── Do you have a CAIO?
│   │       │   ├── No → Create CAIO first, then evaluate CAISO
│   │       │   │
│   │       │   └── Yes
│   │       │       ├── Is AI risk in your top 5 enterprise risks?
│   │       │       │   ├── No → AI security portfolio under CISO
│   │       │       │   │        with dotted line to CAIO
│   │       │       │   │
│   │       │       │   └── Yes → CREATE CAISO ROLE
│   │       │       │            Reports: CEO or Board
│   │       │       │            Coordinates: CISO + CAIO
│   │       │       │            Focus: AI threat landscape,
│   │       │       │            AISOC, AI supply chain,
│   │       │       │            AI red team
│   │       │       │
```

### 5.5 AISOC Concept (AI Security Operations Center)

| Component             | Traditional SOC                 | AISOC Extension                                       |
| --------------------- | ------------------------------- | ----------------------------------------------------- |
| **Monitoring**        | Network, endpoint, cloud        | Model inference, prompt logs, AI APIs                 |
| **Threat Intel**      | IOC feeds, MITRE ATT&CK         | MITRE ATLAS, AI threat feeds                          |
| **Detection Rules**   | Sigma, YARA, Snort              | Prompt injection patterns, model drift                |
| **Incident Response** | Traditional IR playbooks        | AI-specific IR (model rollback, guardrail bypass)     |
| **Red Team**          | Network/app penetration testing | AI red teaming (adversarial ML, prompt attacks)       |
| **Metrics**           | MTTD, MTTR, alert volume        | + Prompt block rate, model drift %, AI false positive |

---

## 6. Board Reporting & SEC Disclosure

### 6.1 SEC Cybersecurity Disclosure Rules (2023)

ตั้งแต่ ธันวาคม 2023 SEC กำหนดให้บริษัทจดทะเบียนในตลาดหลักทรัพย์สหรัฐฯ ต้องเปิดเผยข้อมูล cybersecurity:

| Requirement    | Form     | Timeline              | Content                                               |
| -------------- | -------- | --------------------- | ----------------------------------------------------- |
| **Incident**   | 8-K      | ภายใน 4 business days | Material cybersecurity incident description           |
| **Risk Mgmt**  | 10-K/S-K | Annual filing         | Risk management processes, board oversight, CISO role |
| **Governance** | 10-K/S-K | Annual filing         | Board expertise, committee structure, oversight       |

### 6.2 Materiality Assessment Template

```
┌──────────────────────────────────────────────────────────┐
│           MATERIALITY ASSESSMENT FRAMEWORK               │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Quantitative Factors:                                   │
│  ☐ Financial impact > $X (define threshold)              │
│  ☐ Records exposed > N (e.g., 100,000 PII records)      │
│  ☐ Operational downtime > T hours                        │
│  ☐ Revenue impact > Y% of quarterly revenue              │
│                                                          │
│  Qualitative Factors:                                    │
│  ☐ Regulatory notification triggered (e.g., GDPR 72h)   │
│  ☐ Reputational harm likely (media coverage expected)    │
│  ☐ Critical infrastructure affected                      │
│  ☐ National security implications                        │
│  ☐ Litigation risk (class action probable)               │
│                                                          │
│  Determination: Material / Not Material / Under Review   │
│  Reviewer: ____________  Date: ____________              │
│  Approved by (GC/CFO): ____________                      │
└──────────────────────────────────────────────────────────┘
```

### 6.3 Board KPI Dashboard Template

แดชบอร์ดสำหรับรายงานต่อคณะกรรมการ — แบ่ง 3 ส่วน:

#### Component 1: Risk Posture (สถานะความเสี่ยง)

| KPI                            | Target   | Current | Trend | Source                |
| ------------------------------ | -------- | ------- | ----- | --------------------- |
| Critical vulnerabilities open  | < 10     | —       | —     | Vuln management (D14) |
| Mean time to remediate (MTTR)  | < 7 days | —       | —     | Vuln management (D14) |
| Third-party risk score         | > 80/100 | —       | —     | Vendor assessments    |
| Cyber insurance coverage ratio | > 80%    | —       | —     | Insurance policy      |
| Risk appetite adherence        | 100%     | —       | —     | ERM system            |

#### Component 2: Operational Effectiveness (ประสิทธิผลการดำเนินงาน)

| KPI                         | Target   | Current | Trend | Source                |
| --------------------------- | -------- | ------- | ----- | --------------------- |
| MTTD (mean time to detect)  | < 24 hrs | —       | —     | SOC metrics (D4)      |
| MTTR (mean time to respond) | < 4 hrs  | —       | —     | IR metrics (D1)       |
| Phishing click rate         | < 3%     | —       | —     | Security awareness    |
| MFA coverage                | > 99%    | —       | —     | IAM system            |
| Patch compliance (critical) | > 95%    | —       | —     | Vuln management (D14) |

#### Component 3: Program Maturity (วุฒิภาวะโปรแกรม)

| KPI                          | Target | Current | Trend | Source          |
| ---------------------------- | ------ | ------- | ----- | --------------- |
| CSF maturity tier            | Tier 3 | —       | —     | CSF assessment  |
| Security budget % of IT      | 10-15% | —       | —     | Finance         |
| Open audit findings          | < 5    | —       | —     | Internal audit  |
| Security training completion | > 95%  | —       | —     | LMS             |
| Tabletop exercises conducted | 2/year | —       | —     | IR program (D1) |

### 6.4 Quarterly Board Report Structure

```
1. Executive Summary (1 page)
   - Overall risk posture: GREEN / AMBER / RED
   - Top 3 risks and mitigation status
   - Key incidents since last report

2. Threat Landscape Update (1 page)
   - Industry-specific threats (from TI, D15)
   - Emerging threats relevant to business
   - Peer comparison (benchmarking)

3. KPI Dashboard (1 page)
   - Risk posture metrics (Component 1)
   - Operational effectiveness (Component 2)
   - Program maturity (Component 3)

4. Program Highlights (1 page)
   - Completed initiatives
   - In-progress projects and timeline
   - Resource requests / budget items

5. Regulatory & Compliance Update (1 page)
   - Regulatory changes affecting the org
   - Audit status and findings
   - SEC disclosure readiness

6. Appendix
   - Detailed metrics
   - Glossary for non-technical directors
```

---

## 7. AI Governance at Executive Level

### 7.1 NIST AI RMF — GOVERN Function

NIST AI Risk Management Framework กำหนด **GOVERN** เป็น function แรก ซึ่งตั้ง foundation สำหรับ
Map, Measure, Manage:

| Category | คำอธิบาย                                            | Key Practices                               |
| -------- | --------------------------------------------------- | ------------------------------------------- |
| GOVERN 1 | Policies for trustworthy AI established             | AI acceptable use policy, ethics guidelines |
| GOVERN 2 | Accountability structures defined                   | RACI matrix, AI oversight committee         |
| GOVERN 3 | Workforce diversity and AI literacy ensured         | Training programs, diverse teams            |
| GOVERN 4 | Organizational practices documented                 | AI inventory, model cards, risk assessments |
| GOVERN 5 | Processes for engagement with external stakeholders | Public transparency, community input        |
| GOVERN 6 | Policies addressing AI risks throughout lifecycle   | AI SDLC security gates, model retirement    |

### 7.2 ISO 42001 — AI Management System (Executive View)

| Clause | Area                    | Executive Actions                                          |
| ------ | ----------------------- | ---------------------------------------------------------- |
| 4      | Context of Organization | Define AI scope, stakeholders, legal requirements          |
| 5      | Leadership              | Establish AI policy, assign roles, ensure resources        |
| 6      | Planning                | Address AI risks and opportunities, set objectives         |
| 7      | Support                 | Competence, awareness, communication, documentation        |
| 8      | Operation               | AI system lifecycle, third-party AI components             |
| 9      | Performance Evaluation  | Monitoring, measurement, internal audit, management review |
| 10     | Improvement             | Nonconformity, corrective action, continual improvement    |

### 7.3 EU AI Act — Organizational Obligations

| Obligation               | Timeline   | Executive Action                                  |
| ------------------------ | ---------- | ------------------------------------------------- |
| AI literacy (Art. 4)     | 2 Feb 2025 | Board + C-suite AI training program               |
| Prohibited AI practices  | 2 Feb 2025 | Audit AI systems for prohibited categories        |
| High-risk AI obligations | 2 Aug 2026 | Conformity assessment, quality management system  |
| General-purpose AI rules | 2 Aug 2025 | Transparency, documentation, copyright compliance |
| Risk management system   | 2 Aug 2026 | Lifecycle risk assessment for high-risk AI        |

### 7.4 AI Ethics Board Charter Template

```
AI ETHICS BOARD CHARTER
═══════════════════════

Purpose:
  Provide governance and oversight for AI systems
  to ensure responsible, ethical, and safe AI use.

Composition:
  - Chair: CAIO or CAISO
  - Members: CISO, CTO, General Counsel, Chief Ethics Officer,
    HR representative, external AI ethics expert
  - Quorum: 4 members minimum

Scope:
  - Review all high-risk AI deployments (EU AI Act classification)
  - Approve AI use cases involving PII, decisions affecting individuals,
    or automated decision-making
  - Investigate AI-related incidents or bias reports
  - Annual review of AI governance policies

Decision Authority:
  - APPROVE: Low-risk AI deployments
  - RECOMMEND to Board: High-risk AI deployments
  - HALT: AI systems with unacceptable risk or safety concerns

Meeting Cadence:
  - Monthly regular meetings
  - Ad-hoc meetings for urgent AI safety/ethics issues

Reporting:
  - Quarterly report to Board Risk Committee
  - Annual AI governance report (public disclosure if required)
```

### 7.5 Singapore IMDA Model AI Governance Framework

| Principle           | Executive Action                                     |
| ------------------- | ---------------------------------------------------- |
| Transparency        | Disclose AI use to customers and regulators          |
| Explainability      | Ensure AI decisions can be explained to stakeholders |
| Fairness            | Bias testing and monitoring for all AI models        |
| Human-centricity    | Human oversight for high-stakes AI decisions         |
| Safety and security | AI security controls aligned with CAISO scope        |

> **Thai Context**: สำนักงาน ETDA ของประเทศไทยมีแนวปฏิบัติ AI Ethics Guidelines ที่สอดคล้องกับ OECD AI Principles
> องค์กรไทยควรพิจารณา PDPA implications สำหรับ AI systems ที่ประมวลผลข้อมูลส่วนบุคคล

---

## 8. Governance Program Implementation Roadmap

### 8.1 5-Phase Roadmap (12 เดือน)

```
Month:  1    2    3    4    5    6    7    8    9    10   11   12
Phase 1: ████                                              Assessment
Phase 2:      ████████                                     Foundation
Phase 3:                ████████████                        Build
Phase 4:                              ████████████          Measure
Phase 5:                                          ████████  Optimize
```

#### Phase 1: Assessment (เดือน 1-2)

| Activity                                | Output                       | Owner     |
| --------------------------------------- | ---------------------------- | --------- |
| Current state governance assessment     | Gap analysis report          | CISO      |
| C2M2 / CSF maturity self-assessment     | Maturity scorecard           | GRC team  |
| Stakeholder interviews (Board, C-suite) | Stakeholder expectations doc | CISO      |
| Regulatory landscape review             | Compliance register          | Legal/GRC |
| Peer benchmarking                       | Benchmark comparison report  | CISO      |

#### Phase 2: Foundation (เดือน 2-4)

| Activity                              | Output                         | Owner      |
| ------------------------------------- | ------------------------------ | ---------- |
| Define governance charter             | Governance charter document    | CISO + CEO |
| Establish Security Steering Committee | SSC charter, meeting cadence   | CISO       |
| Define risk appetite & tolerance      | Risk appetite statement        | Board      |
| Create/update security policies       | Policy suite (AUP, IR, DR)     | GRC team   |
| Map roles (RACI matrix)               | RACI matrix for key activities | CISO       |

#### Phase 3: Build (เดือน 4-7)

| Activity                                | Output                        | Owner        |
| --------------------------------------- | ----------------------------- | ------------ |
| Implement board reporting cadence       | Quarterly report template     | CISO         |
| Deploy KPI dashboard                    | Live dashboard (3 components) | Security ops |
| Establish vendor risk management        | Vendor assessment program     | GRC team     |
| Launch security awareness program       | Training platform, schedule   | CISO + HR    |
| Implement AI governance (if applicable) | AI Ethics Board charter       | CAIO/CAISO   |

#### Phase 4: Measure (เดือน 7-10)

| Activity                               | Output                           | Owner          |
| -------------------------------------- | -------------------------------- | -------------- |
| First quarterly board report           | Board report (see 6.4 template)  | CISO           |
| KPI baseline establishment             | Baseline metrics document        | GRC team       |
| Internal audit of governance program   | Audit report                     | Internal audit |
| Tabletop exercise (governance-focused) | Exercise report, lessons learned | CISO           |
| SEC disclosure readiness assessment    | Readiness checklist              | Legal/CISO     |

#### Phase 5: Optimize (เดือน 10-12)

| Activity                             | Output                          | Owner      |
| ------------------------------------ | ------------------------------- | ---------- |
| Maturity reassessment (C2M2/CSF)     | Updated maturity scorecard      | GRC team   |
| Governance program annual review     | Annual governance report        | CISO       |
| Budget planning for next fiscal year | Security budget proposal        | CISO + CFO |
| External assessment or certification | Assessment report / certificate | External   |
| Roadmap update for Year 2            | Updated roadmap                 | CISO       |

### 8.2 Implementation KPIs

| KPI                                  | Target (Year 1) | Measurement                    |
| ------------------------------------ | --------------- | ------------------------------ |
| Governance charter approved          | 100%            | Board approval date            |
| Policies reviewed and updated        | 100%            | Policy review completion date  |
| Board reporting cadence achieved     | 4 reports/year  | Report submission dates        |
| CSF maturity improvement             | +1 tier         | Pre/post assessment comparison |
| Security steering committee meetings | 12/year         | Meeting minutes                |
| Vendor assessments completed         | > 80% critical  | Assessment completion rate     |
| Training completion rate             | > 95%           | LMS records                    |
| SEC disclosure readiness             | 100%            | Readiness checklist score      |

### 8.3 Operating Model Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                    GOVERNANCE LAYER                           │
│  ┌──────────┐  ┌──────────────┐  ┌────────────────┐          │
│  │  Board   │  │   Security   │  │   AI Ethics    │          │
│  │Risk Comm.│  │Steering Comm.│  │     Board      │          │
│  └────┬─────┘  └──────┬───────┘  └───────┬────────┘          │
│       │               │                  │                   │
├───────┼───────────────┼──────────────────┼───────────────────┤
│       │        STRATEGY LAYER            │                   │
│       │    ┌──────────┴──────────┐       │                   │
│       ├────┤ CISO               │───────┤                   │
│       │    ├─ Risk Strategy     │       │                   │
│       │    ├─ Policy Framework  │       │                   │
│       │    ├─ Board Reporting   │    ┌──┴──┐                │
│       │    └─ Program Mgmt     │    │CAIO/│                │
│       │                         │    │CAISO│                │
│       │                         │    └──┬──┘                │
├───────┼─────────────────────────┼───────┼───────────────────┤
│       │        OPERATIONS LAYER │       │                   │
│  ┌────┴────┐  ┌────────┐  ┌────┴────┐  ┌────────┐          │
│  │   GRC   │  │  SOC   │  │ AppSec  │  │  AISOC │          │
│  │  Team   │  │ (D4)   │  │  (D6)   │  │ (D12)  │          │
│  └─────────┘  └────────┘  └─────────┘  └────────┘          │
└──────────────────────────────────────────────────────────────┘
```

---

## 9. Framework References & Governance Checklist

### 9.1 Framework Reference Table

| Framework / Standard     | Version    | Publisher | Focus Area                      | URL                                                                       |
| ------------------------ | ---------- | --------- | ------------------------------- | ------------------------------------------------------------------------- |
| NIST CSF 2.0             | 2.0 (2024) | NIST      | Cybersecurity framework         | https://www.nist.gov/cyberframework                                       |
| NIST CSF 2.0 GOVERN      | 2.0 (2024) | NIST      | Governance function             | https://csf.tools/reference/nist-cybersecurity-framework/v2-0/gv/         |
| ISO/IEC 27014:2020       | 2020       | ISO/IEC   | Information security governance | https://www.iso.org/standard/74046.html                                   |
| C2M2                     | 2.1 (2022) | US DOE    | Cybersecurity maturity          | https://www.energy.gov/ceser/cybersecurity-capability-maturity-model-c2m2 |
| NACD Director's Handbook | 2023       | NACD      | Board cyber-risk oversight      | https://www.nacdonline.org/                                               |
| SEC Cybersecurity Rules  | 2023       | SEC       | Public company disclosure       | https://www.sec.gov/rules/final/2023/33-11216.pdf                         |
| NIST AI RMF              | 1.0 (2023) | NIST      | AI risk management              | https://www.nist.gov/artificial-intelligence/ai-risk-management-framework |
| ISO/IEC 42001:2023       | 2023       | ISO/IEC   | AI management system            | https://www.iso.org/standard/81230.html                                   |
| EU AI Act                | 2024       | EU        | AI regulation                   | https://artificialintelligenceact.eu/                                     |
| Singapore IMDA AI Gov    | 2.0 (2020) | IMDA      | AI governance framework         | https://www.imda.gov.sg/how-we-can-help/model-ai-governance-framework     |

### 9.2 Governance Checklist (ตรวจสอบธรรมาภิบาล)

#### Quick Win (ดำเนินการได้ทันที)

- [ ] Governance charter drafted and approved by executive sponsor
- [ ] CISO reporting line established (CEO or Board preferred)
- [ ] Security Steering Committee formed with quarterly meeting cadence
- [ ] Risk appetite statement defined and approved by Board
- [ ] Cybersecurity included in Board meeting agenda (quarterly minimum)
- [ ] SEC 8-K disclosure process documented (if publicly traded)
- [ ] Current state maturity assessment completed (C2M2 or CSF Tiers)
- [ ] RACI matrix created for key security activities

#### Standard (ภายใน 6 เดือน)

- [ ] Full NIST CSF 2.0 GOVERN function assessment completed
- [ ] All GV categories covered (GV.OC, GV.RM, GV.RR, GV.PO, GV.OV, GV.SC)
- [ ] Board KPI dashboard operational (3 components: Risk, Ops, Maturity)
- [ ] Quarterly board reporting cadence established and maintained
- [ ] Security policies reviewed, updated, and communicated organization-wide
- [ ] Vendor risk management program operational (critical vendors assessed)
- [ ] Security awareness training program launched with > 90% completion
- [ ] ISO 27014 governance processes mapped (Evaluate/Direct/Monitor/Communicate/Assure)

#### Advanced (ภายใน 12 เดือน)

- [ ] CSF maturity improved by 1+ tier from baseline
- [ ] AI Ethics Board established (if AI deployed in production)
- [ ] CAISO role evaluated and decision documented (see 5.4 decision tree)
- [ ] NIST AI RMF GOVERN function implemented (if AI used)
- [ ] ISO 42001 gap assessment completed (if AI management system needed)
- [ ] EU AI Act compliance roadmap created (if operating in EU)
- [ ] Annual governance program review completed with external validation
- [ ] Security budget aligned to risk appetite (10-15% of IT budget benchmark)
- [ ] Peer benchmarking conducted and gaps addressed
- [ ] Board cyber literacy program delivered to all directors

---

## 10. Cyber Resilience Metrics (Prevention → Resilience Shift)

Industry trend 2026: เปลี่ยนจาก prevention-focused KPIs ไปสู่ resilience-focused metrics
— ยอมรับว่า breach จะเกิดขึ้น focus ที่ recovery speed และ business continuity

### 10.1 Resilience KPI Dashboard

| Metric                         | Target               | Measurement                                                |
| ------------------------------ | -------------------- | ---------------------------------------------------------- |
| MTTR (Mean Time to Recover)    | < 4 hours (Critical) | เวลาเฉลี่ยจากตรวจพบ incident จนถึง full recovery           |
| Recovery Test Success Rate     | > 95%                | จำนวน recovery tests ที่สำเร็จ / ทั้งหมด                   |
| Backup Validation Rate         | 100% monthly         | จำนวน backups ที่ verified / ทั้งหมด                       |
| Failover Test Frequency        | Quarterly            | จำนวนครั้งที่ทดสอบ DR failover ต่อปี                       |
| Cyber Insurance Coverage Ratio | > 80%                | มูลค่า coverage / estimated max loss                       |
| Third-Party Resilience Score   | > B+                 | vendor resilience assessment rating                        |
| Business Process Recovery      | < 2 hours (Critical) | เวลาที่ core business process กลับมาทำงานได้               |
| Supply Chain Recovery Time     | < 24 hours           | เวลาเปลี่ยนผู้ให้บริการหรือกู้คืนจาก supply chain incident |

### 10.2 Prevention vs Resilience KPI Comparison

| Prevention KPI           | Resilience Alternative          | Why Shift                                         |
| ------------------------ | ------------------------------- | ------------------------------------------------- |
| # of incidents prevented | MTTR from incident              | Prevention ไม่ 100% — speed of recovery สำคัญกว่า |
| # patches applied        | Patch-to-exploit window         | Focus on reducing exposure window                 |
| Phishing click rate      | Phishing report rate + response | Encourage reporting over blame                    |
| Uptime percentage        | Recovery time from disruption   | Resilience = bounce back, not just stay up        |

---

## 11. Security Workforce Development

### 11.1 Skills Gap Landscape

Based on Fortinet 2025 Skills Gap Report:

- 55% ขององค์กรมีทีม security ไม่เพียงพอ
- 65% มีตำแหน่งว่างที่ยังไม่สามารถหาคนมาทำได้
- Top 3 skills ที่ขาดแคลนมากที่สุด: Cloud Security, AI/ML Security, Identity Security

### 11.2 Skills Gap Assessment Template

| Skill Area          | Current Level (1-5) | Target Level | Gap   | Priority       |
| ------------------- | ------------------- | ------------ | ----- | -------------- |
| AI/ML Security      | {LEVEL}             | {TARGET}     | {GAP} | {HIGH/MED/LOW} |
| Cloud Security      | ...                 | ...          | ...   | ...            |
| OT/ICS Security     | ...                 | ...          | ...   | ...            |
| Threat Intelligence | ...                 | ...          | ...   | ...            |
| Identity & Access   | ...                 | ...          | ...   | ...            |
| Post-Quantum Crypto | ...                 | ...          | ...   | ...            |
| Web3/Blockchain     | ...                 | ...          | ...   | ...            |
| Agentic AI Security | ...                 | ...          | ...   | ...            |

### 11.3 Role-Based Competency Matrix

| Role              | Core Skills                   | Certifications               | Training Path   |
| ----------------- | ----------------------------- | ---------------------------- | --------------- |
| SOC Analyst L1-L2 | SIEM, triage, MITRE ATT&CK    | CompTIA CySA+, SC-200        | D4 → D15 → D1   |
| Security Engineer | DevSecOps, cloud, IaC         | AWS Security Specialty, CCSP | D3 → D10 → D5   |
| GRC Analyst       | Compliance, risk, governance  | CISA, ISO 27001 LA           | D9 → D8 → D17   |
| Threat Hunter     | TI, forensics, DFIR           | GCTI, GREM                   | D15 → D2 → D4   |
| CISO/Leadership   | Governance, risk, strategy    | CISSP, CCISO                 | D17 → D16 → D9  |
| AI Security Eng.  | AI/ML, agent security, prompt | AI+ certification            | D12 → D19 → D6  |
| Identity Eng.     | IAM, FIDO2, SPIFFE, ITDR      | SC-300, CIDPRO               | D21 → D11 → D13 |

### 11.4 Training Program Template

**Phase 1 (Month 1-3): Foundation**

- Assign core domain references based on role
- Complete cybersecurity-pro skill exercises for assigned domains
- Score > 70% on skills assessment

**Phase 2 (Month 4-6): Specialization**

- Deep dive into 2-3 specialty domains
- Hands-on lab exercises
- Cross-domain integration scenarios (D16)

**Phase 3 (Month 7-12): Advanced**

- Lead incident response exercises
- Contribute to policy/framework updates
- Mentor junior team members
