# SOC Operations Reference

คู่มือการปฏิบัติงาน SOC (Security Operations Center) ระดับ L1 ถึง L3

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
- [ ] Source IP/hostname ของ alert: ___
- [ ] Destination IP/hostname: ___
- [ ] User account ที่เกี่ยวข้อง: ___
- [ ] เวลาที่เกิดเหตุ (UTC): ___
- [ ] จำนวนครั้งที่เกิดซ้ำ (last 24h): ___

### Quick Checks
- [ ] IP/Domain ตรวจสอบกับ Threat Intelligence (VirusTotal, AbuseIPDB): ผลลัพธ์ ___
- [ ] User account ปกติหรือไม่ (check last login, location): ___
- [ ] ระบบนี้อยู่ใน Critical Asset list หรือไม่: ___
- [ ] มี related alerts อื่นจาก host/user เดียวกันหรือไม่: ___

### Decision
- [ ] False Positive → Reason: ___
- [ ] Benign True Positive → Reason: ___
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
- จำนวน hosts ที่ได้รับผลกระทบ: ___
- จำนวน users ที่ได้รับผลกระทบ: ___
- Data classification ที่เกี่ยวข้อง: ___
- Lateral movement detected: Yes / No

### Log Analysis
| Log Source | Time Range | Key Findings |
|---|---|---|
| SIEM | | |
| EDR | | |
| Firewall | | |
| Proxy | | |
| AD/IAM | | |

### MITRE ATT&CK Mapping
| Tactic | Technique | Evidence |
|---|---|---|

### IOCs Identified
| Type | Value | Confidence |
|---|---|---|

### Containment Actions Taken
| เวลา (Time) | การดำเนินการ (Action) | ผลลัพธ์ (Result) | ผู้อนุมัติ (Approved By) |
|---|---|---|---|

### Recommendations
- Immediate: ___
- Follow-up: ___
- Escalate to L3: Yes / No — Reason: ___
```

---

## 4. Escalation Matrix

| สถานการณ์ (Condition) | Escalate To | ช่องทาง (Channel) | ภายใน (Within) |
|---|---|---|---|
| Alert ที่ L1 ไม่มี playbook | L2 Analyst | Ticket + Slack | 15 min |
| Confirmed malware execution | L2 Analyst + SOC Manager | Ticket + Phone | ทันที |
| Active data exfiltration | L2/L3 + IR Manager + CISO | Phone + War Room | ทันที |
| Ransomware detected | L3 + IR Manager + CISO + Legal | Phone + War Room | ทันที |
| Multiple systems compromised | L3 + IR Manager + IT Manager | Ticket + Phone | 30 min |
| Insider threat suspected | L3 + HR + Legal + CISO | Secure channel only | 1 hr |
| Third-party breach (supply chain) | L3 + Vendor Management + Legal | Email + Phone | 2 hr |
| ต้องแจ้ง สกมช./NCSA (CII incident) | CISO + Legal + Compliance | Formal notification | 72 hr (กฎหมาย) |

### Escalation Rules
1. **Never** ลดระดับ severity โดยไม่ได้รับอนุมัติจาก SOC Manager
2. เมื่อ doubt → escalate (ดีกว่า under-escalate)
3. Document ทุก escalation decision พร้อมเหตุผล
4. Critical/High incidents ต้อง notify SOC Manager แม้นอกเวลาทำการ

---

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
|---|---|---|---|---|

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

**Outgoing Signature**: ___________
**Incoming Signature**: ___________
```

---

## 8. SOC Metrics & KPIs

### Operational Metrics

| Metric | คำอธิบาย (Description) | เป้าหมาย (Target) |
|---|---|---|
| MTTA (Mean Time to Acknowledge) | เวลาเฉลี่ยจาก alert ถึง acknowledge | Critical: <15 min, High: <30 min |
| MTTD (Mean Time to Detect) | เวลาเฉลี่ยจากเหตุการณ์ถึง detection | <24 hours |
| MTTI (Mean Time to Investigate) | เวลาเฉลี่ยในการ investigate | <2 hours (High/Critical) |
| MTTR (Mean Time to Respond/Resolve) | เวลาเฉลี่ยจาก detection ถึง resolution | Critical: <4 hr, High: <8 hr |
| False Positive Rate | % ของ alerts ที่เป็น false positive | <30% (ยิ่งต่ำยิ่งดี) |
| Escalation Rate (L1→L2) | % ของ alerts ที่ L1 escalate ไป L2 | 20-40% |
| Alert Volume | จำนวน alerts ต่อวัน/สัปดาห์ | Track trend |
| Ticket Backlog | จำนวน tickets ที่ค้าง | <20 (end of shift) |

### Strategic Metrics

| Metric | คำอธิบาย (Description) | ความถี่ (Frequency) |
|---|---|---|
| MITRE ATT&CK Coverage | % ของ techniques ที่มี detection rule | Monthly |
| Dwell Time | เวลาที่ attacker อยู่ในระบบก่อน detect | Per incident |
| Detection-to-Containment | เวลาจาก detect ถึง contain | Per incident |
| SOC Analyst Utilization | % ของเวลาที่ analyst ใช้กับ investigation จริง | Monthly |
| Playbook Coverage | % ของ incident types ที่มี playbook | Quarterly |
