# OT/ICS Security Reference

คู่มือความปลอดภัย Operational Technology (OT) และ Industrial Control Systems (ICS) เชิงลึก
ครอบคลุม NIST SP 800-82, IEC 62443, Purdue Model, MITRE ATT&CK for ICS
พร้อม OT asset discovery, network monitoring, incident response และ SCADA/PLC hardening

> สำหรับ IT network security และ Zero Trust → ดู references/zero-trust-architecture.md (Domain 11)
> สำหรับ SOC operations และ SIEM monitoring → ดู references/soc-operations.md (Domain 4)
> สำหรับ compliance frameworks (NIST 800-53, CIS Controls) → ดู references/compliance-frameworks.md (Domain 9)
> สำหรับ cloud security (IT/OT cloud convergence) → ดู references/cloud-security-cspm.md (Domain 10)
> สำหรับ end-to-end security orchestration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 4: SOC Operations + SOAR → `references/soc-operations.md`
- Domain 9: Compliance Frameworks → `references/compliance-frameworks.md`
- Domain 10: Cloud Security & CSPM → `references/cloud-security-cspm.md`
- Domain 11: Zero Trust Architecture → `references/zero-trust-architecture.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`

## Table of Contents

1. OT Security Landscape & IT/OT Convergence
2. NIST SP 800-82 Rev.3 — OT Security Guide
3. IEC 62443 — Industrial Automation Security
4. Purdue Model / ISA-95 Network Segmentation
5. OT Asset Discovery & Inventory
6. OT Network Monitoring & Threat Detection
7. OT Incident Response
8. SCADA/PLC/HMI Hardening
9. Thai Context — CII under พ.ร.บ. ไซเบอร์ 2562
10. Framework References & OT Security Checklist

---

## 1. ภาพรวมความปลอดภัย OT และการบรรจบ IT/OT (OT Security Landscape & IT/OT Convergence)

### OT vs IT — ตารางเปรียบเทียบ

| Attribute          | IT Systems                                 | OT Systems                                              |
| ------------------ | ------------------------------------------ | ------------------------------------------------------- |
| **Priority**       | Confidentiality → Integrity → Availability | **Availability → Integrity → Safety** → Confidentiality |
| **Uptime Req**     | 99.9% (8.7 hrs downtime/year)              | 99.999% (5.26 min downtime/year)                        |
| **Patch Cycle**    | Monthly (Patch Tuesday)                    | Semi-annual / annual / never                            |
| **Lifespan**       | 3-5 years                                  | 15-25+ years                                            |
| **OS**             | Modern (Windows 11, Linux 6.x)             | Legacy (Windows XP, RTOS, VxWorks)                      |
| **Protocols**      | TCP/IP, HTTP, TLS                          | Modbus, DNP3, OPC UA, BACnet, EtherNet/IP               |
| **Authentication** | MFA, SSO, certificates                     | Shared passwords, no auth (common)                      |
| **Failure Impact** | Data loss, financial loss                  | **Physical damage, safety hazard, environmental**       |
| **Environment**    | Office, data center                        | Factory floor, substation, pipeline                     |
| **Regulation**     | PCI DSS, GDPR, SOC 2                       | NERC CIP, IEC 62443, NIST 800-82                        |

### IT/OT Convergence — ความท้าทาย

การบรรจบของ IT และ OT เกิดจาก Industry 4.0, IIoT (Industrial Internet of Things) และ digital transformation
ทำให้ OT systems ที่เคย air-gapped ถูกเชื่อมต่อกับ IT networks และ cloud:

```
Traditional (Air-Gapped):           Converged (Connected):

┌──────────┐   ╳   ┌──────────┐    ┌──────────┐ ←→ ┌──────────┐
│    IT    │  GAP  │    OT    │    │    IT    │     │    OT    │
│ Network  │       │ Network  │    │ Network  │     │ Network  │
└──────────┘       └──────────┘    └──────────┘ ←→ └──────────┘
                                        ↕              ↕
                                   ┌──────────┐   ┌──────────┐
                                   │  Cloud   │   │  IIoT    │
                                   │ Services │   │ Devices  │
                                   └──────────┘   └──────────┘
```

**ความเสี่ยงหลักจากการบรรจบ:**

1. **Expanded attack surface** — OT devices ที่ไม่ได้ออกแบบมาให้เชื่อมต่อ internet ถูก expose
2. **Legacy vulnerabilities** — OT systems ใช้ OS เก่าที่ไม่มี security patches
3. **Protocol weaknesses** — Modbus, DNP3 ไม่มี authentication หรือ encryption built-in
4. **Lateral movement** — Attacker เจาะจาก IT network แล้วเคลื่อนเข้า OT network
5. **Safety implications** — Cyber attack อาจส่งผลต่อ physical safety ของคนและสิ่งแวดล้อม

### Safety vs Security — ลำดับความสำคัญ

ใน OT environment, **safety มาก่อน security เสมอ**:

```
OT Priority Hierarchy:

1. SAFETY     — ความปลอดภัยของชีวิตและสิ่งแวดล้อม
   ├── Process safety (Safety Instrumented Systems - SIS)
   ├── Personnel safety
   └── Environmental protection
2. INTEGRITY  — ความถูกต้องของ process control
3. AVAILABILITY — ความพร้อมใช้งานของ production
4. CONFIDENTIALITY — ความลับของข้อมูล (lowest priority in OT)
```

**กฎเหล็ก**: การตัดสินใจ security ต้องไม่ทำให้ safety ลดลง เช่น ห้าม patch PLC ระหว่าง production
หากต้องเลือกระหว่าง security fix กับ uptime → **uptime ชนะเสมอ** (แต่ต้อง document risk acceptance)

---

## 2. NIST SP 800-82 Rev.3 — คู่มือความปลอดภัย OT (OT Security Guide)

NIST SP 800-82 Revision 3 (กันยายน 2023) เป็นแนวทางหลักสำหรับ securing OT/ICS environments
จาก National Institute of Standards and Technology

### OT System Categories

| System Type                                          | คำอธิบาย                                                        | ตัวอย่าง                                       |
| ---------------------------------------------------- | --------------------------------------------------------------- | ---------------------------------------------- |
| **SCADA** (Supervisory Control and Data Acquisition) | ระบบ supervisory ที่ควบคุมกระบวนการแบบ geographically dispersed | Power grid, water treatment, pipeline          |
| **DCS** (Distributed Control System)                 | ระบบควบคุมกระบวนการผลิตแบบ centralized ในพื้นที่เดียว           | Oil refinery, chemical plant, power plant      |
| **PLC** (Programmable Logic Controller)              | ตัวควบคุมอุตสาหกรรมที่รัน ladder logic หรือ structured text     | Assembly line, packaging machine, pump control |
| **RTU** (Remote Terminal Unit)                       | อุปกรณ์ field ที่เชื่อมต่อ sensor/actuator กับ SCADA master     | Remote substation, pump station, well site     |
| **HMI** (Human-Machine Interface)                    | หน้าจอแสดงผลและควบคุมสำหรับ operator                            | Operator workstation, control room displays    |
| **Historian**                                        | ฐานข้อมูลที่เก็บ process data แบบ time-series                   | OSIsoft PI, Wonderware Historian, GE Proficy   |
| **SIS** (Safety Instrumented System)                 | ระบบ safety อิสระที่ป้องกัน hazardous events                    | Emergency shutdown (ESD), fire & gas systems   |

### Security Architecture Recommendations

NIST 800-82 Rev.3 แนะนำ defense-in-depth approach สำหรับ OT:

```
Defense-in-Depth Layers for OT:

Layer 1: Physical Security
   └── Locked cabinets, camera surveillance, badge access

Layer 2: Network Security
   ├── Network segmentation (Purdue Model zones)
   ├── Industrial firewalls at zone boundaries
   ├── Industrial DMZ between IT and OT
   └── Unidirectional gateways (data diodes)

Layer 3: Host Security
   ├── Application whitelisting (not blacklisting)
   ├── USB device control
   ├── Minimal services running
   └── Endpoint protection (OT-compatible agents)

Layer 4: Application Security
   ├── Secure coding for PLC programs
   ├── Access control on engineering workstations
   └── Change management for control logic

Layer 5: Data Security
   ├── Encrypted communications where supported
   ├── Backup and recovery of PLC programs
   └── Historian data integrity
```

### OT-Specific Risk Assessment

การประเมินความเสี่ยง OT ต้องพิจารณาผลกระทบ 4 มิติ (ไม่ใช่แค่ CIA triad):

| Impact Dimension  | คำอธิบาย                      | ตัวอย่าง                                           |
| ----------------- | ----------------------------- | -------------------------------------------------- |
| **Safety**        | อันตรายต่อชีวิตและร่างกาย     | Explosion, toxic release, electrical hazard        |
| **Environmental** | ผลกระทบต่อสิ่งแวดล้อม         | Chemical spill, air pollution, water contamination |
| **Operational**   | ผลกระทบต่อ production/service | Production downtime, service interruption          |
| **Financial**     | ความเสียหายทางการเงิน         | Equipment damage, regulatory fines, lost revenue   |

**Risk Assessment Matrix for OT:**

```
LIKELIHOOD →   Rare    Unlikely  Possible  Likely   Almost Certain
IMPACT ↓        (1)      (2)       (3)       (4)        (5)
─────────────────────────────────────────────────────────────────
Catastrophic(5)  5-M     10-H     15-C     20-C       25-C
Major      (4)   4-L      8-M     12-H     16-C       20-C
Moderate   (3)   3-L      6-M      9-M     12-H       15-C
Minor      (2)   2-L      4-L      6-M      8-M       10-H
Negligible (1)   1-L      2-L      3-L      4-L        5-M

L = Low (accept/monitor)  M = Medium (mitigate)
H = High (urgent mitigation)  C = Critical (immediate action + safety review)
```

### Zero Trust in OT Environments

NIST 800-82 Rev.3 แนะนำการประยุกต์ Zero Trust ใน OT แต่ต้องปรับให้เข้ากับ OT constraints:

| ZT Principle           | IT Implementation  | OT Adaptation                                   |
| ---------------------- | ------------------ | ----------------------------------------------- |
| Verify explicitly      | MFA per request    | Role-based access + physical key + badge        |
| Least privilege        | RBAC per user      | Operator/Engineer/Admin roles per zone          |
| Assume breach          | Microsegmentation  | Zone segmentation (Purdue levels)               |
| Continuous monitoring  | EDR + SIEM         | Passive network monitoring (no active scanning) |
| Encrypt communications | TLS 1.3 everywhere | OPC UA security mode where supported            |

> สำหรับ Zero Trust concepts เชิงลึก → ดู references/zero-trust-architecture.md (Domain 11)

---

## 3. IEC 62443 — ความปลอดภัยระบบอัตโนมัติอุตสาหกรรม (Industrial Automation Security)

IEC 62443 (ISA/IEC 62443) เป็น international standard series สำหรับ IACS (Industrial Automation and Control Systems) security
ออกแบบให้ครอบคลุมทุก stakeholder: asset owner, system integrator, component supplier

### Security Levels (SL 1-4)

| Level    | Target                                            | Description                                                      | Example                                                      |
| -------- | ------------------------------------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------ |
| **SL 1** | Casual or coincidental violation                  | Protection against casual/unintentional unauthorized access      | Basic authentication, default password changed               |
| **SL 2** | Intentional violation using simple means          | Protection against intentional attack with low resources         | Role-based access, network segmentation                      |
| **SL 3** | Intentional violation using sophisticated means   | Protection against sophisticated attack (state actors, APT)      | Strong auth, encrypted protocols, IDS, continuous monitoring |
| **SL 4** | Intentional violation using state-sponsored means | Protection against nation-state attacks with unlimited resources | Air-gap + data diode, HSM, defense-in-depth max              |

### Zones and Conduits Model

IEC 62443 จัดกลุ่ม assets เป็น **zones** (กลุ่มที่มี security level เดียวกัน) และ **conduits** (ช่องทาง communication ระหว่าง zones):

```
Zone & Conduit Architecture:

┌─────────────────────────────────────────────────────────┐
│  ZONE: Enterprise Network (SL 1)                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐               │
│  │ Email    │ │ ERP      │ │ Web      │               │
│  │ Server   │ │ System   │ │ Server   │               │
│  └──────────┘ └──────────┘ └──────────┘               │
└─────────────────┬───────────────────────────────────────┘
                  │ CONDUIT: Industrial DMZ (Firewall + IDS)
┌─────────────────┴───────────────────────────────────────┐
│  ZONE: OT DMZ (SL 2)                                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐               │
│  │ Historian│ │ Patch    │ │ Jump     │               │
│  │ Mirror   │ │ Server   │ │ Server   │               │
│  └──────────┘ └──────────┘ └──────────┘               │
└─────────────────┬───────────────────────────────────────┘
                  │ CONDUIT: OT Firewall (strict rules)
┌─────────────────┴───────────────────────────────────────┐
│  ZONE: Control Network (SL 3)                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐               │
│  │ SCADA    │ │ HMI      │ │ Historian│               │
│  │ Server   │ │ Stations │ │ Server   │               │
│  └──────────┘ └──────────┘ └──────────┘               │
└─────────────────┬───────────────────────────────────────┘
                  │ CONDUIT: Control firewall
┌─────────────────┴───────────────────────────────────────┐
│  ZONE: Field Devices (SL 2-3)                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐               │
│  │ PLCs     │ │ RTUs     │ │ Sensors  │               │
│  └──────────┘ └──────────┘ └──────────┘               │
└─────────────────────────────────────────────────────────┘
```

### Security Requirements by Component Type

| Component                     | IEC 62443-4-2 Requirements                                                                     |
| ----------------------------- | ---------------------------------------------------------------------------------------------- |
| **Software Application** (SR) | Authentication (SR 1.1), Access control (SR 2.1), Audit (SR 2.8), Session management           |
| **Embedded Device** (EDR)     | Resource availability (EDR 3.10), Malicious code protection (EDR 3.2), Communication integrity |
| **Host Device** (HDR)         | Least functionality (HDR 2.13), Session lock (HDR 2.5), Audit log protection (HDR 2.8)         |
| **Network Device** (NDR)      | Network segmentation (NDR 5.2), Deny by default (NDR 5.3), Boundary protection                 |

### Certification and Compliance

IEC 62443 certification levels:

- **ISASecure EDSA** — Embedded Device Security Assurance (for PLCs, RTUs)
- **ISASecure SSA** — System Security Assurance (for SCADA/DCS systems)
- **ISASecure SDLA** — Security Development Lifecycle Assurance (for suppliers)

---

## 4. Purdue Model / ISA-95 Network Segmentation

Purdue Enterprise Reference Architecture (PERA) / ISA-95 กำหนด 6 levels สำหรับ OT network segmentation:

### 6-Level Architecture

```
Purdue Model — Industrial Network Architecture:

╔══════════════════════════════════════════════════════════════════╗
║  Level 5: Enterprise Network                                     ║
║  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐              ║
║  │ Internet│ │ Email   │ │ ERP     │ │ Cloud   │              ║
║  │ Access  │ │ Server  │ │ (SAP)   │ │ SaaS    │              ║
║  └─────────┘ └─────────┘ └─────────┘ └─────────┘              ║
╠══════════════════════════════════════════════════════════════════╣
║  Level 4: IT/Business Network                                    ║
║  ┌─────────┐ ┌─────────┐ ┌─────────┐                          ║
║  │ Business│ │ File    │ │ IT      │                          ║
║  │ Systems │ │ Servers │ │ Security│                          ║
║  └─────────┘ └─────────┘ └─────────┘                          ║
╠══════════════════════════════════════════════════════════════════╣
║  Level 3.5: Industrial DMZ (IT/OT Boundary)                     ║
║  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐         ║
║  │ Historian│ │ Remote  │ │ Patch   │ │ AV/      │         ║
║  │ Replica  │ │ Access  │ │ Mgmt    │ │ Update   │         ║
║  │          │ │ Gateway │ │ Server  │ │ Server   │         ║
║  └──────────┘ └──────────┘ └──────────┘ └──────────┘         ║
║  ═══════════ Industrial Firewall ═══════════                   ║
╠══════════════════════════════════════════════════════════════════╣
║  Level 3: Site Operations                                        ║
║  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐              ║
║  │ SCADA   │ │ MES     │ │ Historian│ │ Eng.    │              ║
║  │ Server  │ │ Server  │ │ Server  │ │ Workst. │              ║
║  └─────────┘ └─────────┘ └─────────┘ └─────────┘              ║
╠══════════════════════════════════════════════════════════════════╣
║  Level 2: Area Supervisory Control                               ║
║  ┌─────────┐ ┌─────────┐ ┌─────────┐                          ║
║  │ HMI     │ │ Alarm   │ │ Local   │                          ║
║  │ Panels  │ │ Server  │ │ Control │                          ║
║  └─────────┘ └─────────┘ └─────────┘                          ║
╠══════════════════════════════════════════════════════════════════╣
║  Level 1: Basic Control (Controllers)                            ║
║  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐              ║
║  │ PLC     │ │ RTU     │ │ DCS     │ │ Safety  │              ║
║  │         │ │         │ │ Ctrl    │ │ PLC/SIS │              ║
║  └─────────┘ └─────────┘ └─────────┘ └─────────┘              ║
╠══════════════════════════════════════════════════════════════════╣
║  Level 0: Physical Process                                       ║
║  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐              ║
║  │ Sensors │ │Actuators│ │ Valves  │ │ Motors  │              ║
║  └─────────┘ └─────────┘ └─────────┘ └─────────┘              ║
╚══════════════════════════════════════════════════════════════════╝
```

### Recommended Firewall/DMZ Placement

| Boundary            | Firewall Type                 | Key Rules                                                 |
| ------------------- | ----------------------------- | --------------------------------------------------------- |
| Level 5 ↔ Level 4   | Enterprise FW                 | Standard IT firewall rules                                |
| Level 4 ↔ Level 3.5 | **Industrial DMZ FW (outer)** | Allow only specific services to DMZ; deny direct IT→OT    |
| Level 3.5 ↔ Level 3 | **Industrial DMZ FW (inner)** | Allow only OT services from DMZ; deny all internet-bound  |
| Level 3 ↔ Level 2   | Control network FW            | Limit to HMI ↔ SCADA protocols only                       |
| Level 2 ↔ Level 1   | Protocol-aware FW             | Allow only specific industrial protocols (Modbus, OPC UA) |

### IT/OT DMZ Design Patterns

**Pattern 1: Dual-Firewall DMZ** (แนะนำ)

```
IT Network ── [FW-A] ── DMZ ── [FW-B] ── OT Network
   - ไม่มี traffic ผ่านตรงจาก IT → OT
   - ทุก data exchange ผ่าน DMZ services
   - FW-A และ FW-B ใช้คนละ vendor เพื่อ defense diversity
```

**Pattern 2: Data Diode** (สำหรับ high-security)

```
OT Network ──→ [Data Diode] ──→ IT Network
   - One-way data flow: OT → IT เท่านั้น
   - ไม่มีทาง send command จาก IT → OT ผ่าน diode
   - เหมาะสำหรับ critical infrastructure (nuclear, military)
   - ตัวอย่าง: Waterfall Security, OPSWAT, Owl Cyber Defense
```

---

## 5. การค้นหาและจัดทำทะเบียน OT Assets (OT Asset Discovery & Inventory)

### Passive vs Active Discovery in OT

| Method          | Passive Discovery                   | Active Discovery                                          |
| --------------- | ----------------------------------- | --------------------------------------------------------- |
| **How**         | Mirror/SPAN port, listen to traffic | Send probes/queries to devices                            |
| **Impact**      | **Zero impact on operations**       | May crash legacy devices                                  |
| **Coverage**    | Only active communicating devices   | All reachable devices                                     |
| **OT Safety**   | Safe                                | **Potentially dangerous** for old PLCs                    |
| **Recommended** | **Always use in OT**                | Use with extreme caution, during maintenance windows only |

**กฎ OT**: ใช้ **passive discovery เป็นค่าเริ่มต้น** — active scanning อาจทำให้ PLC/RTU หยุดทำงานหรือ reboot
ใช้ active scanning เฉพาะระหว่าง maintenance window และได้รับ approval จาก operations team

### Asset Classification

| Asset Category            | Examples                                      | Priority                             |
| ------------------------- | --------------------------------------------- | ------------------------------------ |
| **Safety Systems (SIS)**  | Safety PLCs, ESD systems, fire & gas          | **Critical** — never scan actively   |
| **Controllers (Level 1)** | PLCs, RTUs, DCS controllers                   | **High** — passive discovery only    |
| **Supervisory (Level 2)** | HMI, alarm servers, local control             | **High** — passive preferred         |
| **Operations (Level 3)**  | SCADA servers, historians, MES                | **Medium** — can use cautious active |
| **DMZ (Level 3.5)**       | Jump servers, patch servers, historian mirror | **Medium** — standard IT scanning OK |

### OT Asset Inventory Template

```yaml
# OT Asset Inventory Entry
asset_id: "PLC-AREA1-001"
asset_type: "PLC"
manufacturer: "Siemens"
model: "S7-1500"
firmware_version: "V2.9.4"
purdue_level: 1
zone: "Production Area 1"
ip_address: "10.10.1.101"
mac_address: "00:1A:2B:3C:4D:5E"
protocols:
  - "PROFINET"
  - "OPC UA"
  - "S7comm"
network_segment: "VLAN 110"
criticality: "High"
safety_related: false
last_firmware_update: "2025-06-15"
known_vulnerabilities:
  - "CVE-2023-XXXXX"
owner: "Process Engineering"
location: "Building A, Cabinet R3"
backup_status: "Weekly logic backup"
notes: "Controls packaging line 1"
```

### OT Discovery & Inventory Tools

| Tool                                 | Type                          | Protocols Supported                      | License                |
| ------------------------------------ | ----------------------------- | ---------------------------------------- | ---------------------- |
| **Claroty xDome**                    | Passive + safe active         | 450+ industrial protocols                | Commercial             |
| **Nozomi Networks Guardian**         | Passive + active              | Modbus, DNP3, OPC, S7, EtherNet/IP       | Commercial             |
| **Dragos Platform**                  | Passive                       | ICS-specific (S7comm, EtherNet/IP, DNP3) | Commercial             |
| **Tenable OT Security** (Tenable.ot) | Passive + safe active queries | Modbus, S7, OPC UA, BACnet               | Commercial             |
| **Shodan** (external)                | Active (internet-facing only) | Banner grabbing, protocol detection      | Freemium               |
| **Grassmarlin** (DHS)                | Passive                       | ICS protocols                            | Open-source (archived) |
| **Malcolm** (CISA)                   | Passive (full packet capture) | ICS protocol analysis via Zeek           | Open-source            |

> CIS Controls mapping: CIS Control 1 (Enterprise Asset Inventory) และ Control 2 (Software Asset Inventory)
> ใช้ได้กับ OT โดยเพิ่ม fields สำหรับ firmware version, protocol, zone/level

---

## 6. การเฝ้าระวังเครือข่าย OT และตรวจจับภัยคุกคาม (OT Network Monitoring & Threat Detection)

### OT-Specific SIEM/Monitoring Patterns

การ monitor OT network ต่างจาก IT อย่างมาก:

| Aspect               | IT Monitoring                | OT Monitoring                                       |
| -------------------- | ---------------------------- | --------------------------------------------------- |
| **Data source**      | Logs, netflow, EDR telemetry | **Packet capture, protocol inspection**             |
| **Agent-based**      | Standard practice            | **Avoid** — agents may impact real-time performance |
| **Detection method** | Signature + behavioral       | **Baseline + anomaly** (OT traffic is predictable)  |
| **Alert volume**     | High (filter noise)          | Low (every anomaly matters)                         |
| **Integration**      | SIEM (Splunk, Elastic)       | OT SIEM or OT-aware module + IT SIEM                |

### Industrial Protocol Analysis

| Protocol             | Port      | Usage                                | Security Concern                                         |
| -------------------- | --------- | ------------------------------------ | -------------------------------------------------------- |
| **Modbus TCP**       | 502       | SCADA ↔ PLC, register read/write     | No authentication, no encryption, command injection      |
| **DNP3** (IEEE 1815) | 20000     | SCADA ↔ RTU (power, water)           | Optional Secure Authentication (SA) — rarely enabled     |
| **OPC UA**           | 4840      | Modern machine-to-machine            | Built-in security model (sign, encrypt) — verify enabled |
| **BACnet**           | 47808     | Building automation (HVAC, lighting) | No native security, device impersonation possible        |
| **EtherNet/IP**      | 44818     | Rockwell/Allen-Bradley PLCs          | CIP security extension available but not default         |
| **PROFINET**         | Various   | Siemens PLCs (S7 series)             | Limited security; S7comm has known vulnerabilities       |
| **IEC 61850** (MMS)  | 102       | Power grid substation automation     | MMS protocol has limited authentication                  |
| **MQTT**             | 1883/8883 | IIoT sensor data transport           | Often deployed without TLS (port 1883)                   |

### MITRE ATT&CK for ICS Technique Mapping

MITRE ATT&CK for ICS framework ครอบคลุม TTP เฉพาะสำหรับ Industrial Control Systems:

| Tactic               | Key Techniques                                                         | Detection                                                       |
| -------------------- | ---------------------------------------------------------------------- | --------------------------------------------------------------- |
| **Initial Access**   | T0819: Exploit Public-Facing Application, T0886: Remote Services       | Firewall logs, anomalous inbound connections                    |
| **Execution**        | T0807: Command-Line Interface, T0858: Change Operating Mode            | PLC mode change alerts, unauthorized program uploads            |
| **Persistence**      | T0839: Module Firmware, T0889: Modify Program                          | Firmware hash comparison, logic change detection                |
| **Lateral Movement** | T0812: Default Credentials, T0866: Exploitation of Remote Services     | Failed auth attempts, cross-zone traffic                        |
| **Collection**       | T0802: Automated Collection, T0811: Data from Information Repositories | Large data transfers from historian, unusual queries            |
| **Inhibit Response** | T0800: Activate Firmware Update Mode, T0838: Modify Alarm Settings     | Alarm suppression alerts, firmware mode changes                 |
| **Impair Process**   | T0831: Manipulation of Control, T0836: Modify Parameter                | Setpoint changes outside normal range, PLC program modification |
| **Impact**           | T0882: Theft of Operational Information, T0879: Damage to Property     | Abnormal physical process readings, safety system triggers      |

### Anomaly Detection in OT Traffic

OT traffic เป็น **highly predictable** (ต่างจาก IT) ทำให้ baseline-based anomaly detection ได้ผลดี:

```
OT Anomaly Detection Baseline:

1. Communication Pattern Baseline
   - Which devices talk to which devices
   - Normal protocols per device pair
   - Normal traffic volume per device
   - Normal timing/frequency of commands

2. Process Value Baseline
   - Normal ranges for process variables (temperature, pressure, flow)
   - Normal setpoint values
   - Normal PLC program hash
   - Normal firmware versions

3. Behavioral Baseline
   - Normal operator login times/patterns
   - Normal engineering access frequency
   - Normal configuration changes per week
   - Normal HMI screen access patterns

Anomalies to Alert:
- New device communicating on OT network (unknown MAC/IP)
- Unusual protocol on device (e.g., HTTP on PLC)
- PLC program upload/download outside maintenance window
- Setpoint change outside normal operating range
- Communication between Purdue levels that bypasses DMZ
- Modbus WRITE commands from unexpected source
- Safety system alarm suppressed or modified
```

---

## 7. การตอบสนองเหตุการณ์ OT (OT Incident Response)

### OT-Specific IR Considerations

**หลักการ: Safety First, No Hasty Reboot**

OT IR ต่างจาก IT IR อย่างสิ้นเชิง — การ reboot PLC หรือ isolate SCADA อาจทำให้กระบวนการทางกายภาพหยุดฉุกเฉิน

| Phase           | IT IR                                | OT IR                                                         |
| --------------- | ------------------------------------ | ------------------------------------------------------------- |
| **Containment** | Isolate host, disable account        | **Isolate network segment, NOT individual controller**        |
| **Eradication** | Reimage machine, patch vulnerability | **Restore from known-good PLC backup, during planned outage** |
| **Recovery**    | Bring systems online                 | **Verify process stability before full restoration**          |
| **Reboot**      | Standard practice                    | **NEVER reboot controllers without operations approval**      |

### OT IR Decision Tree

```
OT Security Incident Detected
│
├── Is there immediate SAFETY risk?
│   ├── YES → Activate Emergency Shutdown (ESD) per safety procedures
│   │         Notify plant operations IMMEDIATELY
│   │         Physical safety > cyber response
│   └── NO  → Continue IR process
│
├── Is the OT network actively being manipulated?
│   ├── YES → Isolate at network boundary (disable IT↔OT conduit)
│   │         Do NOT disable individual controllers
│   │         Switch to manual/local control if possible
│   └── NO  → Monitor and collect evidence
│
├── Can you identify the attack vector?
│   ├── IT→OT lateral movement → Block at DMZ firewall
│   ├── Compromised engineering workstation → Isolate workstation
│   ├── Direct OT network intrusion → Isolate affected zone
│   └── Supply chain / firmware → Disconnect from update server
│
└── Recovery priority:
    1. Verify Safety Instrumented Systems (SIS) integrity
    2. Verify process controller (PLC/DCS) logic integrity
    3. Restore SCADA/HMI visibility
    4. Restore historian and logging
    5. Re-enable IT/OT connectivity (after verification)
```

### ICS-CERT Coordination

เมื่อเกิด OT security incident ที่มีผลกระทบร้ายแรง ต้องประสานงานกับ:

| Organization                | Role                                      | Contact                                        |
| --------------------------- | ----------------------------------------- | ---------------------------------------------- |
| **CISA ICS-CERT** (US)      | Federal ICS incident coordination         | ics-cert@cisa.dhs.gov                          |
| **สกมช. / NCSA** (Thailand) | Thai national cyber incident coordination | ncsa.or.th                                     |
| **ThaiCERT**                | Thai computer emergency response          | thaicert.or.th                                 |
| **Vendor PSIRT**            | OT vendor product security response       | Siemens ProductCERT, Schneider PSIRT, Rockwell |
| **FIRST**                   | Global incident response community        | first.org                                      |

### Containment Strategies for OT

| Strategy                          | When to Use                    | Risk                               |
| --------------------------------- | ------------------------------ | ---------------------------------- |
| **Network isolation (DMZ block)** | IT→OT attack vector            | Loses remote monitoring            |
| **VLAN isolation**                | Affected zone containment      | May impact inter-zone process      |
| **Manual/local mode**             | Active process manipulation    | Requires operator presence         |
| **Data diode activation**         | One-way data still needed      | No remote commands possible        |
| **Full air-gap**                  | Severe compromise, safety risk | Complete loss of remote operations |

### Recovery Procedures for PLCs and SCADA

```
OT Recovery Checklist:

1. VERIFY — Before restoring anything:
   □ Compare PLC logic hash with known-good backup
   □ Verify firmware version matches approved baseline
   □ Check Safety PLC / SIS independence and integrity
   □ Review historian data for process anomalies during incident

2. RESTORE — In order of priority:
   □ Restore SIS/Safety systems first (verify independently)
   □ Restore PLC programs from offline backup (verified hash)
   □ Restore SCADA server from clean image
   □ Restore HMI configurations
   □ Restore historian from backup (verify data integrity)

3. VALIDATE — Before returning to production:
   □ Run I/O check on all restored controllers
   □ Verify process values within normal range
   □ Test safety functions (emergency stop, alarms)
   □ Conduct operator walkthrough of restored system
   □ Monitor for 24-72 hours before full trust

4. RECONNECT — Last step:
   □ Re-enable IT/OT connectivity only after OT verified clean
   □ Update all firewall rules based on incident lessons
   □ Enable enhanced monitoring on attack vector
```

> สำหรับ IR playbook templates → ดู references/ir-playbooks.md (Domain 1)

---

## 8. การ Hardening SCADA/PLC/HMI (SCADA/PLC/HMI Hardening)

### PLC Security Configuration Checklist

```
PLC Hardening Checklist:

AUTHENTICATION & ACCESS
□ Change all default passwords (admin/admin, 0000, etc.)
□ Enable CPU protection mode (Run/Program key switch or password)
□ Set program upload/download password
□ Disable unnecessary communication services (HTTP, FTP, SNMP)
□ Configure access control lists (ACLs) if supported
□ Use physical key switch for mode changes where available

NETWORK
□ Enable protocol-level security (OPC UA security mode, DNP3 SA)
□ Disable unused ports and protocols
□ Place PLC behind industrial firewall
□ Use VLANs to segment PLC network
□ Disable web server if not operationally needed
□ Restrict management protocols to engineering workstation IPs only

FIRMWARE & SOFTWARE
□ Run latest vendor-approved firmware (not necessarily newest)
□ Verify firmware signature before installation
□ Schedule firmware updates during maintenance windows only
□ Keep offline backup of current firmware and PLC program
□ Document every firmware change in change management system

MONITORING
□ Enable audit logging where supported
□ Monitor for PLC mode changes (RUN → STOP → PROGRAM)
□ Alert on PLC program uploads/downloads
□ Baseline normal PLC memory usage and cycle time
□ Monitor for new/unexpected connections to PLC
```

### HMI Hardening

| Category           | Hardening Action                                                                  |
| ------------------ | --------------------------------------------------------------------------------- |
| **OS**             | Minimal OS install, disable unnecessary services (Bluetooth, WiFi, print spooler) |
| **Authentication** | Individual operator accounts (no shared login), session timeout ≤ 15 min          |
| **Application**    | Application whitelisting (AppLocker/applocker), disable USB auto-run              |
| **Network**        | Dedicated OT VLAN, block internet access from HMI                                 |
| **Display**        | Lock down to HMI application only (kiosk mode), disable Alt-Tab, Task Manager     |
| **Updates**        | Test patches on staging HMI before production, never auto-update                  |
| **Backup**         | Weekly image backup, store offline, test restore quarterly                        |

### SCADA Communication Security

| Protocol       | Security Enhancement                                       | Implementation                                           |
| -------------- | ---------------------------------------------------------- | -------------------------------------------------------- |
| **Modbus TCP** | Use Modbus/TCP security (TLS wrapper) or VPN tunnel        | mbtget + stunnel, or industrial VPN                      |
| **DNP3**       | Enable Secure Authentication (DNP3-SA)                     | IEEE 1815 SA v5, challenge-response                      |
| **OPC UA**     | Set security policy to `Basic256Sha256` + `SignAndEncrypt` | opcua-server config: SecurityPolicy, MessageSecurityMode |
| **BACnet**     | Use BACnet Secure Connect (BACnet/SC)                      | TLS 1.3 over WebSocket                                   |
| **MQTT**       | Use TLS (port 8883), require client certificates           | mosquitto: require_certificate true                      |

### Firmware Update Procedures (Change Management)

```
OT Firmware Update Workflow:

1. EVALUATE
   □ Review vendor security advisory
   □ Assess criticality (CVSS + OT impact)
   □ Check vendor-specific compatibility matrix
   □ Identify all affected devices in asset inventory

2. TEST
   □ Test on lab/staging PLC (identical model)
   □ Verify I/O functionality post-update
   □ Verify process control logic still functions
   □ Measure cycle time change (must be within tolerance)
   □ Test rollback procedure

3. PLAN
   □ Schedule during planned maintenance window
   □ Notify operations team (minimum 48 hours advance)
   □ Prepare rollback plan with tested backup
   □ Assign OT engineer + IT security for joint update
   □ Pre-stage firmware on OT patch management server

4. EXECUTE
   □ Backup current firmware and PLC program
   □ Verify backup integrity (hash comparison)
   □ Apply firmware update per vendor procedure
   □ Verify device boots correctly
   □ Run I/O test and process verification
   □ Monitor for 4-8 hours post-update

5. DOCUMENT
   □ Update asset inventory (firmware version)
   □ Update OT change management log
   □ Close change ticket with verification evidence
   □ Update vulnerability scan baseline
```

---

## 9. บริบทประเทศไทย — โครงสร้างพื้นฐานสำคัญภายใต้ พ.ร.บ. ไซเบอร์ 2562 (Thai Context — CII under Cybersecurity Act)

### Critical Information Infrastructure (CII) Categories

พระราชบัญญัติการรักษาความมั่นคงปลอดภัยไซเบอร์ พ.ศ. 2562 กำหนด CII ที่เกี่ยวข้องกับ OT/ICS:

| CII Sector                         | หน่วยงานกำกับ     | OT/ICS Relevance                                                         |
| ---------------------------------- | ----------------- | ------------------------------------------------------------------------ |
| **พลังงาน (Energy)**               | กกพ. (ERC)        | โรงไฟฟ้า, สายส่ง, ท่อก๊าซ, โรงกลั่น — SCADA/DCS เป็นหลัก                 |
| **น้ำ (Water)**                    | กปน./กปภ.         | ระบบผลิตน้ำประปา, บำบัดน้ำเสีย — SCADA control                           |
| **คมนาคม (Transportation)**        | กรมขนส่ง, รฟท.    | ระบบรถไฟฟ้า, สนามบิน, ท่าเรือ — OT/ICS automation                        |
| **สาธารณสุข (Healthcare)**         | กระทรวงสาธารณสุข  | ระบบ Building Management System (BMS), medical devices                   |
| **โทรคมนาคม (Telecommunications)** | กสทช.             | โครงข่ายโทรคมนาคม — network infrastructure                               |
| **การเงิน (Banking & Finance)**    | ธปท. (BOT)        | ATM, payment systems, data centers — primarily IT but with OT components |
| **ราชการ (Government)**            | สำนักนายกรัฐมนตรี | ระบบราชการที่มี physical control systems                                 |

### สกมช. (NCSA) Reporting Requirements

สำนักงานคณะกรรมการการรักษาความมั่นคงปลอดภัยไซเบอร์แห่งชาติ (สกมช. / NCSA)
กำหนดระดับภัยคุกคามไซเบอร์:

| ระดับ       | Classification            | Response Timeline | Reporting                  |
| ----------- | ------------------------- | ----------------- | -------------------------- |
| **ระดับ 1** | ไม่ร้ายแรง (Non-critical) | ตามปกติ           | รายงานตามกำหนด             |
| **ระดับ 2** | ร้ายแรง (Serious)         | ภายใน 72 ชั่วโมง  | แจ้ง สกมช. ทันที           |
| **ระดับ 3** | วิกฤต (Critical)          | ภายใน 24 ชั่วโมง  | แจ้ง สกมช. + กรรมการ ทันที |

สำหรับ CII sector ที่เกี่ยวข้องกับ OT/ICS, incident ที่ส่งผลกระทบต่อ physical process ถือเป็น **ระดับ 3 (วิกฤต)**

### Thai Energy/Transport/Water Sector OT Landscape

ภาพรวม OT landscape ในประเทศไทยสำหรับ CII sectors:

| Sector                           | Typical OT Systems                                              | Common Vendors                              | Key Challenges                                |
| -------------------------------- | --------------------------------------------------------------- | ------------------------------------------- | --------------------------------------------- |
| **Electricity (EGAT, PEA, MEA)** | SCADA/EMS, substation automation (IEC 61850), generator control | ABB, Siemens, GE, Schneider                 | Legacy SCADA, wide geographic distribution    |
| **Oil & Gas (PTT, IRPC)**        | DCS, pipeline SCADA, tank farm automation, SIS                  | Honeywell, Yokogawa, Emerson                | Safety-critical processes, aging DCS          |
| **Water (MWA, PWA)**             | SCADA for pump stations, water treatment PLC                    | Schneider, Allen-Bradley, local integrators | Budget constraints, limited OT security staff |
| **Rail (BTS, MRT, SRT)**         | Signaling systems, SCADA, building automation                   | Siemens, Alstom, Thales                     | Safety of passengers, IT/OT convergence rapid |
| **Manufacturing**                | DCS, PLC, robotics, MES                                         | Siemens, Rockwell, Mitsubishi, Omron        | Industry 4.0 push increasing connectivity     |

---

## 10. เอกสารอ้างอิงและ Checklist ความปลอดภัย OT (Framework References & OT Security Checklist)

### Framework Reference Table

| Framework                 | Version      | Organization | Focus Area                     | URL                                                                                |
| ------------------------- | ------------ | ------------ | ------------------------------ | ---------------------------------------------------------------------------------- |
| **NIST SP 800-82**        | Rev.3 (2023) | NIST         | OT/ICS security guide          | csrc.nist.gov/publications/detail/sp/800-82/rev-3/final                            |
| **IEC 62443**             | Series       | ISA/IEC      | Industrial automation security | isa.org/standards-and-publications/isa-standards/isa-iec-62443-series-of-standards |
| **Purdue Model / ISA-95** | —            | ISA          | OT network architecture        | isa.org/isa95                                                                      |
| **MITRE ATT&CK for ICS**  | v15          | MITRE        | OT-specific TTP mapping        | attack.mitre.org/techniques/ics/                                                   |
| **NERC CIP**              | v5+          | NERC         | North American electric grid   | nerc.com/pa/Stand/Pages/CIPStandards.aspx                                          |
| **API 1164**              | 3rd ed.      | API          | Pipeline SCADA security        | api.org                                                                            |
| **NIST SP 800-53**        | Rev 5        | NIST         | Security controls (IT+OT)      | csrc.nist.gov/publications/detail/sp/800-53/rev-5/final                            |
| **CIS Controls v8.1**     | v8.1         | CIS          | Prioritized security practices | cisecurity.org/controls                                                            |

### OT Security Checklist — Quick Win / Standard / Advanced

#### Quick Win (ดำเนินการได้ทันที, ไม่ต้อง budget มาก)

- [ ] เปลี่ยน default password บน PLC/RTU/HMI ทุกตัว
- [ ] ปิด unused services บน OT devices (HTTP, FTP, SNMP, Telnet)
- [ ] แยก IT/OT network ด้วย firewall อย่างน้อย 1 ชั้น
- [ ] เริ่มทำ OT asset inventory (spreadsheet ก็ได้)
- [ ] Backup PLC program และ configurations
- [ ] ตั้ง alert สำหรับ PLC mode change (RUN→STOP→PROGRAM)
- [ ] ฝึกอบรม OT staff เรื่อง phishing awareness
- [ ] จำกัด USB access บน HMI workstations

#### Standard (ดำเนินการภายใน 6 เดือน, ต้องลงทุนปานกลาง)

- [ ] Deploy passive OT network monitoring (Nozomi, Claroty, Dragos หรือ Malcolm)
- [ ] สร้าง Industrial DMZ ตาม Purdue Model (Level 3.5)
- [ ] Implement network segmentation ตาม zones & conduits (IEC 62443)
- [ ] สร้าง OT-specific incident response plan (แยกจาก IT IR plan)
- [ ] Establish change management สำหรับ OT firmware/software updates
- [ ] Deploy application whitelisting บน HMI/engineering workstations
- [ ] Integrate OT alerts เข้า SOC/SIEM (read-only feed จาก OT)
- [ ] Conduct OT-specific risk assessment (NIST 800-82 methodology)
- [ ] Map OT assets ตาม IEC 62443 security zones
- [ ] Establish OT security roles and responsibilities

#### Advanced (ดำเนินการภายใน 12-18 เดือน, ลงทุนสูง)

- [ ] Deploy unidirectional gateways (data diodes) สำหรับ critical zones
- [ ] Implement OPC UA security (Sign + Encrypt) ทดแทน legacy protocols
- [ ] Achieve IEC 62443 certification (component หรือ system level)
- [ ] Deploy OT-specific threat intelligence feeds (Dragos WorldView, ICS-CERT advisories)
- [ ] Establish OT red team / purple team exercises
- [ ] Implement Zero Trust for OT (role-based, zone-aware access control)
- [ ] Full IT/OT SOC integration with OT-aware playbooks
- [ ] Automated PLC logic integrity verification (hash comparison, version control)
- [ ] OT cyber-physical simulation exercises (table-top + technical)
- [ ] Compliance with IEC 62443 SL-3 for critical zones

---

**MITRE ATT&CK for ICS Reference**: เมื่อสร้าง output ที่เกี่ยวข้องกับ OT threats ต้องอ้างอิง
MITRE ATT&CK for ICS technique IDs (เช่น T0858: Change Operating Mode, T0831: Manipulation of Control)
เพิ่มเติมจาก ATT&CK Enterprise techniques ที่ใช้สำหรับ initial access ผ่าน IT network

> สำหรับ compliance frameworks ที่เกี่ยวข้อง → ดู references/compliance-frameworks.md (Domain 9)
> สำหรับ vulnerability management ของ OT devices → ดู references/vulnerability-management.md (Domain 14)
> สำหรับ threat intelligence สำหรับ ICS → ดู references/threat-intelligence.md (Domain 15)
