# Incident Response Playbooks & Runbooks Reference

คู่มือการสร้าง IR Playbook และ Runbook ระดับมืออาชีพ

> สำหรับ forensic investigation → ดู references/dfir-reports.md (Domain 2)
> สำหรับ SOC triage และ alert handling → ดู references/soc-operations.md (Domain 4)
> สำหรับ threat intelligence enrichment → ดู references/threat-intelligence.md (Domain 15)
> สำหรับ end-to-end workflow orchestration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 2: DFIR Reports → `references/dfir-reports.md`
- Domain 4: SOC Operations → `references/soc-operations.md`
- Domain 15: Threat Intelligence → `references/threat-intelligence.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`

## Table of Contents

1. Playbook vs Runbook
2. Playbook Template
3. Runbook Template
4. Common Incident Playbooks
5. NIST 800-61 Phase Mapping
6. Severity & Escalation Matrix

---

## 1. Playbook vs Runbook (ความแตกต่าง)

**Playbook** = เอกสารเชิงกลยุทธ์ที่อธิบาย "ทำอะไร" และ "ทำไม" สำหรับ incident type หนึ่งๆ

- ระดับสูง, decision-based, มี decision trees
- เหมาะกับ L2/L3 analysts และ Incident Managers

**Runbook** = เอกสารเชิงปฏิบัติที่อธิบาย "ทำอย่างไร" แบบ step-by-step

- ระดับปฏิบัติ, command-level, copy-paste ได้เลย
- เหมาะกับ L1/L2 analysts

---

## 2. Playbook Template

Use this exact structure for every playbook:

```markdown
# [Incident Type] Playbook

# Playbook: [ชื่อ Incident Type]

**Playbook ID**: PB-[XXX]
**Version**: [x.x]
**Last Updated**: [Date]
**Owner**: [Team/Role]
**Severity Range**: [Critical/High/Medium/Low]
**MITRE ATT&CK Mapping**: [Tactic] - [Technique IDs]

---

## 1. ภาพรวม (Overview)

[คำอธิบาย incident type นี้คืออะไร, ผลกระทบที่อาจเกิดขึ้น]

## 2. ขอบเขต (Scope)

- ระบบที่ได้รับผลกระทบ (Affected Systems):
- ข้อมูลที่เกี่ยวข้อง (Data Classification):
- ทีมที่รับผิดชอบ (Responsible Teams):

## 3. ตัวบ่งชี้การโจมตี (Detection Indicators)

### IOCs (Indicators of Compromise)

| ประเภท (Type) | ค่า (Value) | แหล่งที่มา (Source) | ความเชื่อมั่น (Confidence) |
| ------------- | ----------- | ------------------- | -------------------------- |

### MITRE ATT&CK Mapping

| Tactic | Technique | Sub-technique | ID  |
| ------ | --------- | ------------- | --- |

## 4. การจำแนกความรุนแรง (Severity Classification)

| ระดับ (Level)    | เงื่อนไข (Criteria) | SLA Response | SLA Resolution |
| ---------------- | ------------------- | ------------ | -------------- |
| Critical (วิกฤต) | [criteria]          | 15 นาที      | 4 ชั่วโมง      |
| High (สูง)       | [criteria]          | 30 นาที      | 8 ชั่วโมง      |
| Medium (ปานกลาง) | [criteria]          | 1 ชั่วโมง    | 24 ชั่วโมง     |
| Low (ต่ำ)        | [criteria]          | 4 ชั่วโมง    | 72 ชั่วโมง     |

## 5. ขั้นตอนการตอบสนอง (Response Procedures)

### Phase 1: การเตรียมความพร้อม (Preparation) — NIST 800-61 §3.1

[สิ่งที่ต้องเตรียมก่อนเกิดเหตุ: tools, access, contacts]

### Phase 2: การตรวจจับและวิเคราะห์ (Detection & Analysis) — NIST 800-61 §3.2

[ขั้นตอนการ detect, validate, analyze]

- Step 1: ...
- Step 2: ...
- Decision Point: [Yes/No decision tree]

### Phase 3: การควบคุมและกำจัด (Containment, Eradication & Recovery) — NIST 800-61 §3.3

#### 3a. Short-term Containment (การควบคุมเฉพาะหน้า)

#### 3b. Long-term Containment (การควบคุมระยะยาว)

#### 3c. Eradication (การกำจัด)

#### 3d. Recovery (การกู้คืน)

### Phase 4: กิจกรรมหลังเหตุการณ์ (Post-Incident Activity) — NIST 800-61 §3.4

- Lessons Learned meeting
- Playbook improvements
- Metrics collection

## 6. การสื่อสารและ Escalation (Communication & Escalation)

| สถานการณ์ (Condition) | แจ้ง (Notify) | ช่องทาง (Channel) | ภายใน (Within) |
| --------------------- | ------------- | ----------------- | -------------- |

## 7. เครื่องมือที่ใช้ (Tools)

| เครื่องมือ (Tool) | วัตถุประสงค์ (Purpose) | ประเภท (Type) |
| ----------------- | ---------------------- | ------------- |

## 8. ภาคผนวก (Appendix)

- Related Playbooks
- Reference links
- Revision history
```

---

## 3. Runbook Template

````markdown
# Runbook: [Specific Task Name]

**Runbook ID**: RB-[XXX]
**Related Playbook**: PB-[XXX]
**Skill Level**: L1 / L2 / L3
**Estimated Time**: [minutes]
**Prerequisites**: [tools, access, permissions needed]

---

## ขั้นตอนปฏิบัติ (Procedure)

### Step 1: [Action Name]

**วัตถุประสงค์ (Objective)**: [what this step achieves]

```bash
# คำสั่งที่ต้องรัน (Commands to execute)
[actual command]
```
````

**ผลลัพธ์ที่คาดหวัง (Expected Output)**:
[what you should see]

**ถ้าไม่ตรง (If unexpected)**:
→ [troubleshooting step or escalation]

### Step 2: ...

[repeat pattern]

---

## Decision Points

- ถ้า [condition A] → ไปที่ Step X
- ถ้า [condition B] → Escalate ไปที่ L2/L3
- ถ้า [condition C] → ปิด ticket พร้อม resolution note

## Escalation Criteria

- Escalate ทันทีถ้า: [conditions]
- แจ้ง Incident Manager ถ้า: [conditions]

---

## 4. Common Incident Playbooks

When the user asks for a playbook without specifying a type, offer these standard options:

| ID     | Incident Type                   | MITRE Tactic                     | Key Techniques          |
| ------ | ------------------------------- | -------------------------------- | ----------------------- |
| PB-001 | Phishing / Spear Phishing       | Initial Access                   | T1566.001, T1566.002    |
| PB-002 | Ransomware                      | Impact                           | T1486, T1490, T1489     |
| PB-003 | Data Breach / Data Exfiltration | Exfiltration                     | T1041, T1048, T1567     |
| PB-004 | DDoS Attack                     | Impact                           | T1498, T1499            |
| PB-005 | Insider Threat                  | Collection, Exfiltration         | T1074, T1041, T1530     |
| PB-006 | Supply Chain Attack             | Initial Access                   | T1195.001, T1195.002    |
| PB-007 | Cloud Security Incident         | Various                          | T1078.004, T1537, T1580 |
| PB-008 | Unauthorized Access             | Credential Access                | T1110, T1078, T1556     |
| PB-009 | Malware Infection               | Execution                        | T1059, T1204, T1203     |
| PB-010 | Business Email Compromise       | Initial Access, Lateral Movement | T1566.001, T1534        |

---

## 5. NIST 800-61 Phase Mapping

Every playbook phase maps to NIST SP 800-61 Rev.2:

```

┌─────────────────┐ ┌─────────────────────┐ ┌──────────────────────────────┐ ┌─────────────────────┐
│ Preparation │ ──▶ │ Detection & Analysis │ ──▶ │ Containment, Eradication │ ──▶ │ Post-Incident │
│ §3.1 │ │ §3.2 │ │ & Recovery §3.3 │ │ Activity §3.4 │
│ │ │ │ │ │ │ │
│ • IR plan │ │ • Alert triage │ │ • Short-term containment │ │ • Lessons learned │
│ • Tools ready │ │ • IOC validation │ │ • Evidence preservation │ │ • Metrics review │
│ • Team trained │ │ • Severity rating │ │ • Eradication │ │ • Playbook update │
│ • Contacts list │ │ • Scope assessment │ │ • System recovery │ │ • Report creation │
└─────────────────┘ └─────────────────────┘ └──────────────────────────────┘ └─────────────────────┘
▲ │
└──────────────────────────────────────────────────────────────────────────────────────────┘
Continuous Improvement Loop

```

---

## 6. Severity & Escalation Matrix

Default severity matrix (ปรับตามบริบทองค์กร):

| Severity         | Impact                                                     | SLA: Acknowledge | SLA: Contain | SLA: Resolve | Escalation                       |
| ---------------- | ---------------------------------------------------------- | ---------------- | ------------ | ------------ | -------------------------------- |
| Critical (วิกฤต) | Production down, data breach active, ransomware spreading  | 15 min           | 1 hr         | 4 hr         | SOC Manager + CISO + Legal ทันที |
| High (สูง)       | Service degraded, confirmed malware, credential compromise | 30 min           | 2 hr         | 8 hr         | SOC Manager + IR Lead            |
| Medium (ปานกลาง) | Suspicious activity confirmed, policy violation            | 1 hr             | 4 hr         | 24 hr        | L2 Analyst + Team Lead           |
| Low (ต่ำ)        | False positive ruled out but needs tracking, minor policy  | 4 hr             | 8 hr         | 72 hr        | L1 Analyst                       |
| Info (ข้อมูล)    | Security awareness item, no immediate threat               | 24 hr            | N/A          | 1 week       | Ticket only                      |

### Thai Legal Requirements (พ.ร.บ. ไซเบอร์ 2562)

- Critical incidents affecting Critical Information Infrastructure (CII) ต้องแจ้ง สกมช. (NCSA) ภายใน 72 ชั่วโมง
- Data breach incidents ต้องแจ้ง สำนักงานคุ้มครองข้อมูลส่วนบุคคล ตาม พ.ร.บ. PDPA

---

## 7. Security Incident Post-Mortem Template (แม่แบบ Post-Mortem)

ใช้ blameless post-mortem format สำหรับทุก incident ระดับ High/Critical:

```markdown
# Security Incident Post-Mortem

# รายงาน Post-Mortem เหตุการณ์ด้านความปลอดภัย

**Incident ID**: [INC-YYYY-XXX]
**Post-Mortem Date**: [Date]
**Facilitator**: [Name]
**Attendees**: [Names]

---

## สรุปผู้บริหาร (Executive Summary)

[สรุป 2-3 ประโยค: เกิดอะไร, ผลกระทบ, สถานะปัจจุบัน]

## Timeline (เส้นเวลา)

| เวลา (Time UTC)  | เหตุการณ์ (Event)                 | ผู้ดำเนินการ (Actor) |
| ---------------- | --------------------------------- | -------------------- |
| YYYY-MM-DD HH:MM | [Initial detection / alert fired] | SIEM / EDR           |
|                  | [Investigation started]           | L1 Analyst           |
|                  | [Escalated to L2/L3]              | L1 → L2              |
|                  | [Containment action taken]        | L2 Analyst           |
|                  | [Root cause identified]           | L3 / IR Team         |
|                  | [Eradication completed]           | IR Team              |
|                  | [Recovery / service restored]     | IT Ops               |

## สาเหตุหลัก (Root Cause)

[อธิบายสาเหตุที่แท้จริง — ไม่ใช่ symptom แต่เป็น WHY]

## ผลกระทบ (Impact)

- **ขอบเขต (Scope)**: [จำนวน systems/users ที่ได้รับผลกระทบ]
- **ข้อมูล (Data)**: [ประเภทข้อมูลที่ถูกกระทบ, classification]
- **ระยะเวลา (Duration)**: [เวลาตั้งแต่ initial compromise ถึง containment]
- **ธุรกิจ (Business)**: [ผลกระทบต่อธุรกิจ/ลูกค้า]

## MITRE ATT&CK Mapping

| Tactic | Technique | ID  | Evidence |
| ------ | --------- | --- | -------- |

## สิ่งที่ทำได้ดี (What Went Well)

- [detection ทำงานได้ดี — alert fired ภายใน X นาที]
- [containment รวดเร็ว — isolate host ภายใน X นาที]

## สิ่งที่ต้องปรับปรุง (What Needs Improvement)

- [detection gap: ไม่มี rule สำหรับ technique X]
- [response delay: escalation ช้าเพราะ Y]

## Action Items

| #   | รายการ (Action Item)                  | ผู้รับผิดชอบ (Owner) | กำหนดเสร็จ (Due Date) | สถานะ (Status) |
| --- | ------------------------------------- | -------------------- | --------------------- | -------------- |
| 1   | [เพิ่ม SIEM detection rule สำหรับ...] | Detection Eng.       | [date]                | Open           |
| 2   | [Update playbook PB-XXX]              | SOC Lead             | [date]                | Open           |
| 3   | [Patch vulnerability CVE-XXXX]        | Platform             | [date]                | Open           |

## Metrics

- **MTTD**: [เวลาจาก compromise ถึง detection]
- **MTTC**: [เวลาจาก detection ถึง containment]
- **MTTR**: [เวลาจาก detection ถึง full recovery]
```

### Timeline Reconstruction Checklist

เมื่อสร้าง timeline สำหรับ post-mortem ให้ตรวจสอบ sources เหล่านี้:

- [ ] SIEM alerts และ logs (เวลาที่ alert fired)
- [ ] EDR telemetry (process execution, network connections)
- [ ] Firewall / proxy logs (network activity)
- [ ] Authentication logs (login attempts, MFA events)
- [ ] Ticket system (เวลา escalation, actions taken)
- [ ] Communication logs (Slack/Teams timestamps)
- [ ] Cloud audit logs (AWS CloudTrail, Azure Activity Log)
