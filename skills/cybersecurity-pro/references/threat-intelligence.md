# Threat Intelligence & IOC Management Reference

คู่มือ Threat Intelligence และการจัดการ IOC ครบวงจร — STIX 2.1, TAXII 2.1, Threat Intelligence Platforms,
IOC Lifecycle, Threat Feeds, Intelligence Sharing (TLP 2.0), TI-Driven Detection พร้อม automation templates

> สำหรับ SOC operations และ SIEM correlation → ดู references/soc-operations.md (Domain 4)
> สำหรับ IR playbooks → ดู references/ir-playbooks.md (Domain 1)
> สำหรับ MITRE ATT&CK mapping → ดู references/soc-operations.md (Domain 4)

**Cross-references:**

- Domain 1: IR Playbooks → `references/ir-playbooks.md`
- Domain 4: SOC Operations → `references/soc-operations.md`
- Domain 8: Threat Modeling & Risk → `references/compliance-threat-modeling.md`
- Domain 14: Vulnerability Management → `references/vulnerability-management.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`

---

## Table of Contents

1. STIX 2.1 Object Model
2. TAXII 2.1 Protocol
3. Threat Intelligence Platforms (TI Platforms)
4. IOC Lifecycle Management
5. Threat Feed Integration
6. Intelligence Sharing & ISACs
7. TI-Driven Detection & Hunting
8. TI Automation & SOAR Integration
9. Framework References & Remediation Checklist

---

## 1. โมเดลออบเจกต์ STIX 2.1 (STIX 2.1 Object Model)

STIX (Structured Threat Information eXpression) เป็นมาตรฐาน OASIS สำหรับแลกเปลี่ยนข้อมูล threat intelligence
ในรูปแบบ JSON ที่มีโครงสร้างชัดเจน แบ่งออกเป็น 3 กลุ่มหลัก:

```
STIX 2.1 Object Categories:

┌─────────────────────────────────────────────────────────┐
│  STIX Domain Objects (SDOs) — สิ่งที่ต้องการอธิบาย       │
│  ┌──────────┬──────────┬──────────┬──────────────────┐  │
│  │Indicator │ Malware  │ Threat   │ Campaign         │  │
│  │          │          │ Actor    │                  │  │
│  ├──────────┼──────────┼──────────┼──────────────────┤  │
│  │ Attack   │Intrusion │ Tool     │ Vulnerability    │  │
│  │ Pattern  │ Set      │          │                  │  │
│  ├──────────┼──────────┼──────────┼──────────────────┤  │
│  │ Identity │ Course   │ Report   │                  │  │
│  │          │of Action │          │                  │  │
│  └──────────┴──────────┴──────────┴──────────────────┘  │
├─────────────────────────────────────────────────────────┤
│  STIX Relationship Objects (SROs) — ความสัมพันธ์         │
│  ┌──────────────────┬──────────────────────────────┐    │
│  │  Relationship    │  Sighting                    │    │
│  └──────────────────┴──────────────────────────────┘    │
├─────────────────────────────────────────────────────────┤
│  STIX Cyber-observable Objects (SCOs) — สิ่งที่สังเกตได้  │
│  ┌──────────┬──────────┬──────────┬──────────────────┐  │
│  │IPv4-Addr │Domain-   │ URL      │ File (hashes)    │  │
│  │          │Name      │          │                  │  │
│  ├──────────┼──────────┼──────────┼──────────────────┤  │
│  │Email-Addr│Network-  │ Process  │ Software         │  │
│  │          │Traffic   │          │                  │  │
│  └──────────┴──────────┴──────────┴──────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### STIX 2.1 Indicator Object Example

```json
{
  "type": "indicator",
  "spec_version": "2.1",
  "id": "indicator--a932fcc6-e032-476c-826f-cb970a5a1ade",
  "created": "2025-01-15T08:00:00.000Z",
  "modified": "2025-01-15T08:00:00.000Z",
  "name": "Malicious C2 IP Address",
  "description": "Command and control server for APT group",
  "indicator_types": ["malicious-activity"],
  "pattern": "[ipv4-addr:value = '203.0.113.50']",
  "pattern_type": "stix",
  "valid_from": "2025-01-15T08:00:00.000Z",
  "valid_until": "2025-04-15T08:00:00.000Z",
  "confidence": 85,
  "kill_chain_phases": [
    {
      "kill_chain_name": "mitre-attack",
      "phase_name": "command-and-control"
    }
  ]
}
```

### STIX 2.1 Malware Object Example

```json
{
  "type": "malware",
  "spec_version": "2.1",
  "id": "malware--fdd60b30-b67c-41e3-b0b9-f01faf20d111",
  "created": "2025-01-15T08:00:00.000Z",
  "modified": "2025-01-15T08:00:00.000Z",
  "name": "BlackCat Ransomware",
  "malware_types": ["ransomware"],
  "is_family": true,
  "description": "ALPHV/BlackCat ransomware written in Rust"
}
```

### STIX 2.1 Relationship Object Example

```json
{
  "type": "relationship",
  "spec_version": "2.1",
  "id": "relationship--44298a74-ba52-4f0c-87a3-1824e67d7fad",
  "created": "2025-01-15T08:00:00.000Z",
  "modified": "2025-01-15T08:00:00.000Z",
  "relationship_type": "indicates",
  "source_ref": "indicator--a932fcc6-e032-476c-826f-cb970a5a1ade",
  "target_ref": "malware--fdd60b30-b67c-41e3-b0b9-f01faf20d111"
}
```

### STIX Patterning Language

| Pattern                                                                           | คำอธิบาย                              |
| --------------------------------------------------------------------------------- | ------------------------------------- |
| `[ipv4-addr:value = '203.0.113.50']`                                              | จับคู่ IP address เฉพาะ               |
| `[domain-name:value = 'evil.example.com']`                                        | จับคู่ domain name                    |
| `[file:hashes.'SHA-256' = 'aabbcc...']`                                           | จับคู่ file hash SHA-256              |
| `[email-addr:value = 'phish@evil.example.com']`                                   | จับคู่ email address                  |
| `[network-traffic:dst_ref.type = 'ipv4-addr' AND network-traffic:dst_port = 443]` | Network traffic ไปยัง IP ที่ port 443 |

---

## 2. โปรโตคอล TAXII 2.1 (TAXII 2.1 Protocol)

TAXII (Trusted Automated eXchange of Indicator Information) เป็นโปรโตคอลสำหรับรับ-ส่งข้อมูล
STIX ผ่าน HTTPS RESTful API รองรับทั้ง polling (pull) และ subscription (push) model

```
TAXII 2.1 Architecture:

┌──────────────┐       HTTPS/REST        ┌──────────────────────┐
│              │ ─────────────────────▶   │    TAXII Server      │
│ TAXII Client │                         │                      │
│ (Consumer)   │ ◀─────────────────────  │  ┌───────────────┐   │
│              │     STIX 2.1 Bundles    │  │  API Root 1   │   │
└──────────────┘                         │  │  ├─Collection A│   │
                                         │  │  └─Collection B│   │
┌──────────────┐                         │  ├───────────────┤   │
│ TAXII Client │ ◀────────────────────▶  │  │  API Root 2   │   │
│ (Producer)   │                         │  │  └─Collection C│   │
└──────────────┘                         │  └───────────────┘   │
                                         └──────────────────────┘
```

### TAXII 2.1 API Endpoints

| Endpoint                                 | Method   | คำอธิบาย                              |
| ---------------------------------------- | -------- | ------------------------------------- |
| `/taxii2/`                               | GET      | Discovery — ค้นหา API roots ที่มี     |
| `/{api-root}/`                           | GET      | API root information                  |
| `/{api-root}/collections/`               | GET      | รายการ collections ทั้งหมด            |
| `/{api-root}/collections/{id}/`          | GET      | รายละเอียด collection เฉพาะ           |
| `/{api-root}/collections/{id}/objects/`  | GET/POST | ดึง/เพิ่ม STIX objects ใน collection  |
| `/{api-root}/collections/{id}/manifest/` | GET      | Metadata ของ objects (ไม่รวม content) |
| `/{api-root}/status/{id}/`               | GET      | สถานะการ POST objects                 |

### Python taxii2-client Example

```python
import os
from taxii2client.v21 import Server, Collection

# ใช้ environment variables สำหรับ credentials (ห้าม hardcode)
taxii_user = os.environ["TAXII_USER"]
taxii_pass = os.environ["TAXII_PASS"]

# เชื่อมต่อ TAXII 2.1 server
server = Server(
    "https://taxii.example.com/taxii2/",
    user=taxii_user,
    password=taxii_pass
)

# ดึง API roots
api_root = server.api_roots[0]

# ดึงรายการ collections และเลือก collection ที่ต้องการ
for col in api_root.collections:
    print(f"Collection: {col.title} (ID: {col.id})")

# เลือก collection แรก (หรือ filter ตาม title)
target_collection = api_root.collections[0]

# ดึง STIX objects จาก collection ที่ต้องการ
collection = Collection(
    f"https://taxii.example.com/api1/collections/{target_collection.id}/",
    user=taxii_user,
    password=taxii_pass
)

# Polling — ดึง objects ทั้งหมด (หรือ filter ตาม type/date)
stix_bundle = collection.get_objects(
    added_after="2025-01-01T00:00:00Z",
    type=["indicator", "malware"]
)
```

### Authentication Methods

| Method            | Use Case                       | ความปลอดภัย |
| ----------------- | ------------------------------ | ----------- |
| HTTP Basic        | Internal/dev environments      | ต่ำ         |
| API Key (Header)  | Automated integrations         | ปานกลาง     |
| OAuth 2.0         | Enterprise multi-tenant        | สูง         |
| Certificate-based | High-trust government/military | สูงมาก      |

---

## 3. แพลตฟอร์ม Threat Intelligence (TI Platforms)

### 3.1 MISP — Setup Checklist

MISP (Malware Information Sharing Platform) เป็น open-source TIP ที่ใช้กันอย่างแพร่หลาย:

- [ ] ติดตั้ง MISP บน Ubuntu/RHEL ผ่าน official installer หรือ Docker
- [ ] กำหนด Organization identity และ Sharing Groups
- [ ] เปิดใช้ default feeds: CIRCL OSINT, Botvrij, abuse.ch
- [ ] Configure Galaxy Clusters: MITRE ATT&CK, threat actor, malware families
- [ ] ตั้งค่า Taxonomies: TLP, admiralty-scale, estimative-language
- [ ] สร้าง API key สำหรับ automation
- [ ] Integrate กับ SIEM ผ่าน MISP ZeroMQ หรือ REST API

### 3.2 OpenCTI — Architecture Overview

```
OpenCTI Architecture:

┌──────────┐     ┌──────────────────────────────────────┐
│ Web UI   │────▶│          OpenCTI Platform             │
└──────────┘     │  ┌──────┐  ┌───────┐  ┌──────────┐  │
                 │  │GraphQL│  │Workers│  │Connectors│  │
┌──────────┐     │  │ API   │  │       │  │          │  │
│TAXII/STIX│────▶│  └──┬───┘  └───┬───┘  └────┬─────┘  │
└──────────┘     │     │          │            │        │
                 │  ┌──▼──────────▼────────────▼─────┐  │
                 │  │    ElasticSearch + Redis        │  │
                 │  │    MinIO (file storage)         │  │
                 │  └────────────────────────────────┘  │
                 └──────────────────────────────────────┘
```

Connectors ที่สำคัญ: STIX Import, MISP Feed, AlienVault OTX, CVE (NVD), VirusTotal, AbuseIPDB

### 3.3 Platform Comparison

| Feature           | MISP (OSS)     | OpenCTI (OSS) | ThreatConnect | Recorded Future | Anomali      |
| ----------------- | -------------- | ------------- | ------------- | --------------- | ------------ |
| STIX 2.1 Support  | Full           | Full          | Full          | Full            | Full         |
| TAXII Server      | Built-in       | Built-in      | Built-in      | API-based       | Built-in     |
| ATT&CK Mapping    | Galaxy         | Native        | Native        | Native          | Native       |
| Automated Scoring | Sighting-based | Confidence    | ThreatAssess  | Risk Score      | ThreatStream |
| SOAR Integration  | API            | Connector     | Playbook      | API             | API          |
| Price             | Free           | Free/EE       | Commercial    | Commercial      | Commercial   |

### Integration Patterns

| Pattern    | Data Flow                              | Protocol               |
| ---------- | -------------------------------------- | ---------------------- |
| SIEM ← TIP | IOCs pushed to SIEM threat intel lists | Syslog, REST API, CEF  |
| SOAR ← TIP | Enrichment lookups from SOAR playbooks | REST API, webhooks     |
| EDR ← TIP  | Block lists pushed to EDR agents       | API, TAXII, CSV export |
| FW ← TIP   | IP/Domain block lists to firewalls     | API, STIX/TAXII        |

---

## 4. การจัดการวงจรชีวิต IOC (IOC Lifecycle Management)

### Workflow

```
┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐
│  Collect  │ → │ Validate  │ → │  Enrich   │ → │Disseminate│ → │  Expire   │
│           │   │           │   │           │   │           │   │           │
│• Feeds    │   │• Dedup    │   │• GeoIP    │   │• SIEM     │   │• TTL-based│
│• Reports  │   │• Verify   │   │• WHOIS    │   │• EDR      │   │• Age-out  │
│• Hunting  │   │• Score    │   │• VT       │   │• Firewall │   │• Review   │
│• Partners │   │• FP check │   │• Shodan   │   │• SOAR     │   │• Archive  │
└───────────┘   └───────────┘   └───────────┘   └───────────┘   └───────────┘
```

### IOC Types

| Type       | ตัวอย่าง                         | Pyramid of Pain Level | TTL เริ่มต้น |
| ---------- | -------------------------------- | --------------------- | ------------ |
| Atomic     | IP address, domain, hash, email  | Hash Values / IPs     | 30-90 days   |
| Computed   | Sigma rules, YARA rules, Snort   | Network / Host        | 90-180 days  |
| Behavioral | TTP-based (ATT&CK technique IDs) | TTPs (top)            | 1-2 years    |

### Confidence Scoring

| Score Range | Classification | คำอธิบาย                                        | Action                  |
| ----------- | -------------- | ----------------------------------------------- | ----------------------- |
| 0-29        | Low            | ข้อมูลจาก feed ที่ยังไม่ได้ validate            | Monitor only            |
| 30-59       | Medium         | มี corroboration จากแหล่งเดียว                  | Alert, manual review    |
| 60-84       | High           | ยืนยันจากหลายแหล่ง หรือ sighting ใน environment | Auto-block, investigate |
| 85-100      | Confirmed      | First-hand intelligence, confirmed malicious    | Immediate block + hunt  |

### Aging & TTL Policies

| IOC Type            | Initial TTL | Renewal Condition              | Max Lifetime |
| ------------------- | ----------- | ------------------------------ | ------------ |
| IP Address          | 30 days     | Re-sighting resets TTL         | 180 days     |
| Domain Name         | 60 days     | Active DNS + new sighting      | 1 year       |
| File Hash (MD5)     | 90 days     | New malware analysis confirms  | Indefinite   |
| File Hash (SHA-256) | 90 days     | New malware analysis confirms  | Indefinite   |
| URL                 | 14 days     | URL still active               | 90 days      |
| Email Address       | 60 days     | New phishing campaign observed | 1 year       |
| YARA Rule           | 180 days    | Rule still triggering          | Indefinite   |

### False Positive Management

1. **Detection** — analyst marks IOC as false positive ใน TIP
2. **Validation** — L2/L3 analyst ตรวจสอบยืนยัน false positive
3. **Whitelist** — เพิ่มเข้า allowlist ของ SIEM/EDR พร้อม justification
4. **Feedback** — แจ้ง feed provider เพื่อปรับปรุงคุณภาพ feed
5. **Review** — ตรวจสอบ allowlist รายไตรมาสเพื่อลบ entries ที่หมดอายุ

---

## 5. การรวม Threat Feed (Threat Feed Integration)

### Open-Source Feeds

| Feed                     | ประเภท IOC                   | Format          | URL                                       |
| ------------------------ | ---------------------------- | --------------- | ----------------------------------------- |
| AlienVault OTX           | IP, domain, hash, URL        | STIX/OTX API    | https://otx.alienvault.com/               |
| Abuse.ch URLhaus         | Malicious URLs               | CSV, JSON, API  | https://urlhaus.abuse.ch/                 |
| Abuse.ch MalwareBazaar   | Malware samples, hashes      | CSV, JSON, API  | https://bazaar.abuse.ch/                  |
| Abuse.ch ThreatFox       | IOCs (IP, domain, hash, URL) | JSON, CSV, STIX | https://threatfox.abuse.ch/               |
| Abuse.ch Feodo Tracker   | Botnet C2 IPs                | CSV, JSON       | https://feodotracker.abuse.ch/            |
| PhishTank                | Phishing URLs                | CSV, JSON, API  | https://phishtank.org/                    |
| CIRCL OSINT Feed         | MISP events                  | MISP JSON       | https://www.circl.lu/doc/misp/feed-osint/ |
| DigitalSide Threat-Intel | IP, domain, URL, hash        | CSV, STIX       | https://osint.digitalside.it/             |

### SIEM Integration Patterns

**Splunk** — Threat Intelligence Management:

```
# splunk ค้นหา IOC จาก lookup table
| inputlookup threat_intel_ioc.csv
| search ioc_type="ip"
| lookup dnslookup clientip AS src_ip OUTPUT clienthost
| where isnotnull(clienthost)
```

**Elastic** — Threat Intel Filebeat Module:

```yaml
# filebeat.yml — Threat Intel module
filebeat.modules:
  - module: threatintel
    abuseurl:
      enabled: true
      interval: 10m
    abusemalware:
      enabled: true
      interval: 10m
    otx:
      enabled: true
      api_key: "${OTX_API_KEY}"
      interval: 60m
```

**QRadar** — Reference Sets:

```
# สร้าง reference set สำหรับ malicious IPs
/api/reference_data/sets?name=TI_Malicious_IPs&element_type=IP
# เพิ่ม IOC เข้า reference set
POST /api/reference_data/sets/bulk_load/TI_Malicious_IPs
```

> Cross-ref: Domain 4 (SOC Operations) สำหรับ SIEM correlation rules → ดู `references/soc-operations.md`

---

## 6. การแบ่งปันข่าวกรอง (Intelligence Sharing & ISACs)

### Traffic Light Protocol (TLP) 2.0

TLP 2.0 เผยแพร่โดย FIRST เป็นมาตรฐานในการระบุขอบเขตการแชร์ข้อมูล:

| TLP Color        | ขอบเขตการแชร์                                                                   | ตัวอย่างการใช้งาน                     |
| ---------------- | ------------------------------------------------------------------------------- | ------------------------------------- |
| TLP:RED          | ผู้รับเท่านั้น ห้ามแชร์ต่อนอกห้องประชุมหรือการสนทนา                             | ข่าวกรอง active threat ต่อองค์กรเฉพาะ |
| TLP:AMBER+STRICT | เฉพาะองค์กรผู้รับ ห้ามแชร์ไปยังลูกค้าหรือ partner                               | IOCs ที่ต้องใช้ภายในองค์กรเท่านั้น    |
| TLP:AMBER        | องค์กรผู้รับ + ลูกค้า/partner ที่จำเป็นต้องรู้ (need-to-know) เพื่อป้องกันตนเอง | Advisory แชร์ในกลุ่ม ISAC             |
| TLP:GREEN        | แชร์ได้ในชุมชน (community) แต่ห้ามเผยแพร่สาธารณะ                                | Best practices, general advisories    |
| TLP:CLEAR        | ไม่มีข้อจำกัด เผยแพร่สาธารณะได้                                                 | Published CVE, public report          |

### Information Sharing and Analysis Centers (ISACs)

| ISAC                         | Sector    | URL                         |
| ---------------------------- | --------- | --------------------------- |
| FS-ISAC (Financial Services) | การเงิน   | https://www.fsisac.com/     |
| H-ISAC (Health)              | สาธารณสุข | https://h-isac.org/         |
| IT-ISAC                      | เทคโนโลยี | https://www.it-isac.org/    |
| E-ISAC (Electricity)         | พลังงาน   | https://www.eisac.com/      |
| Auto-ISAC (Automotive)       | ยานยนต์   | https://automotiveisac.com/ |

### Thai Context

- **ThaiCERT** (ศูนย์ประสานการรักษาความมั่นคงปลอดภัยระบบคอมพิวเตอร์ประเทศไทย) — หน่วยงานหลัก CERT ของไทย
- **ETDA** (สำนักงานพัฒนาธุรกรรมทางอิเล็กทรอนิกส์) — กำกับดูแลด้าน cybersecurity ภายใต้กระทรวง DE
- **พ.ร.บ. การรักษาความมั่นคงปลอดภัยไซเบอร์ พ.ศ. 2562** — กำหนดให้หน่วยงาน CII ต้องรายงาน
  cyber incidents ต่อ กมช. (คณะกรรมการการรักษาความมั่นคงปลอดภัยไซเบอร์แห่งชาติ) ภายในกรอบเวลาที่กำหนด
- **PDPA** (พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562) — threat data ที่มี PII (เช่น email addresses,
  IP addresses ที่ระบุตัวบุคคลได้) ต้องปฏิบัติตามหลักการ lawful basis ก่อนแชร์

### Legal Considerations

- **Data Sharing Agreements (DSA)** — ทำข้อตกลงเป็นลายลักษณ์อักษรก่อนแชร์ threat data กับ partner
- **Liability Protection** — ตรวจสอบกฎหมายคุ้มครองความรับผิดสำหรับการแชร์ threat intel โดยสุจริต
- **PII in IOCs** — email addresses, usernames, และ IP addresses อาจเป็น personal data ภายใต้ PDPA/GDPR

---

## 7. การตรวจจับและล่าภัยคุกคามจาก TI (TI-Driven Detection & Hunting)

### MITRE ATT&CK Mapping จาก TI Reports

กระบวนการแปลง threat intelligence report เป็น detection rules:

```
TI Report Analysis Pipeline:

TI Report → Extract TTPs → Map to ATT&CK IDs → Generate Detection Rules
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
              Sigma Rules     YARA Rules      Hunting Queries
```

| Report Element         | ATT&CK Mapping                         | Detection Approach             |
| ---------------------- | -------------------------------------- | ------------------------------ |
| "Spear-phishing email" | T1566.001 Phishing: Attachment         | Email gateway rules, Sigma     |
| "PowerShell execution" | T1059.001 Command: PowerShell          | Script block logging, Sigma    |
| "Registry persistence" | T1547.001 Boot Autostart: Registry Run | Sysmon Event ID 13, Sigma      |
| "Lateral movement SMB" | T1021.002 Remote Services: SMB         | Network traffic analysis, Zeek |
| "Data exfil via HTTPS" | T1041 Exfiltration Over C2             | Proxy logs, anomaly detection  |

### Sigma Rule จาก IOC — Template

```yaml
# Sigma rule generated from TI — suspicious C2 communication
title: Connection to Known C2 Server from TI Feed
id: d4f5e6a7-b8c9-4d0e-a1b2-c3d4e5f6a7b8
status: experimental
description: ตรวจจับ connection ไปยัง C2 IP ที่ได้จาก threat intelligence
references:
  - https://ti-report.example.com/apt-campaign-2025
author: SOC Team
date: 2025/01/15
tags:
  - attack.command_and_control
  - attack.t1071.001
logsource:
  category: firewall
detection:
  selection:
    dst_ip:
      - "203.0.113.50"
      - "198.51.100.23"
  condition: selection
falsepositives:
  - Legitimate services hosted on these IPs
level: high
```

### YARA Rule จาก Malware Intel

```yara
rule TI_BlackCat_Ransomware_Loader {
    meta:
        description = "Detect BlackCat/ALPHV ransomware loader"
        author = "SOC Threat Intel Team"
        date = "2025-01-15"
        tlp = "TLP:AMBER"
        mitre_attack = "T1486"
    strings:
        $rust_panic = "rust_begin_unwind" ascii
        $ransom_note = "RECOVER-FILES.txt" ascii wide
        $mutex = "Global\\BlackCat" ascii
        $api1 = "BCryptGenRandom" ascii
        $api2 = "NtQuerySystemInformation" ascii
    condition:
        uint16(0) == 0x5A4D and
        filesize < 5MB and
        $rust_panic and
        $ransom_note and
        2 of ($mutex, $api1, $api2)
}
```

### Threat Hunting Hypotheses จาก TI

| Hypothesis                                        | Data Source            | ATT&CK ID |
| ------------------------------------------------- | ---------------------- | --------- |
| APT group X ใช้ scheduled tasks เพื่อ persistence | Windows Event Log 4698 | T1053.005 |
| Malware family Y ใช้ DNS tunneling สำหรับ C2      | DNS query logs, Zeek   | T1071.004 |
| Campaign Z ใช้ DLL side-loading เข้า signed app   | Sysmon Event ID 7      | T1574.002 |

> Cross-ref: Domain 4 (SOC Operations) สำหรับ threat hunting queries → ดู `references/soc-operations.md`
> Cross-ref: Domain 1 (IR Playbooks) สำหรับ incident response → ดู `references/ir-playbooks.md`

---

## 8. การทำ TI Automation และ SOAR Integration (TI Automation & SOAR Integration)

### Automated IOC Ingestion Workflow

```
┌──────────┐     ┌───────────┐     ┌───────────┐     ┌──────────┐
│ TI Feeds │ ──▶ │ Collector │ ──▶ │ Enrichment│ ──▶ │   TIP    │
│          │     │ (TAXII/   │     │ (VT, Shodan│    │ (MISP/   │
│• TAXII   │     │  API/CSV) │     │  AbuseIPDB)│    │  OpenCTI)│
│• OTX API │     └───────────┘     └───────────┘     └────┬─────┘
│• Abuse.ch│                                              │
└──────────┘                                              ▼
                                                  ┌──────────────┐
                                              ┌───│  Disseminate │───┐
                                              │   └──────────────┘   │
                                              ▼         ▼            ▼
                                          ┌──────┐ ┌──────┐    ┌────────┐
                                          │ SIEM │ │ EDR  │    │Firewall│
                                          └──────┘ └──────┘    └────────┘
```

### Enrichment Sources

| Source     | ข้อมูลที่ได้                              | API Rate Limit (Free)  |
| ---------- | ----------------------------------------- | ---------------------- |
| VirusTotal | Hash/URL/domain reputation, detections    | 4 req/min              |
| Shodan     | Open ports, services, banners             | 1 req/sec              |
| AbuseIPDB  | IP reputation, abuse reports              | 1000 req/day           |
| GreyNoise  | Internet noise vs targeted classification | 50 req/day (Community) |
| Censys     | Certificate, host, service data           | 250 req/month          |

### Python Automation — STIX Bundle Processing

```python
from stix2 import Filter, MemoryStore, parse

def process_stix_bundle(bundle_json):
    """Process STIX bundle: extract indicators and enrich."""
    bundle = parse(bundle_json, allow_custom=True)
    store = MemoryStore(stix_data=bundle.objects)

    # ดึงเฉพาะ indicators ที่มี confidence >= 60
    indicators = store.query([
        Filter("type", "=", "indicator"),
        Filter("confidence", ">=", 60)
    ])

    enriched = []
    for indicator in indicators:
        result = {
            "id": indicator.id,
            "pattern": indicator.pattern,
            "confidence": indicator.confidence,
            "valid_until": str(indicator.valid_until),
            "enrichment": enrich_indicator(indicator.pattern)
        }
        enriched.append(result)

    return enriched
```

### SOAR Workflow — TI Automated Triage

```
SOAR Playbook: TI IOC Triage

Trigger: New IOC ingested with confidence >= 60
    │
    ├──▶ Step 1: Deduplicate (check existing IOCs in TIP)
    │
    ├──▶ Step 2: Enrich (parallel)
    │    ├─ VirusTotal lookup
    │    ├─ AbuseIPDB check
    │    └─ GreyNoise classification
    │
    ├──▶ Step 3: Score (combine enrichment results)
    │    ├─ VT detections >= 5 → +20 confidence
    │    ├─ AbuseIPDB score >= 80 → +15 confidence
    │    └─ GreyNoise "malicious" → +10 confidence
    │
    ├──▶ Step 4: Action (based on final score)
    │    ├─ Score >= 85 → Auto-block (firewall + EDR)
    │    ├─ Score 60-84 → Alert SOC for review
    │    └─ Score < 60 → Monitor only
    │
    └──▶ Step 5: Notify (Slack/Teams/email to SOC channel)
```

> Cross-ref: Domain 4 (SOC Operations) สำหรับ SOAR playbook patterns → ดู `references/soc-operations.md`

---

## 9. อ้างอิง Framework และเช็คลิสต์ (Framework References & Remediation Checklist)

### Framework References

| Framework                      | Version | Primary Use                             | URL                                                                   |
| ------------------------------ | ------- | --------------------------------------- | --------------------------------------------------------------------- |
| STIX                           | 2.1     | Structured threat intel exchange format | https://oasis-open.github.io/cti-documentation/stix/intro.html        |
| TAXII                          | 2.1     | Automated TI transport protocol         | https://oasis-open.github.io/cti-documentation/taxii/intro.html       |
| MITRE ATT&CK                   | Current | Adversary TTPs knowledge base           | https://attack.mitre.org/                                             |
| Traffic Light Protocol         | 2.0     | Information sharing classification      | https://www.first.org/tlp/                                            |
| Diamond Model                  | 2013    | Intrusion analysis methodology          | https://www.activeresponse.org/wp-content/uploads/2013/07/diamond.pdf |
| FIRST CSIRT Services Framework | 2.1     | CSIRT capability maturity               | https://www.first.org/standards/frameworks/csirts/                    |
| Pyramid of Pain                | 2013    | IOC value hierarchy                     | https://detect-respond.blogspot.com/2013/03/the-pyramid-of-pain.html  |

### Threat Intelligence Program Checklist

#### Quick Win (ดำเนินการได้ภายใน 1-2 วัน)

- [ ] **[Quick Win]** Subscribe to CISA KEV และ vendor security advisories
- [ ] **[Quick Win]** เปิดใช้ open-source threat feeds อย่างน้อย 3 แหล่ง (OTX, Abuse.ch, PhishTank)
- [ ] **[Quick Win]** กำหนด TLP labeling policy สำหรับทุก threat intel ที่แชร์
- [ ] **[Quick Win]** สร้าง IOC watchlist ใน SIEM สำหรับ critical indicators
- [ ] **[Quick Win]** ตั้งค่า automated alerting เมื่อ IOC match พบใน environment

#### Standard (ดำเนินการได้ภายใน 1-4 สัปดาห์)

- [ ] **[Standard]** Deploy TIP (MISP หรือ OpenCTI) สำหรับ centralized IOC management
- [ ] **[Standard]** Implement IOC lifecycle management พร้อม TTL policies (Section 4)
- [ ] **[Standard]** Integrate TIP กับ SIEM สำหรับ automated IOC correlation
- [ ] **[Standard]** สร้าง confidence scoring framework (0-100 scale)
- [ ] **[Standard]** กำหนด false positive management process
- [ ] **[Standard]** Establish feed aggregation และ deduplication pipeline
- [ ] **[Standard]** จัดทำ data sharing agreement กับ ISAC หรือ trusted partners

#### Advanced (ดำเนินการ 1-3 เดือน)

- [ ] **[Advanced]** Implement STIX/TAXII infrastructure สำหรับ automated sharing
- [ ] **[Advanced]** สร้าง SOAR playbooks สำหรับ automated IOC triage และ enrichment (Section 8)
- [ ] **[Advanced]** Develop TI-driven threat hunting program (Section 7)
- [ ] **[Advanced]** Map threat intel to MITRE ATT&CK framework อย่างเป็นระบบ
- [ ] **[Advanced]** Implement automated Sigma/YARA rule generation จาก TI reports
- [ ] **[Advanced]** สร้าง TI metrics dashboard: feed coverage, IOC volume, detection rate, MTTD improvement
- [ ] **[Advanced]** Establish bi-directional sharing กับ industry ISACs ผ่าน TAXII 2.1
