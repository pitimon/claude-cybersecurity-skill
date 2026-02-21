# Digital Forensics & Incident Response Reports Reference

คู่มือการสร้างรายงานนิติวิทยาศาสตร์ดิจิทัลและรายงานการตอบสนองเหตุการณ์ระดับมืออาชีพ

> สำหรับ IR playbooks และ response procedures → ดู references/ir-playbooks.md (Domain 1)
> สำหรับ SOC operations และ SIEM correlation → ดู references/soc-operations.md (Domain 4)
> สำหรับ threat intelligence และ IOC management → ดู references/threat-intelligence.md (Domain 15)
> สำหรับ end-to-end workflow orchestration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 1: IR Playbooks → `references/ir-playbooks.md`
- Domain 4: SOC Operations → `references/soc-operations.md`
- Domain 15: Threat Intelligence → `references/threat-intelligence.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`

## Table of Contents

1. Report Types
2. Forensic Investigation Report Template
3. Chain of Custody Documentation
4. Timeline Reconstruction
5. IOC Documentation
6. Evidence Handling Procedures
7. Tool Reference

---

## 1. Report Types (ประเภทรายงาน)

| Report Type                   | Use Case                                | Audience                           | Format            |
| ----------------------------- | --------------------------------------- | ---------------------------------- | ----------------- |
| Forensic Investigation Report | รายงานการสอบสวนเต็มรูปแบบ               | Management, Legal, Law Enforcement | .docx             |
| Threat Analysis Report        | การวิเคราะห์ภัยคุกคามเฉพาะ              | SOC Team, IR Team                  | .md or .docx      |
| Malware Analysis Report       | วิเคราะห์ malware ทั้ง static + dynamic | IR Team, Threat Intel              | .md or .docx      |
| Root Cause Analysis (RCA)     | หาสาเหตุหลังจบ incident                 | Management, Engineering            | .docx             |
| Executive Summary             | สรุปสำหรับผู้บริหาร                     | C-Suite, Board                     | .docx (1-2 pages) |

---

## 2. Forensic Investigation Report Template

Use this structure for formal forensic reports (use `docx` skill for production):

```markdown
# รายงานการสอบสวนทางนิติวิทยาศาสตร์ดิจิทัล

# Digital Forensic Investigation Report

**Case Number**: DFIR-[YYYY]-[XXX]
**Classification**: [Confidential / Internal / Restricted]
**Report Date**: [Date]
**Investigator(s)**: [Names, Titles, Certifications]
**Reviewed By**: [Name, Title]

---

## บทสรุปผู้บริหาร (Executive Summary)

[2-3 paragraphs: สรุปเหตุการณ์, ผลการสอบสวน, ผลกระทบ, ข้อเสนอแนะหลัก]
[เขียนให้ผู้บริหารที่ไม่มีพื้นฐานเทคนิคเข้าใจได้]

## 1. ข้อมูลเหตุการณ์ (Incident Information)

| รายการ                                    | รายละเอียด    |
| ----------------------------------------- | ------------- |
| วันที่ตรวจพบ (Date Detected)              |               |
| วันที่เกิดเหตุจริง (Actual Incident Date) |               |
| ผู้แจ้ง (Reported By)                     |               |
| ประเภทเหตุการณ์ (Incident Type)           |               |
| ระดับความรุนแรง (Severity)                |               |
| MITRE ATT&CK Mapping                      |               |
| สถานะ (Status)                            | Open / Closed |

## 2. ขอบเขตการสอบสวน (Scope of Investigation)

### 2.1 วัตถุประสงค์ (Objectives)

### 2.2 ระบบที่เกี่ยวข้อง (Systems Involved)

### 2.3 ระยะเวลาที่ตรวจสอบ (Time Period Examined)

### 2.4 ข้อจำกัด (Limitations)

## 3. หลักฐาน (Evidence)

### 3.1 รายการหลักฐาน (Evidence Inventory)

| Evidence ID | ประเภท (Type) | แหล่งที่มา (Source) | Hash (SHA-256) | วันที่เก็บ (Collected) | ผู้เก็บ (Collected By) |
| ----------- | ------------- | ------------------- | -------------- | ---------------------- | ---------------------- |

### 3.2 Chain of Custody

[ดู Section 3 ด้านล่าง — แนบเป็น Appendix]

## 4. ลำดับเหตุการณ์ (Timeline of Events)

| Timestamp (UTC) | แหล่งที่มา (Source) | เหตุการณ์ (Event) | MITRE ATT&CK | หมายเหตุ (Notes) |
| --------------- | ------------------- | ----------------- | ------------ | ---------------- |

## 5. การวิเคราะห์ (Analysis)

### 5.1 Initial Access (การเข้าถึงครั้งแรก)

### 5.2 Execution & Persistence

### 5.3 Lateral Movement (การเคลื่อนที่ในเครือข่าย)

### 5.4 Data Access & Exfiltration

### 5.5 Impact Assessment (การประเมินผลกระทบ)

[แต่ละ sub-section ต้องมี:]

- หลักฐานที่สนับสนุน (Supporting Evidence)
- MITRE ATT&CK technique mapping
- เครื่องมือที่ใช้วิเคราะห์ (Tools Used)

## 6. สิ่งที่ค้นพบ (Findings)

### Finding 1: [Title]

- **ระดับความรุนแรง (Severity)**: Critical / High / Medium / Low
- **รายละเอียด (Description)**:
- **หลักฐาน (Evidence)**:
- **ผลกระทบ (Impact)**:
- **MITRE ATT&CK**: [Technique ID]

## 7. ตัวบ่งชี้การโจมตี (Indicators of Compromise)

### 7.1 Network-based IOCs

| Type       | Value | Context | First Seen | Last Seen |
| ---------- | ----- | ------- | ---------- | --------- |
| IP Address |       |         |            |           |
| Domain     |       |         |            |           |
| URL        |       |         |            |           |

### 7.2 Host-based IOCs

| Type                | Value | Context | Location |
| ------------------- | ----- | ------- | -------- |
| File Hash (SHA-256) |       |         |          |
| File Path           |       |         |          |
| Registry Key        |       |         |          |
| Service Name        |       |         |          |
| Scheduled Task      |       |         |          |

### 7.3 Email-based IOCs

| Type            | Value | Context |
| --------------- | ----- | ------- |
| Sender Address  |       |         |
| Subject Pattern |       |         |
| Attachment Hash |       |         |

## 8. ข้อเสนอแนะ (Recommendations)

### ระยะสั้น (Immediate — ภายใน 24-72 ชั่วโมง)

### ระยะกลาง (Short-term — ภายใน 1-4 สัปดาห์)

### ระยะยาว (Long-term — ภายใน 1-3 เดือน)

## 9. ภาคผนวก (Appendices)

- Appendix A: Chain of Custody Forms
- Appendix B: Full IOC List (machine-readable format)
- Appendix C: Raw Evidence Logs
- Appendix D: Tool Output Reports
```

---

## 3. Chain of Custody Documentation

ทุก evidence item ต้องมี chain of custody ที่สมบูรณ์:

```markdown
## Chain of Custody Record

**Evidence ID**: [EVD-YYYY-XXX]
**Description**: [รายละเอียดหลักฐาน]
**Original Hash (SHA-256)**: [hash]
**Current Hash (SHA-256)**: [hash — ต้องตรงกับ original]

| #   | วันที่/เวลา (Date/Time) | การดำเนินการ (Action) | ผู้ดำเนินการ (Person) | สถานที่ (Location) | หมายเหตุ (Notes) |
| --- | ----------------------- | --------------------- | --------------------- | ------------------ | ---------------- |
| 1   |                         | Collected / Acquired  |                       |                    |                  |
| 2   |                         | Transferred to        |                       |                    |                  |
| 3   |                         | Analyzed by           |                       |                    |                  |
| 4   |                         | Stored at             |                       |                    |                  |
```

**กฎเหล็ก (Critical Rules)**:

- ต้องคำนวณ hash ทุกครั้งที่ transfer evidence
- ห้าม analyze original evidence โดยตรง — ทำ forensic copy ก่อนเสมอ
- Document ทุก action ที่ทำกับ evidence
- ใช้ write-blocker เมื่อ acquire disk evidence

---

## 4. Timeline Reconstruction (การสร้างลำดับเหตุการณ์)

Approach สำหรับ timeline reconstruction:

1. **รวบรวม timestamp จากหลายแหล่ง**:
   - System logs (Event Log, syslog, auth.log)
   - Network logs (firewall, proxy, DNS, NetFlow)
   - Application logs (web server, database, email)
   - Endpoint telemetry (EDR, AV)
   - Cloud audit logs (CloudTrail, Azure Activity Log, GCP Audit)

2. **Normalize เป็น UTC**:
   - ตรวจสอบ timezone ของทุก log source
   - แปลงทุก timestamp เป็น UTC ก่อน correlate
   - Document timezone offset ของแต่ละ source

3. **สร้าง unified timeline**:
   - เรียงตาม timestamp
   - แยกเหตุการณ์ของ attacker vs normal operations
   - Map แต่ละ event ไปยัง MITRE ATT&CK technique
   - Mark ช่วงเวลาที่ไม่มี visibility (gaps)

---

## 5. IOC Documentation Format

สำหรับ machine-readable IOC export ให้ใช้ STIX 2.1 format หรือ CSV:

```csv
type,value,context,confidence,first_seen,last_seen,mitre_technique,source
ipv4-addr,198.51.100.100,C2 Server,High,2025-01-15T08:00:00Z,2025-01-16T23:59:00Z,T1071.001,Firewall Logs
domain-name,evil.example.com,Phishing Domain,High,2025-01-14T00:00:00Z,,T1566.002,Email Gateway
file:hashes.SHA-256,abc123...,Malware Dropper,High,2025-01-15T10:30:00Z,,T1059.001,EDR Alert
```

---

## 6. Evidence Handling Procedures

### Disk Forensics

```bash
# สร้าง forensic image ด้วย dd (Linux)
# WARNING: ตรวจสอบ if= และ of= ให้ถูกต้อง — สลับกันจะทำลาย evidence drive
# ALWAYS ใช้ hardware write-blocker กับ source drive ก่อน acquire
sudo dd if=/dev/sda of=/evidence/case-001/disk.dd bs=4K conv=noerror,sync status=progress

# คำนวณ hash
sha256sum /evidence/case-001/disk.dd > /evidence/case-001/disk.dd.sha256

# ใช้ FTK Imager (Windows) หรือ Guymager (Linux GUI) แทนได้
```

### Memory Forensics

```bash
# Acquire memory dump
# Linux: LiME (Linux Memory Extractor)
sudo insmod lime.ko "path=/evidence/case-001/memory.lime format=lime"

# Windows: WinPmem, Belkasoft RAM Capturer, หรือ Magnet RAM Capture

# Analyze ด้วย Volatility 3
vol -f memory.lime linux.pslist
vol -f memory.lime linux.netstat
vol -f memory.lime linux.bash
```

### Network Forensics

```bash
# Capture traffic ด้วย tcpdump
sudo tcpdump -i eth0 -w /evidence/case-001/capture.pcap -c 1000000

# Analyze ด้วย tshark / Wireshark
tshark -r capture.pcap -Y "http.request" -T fields -e ip.src -e http.host -e http.request.uri
```

---

## 7. Tool Reference

### Forensic Analysis Tools

| เครื่องมือ (Tool)    | ประเภท (Type)         | License           | ใช้สำหรับ (Use Case)              |
| -------------------- | --------------------- | ----------------- | --------------------------------- |
| Autopsy              | Disk Forensics        | Open Source       | Full disk analysis, file recovery |
| Volatility 3         | Memory Forensics      | Open Source       | RAM analysis, process detection   |
| Wireshark / tshark   | Network Forensics     | Open Source       | Packet analysis                   |
| KAPE                 | Triage Collection     | Free (commercial) | Fast artifact collection          |
| Velociraptor         | DFIR Platform         | Open Source       | Remote collection & hunting       |
| TheHive              | Case Management       | Open Source       | IR case tracking                  |
| MISP                 | Threat Intel Platform | Open Source       | IOC sharing & management          |
| Plaso / log2timeline | Timeline              | Open Source       | Super timeline creation           |
| Eric Zimmerman Tools | Windows Forensics     | Free              | Registry, MFT, ShellBags          |
| CyberChef            | Data Transformation   | Open Source       | Decode, decrypt, analyze          |

### Commercial Alternatives

| เครื่องมือ (Tool)          | ประเภท (Type)            | ใช้สำหรับ (Use Case)          |
| -------------------------- | ------------------------ | ----------------------------- |
| EnCase                     | Disk Forensics           | Court-admissible forensics    |
| Magnet AXIOM               | Multi-platform Forensics | Mobile + desktop + cloud      |
| X-Ways Forensics           | Disk Forensics           | Advanced disk analysis        |
| Cellebrite                 | Mobile Forensics         | Mobile device extraction      |
| Carbon Black / CrowdStrike | EDR                      | Endpoint detection & response |
