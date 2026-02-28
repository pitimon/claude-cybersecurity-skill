# Zero Trust Architecture Reference

คู่มือสถาปัตยกรรม Zero Trust เชิงลึก — NIST 800-207, CISA Maturity Model, Five Pillars
พร้อม implementation templates, roadmap และ maturity assessment

> สำหรับ SOC operations และ monitoring → ดู references/soc-operations.md
> สำหรับ GitOps security policies → ดู references/gitops-security.md
> สำหรับ cloud security configurations → ดู references/cloud-security-cspm.md (Domain 10)
> สำหรับ end-to-end cloud compliance workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 4: SOC Operations → `references/soc-operations.md`
- Domain 5: GitOps Security → `references/gitops-security.md`
- Domain 10: Cloud Security & CSPM → `references/cloud-security-cspm.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 18: OT/ICS Security → `references/ot-ics-security.md`
- Domain 20: Post-Quantum Cryptography → `references/post-quantum-cryptography.md`
- Domain 21: Identity & Access Security → `references/identity-access-security.md`

## Table of Contents

1. Zero Trust Overview & Principles
2. NIST SP 800-207 Framework
3. Five Pillars of Zero Trust
4. CISA Zero Trust Maturity Model
5. Implementation Patterns & Templates
6. Zero Trust Roadmap
7. Zero Trust Security Checklist

---

## 1. หลักการ Zero Trust (Zero Trust Overview & Principles)

### ปรัชญาหลัก: "Never Trust, Always Verify"

Zero Trust เป็น security model ที่ยกเลิกแนวคิด implicit trust ทั้งหมด
ทุก request ต้องผ่านการ authenticate, authorize และ encrypt โดยไม่สนว่ามาจาก network zone ใด

```
Traditional Security:              Zero Trust Security:
"Trust but verify"                 "Never trust, always verify"

┌──────────────────────┐           ┌──────────────────────┐
│   Trusted Network    │           │  Every request is    │
│   ┌──────────────┐   │           │  verified regardless │
│   │ Once inside, │   │           │  of source location  │
│   │ free to roam │   │           │                      │
│   └──────────────┘   │           │  ┌────┐  ┌────┐     │
│                      │           │  │Auth│→ │Authz│→ OK │
│   ===Firewall===     │           │  └────┘  └────┘     │
│      Perimeter       │           │  Applied to EVERY    │
└──────────────────────┘           │  access attempt      │
                                   └──────────────────────┘
```

### 3 หลักการหลัก (Core Principles)

1. **Verify Explicitly** — ทุก access request ต้องผ่านการ authenticate และ authorize จาก data points ทั้งหมด: user identity, location, device health, service/workload, data classification, anomalies
2. **Use Least Privilege Access** — จำกัด access ด้วย Just-In-Time (JIT) และ Just-Enough-Access (JEA), risk-based adaptive policies, data protection ตาม sensitivity
3. **Assume Breach** — ออกแบบระบบโดยสมมติว่า attacker อยู่ใน network แล้ว, minimize blast radius ด้วย micro-segmentation, ใช้ end-to-end encryption, continuous monitoring

### ประวัติความเป็นมา (History)

| ปี (Year) | เหตุการณ์ (Event)                                                    |
| --------- | -------------------------------------------------------------------- |
| 2010      | Forrester (John Kindervag) บัญญัติคำว่า "Zero Trust"                 |
| 2014      | Google เผยแพร่ BeyondCorp — Zero Trust implementation ขนาดใหญ่       |
| 2020      | NIST SP 800-207 — มาตรฐาน Zero Trust Architecture อย่างเป็นทางการ    |
| 2021      | EO 14028 — Executive Order on Cybersecurity กำหนดให้ Federal ใช้ ZTA |
| 2023      | CISA Zero Trust Maturity Model v2.0 — maturity assessment framework  |
| 2024      | DoD Zero Trust Reference Architecture v2.0                           |

### Vendor-Specific Implementation Reference: MCRA

Microsoft Cybersecurity Reference Architecture (MCRA) เป็น vendor-specific reference architecture
ที่ map Microsoft security products (Entra ID, Defender XDR, Sentinel, Intune, Purview)
เข้ากับ Zero Trust pillars ทั้ง 5 ด้าน สามารถใช้เป็นตัวอย่าง implementation สำหรับองค์กรที่ใช้ Microsoft ecosystem
แต่ควรใช้คู่กับ vendor-neutral standards เช่น NIST 800-207 และ CISA ZT Maturity Model เป็นหลัก

> **หมายเหตุ**: MCRA เป็น vendor-specific — plugin นี้ออกแบบเป็น vendor-neutral
> ใช้ NIST 800-207 เป็น primary reference, MCRA เป็น supplementary implementation guide สำหรับ Microsoft shops เท่านั้น

### เปรียบเทียบ Traditional Perimeter vs Zero Trust

| Aspect           | Traditional Perimeter       | Zero Trust                         |
| ---------------- | --------------------------- | ---------------------------------- |
| Trust Model      | Trust internal network      | Trust nothing, verify everything   |
| Network Design   | Castle-and-moat perimeter   | Micro-segmented, identity-centric  |
| Access Control   | VPN + firewall rules        | Per-request policy evaluation      |
| Lateral Movement | Easy once inside perimeter  | Restricted by micro-segmentation   |
| Visibility       | North-south traffic only    | East-west + north-south monitoring |
| Authentication   | One-time at perimeter       | Continuous, context-aware          |
| Remote Access    | VPN tunnel to corporate     | ZTNA direct-to-app access          |
| Security Posture | Strong perimeter, soft core | Defense-in-depth at every layer    |
| Cloud Readiness  | Difficult to extend         | Cloud-native by design             |

### คำศัพท์สำคัญ (Key Terminology)

- **PDP (Policy Decision Point)** — จุดที่ตัดสินใจว่า access request ผ่านหรือไม่ ประกอบด้วย PE + PA
- **PEP (Policy Enforcement Point)** — จุดที่ enforce decision ของ PDP (เช่น gateway, proxy, firewall)
- **PE (Policy Engine)** — component ที่คำนวณ trust score และตัดสินใจ grant/deny
- **PA (Policy Administrator)** — component ที่ establish/terminate session ตาม PE decision
- **ZTNA (Zero Trust Network Access)** — ทดแทน VPN ด้วย identity-based, application-level access
- **SDP (Software Defined Perimeter)** — สร้าง perimeter แบบ dynamic รอบ resources

### Forrester ZTX (Zero Trust eXtended)

Forrester ZTX ขยายแนวคิด Zero Trust เดิมเป็น 7 domains ที่ map กับ CISA 5 Pillars:
Data Security (→ Data), Network Security (→ Network), People Security (→ Identity),
Workload Security (→ Application), Device Security (→ Device),
plus **Visibility** และ **Automation** เป็น cross-pillar capabilities
สำหรับ centralized analytics, orchestration และ automated response

---

## 2. มาตรฐาน NIST 800-207 (NIST SP 800-207 Framework)

### 7 Tenets of Zero Trust (หลักการ 7 ข้อ)

| #   | Tenet                                                            | คำอธิบาย                                                         |
| --- | ---------------------------------------------------------------- | ---------------------------------------------------------------- |
| 1   | All data sources and computing services are resources            | ทุก device, service, data store ถือเป็น resource ที่ต้องปกป้อง   |
| 2   | All communication is secured regardless of network location      | Encrypt ทุก traffic ไม่ว่าจะอยู่ใน internal network              |
| 3   | Access to individual resources is granted on a per-session basis | ทุก session ต้อง authenticate ใหม่ ไม่มี persistent trust        |
| 4   | Access is determined by dynamic policy                           | Policy ใช้ identity, device state, behavior, environment context |
| 5   | Enterprise monitors and measures integrity of all assets         | Continuous monitoring ทุก device ที่ connect เข้ามา              |
| 6   | All resource authentication and authorization are dynamic        | Re-evaluate trust ตลอดเวลา ไม่ใช่แค่ตอน login                    |
| 7   | Enterprise collects info about current state of assets/network   | ใช้ data จาก network, infra, communications เพื่อปรับปรุง policy |

### 3 Deployment Approaches

```
Approach 1: Enhanced Identity Governance
├── เน้น identity เป็นหลัก
├── Strong authentication (MFA, passwordless)
├── Fine-grained authorization (RBAC → ABAC)
└── เหมาะกับ: องค์กรที่มี mature identity infrastructure

Approach 2: Micro-Segmentation
├── เน้น network segmentation
├── แบ่ง network เป็น zones ย่อยมาก
├── Workload-level isolation
└── เหมาะกับ: Data center, multi-tier applications

Approach 3: Software Defined Perimeter (SDP)
├── เน้น network infrastructure
├── สร้าง overlay network ตาม identity
├── Resources invisible จนกว่าจะ authenticate
└── เหมาะกับ: Cloud-native, remote workforce
```

### Logical Architecture (สถาปัตยกรรมเชิงตรรกะ)

```
                    ┌─────────────────────────────────────┐
                    │        Policy Data Sources           │
                    │  ┌──────┐ ┌──────┐ ┌──────────────┐ │
                    │  │ CDM  │ │Threat│ │ Activity Logs│ │
                    │  │System│ │Intel │ │              │ │
                    │  └──┬───┘ └──┬───┘ └──────┬───────┘ │
                    └─────┼────────┼────────────┼─────────┘
                          │        │            │
                          ▼        ▼            ▼
                    ┌─────────────────────────────────────┐
                    │    PE (Policy Engine)                 │
                    │    คำนวณ trust score จาก:             │
                    │    • User identity + MFA status      │
                    │    • Device health + compliance      │
                    │    • Behavior analytics              │
                    │    • Threat intelligence              │
                    │    • Data sensitivity level           │
                    └────────────────┬────────────────────┘
                                     │ Decision
                                     ▼
                    ┌─────────────────────────────────────┐
                    │    PA (Policy Administrator)          │
                    │    Establish / Terminate session      │
                    └────────────────┬────────────────────┘
                                     │
Subject ─────▶ PEP (Policy Enforcement Point) ─────▶ Resource
  (User/       Gateway, Proxy, Firewall                (App, Data,
   Device)     Enforce grant/deny decision              Service)
```

### Trust Algorithm Inputs

| Input Category      | Data Points                                           | Weight |
| ------------------- | ----------------------------------------------------- | ------ |
| User Identity       | MFA status, role, clearance, authentication method    | High   |
| Device Health       | OS patch level, AV status, MDM enrollment, compliance | High   |
| Behavior Analytics  | Login patterns, access frequency, geo-velocity        | Medium |
| Threat Intelligence | IP reputation, known attack patterns, IOC matches     | Medium |
| Data Sensitivity    | Classification level, regulatory requirements         | High   |
| Request Context     | Time of day, source location, requested action        | Low    |
| Historical Access   | Previous access patterns, privilege usage history     | Low    |

---

## 3. เสาหลัก 5 ประการของ Zero Trust (Five Pillars of Zero Trust)

### Pillar 1: Identity (อัตลักษณ์)

ทุก access ต้องผูกกับ verified identity — ทั้ง users, services และ machines

**Components**:

- **MFA (Multi-Factor Authentication)** — Phishing-resistant MFA (FIDO2, passkeys) เป็น minimum
- **Conditional Access** — Policy ตาม risk signals (device, location, behavior)
- **Identity Governance** — Lifecycle management, access reviews, JIT/JEA
- **PAM (Privileged Access Management)** — Vault secrets, session recording, just-in-time elevation
- **SSO Federation** — SAML/OIDC federation ข้าม IdP, eliminate password sprawl

| Maturity Level | Description                                                                       |
| -------------- | --------------------------------------------------------------------------------- |
| Traditional    | Password-only authentication, static group-based access, no centralized IdP       |
| Initial        | MFA deployed, centralized IdP (Azure AD/Okta), basic RBAC                         |
| Advanced       | Phishing-resistant MFA, conditional access policies, PAM for admins, ABAC         |
| Optimal        | Passwordless auth, continuous identity verification, automated JIT/JEA, AI-driven |

### Pillar 2: Device (อุปกรณ์)

ทุก device ที่เข้าถึง resources ต้องผ่านการ assess trust level

**Components**:

- **Device Trust Scoring** — คำนวณ trust จาก OS version, patch level, security config
- **MDM/UEM** — Manage และ enforce policy บน endpoints (Intune, Jamf, Workspace ONE)
- **Endpoint Compliance** — Check AV status, disk encryption, firewall, screen lock
- **Device Identity** — Certificate-based identity, TPM attestation

| Maturity Level | Description                                                                 |
| -------------- | --------------------------------------------------------------------------- |
| Traditional    | No device inventory, BYOD unmanaged, network-based access only              |
| Initial        | Device inventory exists, MDM on corporate devices, basic compliance checks  |
| Advanced       | Real-time compliance enforcement, device health in access decisions, EDR    |
| Optimal        | Continuous device attestation, automated remediation, hardware-rooted trust |

### Pillar 3: Network (เครือข่าย)

Network ไม่ใช่ trust boundary อีกต่อไป — ใช้ micro-segmentation และ encryption ทุก path

**Components**:

- **Micro-Segmentation** — แยก workloads เป็น segments ย่อยมาก, deny-all default
- **Encrypted Communications** — mTLS ทุก service-to-service, TLS 1.3 minimum
- **SDN (Software Defined Networking)** — Dynamic network policy ตาม identity/context
- **East-West Traffic Control** — Monitor และ control lateral movement ภายใน network

| Maturity Level | Description                                                                            |
| -------------- | -------------------------------------------------------------------------------------- |
| Traditional    | Flat network, perimeter firewall only, no east-west visibility                         |
| Initial        | Basic VLANs/subnets, some internal firewalls, encrypted external traffic               |
| Advanced       | Micro-segmentation by workload, mTLS for services, east-west monitoring                |
| Optimal        | Fully software-defined, identity-based segmentation, automated policy, full encryption |

### Pillar 4: Application/Workload (แอปพลิเคชัน)

ทุก application ต้องมี authentication/authorization ของตัวเอง ไม่พึ่ง network trust

**Components**:

- **Application-Level Auth** — ทุก app มี AuthN/AuthZ ของตัวเอง, OAuth 2.0 / OIDC
- **ZTNA vs VPN** — เปลี่ยนจาก network-level VPN เป็น app-level ZTNA
- **Service Mesh** — Istio/Linkerd สำหรับ mTLS, authorization policies ระหว่าง services
- **Workload Identity** — SPIFFE/SPIRE สำหรับ machine-to-machine identity

| Maturity Level | Description                                                               |
| -------------- | ------------------------------------------------------------------------- |
| Traditional    | Network-based access, VPN for remote, no app-level auth                   |
| Initial        | SSO for web apps, VPN still primary, basic API authentication             |
| Advanced       | ZTNA deployed, service mesh with mTLS, workload identity (SPIFFE)         |
| Optimal        | All apps via ZTNA, per-request authorization, fully meshed, AI-driven WAF |

### Pillar 5: Data (ข้อมูล)

ข้อมูลเป็นสิ่งที่ Zero Trust ปกป้องเป็นหลัก — ต้อง classify, encrypt และ monitor ทุก access

**Components**:

- **Data Classification** — Classify ข้อมูลตาม sensitivity: Public, Internal, Confidential, Restricted
- **Encryption** — At-rest (AES-256) + in-transit (TLS 1.3) + in-use (confidential computing)
- **DLP (Data Loss Prevention)** — Prevent unauthorized data exfiltration
- **Access Logging** — Log ทุก data access สำหรับ audit trail
- **Rights Management** — Information Rights Management (IRM), conditional sharing

| Maturity Level | Description                                                                              |
| -------------- | ---------------------------------------------------------------------------------------- |
| Traditional    | No classification, encryption only at perimeter, no DLP                                  |
| Initial        | Basic classification, encryption at rest/transit, manual DLP rules                       |
| Advanced       | Automated classification, granular DLP, access logging, tokenization                     |
| Optimal        | Real-time classification, adaptive DLP, confidential computing, zero-standing privileges |

---

## 4. โมเดลวุฒิภาวะ Zero Trust ตาม CISA (CISA Zero Trust Maturity Model)

### CISA Maturity Levels Overview

```
Traditional ──▶ Initial ──▶ Advanced ──▶ Optimal

Traditional:  Legacy approach, manual processes, perimeter-centric
Initial:      Some automation, transitioning to ZT principles
Advanced:     Centralized, automated, cross-pillar integration
Optimal:      Fully automated, AI-driven, continuous optimization
```

### Self-Assessment Checklist by Pillar

#### Identity Maturity Assessment

- [ ] **Traditional**: Password-only auth ยังใช้อยู่
- [ ] **Initial**: MFA deployed สำหรับ critical systems
- [ ] **Initial**: Centralized IdP (Azure AD, Okta, Google Workspace)
- [ ] **Advanced**: Phishing-resistant MFA (FIDO2/Passkeys) enforced
- [ ] **Advanced**: Conditional access policies based on risk signals
- [ ] **Advanced**: PAM solution สำหรับ privileged accounts
- [ ] **Optimal**: Passwordless authentication organization-wide
- [ ] **Optimal**: Continuous identity verification (behavioral biometrics)

#### Device Maturity Assessment

- [ ] **Traditional**: ไม่มี comprehensive device inventory
- [ ] **Initial**: MDM/UEM deployed บน corporate devices
- [ ] **Initial**: Basic compliance checks (OS version, AV)
- [ ] **Advanced**: Real-time device health in access decisions
- [ ] **Advanced**: EDR deployed, automated response
- [ ] **Optimal**: Hardware-rooted trust (TPM attestation)
- [ ] **Optimal**: Automated device remediation/quarantine

#### Network Maturity Assessment

- [ ] **Traditional**: Flat network, perimeter firewall เท่านั้น
- [ ] **Initial**: Basic segmentation (VLANs), encrypted external traffic
- [ ] **Advanced**: Micro-segmentation by workload, mTLS deployed
- [ ] **Advanced**: East-west traffic monitoring active
- [ ] **Optimal**: Full SDN, identity-based network policy
- [ ] **Optimal**: Encrypted all internal + external communications

#### Application Maturity Assessment

- [ ] **Traditional**: VPN-based access, no app-level auth
- [ ] **Initial**: SSO deployed, basic API auth
- [ ] **Advanced**: ZTNA replaces VPN, service mesh with mTLS
- [ ] **Advanced**: Workload identity (SPIFFE/SPIRE) deployed
- [ ] **Optimal**: Per-request authorization, all apps via ZTNA
- [ ] **Optimal**: AI-driven application security controls

#### Data Maturity Assessment

- [ ] **Traditional**: ไม่มี data classification scheme
- [ ] **Initial**: Basic classification, encryption at rest/transit
- [ ] **Advanced**: Automated classification, granular DLP active
- [ ] **Advanced**: Comprehensive audit logging for data access
- [ ] **Optimal**: Real-time adaptive DLP, confidential computing
- [ ] **Optimal**: Zero standing access to sensitive data

### Implementation Priority Matrix

| Priority      | Actions                                        | Effort | Impact |
| ------------- | ---------------------------------------------- | ------ | ------ |
| Quick Win     | Deploy MFA on all accounts                     | Low    | High   |
| Quick Win     | Enable encryption at rest/transit              | Low    | High   |
| Quick Win     | Create asset/device inventory                  | Low    | Medium |
| Medium Effort | Deploy centralized IdP with conditional access | Medium | High   |
| Medium Effort | Implement network segmentation                 | Medium | High   |
| Medium Effort | Deploy MDM/UEM on endpoints                    | Medium | Medium |
| Long-term     | Micro-segmentation by workload                 | High   | High   |
| Long-term     | ZTNA replaces VPN                              | High   | High   |
| Long-term     | Passwordless auth organization-wide            | High   | Medium |
| Long-term     | Continuous verification + AI-driven policy     | High   | High   |

---

## 5. รูปแบบการนำไปใช้ (Implementation Patterns & Templates)

### Micro-Segmentation Policy Template

```markdown
## Micro-Segmentation Policy: [Application Name]

### Policy ID: MSEG-[YYYY]-[NNN]

### Effective Date: [Date]

### Owner: [Team/Person]

### Segment Definition

| Attribute        | Value                              |
| ---------------- | ---------------------------------- |
| Segment Name     | [e.g., payment-processing]         |
| Environment      | [Production / Staging / Dev]       |
| Workloads        | [List of services in segment]      |
| Data Sensitivity | [Public / Internal / Confidential] |

### Allowed Communications

| Source Segment     | Destination Segment | Protocol | Port | Direction | Justification             |
| ------------------ | ------------------- | -------- | ---- | --------- | ------------------------- |
| api-gateway        | payment-processing  | HTTPS    | 443  | Inbound   | API requests              |
| payment-processing | database-segment    | TCP      | 5432 | Outbound  | Database queries          |
| monitoring         | payment-processing  | HTTPS    | 9090 | Inbound   | Prometheus metrics scrape |

### Denied Communications (Explicit)

- Default: DENY ALL not explicitly allowed above
- No direct internet access from this segment
- No lateral movement to other application segments
```

### ZTNA vs VPN Comparison & Migration

| Feature          | Traditional VPN         | ZTNA                              |
| ---------------- | ----------------------- | --------------------------------- |
| Access Scope     | Full network access     | Per-application access            |
| Authentication   | One-time at connection  | Continuous per-session            |
| Visibility       | Tunnel obscures traffic | Full application-level visibility |
| Lateral Movement | Possible once connected | Prevented by design               |
| User Experience  | Client + full tunnel    | Clientless or lightweight agent   |
| Scalability      | VPN concentrator limits | Cloud-native, elastic             |
| Cloud Support    | Hairpin through DC      | Direct-to-cloud access            |

### Conditional Access Policy Template

```markdown
## Conditional Access Policy: [Policy Name]

### Policy ID: CAP-[YYYY]-[NNN]

### Platform: [Azure AD / Okta / Google Workspace]

### Conditions

| Condition         | Value                                  |
| ----------------- | -------------------------------------- |
| Users/Groups      | [All Users / Specific Group]           |
| Applications      | [All Cloud Apps / Specific Apps]       |
| Device Platform   | [Windows, macOS, iOS, Android, Linux]  |
| Location          | [Named locations / Any / Trusted only] |
| Device Compliance | [Compliant / Domain-joined / Any]      |
| Sign-in Risk      | [Low / Medium / High]                  |
| User Risk         | [Low / Medium / High]                  |

### Access Controls (Grant)

| Control                     | Setting        |
| --------------------------- | -------------- |
| Require MFA                 | [Yes / No]     |
| Require compliant device    | [Yes / No]     |
| Require approved client app | [Yes / No]     |
| Require password change     | [If high risk] |

### Session Controls

| Control                        | Setting                     |
| ------------------------------ | --------------------------- |
| Sign-in frequency              | [e.g., 8 hours]             |
| Persistent browser session     | [Never / Always]            |
| Conditional Access App Control | [Monitor / Block downloads] |
```

### Service Mesh Zero Trust Configuration (Istio mTLS)

```yaml
# Istio PeerAuthentication — enforce mTLS ทั้ง mesh
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: istio-system
spec:
  mtls:
    mode: STRICT # บังคับ mTLS ทุก service-to-service

---
# Istio AuthorizationPolicy — allow เฉพาะ traffic ที่กำหนด
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: payment-service-policy
  namespace: production
spec:
  selector:
    matchLabels:
      app: payment-service
  action: ALLOW
  rules:
    - from:
        - source:
            principals: ["cluster.local/ns/production/sa/api-gateway"]
      to:
        - operation:
            methods: ["POST"]
            paths: ["/api/v1/payments"]

---
# Deny all other traffic by default
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: deny-all
  namespace: production
spec: {} # Empty spec = deny all traffic not explicitly allowed
```

### Identity-Aware Proxy Pattern (BeyondCorp Style)

```
User Request Flow (BeyondCorp Model):

User ──▶ Identity-Aware Proxy ──▶ Application
           │
           ├── 1. Authenticate user (IdP: Okta/Azure AD)
           ├── 2. Check device trust (MDM compliance)
           ├── 3. Evaluate context (location, time, risk)
           ├── 4. Apply access policy (per-app rules)
           ├── 5. Log access decision (audit trail)
           └── 6. Grant/Deny with session controls

Tools: Google IAP, Cloudflare Access, Zscaler Private Access, Palo Alto Prisma Access
```

---

## 6. แผนการดำเนินงาน Zero Trust (Zero Trust Roadmap)

### Phase-by-Phase Implementation

```
Month:  1   2   3   4   5   6   7   8   9   10  11  12
        ├───────────┤───────────┤───────────┤───────────┤
        Phase 1:     Phase 2:    Phase 3:    Phase 4:
        Identity     Device +    Application Data +
        Foundation   Network     Controls    Continuous
                                             Verification

Phase 1 ████████████
Phase 2              ████████████
Phase 3                          ████████████
Phase 4                                      ████████████
```

### Phase 1: Identity Foundation (เดือนที่ 1-3)

| Activity                        | Deliverable                           | Owner    |
| ------------------------------- | ------------------------------------- | -------- |
| Deploy MFA on all user accounts | MFA enrollment > 95%                  | IAM team |
| Implement centralized SSO       | All SaaS apps federated via IdP       | IAM team |
| Create identity inventory       | Complete user/service account catalog | IAM team |
| Establish conditional access    | Risk-based policies for critical apps | Security |
| Deploy PAM for admin accounts   | Privileged access via vault only      | IAM team |
| Define access review process    | Quarterly review schedule established | GRC      |

### Phase 2: Device Trust + Network Segmentation (เดือนที่ 4-6)

| Activity                          | Deliverable                          | Owner    |
| --------------------------------- | ------------------------------------ | -------- |
| Deploy MDM/UEM on all endpoints   | 100% corporate device enrollment     | IT Ops   |
| Define device compliance policies | Compliance checks automated          | Security |
| Implement network segmentation    | Critical workloads isolated          | Network  |
| Enable east-west traffic logging  | Lateral movement visibility achieved | SOC      |
| Deploy EDR on all endpoints       | Endpoint detection active            | SecOps   |
| Encrypt internal communications   | TLS 1.3 on internal services         | Platform |

### Phase 3: Application-Level Controls (เดือนที่ 7-9)

| Activity                          | Deliverable                          | Owner     |
| --------------------------------- | ------------------------------------ | --------- |
| Deploy ZTNA for remote access     | VPN decommission plan started        | Network   |
| Implement service mesh (mTLS)     | Service-to-service encryption active | Platform  |
| Deploy workload identity          | SPIFFE/SPIRE for machine identity    | Platform  |
| App-level authorization policies  | Per-app access controls enforced     | App teams |
| API gateway with auth enforcement | All APIs behind gateway with auth    | Platform  |
| Application inventory complete    | Shadow IT identified and addressed   | Security  |

### Phase 4: Data Protection + Continuous Verification (เดือนที่ 10-12)

| Activity                        | Deliverable                            | Owner     |
| ------------------------------- | -------------------------------------- | --------- |
| Implement data classification   | All data stores classified             | Data team |
| Deploy DLP policies             | Sensitive data exfiltration prevented  | Security  |
| Enable continuous verification  | Session re-evaluation active           | IAM team  |
| Automate compliance monitoring  | ZTA compliance dashboard live          | GRC       |
| Conduct ZTA maturity assessment | Maturity scorecard completed           | Security  |
| Red team exercise against ZTA   | Findings addressed, controls validated | SecOps    |

### KPIs and Metrics for ZTA Success

| Metric                           | เป้าหมาย (Target)    | Measurement Method              |
| -------------------------------- | -------------------- | ------------------------------- |
| MFA Adoption Rate                | > 99%                | IdP enrollment reports          |
| Mean Time to Detect (MTTD)       | < 1 hour             | SIEM/SOC metrics                |
| Percentage of Apps via ZTNA      | > 90%                | ZTNA gateway access logs        |
| Device Compliance Rate           | > 95%                | MDM/UEM compliance dashboard    |
| Lateral Movement Incidents       | 0                    | SOC incident reports            |
| Micro-Segmentation Coverage      | > 80% of workloads   | Network policy audit            |
| VPN Dependency                   | 0 (fully migrated)   | VPN connection logs             |
| Access Policy Violations Blocked | 100% detected        | PDP/PEP logs                    |
| Data Classification Coverage     | > 90% of data stores | DLP/classification tool reports |

### Common Pitfalls and Mitigations

| Pitfall                                        | Mitigation                                                  |
| ---------------------------------------------- | ----------------------------------------------------------- |
| Trying to do everything at once                | Phased approach, start with identity (highest impact)       |
| Ignoring user experience                       | Pilot with IT team first, gather feedback, iterate          |
| Legacy applications cannot support ZTA         | Use identity-aware proxy as bridge, plan modernization      |
| Over-reliance on single vendor                 | Multi-vendor strategy, standards-based (OIDC, SCIM, SPIFFE) |
| Insufficient logging and monitoring            | Deploy SIEM integration from Phase 1, not as afterthought   |
| Not involving business stakeholders            | Executive sponsor, regular business alignment meetings      |
| Treating Zero Trust as a product, not strategy | ZTA is an architecture — no single product delivers it      |
| Neglecting service/machine identities          | Include workload identity (SPIFFE) in scope from Phase 1    |

---

## 7. รายการตรวจสอบ Zero Trust (Zero Trust Security Checklist)

### Identity Pillar (NIST Tenets: 3, 4, 6)

- [ ] MFA enforced on all user accounts (phishing-resistant preferred) — **Quick Win**
- [ ] Centralized IdP with SSO federation for all applications — **Quick Win**
- [ ] Conditional access policies based on risk signals — **Medium Effort**
- [ ] PAM deployed for all privileged/admin accounts — **Medium Effort**
- [ ] Service accounts inventoried and secured — **Medium Effort**
- [ ] JIT/JEA access for administrative tasks — **Long-term**
- [ ] Quarterly access reviews automated — **Medium Effort**
- [ ] Passwordless authentication deployed — **Long-term**

### Device Pillar (NIST Tenets: 1, 5)

- [ ] Complete device inventory maintained (corporate + BYOD) — **Quick Win**
- [ ] MDM/UEM enrolled on all corporate devices — **Medium Effort**
- [ ] Device compliance checks automated (OS, AV, encryption) — **Medium Effort**
- [ ] Device health integrated into access decisions — **Long-term**
- [ ] EDR deployed on all endpoints — **Medium Effort**
- [ ] Hardware-based attestation (TPM) for high-security assets — **Long-term**

### Network Pillar (NIST Tenets: 2, 5, 7)

- [ ] All external communications encrypted (TLS 1.3) — **Quick Win**
- [ ] Basic network segmentation (VLANs for critical systems) — **Quick Win**
- [ ] East-west traffic monitoring enabled — **Medium Effort**
- [ ] Micro-segmentation for critical workloads — **Long-term**
- [ ] mTLS for all service-to-service communication — **Long-term**
- [ ] DNS filtering and encrypted DNS (DoH/DoT) — **Medium Effort**
- [ ] Network flow logging to SIEM — **Medium Effort**

### Application/Workload Pillar (NIST Tenets: 1, 3, 4)

- [ ] Application inventory complete (including shadow IT) — **Quick Win**
- [ ] SSO integrated for all web applications — **Medium Effort**
- [ ] ZTNA deployed for remote application access — **Long-term**
- [ ] Service mesh with mTLS for microservices — **Long-term**
- [ ] Workload identity (SPIFFE/SPIRE) deployed — **Long-term**
- [ ] API gateway with authentication enforcement — **Medium Effort**
- [ ] Application-level authorization policies defined — **Medium Effort**

### Data Pillar (NIST Tenets: 1, 7)

- [ ] Data classification scheme defined and communicated — **Quick Win**
- [ ] Encryption at rest for all sensitive data stores — **Quick Win**
- [ ] DLP policies for sensitive data (PII, PHI, PCI) — **Medium Effort**
- [ ] Data access logging and audit trail enabled — **Medium Effort**
- [ ] Automated data classification deployed — **Long-term**
- [ ] Rights management for confidential documents — **Long-term**
- [ ] Zero standing access to production data — **Long-term**

### Cross-Pillar (NIST Tenets: 5, 6, 7)

- [ ] SIEM integrated with all ZTA components — **Medium Effort**
- [ ] Continuous monitoring and anomaly detection — **Long-term**
- [ ] Automated incident response for policy violations — **Long-term**
- [ ] Regular ZTA maturity assessment (quarterly) — **Medium Effort**
- [ ] Executive dashboard for ZTA metrics — **Medium Effort**
- [ ] Red team exercises targeting ZTA controls — **Long-term**
- [ ] ZTA policy review and update cycle established — **Quick Win**
