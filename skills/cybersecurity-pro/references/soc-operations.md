# SOC Operations Reference

คู่มือการปฏิบัติงาน SOC (Security Operations Center) ระดับ L1 ถึง L3

> สำหรับ IR playbooks และ escalation → ดู references/ir-playbooks.md (Domain 1)
> สำหรับ vulnerability prioritization → ดู references/vulnerability-management.md (Domain 14)
> สำหรับ threat intelligence feeds → ดู references/threat-intelligence.md (Domain 15)
> สำหรับ end-to-end workflow orchestration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 1: IR Playbooks → `references/ir-playbooks.md`
- Domain 14: Vulnerability Management → `references/vulnerability-management.md`
- Domain 15: Threat Intelligence → `references/threat-intelligence.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 17: Security Governance & Executive Leadership → `references/security-governance-executive.md`
- Domain 18: OT/ICS Security → `references/ot-ics-security.md`

## Table of Contents

1. SOC Analyst Roles (L1-L3)
2. Alert Triage Procedure
3. Investigation Playbook per Tier
4. Escalation Matrix
5. SIEM Correlation Rules
6. Threat Hunting Queries
7. Shift Handover Template
8. SOC Metrics & KPIs

---

## 1. SOC Analyst Roles (บทบาท L1-L3)

### L1 — Tier 1: Alert Analyst (นักวิเคราะห์ Alert)

**หน้าที่หลัก**: Monitor, triage, classify alerts

- ตรวจสอบ SIEM alerts ตาม priority queue
- ทำ initial triage: true positive / false positive / benign true positive
- Classify severity ตาม playbook
- Document findings ใน ticketing system
- Escalate ไป L2 เมื่อเกินขอบเขต
- **SLA**: Acknowledge alert ภายใน 15 นาที (Critical), 30 นาที (High)

### L2 — Tier 2: Incident Analyst (นักวิเคราะห์เหตุการณ์)

**หน้าที่หลัก**: Deep investigation, correlation, containment

- รับ escalation จาก L1
- ทำ deep-dive analysis: log correlation, IOC pivot, scope assessment
- ดำเนินการ containment actions (isolate host, block IP, disable account)
- Coordinate กับ IT/Engineering teams
- สร้าง incident timeline
- Escalate ไป L3 สำหรับ advanced threats
- **SLA**: Start investigation ภายใน 30 นาที (Critical)

### L3 — Tier 3: Threat Hunter / Senior Analyst

**หน้าที่หลัก**: Proactive hunting, advanced analysis, forensics

- Threat hunting based on intelligence
- Malware analysis (basic static + dynamic)
- Forensic investigation support
- SIEM rule tuning และ detection engineering
- Threat intelligence integration
- Mentor L1/L2 analysts
- Develop และ maintain playbooks

---

## 2. Alert Triage Procedure (ขั้นตอนการ Triage)

ทุก alert ที่เข้า SOC ต้องผ่าน triage process นี้:

```
Alert เข้ามา
    │
    ▼
┌─────────────────────────┐
│ Step 1: Acknowledge      │  ⏱ ภายใน SLA ตาม severity
│ บันทึกใน ticket system   │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ Step 2: Validate         │  ตรวจสอบว่า alert ถูกต้องหรือไม่
│ • Source reliability?    │
│ • Context makes sense?   │
│ • Known false positive?  │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐     ┌──────────────┐
│ Step 3: Classify         │────▶│ False Positive│──▶ Tune rule, close ticket
│ True Positive?           │     └──────────────┘
│ False Positive?          │     ┌──────────────┐
│ Benign True Positive?    │────▶│ Benign TP    │──▶ Document, whitelist, close
└────────────┬────────────┘     └──────────────┘
             ▼ (True Positive)
┌─────────────────────────┐
│ Step 4: Severity Rating  │
│ • Impact scope?          │
│ • Data classification?   │
│ • System criticality?    │
│ • Active vs historical?  │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ Step 5: Initial Analysis │
│ • Collect context logs   │
│ • Check IOCs against TI  │
│ • Identify affected      │
│   users/systems          │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐     ┌──────────────────┐
│ Step 6: Can L1 handle?   │────▶│ No → Escalate L2 │
│ (within L1 playbook?)    │     └──────────────────┘
└────────────┬────────────┘
             ▼ (Yes)
┌─────────────────────────┐
│ Step 7: Respond          │
│ Execute playbook steps   │
│ Document all actions     │
│ Update ticket            │
└────────────┬────────────┘
             ▼
┌─────────────────────────┐
│ Step 8: Close / Monitor  │
│ Verify resolution        │
│ Update knowledge base    │
└─────────────────────────┘
```

---

## 3. Investigation Playbook per Tier

### L1 Investigation Checklist

สำหรับทุก alert ที่เป็น True Positive, L1 ต้องรวบรวม:

```markdown
## L1 Initial Investigation Form

**Alert ID**: [ID]
**Timestamp**: [UTC]
**Alert Source**: [SIEM rule name / EDR detection]
**Severity**: [Critical/High/Medium/Low]

### Context Gathering

- [ ] Source IP/hostname ของ alert: \_\_\_
- [ ] Destination IP/hostname: \_\_\_
- [ ] User account ที่เกี่ยวข้อง: \_\_\_
- [ ] เวลาที่เกิดเหตุ (UTC): \_\_\_
- [ ] จำนวนครั้งที่เกิดซ้ำ (last 24h): \_\_\_

### Quick Checks

- [ ] IP/Domain ตรวจสอบกับ Threat Intelligence (VirusTotal, AbuseIPDB): ผลลัพธ์ \_\_\_
- [ ] User account ปกติหรือไม่ (check last login, location): \_\_\_
- [ ] ระบบนี้อยู่ใน Critical Asset list หรือไม่: \_\_\_
- [ ] มี related alerts อื่นจาก host/user เดียวกันหรือไม่: \_\_\_

### Decision

- [ ] False Positive → Reason: \_\_\_
- [ ] Benign True Positive → Reason: \_\_\_
- [ ] True Positive → Escalate to L2 with this form
```

### L2 Deep Investigation Template

```markdown
## L2 Investigation Report

**Incident ID**: [INC-YYYY-XXX]
**Escalated from**: [Alert ID]
**L2 Analyst**: [Name]
**Investigation Start**: [UTC]

### Scope Assessment

- จำนวน hosts ที่ได้รับผลกระทบ: \_\_\_
- จำนวน users ที่ได้รับผลกระทบ: \_\_\_
- Data classification ที่เกี่ยวข้อง: \_\_\_
- Lateral movement detected: Yes / No

### Log Analysis

| Log Source | Time Range | Key Findings |
| ---------- | ---------- | ------------ |
| SIEM       |            |              |
| EDR        |            |              |
| Firewall   |            |              |
| Proxy      |            |              |
| AD/IAM     |            |              |

### MITRE ATT&CK Mapping

| Tactic | Technique | Evidence |
| ------ | --------- | -------- |

### IOCs Identified

| Type | Value | Confidence |
| ---- | ----- | ---------- |

### Containment Actions Taken

| เวลา (Time) | การดำเนินการ (Action) | ผลลัพธ์ (Result) | ผู้อนุมัติ (Approved By) |
| ----------- | --------------------- | ---------------- | ------------------------ |

### Recommendations

- Immediate: \_\_\_
- Follow-up: \_\_\_
- Escalate to L3: Yes / No — Reason: \_\_\_
```

---

## 4. Escalation Matrix

| สถานการณ์ (Condition)              | Escalate To                    | ช่องทาง (Channel)   | ภายใน (Within) |
| ---------------------------------- | ------------------------------ | ------------------- | -------------- |
| Alert ที่ L1 ไม่มี playbook        | L2 Analyst                     | Ticket + Slack      | 15 min         |
| Confirmed malware execution        | L2 Analyst + SOC Manager       | Ticket + Phone      | ทันที          |
| Active data exfiltration           | L2/L3 + IR Manager + CISO      | Phone + War Room    | ทันที          |
| Ransomware detected                | L3 + IR Manager + CISO + Legal | Phone + War Room    | ทันที          |
| Multiple systems compromised       | L3 + IR Manager + IT Manager   | Ticket + Phone      | 30 min         |
| Insider threat suspected           | L3 + HR + Legal + CISO         | Secure channel only | 1 hr           |
| Third-party breach (supply chain)  | L3 + Vendor Management + Legal | Email + Phone       | 2 hr           |
| ต้องแจ้ง สกมช./NCSA (CII incident) | CISO + Legal + Compliance      | Formal notification | 72 hr (กฎหมาย) |

### Escalation Rules

1. **Never** ลดระดับ severity โดยไม่ได้รับอนุมัติจาก SOC Manager
2. เมื่อ doubt → escalate (ดีกว่า under-escalate)
3. Document ทุก escalation decision พร้อมเหตุผล
4. Critical/High incidents ต้อง notify SOC Manager แม้นอกเวลาทำการ

---

### SIEM/XDR Platform Options

| Platform                       | Type       | Query Language   | Strengths                                                                              |
| ------------------------------ | ---------- | ---------------- | -------------------------------------------------------------------------------------- |
| **Splunk Enterprise Security** | SIEM       | SPL              | Mature ecosystem, custom apps, flexible data model                                     |
| **Elastic Security**           | SIEM/XDR   | EQL, KQL, Lucene | Open-source core, scalable, detection rules as code                                    |
| **Microsoft Sentinel**         | Cloud SIEM | KQL              | Native Azure/M365 integration, AI-driven analytics, cost-effective for Microsoft shops |
| **Microsoft Defender XDR**     | XDR        | KQL              | Unified endpoint/identity/email/cloud protection, auto investigation & response        |
| **Google Chronicle**           | SIEM       | YARA-L           | Petabyte-scale, VirusTotal integration, fixed pricing                                  |
| **Wazuh**                      | SIEM/XDR   | —                | Open-source, agent-based, compliance monitoring                                        |
| **QRadar** (IBM)               | SIEM       | AQL              | Strong correlation engine, offense-based workflows                                     |

> เลือก platform ตามขนาดองค์กร, cloud strategy, และ existing vendor ecosystem
> สำหรับ OT/ICS monitoring → ดู references/ot-ics-security.md (Domain 18) สำหรับ OT-specific SIEM integration patterns

## 5. SIEM Correlation Rules (ตัวอย่าง)

### Brute Force Detection

```
Rule: Multiple Failed Logins Followed by Success
Condition:
  - event_type = "authentication_failure"
  - count >= 5 within 10 minutes
  - same source_ip AND same target_user
  - THEN event_type = "authentication_success" within 5 minutes
Severity: High
MITRE: T1110 (Brute Force)
Action: Alert L1 + auto-block source_ip for 1 hour
```

### Possible Data Exfiltration

```
Rule: Large Outbound Transfer to Uncommon Destination
Condition:
  - direction = "outbound"
  - bytes_sent > 100MB within 1 hour
  - destination_ip NOT IN approved_destinations
  - destination_country NOT IN approved_countries
Severity: High
MITRE: T1048 (Exfiltration Over Alternative Protocol)
Action: Alert L2 + capture full packet for analysis
```

### Lateral Movement Detection

```
Rule: Multiple RDP/SSH Connections from Single Host
Condition:
  - (event_type = "rdp_connection" OR event_type = "ssh_connection")
  - source_host = same
  - destination_host count >= 3 unique within 30 minutes
  - source_host NOT IN jump_servers
Severity: Medium-High
MITRE: T1021 (Remote Services)
Action: Alert L2 + enrich with EDR data
```

---

## 6. Threat Hunting Queries (ตัวอย่าง)

### Splunk Queries

```spl
# หา PowerShell encoded commands (T1059.001)
index=windows EventCode=4688
| where like(CommandLine, "%powershell%") AND (like(CommandLine, "%-enc%") OR like(CommandLine, "%-e %") OR like(CommandLine, "%encodedcommand%"))
| stats count by ComputerName, User, CommandLine

# หา unusual outbound connections
index=firewall action=allowed direction=outbound
| where dest_port NOT IN (80, 443, 53, 25, 587)
| stats count dc(dest_ip) as unique_destinations by src_ip
| where unique_destinations > 50

# หา credential dumping indicators (T1003)
index=windows (EventCode=4656 OR EventCode=4663)
| where ObjectName="*\\lsass.exe" OR ObjectName="*\\SAM" OR ObjectName="*\\SECURITY"
| stats count by ComputerName, SubjectUserName, ObjectName
```

### KQL Queries (Microsoft Sentinel / Defender)

```kql
// หา suspicious process creation
DeviceProcessEvents
| where Timestamp > ago(24h)
| where FileName in~ ("mimikatz.exe", "procdump.exe", "psexec.exe", "sharphound.exe")
    or ProcessCommandLine has_any ("sekurlsa", "lsadump", "dcsync", "kerberoast")
| project Timestamp, DeviceName, AccountName, FileName, ProcessCommandLine

// หา impossible travel
SigninLogs
| where TimeGenerated > ago(7d)
| where ResultType == 0
| summarize locations=make_set(Location), count() by UserPrincipalName
| where array_length(locations) > 3
```

---

## 7. Shift Handover Template

```markdown
# SOC Shift Handover Report

# รายงานส่งเวร SOC

**Date**: [Date]
**Shift**: [Morning/Afternoon/Night]
**Outgoing Analyst(s)**: [Names]
**Incoming Analyst(s)**: [Names]
**Handover Time**: [UTC]

---

## เหตุการณ์ที่ยังดำเนินอยู่ (Open Incidents)

| Incident ID | Severity | สถานะ (Status) | สิ่งที่ต้องทำต่อ (Next Action) | ผู้รับผิดชอบ (Owner) |
| ----------- | -------- | -------------- | ------------------------------ | -------------------- |

## Alerts ที่รอดำเนินการ (Pending Alerts)

- จำนวน alerts ใน queue: [N]
- Critical/High ที่รอ: [N]
- Oldest unacknowledged alert: [time]

## สิ่งที่น่าสังเกตระหว่าง shift (Notable Events)

[สรุปเหตุการณ์สำคัญ, false positive trends, system issues]

## Scheduled Maintenance / Changes

[planned changes ที่อาจสร้าง alerts]

## ปัญหาของเครื่องมือ/ระบบ (Tool/System Issues)

[SIEM lag, EDR agent offline, etc.]

## หมายเหตุเพิ่มเติม (Additional Notes)

[anything else the incoming shift needs to know]

**Outgoing Signature**: \***\*\_\_\_\*\***
**Incoming Signature**: \***\*\_\_\_\*\***
```

---

## 8. SOC Metrics & KPIs

### Operational Metrics

| Metric                              | คำอธิบาย (Description)                 | เป้าหมาย (Target)                |
| ----------------------------------- | -------------------------------------- | -------------------------------- |
| MTTA (Mean Time to Acknowledge)     | เวลาเฉลี่ยจาก alert ถึง acknowledge    | Critical: <15 min, High: <30 min |
| MTTD (Mean Time to Detect)          | เวลาเฉลี่ยจากเหตุการณ์ถึง detection    | <24 hours                        |
| MTTI (Mean Time to Investigate)     | เวลาเฉลี่ยในการ investigate            | <2 hours (High/Critical)         |
| MTTR (Mean Time to Respond/Resolve) | เวลาเฉลี่ยจาก detection ถึง resolution | Critical: <4 hr, High: <8 hr     |
| False Positive Rate                 | % ของ alerts ที่เป็น false positive    | <30% (ยิ่งต่ำยิ่งดี)             |
| Escalation Rate (L1→L2)             | % ของ alerts ที่ L1 escalate ไป L2     | 20-40%                           |
| Alert Volume                        | จำนวน alerts ต่อวัน/สัปดาห์            | Track trend                      |
| Ticket Backlog                      | จำนวน tickets ที่ค้าง                  | <20 (end of shift)               |

### Strategic Metrics

| Metric                   | คำอธิบาย (Description)                         | ความถี่ (Frequency) |
| ------------------------ | ---------------------------------------------- | ------------------- |
| MITRE ATT&CK Coverage    | % ของ techniques ที่มี detection rule          | Monthly             |
| Dwell Time               | เวลาที่ attacker อยู่ในระบบก่อน detect         | Per incident        |
| Detection-to-Containment | เวลาจาก detect ถึง contain                     | Per incident        |
| SOC Analyst Utilization  | % ของเวลาที่ analyst ใช้กับ investigation จริง | Monthly             |
| Playbook Coverage        | % ของ incident types ที่มี playbook            | Quarterly           |

---

## 9. SOAR Automation Patterns (รูปแบบ SOAR Automation)

### Common SOAR Playbooks

| Playbook             | Trigger                        | Automated Actions                                                                 | ผลลัพธ์ (Outcome) |
| -------------------- | ------------------------------ | --------------------------------------------------------------------------------- | ----------------- |
| Phishing Response    | Email reported / SIEM alert    | Extract IOCs → Check TI → Block sender → Quarantine email → Notify user           | MTTA < 5 min      |
| Brute Force Response | Failed login threshold         | Validate alert → Block IP (temp) → Check geo/TI → Enrich with EDR → Create ticket | MTTA < 2 min      |
| Malware Detection    | EDR alert                      | Isolate host → Collect artifacts → Check hash in TI → Notify L2 → Create incident | MTTC < 10 min     |
| Ransomware Response  | EDR + file entropy alert       | Isolate host → Disable user → Snapshot → Alert IR Manager + CISO → War room       | MTTC < 5 min      |
| Suspicious Login     | Impossible travel / new device | Check location history → MFA challenge → Block if failed → Enrich with context    | MTTA < 3 min      |

### Enrichment Sources

| Source           | ข้อมูลที่ได้ (Data)          | ใช้สำหรับ (Used For)  |
| ---------------- | ---------------------------- | --------------------- |
| VirusTotal       | Hash/IP/Domain reputation    | IOC validation        |
| AbuseIPDB        | IP abuse history             | Brute force, scanning |
| Shodan           | Open ports, services         | Exposure assessment   |
| MITRE ATT&CK     | Technique mapping            | Context enrichment    |
| Internal CMDB    | Asset ownership, criticality | Impact assessment     |
| Active Directory | User role, last login        | User context          |

### SOAR Architecture Pattern (Wazuh + n8n/XSOAR)

```
Wazuh SIEM          SOAR Platform        Firewall/EDR
(Detection)    →    (Orchestration)  →   (Response)
  Alerts             Playbooks            Block IP
  Events             Enrichment           Isolate Host
  Rules              Decision Logic       Disable Account
                         ↓
                    Notifications
                    (Slack/Teams/Email)
```

### Automation Metrics

| Metric                          | คำอธิบาย (Description)            | เป้าหมาย (Target)    |
| ------------------------------- | --------------------------------- | -------------------- |
| MTTD (Mean Time to Detect)      | เวลาจาก event ถึง detection       | < 1 ชั่วโมง          |
| MTTA (Mean Time to Acknowledge) | เวลาจาก alert ถึง acknowledge     | < 5 นาที (automated) |
| MTTR (Mean Time to Respond)     | เวลาจาก detection ถึง containment | < 30 นาที            |
| Automation Rate                 | % ของ alerts ที่ handle อัตโนมัติ | > 60%                |
| Playbook Execution Success      | % ของ playbook runs ที่สำเร็จ     | > 95%                |

### SRE-Inspired Security SLI/SLOs

| SLI                         | คำอธิบาย (Description)                       | SLO Target                     |
| --------------------------- | -------------------------------------------- | ------------------------------ |
| MTTD for security incidents | เวลาเฉลี่ยจากเหตุการณ์ถึง detection          | < 24 hr (P50), < 4 hr (P95)    |
| MTTR for security incidents | เวลาเฉลี่ยจาก detection ถึง resolution       | Critical: < 4 hr, High: < 8 hr |
| False positive rate         | อัตรา false positive ของ SIEM rules          | < 30% (error budget)           |
| Detection coverage          | % ของ MITRE ATT&CK techniques ที่ detect ได้ | > 80%                          |

**Severity Framework Mapping (SRE → SOC):**

| SRE Level  | SOC Level        | คำอธิบาย (Description)                 | Response    |
| ---------- | ---------------- | -------------------------------------- | ----------- |
| P1 (SEV-1) | Critical (วิกฤต) | Active breach, data exfiltration       | ทันที, 24/7 |
| P2 (SEV-2) | High (สูง)       | Confirmed malware, unauthorized access | ภายใน 1 hr  |
| P3 (SEV-3) | Medium (ปานกลาง) | Suspicious activity, policy violation  | ภายใน 4 hr  |
| P4 (SEV-4) | Low (ต่ำ)        | Minor policy violation, info alert     | ภายใน 24 hr |
