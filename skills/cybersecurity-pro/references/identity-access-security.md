# Identity & Access Security Reference

คู่มือความปลอดภัยด้าน Identity — Human/Machine/AI Agent Identity, FIDO2/Passkeys,
Non-Human Identity Management, Token Security, ITDR และ Identity Governance

> สำหรับ Zero Trust architecture → ดู references/zero-trust-architecture.md (Domain 11)
> สำหรับ API security (OAuth, JWT) → ดู references/api-security.md (Domain 13)
> สำหรับ cloud IAM → ดู references/cloud-security-cspm.md (Domain 10)
> สำหรับ security governance → ดู references/security-governance-executive.md (Domain 17)
> สำหรับ AI agent identity → ดู references/agentic-ai-security.md (Domain 19)

**Cross-references:**

- Domain 10: Cloud Security & CSPM → `references/cloud-security-cspm.md`
- Domain 11: Zero Trust Architecture → `references/zero-trust-architecture.md`
- Domain 13: API Security → `references/api-security.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 17: Security Governance → `references/security-governance-executive.md`
- Domain 19: Agentic AI Security → `references/agentic-ai-security.md`

## Table of Contents

1. Identity Threat Landscape 2026
2. Human vs Machine vs AI Agent Identity
3. Authentication Standards (NIST 800-63B, FIDO2, Passkeys)
4. Non-Human Identity Management
5. Token & Session Security (NIST IR 8587)
6. Identity Governance & Lifecycle
7. Identity Threat Detection & Response (ITDR)
8. Thai Context (บริบทประเทศไทย)
9. Identity Security Checklist

---

## Quick Reference (สรุปย่อ)

> ใช้ section นี้สำหรับตอบคำถามเร็ว — deep-dive ดู sections ด้านล่าง

**Frameworks:** NIST SP 800-63B Rev 4 | FIDO2/WebAuthn L3 | NIST IR 8587 | SPIFFE/SPIRE | OAuth 2.1

**Authentication Assurance Levels (AAL):**

| Level | Factor         | Examples                       | Use Case                   |
| ----- | -------------- | ------------------------------ | -------------------------- |
| AAL1  | Single-factor  | Password, SMS OTP (deprecated) | Public, non-sensitive      |
| AAL2  | Multi-factor   | TOTP, push notification        | Internal, SaaS             |
| AAL3  | Hardware-based | FIDO2 key, smart card (PIV)    | Critical, financial, admin |

**Identity Types:**

| Type            | Examples                                 | Ratio   |
| --------------- | ---------------------------------------- | ------- |
| Human           | Employees, contractors, customers        | 1x      |
| Non-Human (NHI) | Service accounts, API keys, workload IDs | 45x     |
| AI Agent        | Claude Code, autonomous agents           | Growing |

**Key Stats:** 30% ของ initial access vectors ใช้ stolen/leaked credentials (IBM X-Force 2025)

**Essential Controls:**

- FIDO2/Passkeys สำหรับ phishing-resistant MFA (AAL3)
- SPIFFE/SPIRE สำหรับ workload identity ใน cloud-native
- NIST IR 8587 token binding — ป้องกัน session hijacking
- ITDR (Identity Threat Detection & Response) — detect credential abuse real-time
- NHI lifecycle management — rotate, expire, audit non-human identities

**Thai Context:** NDID architecture, PromptPay identity layer, PDPA consent สำหรับ biometric data

---

## 1. ภูมิทัศน์ภัยคุกคามด้าน Identity ปี 2026 (Identity Threat Landscape 2026)

Identity กลายเป็น attack vector อันดับ 1 ขององค์กรทั่วโลก จากข้อมูล IBM X-Force Threat Intelligence Index 2025
พบว่า 30% ของ initial access vectors ใช้ valid credentials ที่ถูกขโมยหรือรั่วไหล
ในขณะที่ SentinelOne 2026 Predictions ระบุว่า identity-based attacks เพิ่มขึ้นต่อเนื่อง
โดยเฉพาะ session hijacking, MFA fatigue/bombing และ token theft

```
Identity Threat Landscape 2026:

Attack Vector Distribution (IBM X-Force / Industry Reports):

   Valid Credentials ████████████████████████████  30%
   Phishing          ██████████████████████         22%
   Exploit Vuln      █████████████████              18%
   Social Eng.       ██████████████                 15%
   Brute Force       █████████                      10%
   Other             █████                           5%

เทรนด์ที่ต้องจับตา (Key Trends):

1. Credential Stuffing — ฐานข้อมูลรั่วไหลสะสม 24B+ records
   ├── 15M+ credential stuffing attacks/day (Cloudflare 2025)
   ├── Automated tools: SentryMBA, OpenBullet, credential proxies
   └── Success rate ~0.1-2% แต่ volume ทำให้ impact สูง

2. Session Hijacking (AitM — Adversary-in-the-Middle)
   ├── Evilginx, Modlishka, EvilGoPhish reverse proxy kits
   ├── Bypass MFA โดยขโมย session cookie หลัง authentication
   └── ไม่ต้อง crack password เลย — ได้ authenticated session โดยตรง

3. MFA Fatigue / MFA Bombing
   ├── ส่ง push notifications ซ้ำจนเหยื่อกด "Allow"
   ├── Uber (Sep 2022), Cisco (Aug 2022) เป็นตัวอย่างที่โด่งดัง
   └── แก้ด้วย number matching, phishing-resistant MFA (FIDO2)

4. Non-Human Identity Explosion
   ├── Service accounts outnumber humans 45:1 (Astrix Security 2025)
   ├── API keys, service principals, machine certificates
   ├── 68% ของ service accounts มี excessive privileges
   └── เฉลี่ย rotation period 180+ วัน (ควร < 90 วัน)

5. AI Agent Identity — ชายแดนใหม่
   ├── Autonomous AI agents ทำงานแทนมนุษย์
   ├── ยังไม่มี standard สำหรับ agent identity lifecycle
   ├── ความเสี่ยง: goal hijacking, privilege escalation, delegation abuse
   └── ต้องการ scoped credentials + per-task permission model
```

### สถิติสำคัญ (Key Statistics)

| Metric                                                 | ค่า (Value) | แหล่งข้อมูล (Source)           |
| ------------------------------------------------------ | ----------- | ------------------------------ |
| ต้นทุนเฉลี่ย data breach จาก stolen credentials        | $4.81M      | IBM Cost of a Data Breach 2024 |
| เวลาเฉลี่ยในการตรวจจับ credential-based breach         | 292 วัน     | IBM CODB 2024                  |
| องค์กรที่ถูกโจมตีผ่าน identity ใน 12 เดือน             | 90%         | IDSA 2024 Report               |
| Service accounts ต่อ human identity (เฉลี่ย)           | 45:1        | Astrix Security 2025           |
| องค์กรที่ไม่มี full visibility เรื่อง service accounts | 62%         | Osterman Research 2024         |
| สัดส่วนของ breaches ที่เกี่ยวกับ compromised identity  | 80%         | CrowdStrike 2024               |
| MFA adoption rate (ค่าเฉลี่ย enterprise)               | 64%         | Okta Business at Work 2025     |
| FIDO2/Passkey adoption rate (enterprise)               | 18%         | FIDO Alliance 2025             |

### Kill Chain ของ Identity-Based Attacks

```
Identity Attack Kill Chain:

Phase 1: Reconnaissance
├── OSINT: LinkedIn, data breaches, dark web credential markets
├── Password spraying against exposed services (OWA, VPN, SSO)
└── Enumerate valid usernames via timing attacks / error messages

Phase 2: Initial Access
├── Credential stuffing (leaked credentials)
├── Phishing → credential harvest (Evilginx AitM)
├── MFA fatigue / social engineering helpdesk
└── Compromised service account / API key from code repo

Phase 3: Persistence
├── Register additional MFA device
├── Create new service account / API key
├── Inject SSH key into authorized_keys
└── Modify conditional access exclusions

Phase 4: Lateral Movement
├── Use compromised identity to access additional resources
├── Request access to new groups / roles (privilege creep)
├── Leverage service account to move between environments
└── OAuth consent grant for persistent access

Phase 5: Impact
├── Data exfiltration via legitimate cloud APIs
├── Business email compromise (BEC)
├── Ransomware deployment via admin credentials
└── Supply chain compromise via CI/CD service accounts
```

---

## 2. ตัวตนมนุษย์ เครื่อง และ AI Agent (Human vs Machine vs AI Agent Identity)

### ตารางเปรียบเทียบ 3 ประเภทของ Identity

| Aspect              | Human Identity                               | Machine Identity                              | AI Agent Identity                                   |
| ------------------- | -------------------------------------------- | --------------------------------------------- | --------------------------------------------------- |
| Lifecycle           | HR-driven (hire/transfer/leave)              | DevOps-driven (deploy/rotate/decommission)    | Dynamic (spawn/delegate/terminate)                  |
| ปริมาณ (Volume)     | 1x (baseline)                                | 45x ต่อ human                                 | กำลังเพิ่มขึ้นแบบ exponential                       |
| Auth method         | Password + MFA, FIDO2/Passkeys               | Certificate, API key, token, SPIFFE           | Delegated token, scoped credential                  |
| Credential rotation | 90-365 วัน (NIST แนะนำไม่บังคับ)             | ชั่วโมง ถึง วัน                               | Per-session หรือ per-task                           |
| Session duration    | ชั่วโมง (8-24h ทั่วไป)                       | Long-lived (days-months)                      | นาที ถึง ชั่วโมง (task-bound)                       |
| Risk profile        | Phishing, social engineering, password reuse | Key exposure, over-privileged, no rotation    | Goal hijack, privilege escalation, delegation abuse |
| Governance          | IGA (Identity Governance & Admin)            | Secret management (Vault, CSM)                | Agent permission framework (emerging)               |
| Visibility          | Good (HR system + IdP)                       | Poor (scattered across clouds, repos, config) | Very poor (dynamic, ephemeral)                      |
| Accountability      | Clear (maps to employee)                     | Shared (team/service ownership)               | Ambiguous (who owns agent decisions?)               |
| Standards           | NIST 800-63B, FIDO2                          | SPIFFE, X.509, OAuth client credentials       | No established standard yet                         |

### Identity Sprawl Diagram

```
Identity Sprawl — องค์กรขนาดกลาง (1,000 employees):

Human Identities (~1,000)
├── Employees: 800
├── Contractors: 150
└── Partners/Vendors: 50

Machine Identities (~45,000)                    AI Agent Identities (~500, growing)
├── Service Accounts: 12,000                    ├── Coding Assistants: 200
│   ├── Active Directory: 4,000                 │   ├── GitHub Copilot workspace agents
│   ├── Cloud (AWS IAM, Azure SP): 5,000        │   ├── Claude Code sessions
│   └── Database/App-level: 3,000               │   └── Custom dev agents
│                                                │
├── API Keys: 15,000                            ├── Business Automation: 150
│   ├── Internal microservices: 8,000           │   ├── Customer support agents
│   ├── Third-party integrations: 4,000         │   ├── Data analysis agents
│   └── CI/CD pipelines: 3,000                  │   └── Document processing agents
│                                                │
├── Certificates: 10,000                        ├── Security Agents: 100
│   ├── TLS/SSL: 3,000                          │   ├── SOAR playbook agents
│   ├── mTLS (service mesh): 5,000              │   ├── Threat hunting agents
│   └── Code signing: 2,000                     │   └── Compliance scanning agents
│                                                │
├── SSH Keys: 5,000                             └── Infrastructure Agents: 50
└── Secrets/Tokens: 3,000                           ├── Auto-remediation agents
                                                    ├── Capacity planning agents
                                                    └── Deployment agents

Total Identity Surface: ~46,500+
ปัญหา: 73% ขององค์กรไม่มี unified view ของ identity ทั้งหมด
```

### Identity Type Decision Tree

```
กำหนด Identity Type:
│
├── ผู้ใช้งานเป็นมนุษย์?
│   ├── YES → Human Identity
│   │   ├── พนักงาน (Employee) → Corporate IdP (Entra ID, Okta, Google Workspace)
│   │   ├── Contractor → Guest account + time-bound access
│   │   └── Partner → B2B federation (SAML/OIDC) หรือ guest
│   │
│   └── NO → Non-Human Identity
│       │
│       ├── เป็น AI Agent ที่ทำงานอัตโนมัติ?
│       │   ├── YES → AI Agent Identity
│       │   │   ├── ทำงานแทนผู้ใช้ → Delegated credential (user context)
│       │   │   ├── ทำงานอิสระ → Service principal + scoped permissions
│       │   │   └── ทำงานแบบ chain (agent→agent) → Cascading delegation with scope reduction
│       │   │
│       │   └── NO → Machine Identity
│       │       ├── Service-to-service → SPIFFE/SPIRE, mTLS certificate
│       │       ├── CI/CD pipeline → Short-lived OIDC token (GitHub Actions, GitLab CI)
│       │       ├── Cloud workload → Cloud IAM role (AWS IAM Role, Azure MI, GCP SA)
│       │       └── IoT/Device → X.509 device certificate
│       │
│       └── จัดเก็บใน Secret Manager (Vault, AWS SM, Azure KV, GCP SM)
```

---

## 3. มาตรฐานการ Authentication (Authentication Standards)

### NIST SP 800-63B Rev 4 — Authentication Assurance Levels

NIST SP 800-63B Rev 4 (2024) กำหนด 3 ระดับของ Authentication Assurance Level (AAL)
ที่องค์กรต้องเลือกตามระดับความเสี่ยงของระบบที่ต้องปกป้อง

| AAL  | คำอธิบาย                     | Authenticator Types                            | ตัวอย่างใช้งาน                                 |
| ---- | ---------------------------- | ---------------------------------------------- | ---------------------------------------------- |
| AAL1 | Single-factor authentication | Password, SMS OTP (deprecated for new systems) | ระบบสาธารณะที่มีข้อมูลไม่ sensitive            |
| AAL2 | Multi-factor authentication  | TOTP, push notification, OTP hardware token    | ระบบภายในองค์กรทั่วไป, SaaS applications       |
| AAL3 | Hardware-based multi-factor  | FIDO2 security key, smart card (PIV)           | ระบบวิกฤต, financial, government, admin access |

### Authenticator Comparison Matrix

| Authenticator                       | AAL Level         | Phishing Resistant            | Verifier Impersonation Resistant | Replay Resistant | Usability                 |
| ----------------------------------- | ----------------- | ----------------------------- | -------------------------------- | ---------------- | ------------------------- |
| Password only                       | AAL1              | No                            | No                               | No               | High (ง่าย แต่ไม่ปลอดภัย) |
| Password + SMS OTP                  | AAL1 (deprecated) | No                            | No                               | Yes              | Medium                    |
| Password + TOTP (Authenticator app) | AAL2              | No                            | No                               | Yes              | Medium                    |
| Password + Push notification        | AAL2              | No (ถ้าไม่มี number matching) | No                               | Yes              | High                      |
| Password + Push + Number matching   | AAL2              | Partial                       | No                               | Yes              | High                      |
| FIDO2 Security Key (USB/NFC)        | AAL3              | Yes                           | Yes                              | Yes              | Medium                    |
| Passkey (platform authenticator)    | AAL2-AAL3         | Yes                           | Yes                              | Yes              | Very High                 |
| Smart Card (PIV/CAC)                | AAL3              | Yes                           | Yes                              | Yes              | Low                       |
| Certificate-based (mTLS)            | AAL3              | Yes                           | Yes                              | Yes              | Low (setup)               |

### FIDO2/WebAuthn Deep Dive

FIDO2 ประกอบด้วย 2 specifications: WebAuthn (W3C) สำหรับ browser/platform APIs
และ CTAP2 (FIDO Alliance) สำหรับ external authenticator communication

```
FIDO2 Registration Flow:

User                    Browser/Platform           Relying Party (Server)
│                       │                          │
│ 1. Click "Register"   │                          │
│ ─────────────────────▶│                          │
│                       │ 2. navigator.credentials │
│                       │    .create() request     │
│                       │ ─────────────────────────▶│
│                       │                          │
│                       │ 3. PublicKeyCredential    │
│                       │    CreationOptions        │
│                       │    (challenge, rp, user,  │
│                       │     pubKeyCredParams,     │
│                       │     authenticatorSelection│
│                       │     attestation)          │
│                       │ ◀────────────────────────│
│                       │                          │
│ 4. User verification  │                          │
│    (biometric/PIN)    │                          │
│ ─────────────────────▶│                          │
│                       │                          │
│                       │ 5. AuthenticatorAttestation│
│                       │    Response               │
│                       │    (attestationObject,     │
│                       │     clientDataJSON)        │
│                       │ ─────────────────────────▶│
│                       │                          │
│                       │                          │ 6. Verify attestation
│                       │                          │    Store public key
│                       │                          │    Associate with user
│                       │                          │
│                       │ 7. Registration success  │
│                       │ ◀────────────────────────│
```

```
FIDO2 Authentication Flow:

User                    Browser/Platform           Relying Party (Server)
│                       │                          │
│ 1. Click "Sign In"    │                          │
│ ─────────────────────▶│                          │
│                       │ 2. navigator.credentials │
│                       │    .get() request        │
│                       │ ─────────────────────────▶│
│                       │                          │
│                       │ 3. PublicKeyCredential    │
│                       │    RequestOptions         │
│                       │    (challenge,            │
│                       │     allowCredentials,     │
│                       │     rpId, userVerification│
│                       │     timeout)              │
│                       │ ◀────────────────────────│
│                       │                          │
│ 4. User verification  │                          │
│    (biometric/PIN)    │                          │
│ ─────────────────────▶│                          │
│                       │                          │
│                       │ 5. AuthenticatorAssertion │
│                       │    Response               │
│                       │    (authenticatorData,     │
│                       │     signature,             │
│                       │     clientDataJSON,        │
│                       │     userHandle)            │
│                       │ ─────────────────────────▶│
│                       │                          │
│                       │                          │ 6. Verify signature
│                       │                          │    with stored pubkey
│                       │                          │    Check challenge
│                       │                          │
│                       │ 7. Authentication success│
│                       │ ◀────────────────────────│
```

### Passkeys — Platform vs Cross-Platform

| Aspect             | Platform Passkey (Synced)              | Device-Bound Passkey                | Cross-Platform Security Key     |
| ------------------ | -------------------------------------- | ----------------------------------- | ------------------------------- |
| Storage            | Cloud sync (iCloud, Google, 1Password) | TPM/Secure Enclave (ไม่ export ได้) | Hardware token (YubiKey, Titan) |
| Availability       | ทุก device ที่ sync account            | เฉพาะ device ที่ลงทะเบียน           | ต้องพกกุญแจ hardware            |
| Recovery           | Cloud account recovery                 | ไม่มี (ถ้าเสีย device = เสีย key)   | ต้องมี backup key               |
| AAL Level          | AAL2 (เพราะ exportable)                | AAL3 (hardware-bound)               | AAL3 (hardware-bound)           |
| Use case           | Consumer apps, BYOD                    | High-security enterprise            | Government, financial, admin    |
| Phishing resistant | Yes                                    | Yes                                 | Yes                             |
| Loss risk          | ต่ำ (cloud backup)                     | สูง (single device)                 | ปานกลาง (ทำ backup key ได้)     |
| Cost               | ฟรี (built into OS/browser)            | ฟรี (built into device)             | $25-70 ต่อ key                  |

### Passwordless Migration Roadmap

```
Passwordless Migration Roadmap:

Phase 1: Foundation (เดือน 1-3)
├── Inventory ทุก authentication flows
├── Deploy FIDO2 security keys สำหรับ IT/Admin (AAL3)
├── Enable passkey registration ใน IdP
├── Implement number matching สำหรับ push MFA
└── Establish phishing-resistant MFA policy สำหรับ critical apps

Phase 2: Expansion (เดือน 4-6)
├── Roll out passkeys สำหรับ employees ทั่วไป
├── ลด password complexity requirements (NIST 800-63B)
│   (เน้น length > complexity, no forced rotation)
├── Implement conditional access: require phishing-resistant MFA สำหรับ high-risk
├── Onboard partner/contractor สู่ FIDO2
└── Enable cross-device authentication (hybrid transport)

Phase 3: Password Reduction (เดือน 7-9)
├── Set password as fallback only (ไม่ใช่ primary)
├── Implement "prefer passkey" UX flow
├── ลด password reset calls (target: -60%)
├── Remove SMS OTP from all systems
└── Monitor password-only logins (target: < 10%)

Phase 4: Passwordless (เดือน 10-12)
├── Disable password auth สำหรับ internal systems
├── External apps: passkey-first, password as last resort
├── Decommission legacy OTP infrastructure
├── Continuous monitoring: FIDO2 registration coverage > 95%
└── Document remaining password exceptions with risk acceptance
```

### IdP Configuration Templates (ตัวอย่างการตั้งค่า IdP)

#### Microsoft Entra ID — Conditional Access Policy (JSON)

```json
{
  "displayName": "Require phishing-resistant MFA for admins",
  "state": "enabled",
  "conditions": {
    "users": {
      "includeRoles": [
        "62e90394-69f5-4237-9190-012177145e10",
        "194ae4cb-b126-40b2-bd5b-6091b380977d"
      ]
    },
    "applications": {
      "includeApplications": ["All"]
    },
    "clientAppTypes": ["browser", "mobileAppsAndDesktopClients"]
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [],
    "authenticationStrength": {
      "id": "00000000-0000-0000-0000-000000000004",
      "displayName": "Phishing-resistant MFA"
    }
  },
  "sessionControls": {
    "signInFrequency": {
      "value": 4,
      "type": "hours",
      "isEnabled": true
    }
  }
}
```

**หมายเหตุ:** `authenticationStrength` ID `...0004` = Phishing-resistant MFA (FIDO2 + Windows Hello + Certificate)
Deploy ผ่าน Microsoft Graph API: `POST /identity/conditionalAccess/policies`

#### Okta — Authentication Policy (Terraform)

```hcl
# Okta Authentication Policy — require FIDO2 for admin apps
resource "okta_app_signon_policy_rule" "admin_phishing_resistant" {
  policy_id          = okta_app_signon_policy.admin_policy.id
  name               = "Require FIDO2 for Admin Applications"
  priority           = 1
  status             = "ACTIVE"
  factor_mode        = "2FA"
  type               = "ASSURANCE"

  platform_include {
    type = "ANY"
  }

  constraints = jsonencode([
    {
      knowledge = {
        types                 = ["password"]
        reauthenticateIn      = "PT4H"
      }
      possession = {
        deviceBound           = "REQUIRED"
        hardwareProtection    = "REQUIRED"
        phishingResistant     = "REQUIRED"
        userPresence          = "REQUIRED"
        userVerification      = "REQUIRED"
      }
    }
  ])
}

# Okta Authenticator Enrollment Policy
resource "okta_authenticator" "webauthn" {
  name   = "Security Key or Biometric"
  key    = "webauthn"
  status = "ACTIVE"
  settings = jsonencode({
    userVerification   = "REQUIRED"
    appInstanceId      = null
    compliance = {
      fips = "OPTIONAL"
    }
    attachment         = "ANY"
    residentKey        = "REQUIRED"
  })
}
```

#### AWS IAM Identity Center — SCIM Provisioning Config

```json
{
  "schemas": ["urn:ietf:params:scim:schemas:core:2.0:ServiceProviderConfig"],
  "documentationUri": "https://docs.aws.amazon.com/singlesignon/latest/userguide/provision-automatically.html",
  "patch": { "supported": true },
  "bulk": { "supported": false },
  "filter": {
    "supported": true,
    "maxResults": 50
  },
  "changePassword": { "supported": false },
  "sort": { "supported": false },
  "etag": { "supported": false },
  "authenticationSchemes": [
    {
      "name": "OAuth Bearer Token",
      "description": "SCIM Bearer Token Authentication",
      "specUri": "https://tools.ietf.org/html/rfc6750",
      "type": "oauthbearertoken",
      "primary": true
    }
  ]
}
```

**SCIM Provisioning Setup Steps:**

1. AWS IAM Identity Center → Settings → Automatic provisioning → Enable
2. คัดลอก SCIM endpoint URL + Access token
3. Okta/Entra ID → Enterprise app → Provisioning → SCIM connector
4. ใส่ SCIM endpoint + token → Test connection
5. Configure attribute mapping: `userName`, `displayName`, `emails`, `groups`
6. Enable: Create, Update, Delete users automatically
7. ⏱ Initial sync อาจใช้เวลา 20-40 นาทีสำหรับ 1,000+ users

---

## 4. การจัดการ Non-Human Identity (Non-Human Identity Management)

Non-Human Identity (NHI) คือ identity ทั้งหมดที่ไม่ใช่มนุษย์ ได้แก่ service accounts, API keys,
machine certificates, workload identities, CI/CD tokens และ bot accounts
ปัจจุบัน NHI มีจำนวนมากกว่า human identity 45:1 แต่ได้รับการจัดการน้อยกว่ามาก

### ประเภทของ Non-Human Identity

```
Non-Human Identity Taxonomy:

┌─────────────────────────────────────────────────────────────────┐
│                    Non-Human Identities                         │
├────────────────┬───────────────┬────────────────┬──────────────┤
│ Service        │ Workload      │ Machine        │ Application  │
│ Accounts       │ Identity      │ Certificates   │ Credentials  │
│                │               │                │              │
│ • AD service   │ • SPIFFE ID   │ • TLS/SSL      │ • API keys   │
│   accounts     │ • K8s SA      │ • mTLS certs   │ • OAuth      │
│ • Cloud SPs    │ • Cloud IAM   │ • Code signing │   client     │
│   (Azure SP,   │   roles       │ • SSH keys     │   creds      │
│    AWS roles)  │ • CI/CD OIDC  │ • Device certs │ • Webhook    │
│ • DB accounts  │   tokens      │ • VPN certs    │   secrets    │
│ • Scheduled    │ • Managed     │                │ • PAT        │
│   tasks        │   identity    │                │   (Personal  │
│                │               │                │   Access     │
│                │               │                │   Tokens)    │
└────────────────┴───────────────┴────────────────┴──────────────┘
```

### SPIFFE/SPIRE Workload Identity

SPIFFE (Secure Production Identity Framework for Everyone) เป็น standard สำหรับ
workload identity ที่ออกแบบมาสำหรับ distributed systems และ service mesh

```
SPIFFE Architecture:

┌──────────────────────────────────────────────────┐
│                SPIRE Server                        │
│  ┌─────────┐  ┌──────────┐  ┌─────────────────┐  │
│  │ CA       │  │ Registry │  │ Attestation     │  │
│  │ (X.509 + │  │ (SPIFFE  │  │ (Node + Workload│  │
│  │  JWT     │  │  IDs +   │  │  attestors)     │  │
│  │  issuer) │  │  selectors│ │                 │  │
│  └─────────┘  └──────────┘  └─────────────────┘  │
└───────────────────────┬──────────────────────────┘
                        │ Attestation + SVID issuance
                        ▼
┌──────────────────────────────────────────────────┐
│               SPIRE Agent (per node)              │
│  ┌─────────────┐  ┌──────────────────────────┐   │
│  │ Workload API │  │ SVID cache               │   │
│  │ (UDS socket) │  │ (X.509-SVID, JWT-SVID)   │   │
│  └──────┬──────┘  └──────────────────────────┘   │
└─────────┼────────────────────────────────────────┘
          │
    ┌─────┼─────┐
    ▼     ▼     ▼
  Pod A  Pod B  Pod C
  (spiffe://example.org/ns/prod/sa/payment)

SPIFFE ID Format: spiffe://<trust-domain>/<path>
ตัวอย่าง: spiffe://example.org/ns/production/sa/payment-service
```

### Cloud IAM Role Mapping

| Feature                 | AWS IAM                               | Azure Entra ID                         | GCP IAM                              |
| ----------------------- | ------------------------------------- | -------------------------------------- | ------------------------------------ |
| Workload identity       | IAM Roles for Service Accounts (IRSA) | Managed Identity (System/User)         | Workload Identity Federation         |
| Cross-account           | AssumeRole + trust policy             | Cross-tenant app registration          | Cross-project SA impersonation       |
| Short-lived credentials | STS GetSessionToken (max 12h)         | Managed Identity token (24h)           | Service Account key-less (1h)        |
| CI/CD integration       | OIDC provider + IAM role              | Federated credentials                  | Workload Identity Pool               |
| Rotation                | Automatic (STS)                       | Automatic (Managed Identity)           | Automatic (key-less)                 |
| Audit                   | CloudTrail                            | Entra ID Sign-in logs                  | Cloud Audit Logs                     |
| Best practice           | ใช้ IRSA ไม่ใช่ long-lived keys       | ใช้ Managed Identity ไม่ใช่ SP secrets | ใช้ Workload Identity ไม่ใช่ SA keys |

### Kubernetes ServiceAccount Security

```yaml
# Kubernetes ServiceAccount best practices
apiVersion: v1
kind: ServiceAccount
metadata:
  name: payment-service
  namespace: production
  annotations:
    # AWS EKS: IRSA (IAM Roles for Service Accounts)
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/payment-svc-role
    # Azure AKS: Workload Identity
    azure.workload.identity/client-id: "<client-id>"
    # GCP GKE: Workload Identity
    iam.gke.io/gcp-service-account: payment-svc@project.iam.gserviceaccount.com
automountServiceAccountToken: false # ปิด auto-mount สำหรับ pods ที่ไม่ต้องใช้ K8s API

---
# Pod spec ที่ต้องใช้ ServiceAccount
apiVersion: v1
kind: Pod
metadata:
  name: payment-pod
  namespace: production
spec:
  serviceAccountName: payment-service
  automountServiceAccountToken: true # เปิดเฉพาะเมื่อจำเป็น
  containers:
    - name: payment
      image: payment-service:v2.1.0
      # Projected volume สำหรับ bound service account token (short-lived)
      volumeMounts:
        - name: sa-token
          mountPath: /var/run/secrets/tokens
          readOnly: true
  volumes:
    - name: sa-token
      projected:
        sources:
          - serviceAccountToken:
              path: token
              expirationSeconds: 3600 # 1 hour (ค่าเดิม = ไม่หมดอายุ)
              audience: "payment-api" # audience restriction
```

### Machine Identity Platform Comparison

| Platform            | Type                   | Key Capabilities                                   | จุดแข็ง                                     | ราคา                          |
| ------------------- | ---------------------- | -------------------------------------------------- | ------------------------------------------- | ----------------------------- |
| HashiCorp Vault     | Secret manager + PKI   | Dynamic secrets, PKI engine, transit encryption    | Open source, multi-cloud, plugin ecosystem  | Free (OSS), $$$$ (Enterprise) |
| CyberArk            | PAM + Machine Identity | Conjur secrets, cert management, session recording | Enterprise PAM leader, compliance reporting | $$$$                          |
| Venafi              | Machine identity mgmt  | TLS cert lifecycle, code signing, SSH key mgmt     | Machine identity specialist, outpost model  | $$$$                          |
| AWS Secrets Manager | Cloud-native secrets   | Auto rotation, RDS integration, cross-account      | AWS native, pay-per-use                     | $                             |
| Azure Key Vault     | Cloud-native secrets   | HSM-backed, managed identity integration           | Azure native, FIPS 140-2 Level 2            | $                             |
| GCP Secret Manager  | Cloud-native secrets   | Auto rotation, IAM integration, versioning         | GCP native, simple API                      | $                             |
| Akeyless            | SaaS vault             | Zero-knowledge, multi-cloud, RBAC                  | SaaS model, fragment cryptography           | $$                            |
| Doppler             | Secret management      | Environment sync, audit log, integrations          | Developer-friendly, simple setup            | $$                            |

### NHI Lifecycle Management

```
Non-Human Identity Lifecycle:

                    ┌─────────────────┐
                    │   1. REQUEST     │
                    │   ├── Owner      │
                    │   ├── Purpose    │
                    │   ├── Scope      │
                    │   └── Expiry     │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   2. APPROVE     │
                    │   ├── Security   │
                    │   ├── Least priv │
                    │   └── Time-bound │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   3. PROVISION   │
                    │   ├── Create ID  │
                    │   ├── Issue cred │
                    │   └── Store safe │
                    └────────┬────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
   ┌────────▼────────┐  ┌───▼──────────┐  ┌──▼───────────┐
   │  4. MONITOR      │  │  5. ROTATE   │  │  6. REVIEW   │
   │  ├── Usage logs  │  │  ├── Auto    │  │  ├── Quarterly│
   │  ├── Anomalies   │  │  │  rotation │  │  ├── Ownership│
   │  └── Alerts      │  │  ├── < 90 d  │  │  ├── Privilege│
   └──────────────────┘  │  └── Zero    │  │  └── Justify  │
                         │     downtime │  └──────────────┘
                         └──────────────┘
                             │
                    ┌────────▼────────┐
                    │  7. DECOMMISSION │
                    │  ├── Revoke cred │
                    │  ├── Disable acct│
                    │  ├── Archive logs│
                    │  └── Confirm dead│
                    └─────────────────┘
```

---

## 5. ความปลอดภัยของ Token และ Session (Token & Session Security — NIST IR 8587)

NIST IR 8587 (Initial Public Draft, 2025) — "Recommendations for Token and Session Protection"
กำหนดแนวปฏิบัติในการป้องกัน token theft, session hijacking และ replay attacks

### NIST IR 8587 Key Recommendations

| Area                  | Recommendation                  | รายละเอียด                                                             |
| --------------------- | ------------------------------- | ---------------------------------------------------------------------- |
| Token binding         | Bind tokens to client instance  | ใช้ DPoP (RFC 9449) หรือ mTLS certificate-bound tokens                 |
| Token lifetime        | Minimize token lifetime         | Access token: 5-15 นาที, Refresh token: 8-24 ชั่วโมง                   |
| Token storage         | Secure token storage            | httpOnly + Secure + SameSite=Strict cookies (ไม่ใช่ localStorage)      |
| Session binding       | Bind session to device context  | Device fingerprint, IP binding (flexible), TLS channel binding         |
| Continuous evaluation | Re-evaluate trust continuously  | ตรวจสอบ device compliance, location, behavior ตลอด session             |
| Token revocation      | Immediate revocation capability | Implement revocation endpoint, token introspection, short-lived tokens |
| Replay prevention     | Prevent token replay            | Use nonce, timestamp, DPoP proof, sender-constrained tokens            |

### JWT Best Practices (สรุปจาก NIST IR 8587 + RFC 9068 + RFC 8725)

```
JWT Security Checklist:

Algorithm Security:
├── [MUST]  ใช้ asymmetric algorithms: RS256, ES256, EdDSA
├── [MUST]  Reject alg: "none" อย่างเด็ดขาด
├── [MUST]  Allowlist algorithms ฝั่ง server (ห้ามเชื่อ JWT header)
├── [MUST]  ห้ามใช้ HS256 กับ public APIs (แชร์ key = เสี่ยง)
└── [SHOULD] Prefer ES256 (ECDSA) หรือ EdDSA (Ed25519) — เร็วกว่า RSA

Claim Validation:
├── [MUST]  ตรวจสอบ iss (issuer) — ต้องตรงกับ trusted issuer
├── [MUST]  ตรวจสอบ aud (audience) — ต้อง match กับ API ปลายทาง
├── [MUST]  ตรวจสอบ exp (expiration) — max 15 นาที สำหรับ access token
├── [MUST]  ตรวจสอบ nbf (not before) — ป้องกัน token ถูกใช้ก่อนเวลา
├── [SHOULD] ตรวจสอบ iat (issued at) — reject ถ้าเก่าเกินไป
├── [SHOULD] ใช้ jti (JWT ID) — ป้องกัน replay attack
└── [SHOULD] ตรวจสอบ sub (subject) — match กับ user context

Key Management:
├── [MUST]  ใช้ JWKS endpoint สำหรับ public key distribution
├── [MUST]  Support kid (key ID) header สำหรับ key selection
├── [SHOULD] Key rotation ทุก 90 วัน (overlap period 7 วัน)
├── [SHOULD] Cache JWKS response (max 24h, force refresh on unknown kid)
└── [SHOULD] Store private keys ใน HSM หรือ cloud KMS
```

### Session Management Security

```
Session Security Architecture:

Client                  Session Service              Backend
│                       │                            │
│ 1. Authenticate       │                            │
│ ──────────────────────▶ 2. Create session          │
│                       │    ├── Session ID (opaque)  │
│                       │    ├── Bind to: device FP   │
│                       │    ├── Bind to: IP range    │
│                       │    ├── Bind to: TLS channel │
│                       │    └── Set: max idle 30m    │
│                       │         max absolute 8h     │
│ ◀──── Set-Cookie ─────│                            │
│   id=<sid>;            │                            │
│   httpOnly;Secure;     │                            │
│   SameSite=Strict;     │                            │
│   Path=/;              │                            │
│   max-age=28800        │                            │
│                       │                            │
│ 3. API request + cookie│                            │
│ ──────────────────────▶ 4. Validate session        │
│                       │    ├── Check: not expired   │
│                       │    ├── Check: device FP     │
│                       │    ├── Check: IP in range   │
│                       │    ├── Check: not revoked   │
│                       │    └── Step-up if needed    │
│                       │                            │
│                       │ 5. Forward + user context  │
│                       │ ──────────────────────────▶│
│                       │                            │
│ ◀──── Response ───────────────────────────────────│
```

### Token Theft Detection Patterns

| Detection Pattern          | Signal                                              | Detection Method                      | Response                      |
| -------------------------- | --------------------------------------------------- | ------------------------------------- | ----------------------------- |
| Impossible travel          | Access token ใช้จาก 2 locations ที่เดินทางไม่ทัน    | Geo-velocity check (< 500 mph)        | Revoke token, force re-auth   |
| Device mismatch            | Token ใช้จาก device fingerprint ที่ต่างจากตอน issue | Device fingerprint comparison         | Step-up authentication        |
| IP anomaly                 | Token ใช้จาก IP range/ASN ที่ผิดปกติ                | IP reputation + baseline comparison   | Risk-based conditional access |
| Concurrent sessions        | Token เดียวกันใช้พร้อมกันจากหลาย locations          | Session concurrency check             | Terminate all sessions        |
| Token reuse after rotation | Refresh token เก่าถูกใช้หลัง rotation               | Refresh token family tracking         | Revoke entire token family    |
| AitM proxy detection       | Session cookie ถูก replay จาก attacker proxy        | Token binding (DPoP), TLS fingerprint | Terminate session, alert SOC  |

### OAuth 2.1 Improvements Over OAuth 2.0

| Feature                 | OAuth 2.0            | OAuth 2.1 (Draft)                |
| ----------------------- | -------------------- | -------------------------------- |
| PKCE                    | Optional (แนะนำ)     | Mandatory สำหรับทุก client type  |
| Implicit grant          | ใช้ได้               | Removed (ไม่อนุญาต)              |
| Resource Owner Password | ใช้ได้               | Removed (ไม่อนุญาต)              |
| Refresh token rotation  | Optional             | Mandatory สำหรับ public clients  |
| Redirect URI matching   | Flexible             | Exact match only (ห้าม wildcard) |
| Bearer tokens           | Default              | DPoP/mTLS-bound tokens แนะนำ     |
| Authorization code      | Reusable (some impl) | Single-use only                  |
| Client authentication   | Various methods      | ลดเหลือ recommended methods      |

---

## 6. การกำกับดูแลและวงจร Identity (Identity Governance & Lifecycle)

### Joiner-Mover-Leaver Workflow

```
Identity Lifecycle — Joiner-Mover-Leaver:

JOINER (เข้าร่วมองค์กร)
├── HR creates employee record → trigger identity provisioning
├── Auto-create accounts: IdP, email, SaaS (SCIM)
├── Assign base entitlements (birthright access) ตาม:
│   ├── Department
│   ├── Role / job title
│   ├── Location
│   └── Employment type
├── Manager approval สำหรับ additional access
├── Register MFA device (FIDO2 security key + passkey)
├── Security awareness training (mandatory)
└── Day 1: account active, access ready

MOVER (ย้ายตำแหน่ง/ทีม)
├── HR updates role/department → trigger access review
├── REMOVE old entitlements (ห้ามสะสม = privilege creep)
├── GRANT new entitlements ตาม new role
├── Manager of OLD team: confirm access removal
├── Manager of NEW team: approve new access
├── Re-certify remaining access
└── Timeline: ภายใน 5 business days

LEAVER (ออกจากองค์กร)
├── HR marks termination date → trigger deprovisioning
├── Immediate (involuntary termination):
│   ├── Disable all accounts (IdP, email, SaaS)
│   ├── Revoke all active sessions
│   ├── Revoke MFA devices
│   ├── Revoke OAuth grants
│   └── Disable VPN/ZTNA access
├── Scheduled (voluntary resignation):
│   ├── Last day: disable accounts + sessions
│   ├── Transfer file/email ownership
│   └── Remove from all groups/roles
├── 30 days: delete accounts (retain audit logs)
└── Verify: no orphaned accounts remain
```

### Access Certification & Review

| Review Type              | ความถี่               | ผู้ทำ Review   | เป้าหมาย                                           |
| ------------------------ | --------------------- | -------------- | -------------------------------------------------- |
| Manager review           | Quarterly (3 เดือน)   | Direct manager | ตรวจสอบว่า direct reports มีเฉพาะ access ที่จำเป็น |
| Application owner review | Semi-annual (6 เดือน) | App owner      | ตรวจสอบว่าทุกคนที่ access แอปมีเหตุผลทาง business  |
| Privileged access review | Monthly (เดือน)       | Security team  | ตรวจสอบ admin/privileged accounts ทั้งหมด          |
| Service account review   | Quarterly (3 เดือน)   | Service owner  | ตรวจสอบ NHI: ownership, permissions, rotation      |
| Entitlement review       | Annual (ปี)           | GRC team       | ตรวจสอบ roles, policies, entitlement definitions   |
| SOD review               | Semi-annual (6 เดือน) | Compliance     | Separation of Duties violations                    |

### Privilege Creep Detection

```
Privilege Creep Detection Patterns:

Pattern 1: Role Accumulation
├── Signal: user มี > 3 roles assigned
├── Detection: query IGA → users with role_count > threshold
├── Action: trigger access review สำหรับ users with excessive roles
└── Example: dev ที่ย้ายเป็น PM แต่ยังมี deployment access

Pattern 2: Unused Entitlements
├── Signal: access granted > 90 วัน แต่ไม่เคยใช้
├── Detection: correlate IGA grants กับ actual access logs
├── Action: recommend removal, auto-revoke after warning period
└── Example: database access ที่ขอตอน onboard แต่ไม่เคย connect

Pattern 3: Outlier Detection
├── Signal: user มี access ที่ peers ในตำแหน่งเดียวกันไม่มี
├── Detection: peer group analysis (same department + role)
├── Action: flag สำหรับ manager review
└── Example: marketing staff ที่มี access ถึง production database

Pattern 4: Dormant Accounts
├── Signal: account ไม่ login > 60 วัน
├── Detection: IdP last login timestamp check
├── Action: disable account, notify owner, delete after 30 วัน
└── Example: contractor account ที่ project จบแล้ว
```

### Role Mining & RBAC Optimization

```
Role Mining Process:

Step 1: Collect Current State
├── Export user-entitlement matrix จาก IdP + target systems
├── Collect: user, role, group, direct entitlements
└── ขนาดตัวอย่าง: 1,000 users × 500 entitlements = 500K data points

Step 2: Role Mining (Bottom-Up)
├── Cluster analysis: group users with similar entitlement patterns
├── Algorithm: hierarchical clustering, frequent itemset mining
├── Output: candidate roles (entitlement bundles)
└── ตั้งเป้า: ลดจำนวน unique assignments > 60%

Step 3: Role Engineering (Top-Down)
├── Map candidate roles → business functions
├── Define role hierarchy: base → functional → privileged
├── Validate กับ business owners
└── Resolve conflicts: overlapping roles, SOD violations

Step 4: Role Governance
├── Role owner assignment (ทุก role ต้องมี owner)
├── Periodic role review (annual)
├── Role request/approval workflow
└── Role metrics: coverage, exception rate, bloat ratio
```

### IGA Platform Comparison

| Platform                      | Type             | จุดแข็ง                                                   | ข้อจำกัด                             | เหมาะกับ                      |
| ----------------------------- | ---------------- | --------------------------------------------------------- | ------------------------------------ | ----------------------------- |
| SailPoint IdentityNow         | SaaS IGA         | AI-driven access insights, role mining, strong compliance | ซับซ้อนในการ implement, ค่าสูง       | Enterprise 5,000+ users       |
| Saviynt                       | SaaS IGA         | Cloud-native, strong PAM integration, converged platform  | UI อาจซับซ้อน, learning curve        | Enterprise, cloud-first org   |
| One Identity Manager          | On-prem/Hybrid   | Flexible data model, strong AD integration                | ต้อง infrastructure, ช้าในการ deploy | Hybrid/on-prem enterprise     |
| Microsoft Entra ID Governance | SaaS (Microsoft) | Native Azure AD integration, lifecycle workflows          | จำกัดเฉพาะ Microsoft ecosystem       | Microsoft-heavy organizations |
| Okta Identity Governance      | SaaS             | Strong SaaS integration, user-friendly                    | จำกัด on-prem capability             | SaaS-first, cloud-native      |
| CyberArk Identity             | SaaS             | PAM + IGA converged, strong privileged access             | IGA features still maturing          | PAM-centric organizations     |

### Access Request/Approval Workflow Template

```
Access Request Workflow:

Requester                Manager              App Owner          Security
│                       │                    │                  │
│ 1. Submit request     │                    │                  │
│    ├── Resource        │                    │                  │
│    ├── Access level    │                    │                  │
│    ├── Justification   │                    │                  │
│    └── Duration        │                    │                  │
│ ──────────────────────▶│                    │                  │
│                       │ 2. Manager review   │                  │
│                       │    ├── Verify need  │                  │
│                       │    └── Approve/Deny │                  │
│                       │ ──────────────────▶│                  │
│                       │                    │ 3. Owner review   │
│                       │                    │    ├── Check SOD  │
│                       │                    │    └── Approve    │
│                       │                    │ ────────────────▶│
│                       │                    │                  │ 4. Risk check
│                       │                    │                  │    ├── SOD check
│                       │                    │                  │    ├── Risk score
│                       │                    │                  │    └── Auto/Manual
│                       │                    │                  │
│ ◀──── Access granted (auto-provisioned via SCIM) ────────────│
│                       │                    │                  │
│ [Expiry: auto-revoke after approved duration]                │
```

---

## 7. Identity Threat Detection & Response — ITDR

ITDR (Identity Threat Detection & Response) เป็น security discipline ที่เกิดขึ้นเพื่อรับมือกับ
identity-based attacks โดยเฉพาะ โดยเน้นการตรวจจับภัยคุกคามที่กระทบต่อ identity infrastructure
(Active Directory, IdP, PAM, MFA) และตอบสนองอย่างรวดเร็ว

### ITDR Architecture

```
ITDR Architecture:

┌─────────────────────────────────────────────────────────────────┐
│                      ITDR Platform                               │
│  ┌────────────────┐  ┌──────────────┐  ┌────────────────────┐   │
│  │ Detection       │  │ Investigation│  │ Response            │   │
│  │ Engine          │  │ Console      │  │ Orchestration       │   │
│  │ ├── ML models   │  │ ├── Timeline │  │ ├── Auto-remediate  │   │
│  │ ├── Rules       │  │ ├── Graph    │  │ ├── Force re-auth   │   │
│  │ ├── Behavioral  │  │ ├── Risk     │  │ ├── Disable account │   │
│  │ └── Correlation │  │ └── Forensics│  │ └── Notify SOC      │   │
│  └───────┬────────┘  └──────────────┘  └────────────────────┘   │
│          │                                                       │
│  ┌───────▼──────────────────────────────────────────────────┐   │
│  │              Identity Signal Collection                    │   │
│  │  ┌──────┐ ┌──────┐ ┌─────┐ ┌─────┐ ┌──────┐ ┌────────┐ │   │
│  │  │ IdP  │ │  AD  │ │ PAM │ │ MFA │ │ SIEM │ │ Cloud  │ │   │
│  │  │ Logs │ │ Logs │ │ Logs│ │ Logs│ │      │ │ IAM    │ │   │
│  │  └──────┘ └──────┘ └─────┘ └─────┘ └──────┘ └────────┘ │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### ITDR Detection Patterns & SIEM Rules

#### Pattern 1: MFA Fatigue / MFA Bombing

```
Detection: MFA Fatigue Attack
Signal: ผู้ใช้ได้รับ MFA push > 5 ครั้งใน 10 นาทีโดยไม่ได้เริ่มจาก legitimate login

# Splunk SPL
index=idp sourcetype=mfa_events action=push_sent
| bin _time span=10m
| stats count as push_count by user, _time
| where push_count > 5
| lookup user_context user OUTPUT department, manager
| alert "MFA Fatigue Detected" severity=high

# Microsoft Sentinel KQL
SigninLogs
| where ResultType == "50074"  // MFA required
| summarize push_count=count(), make_set(IPAddress) by UserPrincipalName, bin(TimeGenerated, 10m)
| where push_count > 5
| extend alert_severity = "High"

Response:
├── Block authentication attempts สำหรับ user นี้ (15 นาที)
├── Notify user ผ่านช่องทางอื่น (email/SMS/call) เพื่อยืนยัน
├── Review source IPs ของ push requests
├── ถ้ายืนยัน attack: reset MFA, force password change
└── ถ้า push ถูก approve: treat as compromised → full incident response
```

#### Pattern 2: Impossible Travel

```
Detection: Impossible Travel
Signal: user login จาก 2 locations ที่เดินทางไม่ทันภายในเวลาที่กำหนด

# Splunk SPL
index=idp sourcetype=auth_events action=login status=success
| sort user, _time
| streamstats current=f last(_time) as prev_time last(src_geo_lat) as prev_lat
  last(src_geo_long) as prev_long by user
| eval time_diff_hours = (_time - prev_time) / 3600
| eval distance_km = 6371 * acos(sin(prev_lat*pi()/180) * sin(src_geo_lat*pi()/180)
  + cos(prev_lat*pi()/180) * cos(src_geo_lat*pi()/180)
  * cos((src_geo_long-prev_long)*pi()/180))
| eval speed_kmh = distance_km / time_diff_hours
| where speed_kmh > 800 AND time_diff_hours < 24
| table user, _time, src_ip, src_geo_city, distance_km, speed_kmh

# Microsoft Sentinel KQL
let threshold_speed = 800;  // km/h
SigninLogs
| where ResultType == 0
| project UserPrincipalName, TimeGenerated, IPAddress,
    LocationDetails.geoCoordinates.latitude,
    LocationDetails.geoCoordinates.longitude, LocationDetails.city
| sort by UserPrincipalName asc, TimeGenerated asc
| serialize
| extend prev_lat = prev(toreal(latitude)), prev_long = prev(toreal(longitude)),
    prev_time = prev(TimeGenerated), prev_user = prev(UserPrincipalName)
| where UserPrincipalName == prev_user
| extend time_diff_h = datetime_diff('hour', TimeGenerated, prev_time)
| where time_diff_h > 0 and time_diff_h < 24
// Haversine formula for distance calculation
| extend distance_km = 6371 * acos(sin(toreal(latitude)*pi()/180)
    * sin(prev_lat*pi()/180) + cos(toreal(latitude)*pi()/180)
    * cos(prev_lat*pi()/180) * cos((toreal(longitude)-prev_long)*pi()/180))
| extend speed_kmh = distance_km / time_diff_h
| where speed_kmh > threshold_speed

Response:
├── Force re-authentication ด้วย phishing-resistant MFA
├── ตรวจสอบ: user ใช้ VPN หรือ proxy หรือไม่ (false positive ที่พบบ่อย)
├── ถ้ายืนยัน attack: revoke all sessions, force password change
└── Log ทุก session activity ระหว่าง investigation
```

#### Pattern 3: Token Theft / Session Hijacking

```
Detection: Token Theft via AitM Proxy
Signal: Session cookie ถูกใช้จาก device/browser fingerprint ที่ต่างจากตอน authentication

# Detection signals:
├── User-Agent string เปลี่ยนระหว่าง session
├── TLS fingerprint (JA3/JA4) ไม่ตรงกับ baseline
├── IP address เปลี่ยนขณะ session ยัง active
├── Simultaneous sessions จาก multiple IPs
└── Token ถูกใช้จาก ASN ที่ไม่เคยเห็นสำหรับ user นี้

# Splunk SPL
index=web sourcetype=proxy
| transaction session_id maxspan=24h
| where mvcount(src_ip) > 1 OR mvcount(user_agent) > 1
| eval risk_score = case(
    mvcount(src_ip) > 2, 90,
    mvcount(user_agent) > 1, 80,
    mvcount(ja3_hash) > 1, 95,
    1=1, 50)
| where risk_score >= 80
| table session_id, user, src_ip, user_agent, ja3_hash, risk_score

Response:
├── Terminate suspicious session immediately
├── Revoke all refresh tokens สำหรับ user
├── Force re-authentication ด้วย FIDO2 (ไม่ใช่ push MFA)
├── Investigate: ตรวจสอบ phishing email ที่นำไปสู่ AitM
├── ตรวจสอบ data access ระหว่าง compromised session
└── Implement DPoP token binding เพื่อป้องกัน replay
```

#### Pattern 4: Credential Stuffing / Password Spray

```
Detection: Password Spray Attack
Signal: failed login attempts จาก IP เดียว/กลุ่มเดียว ไปยัง accounts หลายตัว

# Splunk SPL
index=idp sourcetype=auth_events action=login status=failure
| bin _time span=30m
| stats dc(user) as unique_users count as total_attempts
  values(user) as targeted_users by src_ip, _time
| where unique_users > 10 AND total_attempts > 20
| eval attack_type = case(
    total_attempts / unique_users < 3, "password_spray",
    total_attempts / unique_users >= 3, "credential_stuffing",
    1=1, "brute_force")

# Microsoft Sentinel KQL
SigninLogs
| where ResultType in ("50126", "50053", "50055")  // Invalid password codes
| summarize
    unique_users = dcount(UserPrincipalName),
    total_attempts = count(),
    users_list = make_set(UserPrincipalName, 20)
  by IPAddress, bin(TimeGenerated, 30m)
| where unique_users > 10 and total_attempts > 20

Response (Password Spray):
├── Block source IP(s) temporarily (30 นาที — 24 ชั่วโมง)
├── Check ว่ามี account ใดที่ login สำเร็จหลัง spray
├── Force password change สำหรับ accounts ที่อาจ compromised
├── ตรวจสอบ IP reputation (Tor exit node, VPN, hosting provider)
└── Report to threat intelligence team สำหรับ indicator sharing
```

#### Pattern 5: Lateral Movement via Compromised Identity

```
Detection: Lateral Movement
Signal: identity ที่ปกติเข้าถึง resources จำกัด ทำการ access resources ที่ไม่เคยใช้

# Detection Signals:
├── First-time access to sensitive resources (new resource access)
├── Access outside normal working hours
├── Enumeration activity (listing users, groups, shares)
├── Service account used interactively
└── Privilege escalation (requesting higher roles)

# Splunk SPL
index=windows sourcetype=WinEventLog EventCode=4624 Logon_Type=3
| eval is_service_account = if(match(Account_Name, "^svc-|^sa-|^bot-"), 1, 0)
| where is_service_account=1 AND Logon_Type=10  // Interactive logon
| stats count by Account_Name, src_ip, dest_host
| lookup service_account_baseline Account_Name OUTPUT expected_hosts
| where NOT match(dest_host, expected_hosts)

Response:
├── Isolate compromised account immediately (disable + revoke sessions)
├── Identify blast radius: ทุก resources ที่ account เข้าถึง
├── Check: compromised identity ถูกใช้สร้าง accounts/keys ใหม่หรือไม่
├── Timeline: สร้าง activity timeline ตั้งแต่จุดที่สงสัย compromise
└── Remediate: rotate credentials, patch entry point, restore affected systems
```

### ITDR Platform Comparison

| Platform                           | Type                | Key Capability                                   | จุดแข็ง                                              |
| ---------------------------------- | ------------------- | ------------------------------------------------ | ---------------------------------------------------- |
| CrowdStrike Falcon Identity        | Endpoint + Identity | AD threat detection, identity-based segmentation | Real-time AD protection, lateral movement prevention |
| Microsoft Defender for Identity    | Cloud ITDR          | AD monitoring, entity behavior analytics (UEBA)  | Native Entra ID + AD integration, part of XDR suite  |
| SentinelOne Singularity Identity   | Endpoint + Identity | AD deception, credential theft prevention        | Active Directory assessor, deception decoys          |
| Proofpoint Identity Threat Defense | Identity ITDR       | Identity vulnerability assessment, AD monitoring | Focuses on identity attack surface reduction         |
| Silverfort                         | Identity protection | MFA everywhere (incl. legacy), identity firewall | Agentless, extends MFA to any system incl. RDP/SSH   |
| Semperis                           | AD-specific ITDR    | AD disaster recovery, threat detection           | Specialized AD protection, forest recovery           |

---

## 8. บริบทประเทศไทย (Thai Context — Identity & Access Security)

### Thai e-KYC Requirements

e-KYC (Electronic Know Your Customer) ในประเทศไทยถูกกำกับดูแลโดยหลายหน่วยงาน
ขึ้นอยู่กับ sector ที่ให้บริการ

```
Thai e-KYC Regulatory Landscape:

┌─────────────────────────────────────────────────────────────┐
│                    Thai e-KYC Framework                       │
├─────────────────┬───────────────────┬───────────────────────┤
│ Financial Sector│ Government Sector │ General Sector        │
│ (ธปท. / BoT)    │ (DGA / ETDA)       │ (ETDA)                │
│                 │                   │                       │
│ • BoT Circular  │ • ThaID / DOPA    │ • ETDA e-Signature    │
│   on Digital    │ • Digital Gov Act │   Act B.E. 2544       │
│   Identity      │   B.E. 2562       │ • Electronic Trans.   │
│ • Face verifi-  │ • บัตร smart card  │   Act B.E. 2544      │
│   cation (liveness) │   integration │ • NDID Framework      │
│ • Document      │                   │                       │
│   verification  │                   │                       │
│ (AMLO AML/CFT)  │                   │                       │
└─────────────────┴───────────────────┴───────────────────────┘
```

#### BoT (ธนาคารแห่งประเทศไทย) Digital Identity Guidelines

| Area                   | Requirement                            | รายละเอียด                                                 |
| ---------------------- | -------------------------------------- | ---------------------------------------------------------- |
| Identity proofing      | Face verification + liveness detection | ต้องตรวจสอบใบหน้าจริง (ไม่ใช่ภาพถ่าย/วิดีโอ)               |
| Document verification  | Government ID verification             | ตรวจสอบบัตรประชาชน/passport ด้วย NFC หรือ OCR + validation |
| Authentication level   | Multi-factor required                  | สำหรับ high-value transactions: biometric + PIN/password   |
| Transaction monitoring | Risk-based authentication              | Step-up authentication สำหรับ unusual transactions         |
| Fraud detection        | Real-time monitoring                   | Detect identity fraud, SIM swap, device anomalies          |
| Record keeping         | 5 years minimum retention              | บันทึก e-KYC process + results + consent                   |

#### NDID (National Digital ID) Platform

```
NDID Architecture (simplified):

ผู้ใช้ (User)
│
│ 1. ขอ verify identity
│
├────▶ RP (Relying Party) — เช่น ธนาคาร, บริษัทประกัน
│      │
│      │ 2. ส่ง verification request ผ่าน NDID
│      │
│      ├────▶ NDID Platform (Blockchain-based)
│      │      │
│      │      │ 3. Route to IdP ที่ user เลือก
│      │      │
│      │      ├────▶ IdP (Identity Provider) — เช่น ธนาคารที่ user มีบัญชี
│      │      │      │
│      │      │      │ 4. User ยืนยันตัวตนกับ IdP
│      │      │      │    (biometric/PIN)
│      │      │      │
│      │      │      │ 5. IdP ส่ง identity assertion กลับ
│      │      │      │
│      │      ◀──────┘
│      │
│      │ 6. RP ได้รับ verified identity
│      │
◀──────┘
│ 7. Service เริ่มใช้งาน

Blockchain: เก็บเฉพาะ transaction log (ไม่เก็บ PII)
PII: ส่งตรงระหว่าง IdP → RP (off-chain encrypted)
```

### PDPA (พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล 2562) — Identity Data Handling

| PDPA Requirement                | ความเกี่ยวข้องกับ Identity                 | การดำเนินการ                                               |
| ------------------------------- | ------------------------------------------ | ---------------------------------------------------------- |
| Consent (Section 19)            | ต้องได้ consent ก่อน collect identity data | Record consent: purpose, data categories, retention period |
| Purpose limitation (Section 21) | ใช้ identity data เฉพาะ purpose ที่แจ้ง    | ห้ามใช้ biometric data สำหรับ purpose อื่นที่ไม่ได้แจ้ง    |
| Data minimization (Section 22)  | เก็บเฉพาะ identity data ที่จำเป็น          | ไม่ต้องเก็บสำเนาบัตร ถ้าตรวจสอบแล้ว                        |
| Retention (Section 23)          | กำหนดระยะเวลาเก็บ identity data            | ลบ identity data เมื่อหมดความจำเป็น (ยกเว้นกฎหมายบังคับ)   |
| Cross-border (Section 28)       | ส่ง identity data ไปต่างประเทศ             | ประเทศปลายทางต้องมี adequate protection                    |
| Data breach (Section 37)        | แจ้ง breach ที่กระทบ identity data         | แจ้ง PDPC ภายใน 72 ชั่วโมง                                 |
| Sensitive data (Section 26)     | Biometric data เป็น sensitive data         | ต้องได้ explicit consent สำหรับ biometric collection       |

### ThaID (แอป ThaID) Integration

ThaID เป็นแอปยืนยันตัวตนดิจิทัลของกรมการปกครอง (DOPA) กระทรวงมหาดไทย
ใช้ข้อมูลจากบัตรประชาชนอิเล็กทรอนิกส์ (Smart Card) สำหรับ digital identity verification

```
ThaID Integration Considerations:

Use Cases:
├── Government service authentication (e-Citizen)
├── Financial service e-KYC (BoT approved)
├── Private sector identity verification
└── Age verification for regulated services

Security Requirements:
├── Face verification ด้วย liveness detection
├── PIN/biometric สำหรับ app authentication
├── ข้อมูลเก็บใน device (ไม่ upload ไป server)
├── Consent-based data sharing (per-transaction)
└── Offline verification capability (QR code)

Integration API:
├── ThaID API (DOPA provided)
├── NDID integration path
├── Identity assertion format: JSON (signed)
└── Support: iOS + Android SDK
```

### PromptPay Identity Layer

PromptPay เป็นระบบ National e-Payment ของประเทศไทย (เปิดใช้ 2017) มีผู้ลงทะเบียน 40+ ล้านบัญชี
โดย bind identity ผ่านเลขบัตรประชาชน 13 หลักหรือเบอร์โทรศัพท์:

```
PromptPay Identity Binding Architecture:

ผู้ใช้ (National ID / เบอร์มือถือ)
│
├── Registration: ลงทะเบียนผ่าน mobile banking app
│   ├── Bank ยืนยัน identity (e-KYC / in-branch)
│   ├── National ID → PromptPay Proxy (ITMX managed)
│   └── ถ้าเลือกเบอร์มือถือ → OTP verification + ID binding
│
├── Payment Flow:
│   ├── Sender ใส่ Proxy ID (เลขบัตร/เบอร์โทร)
│   ├── ITMX resolve Proxy → Account Number + Bank Code
│   ├── Inter-bank settlement (BAHTNET / PromptPay rail)
│   └── Receiver ได้รับเงิน real-time
│
└── Security Considerations:
    ├── SIM swap → เบอร์โทรถูก takeover → PromptPay account hijack
    ├── National ID leak → ใช้ receive funds (low risk) แต่ social eng. vector
    ├── No MFA on PromptPay registration at some banks (gap)
    └── NDID integration → future: PromptPay re-registration ผ่าน NDID verification
```

**PromptPay + NDID Integration (แผนอนาคต):**

- ธปท. ผลักดันให้ใช้ NDID สำหรับ PromptPay re-registration เพื่อลด SIM swap fraud
- Cross-bank identity verification ผ่าน NDID ก่อน allow PromptPay proxy change
- PromptPay QR code payment ควร link กับ ThaID verification สำหรับ high-value transactions

**NDID Protocol Details (เพิ่มเติม):**

| Component          | Technology                        | Description                                                         |
| ------------------ | --------------------------------- | ------------------------------------------------------------------- |
| Blockchain         | Tendermint (private chain)        | เก็บ transaction log, consent records (ไม่เก็บ PII)                 |
| Identity Assertion | JSON signed with RSA-2048+        | IdP sign assertion → RP verify signature                            |
| Encryption         | RSA + AES-256 (PII in transit)    | PII ส่งตรง IdP → RP, encrypted end-to-end                           |
| SPIFFE ID (อนาคต)  | spiffe://ndid.co.th/idp/{bank}    | กำลังศึกษาการใช้ SPIFFE สำหรับ workload identity ระหว่าง NDID nodes |
| DID Format         | did:ndid:{namespace}:{identifier} | Decentralized Identifier per NDID participant                       |
| Consent            | On-chain hash                     | Hash of consent stored on blockchain, full consent off-chain        |

### Thai Organization Identity Security Recommendations

| Priority  | Action                | Thai Context                                                             |
| --------- | --------------------- | ------------------------------------------------------------------------ |
| Quick Win | MFA enforcement       | บังคับ MFA ทุก system, ใช้ FIDO2 สำหรับ admin                            |
| Quick Win | Service account audit | ตรวจสอบ service accounts ทั้งหมด, โดยเฉพาะ system ที่เก็บข้อมูลส่วนบุคคล |
| Standard  | PDPA data mapping     | Map identity data flows, consent management, retention policy            |
| Standard  | e-KYC implementation  | เลือกระหว่าง NDID pathway หรือ standalone ตาม BoT guidelines             |
| Advanced  | ThaID integration     | สำหรับ government-facing services, ลดต้นทุน identity verification        |
| Advanced  | Biometric governance  | Policy สำหรับ biometric data handling ตาม PDPA sensitive data rules      |

---

## 9. รายการตรวจสอบ Identity Security (Identity Security Checklist)

### Quick Win (ดำเนินการได้ภายใน 1-2 สัปดาห์, ลงทุนต่ำ)

- [ ] Enable phishing-resistant MFA (FIDO2/Passkeys) สำหรับ admin accounts ทั้งหมด
- [ ] Enable number matching สำหรับ push MFA (ป้องกัน MFA fatigue)
- [ ] Audit service accounts ทั้งหมด: ระบุ owner, purpose, last used
- [ ] ปิด legacy authentication protocols (NTLM, basic auth, IMAP/POP with password)
- [ ] Implement session management: max idle timeout 30 นาที, absolute timeout 8 ชั่วโมง
- [ ] Block known-compromised credentials (Azure AD Password Protection, Have I Been Pwned API)
- [ ] Enable sign-in risk detection (Entra ID P2, Okta ThreatInsight, Google login challenges)
- [ ] ตรวจสอบ JWT validation: reject alg:none, verify iss/aud/exp
- [ ] Remove inactive user accounts (> 90 วันไม่ login)
- [ ] Enable audit logging สำหรับ identity events ทั้งหมด (login, MFA, role change, group change)

### Standard (ดำเนินการภายใน 3-6 เดือน, ลงทุนปานกลาง)

- [ ] Deploy FIDO2/Passkeys organization-wide (target: 80%+ coverage)
- [ ] Implement Non-Human Identity lifecycle management (create, rotate, review, decommission)
- [ ] Set up ITDR monitoring: impossible travel, MFA fatigue, credential stuffing, token theft
- [ ] Deploy conditional access policies: risk-based MFA, device compliance, location
- [ ] Implement Joiner-Mover-Leaver automation (SCIM provisioning/deprovisioning)
- [ ] Quarterly access certification reviews (manager + application owner)
- [ ] Implement privilege creep detection (unused entitlements, role accumulation, outliers)
- [ ] Deploy PAM สำหรับ privileged accounts (just-in-time elevation, session recording)
- [ ] Credential rotation automation: service accounts < 90 วัน, API keys < 30 วัน
- [ ] OAuth 2.1 migration: PKCE mandatory, remove implicit grant, refresh token rotation
- [ ] PDPA compliance: consent management, biometric data governance, retention policy
- [ ] Integrate identity signals เข้า SIEM/SOAR สำหรับ correlation กับ security events อื่น

### Advanced (ดำเนินการภายใน 12-18 เดือน, ลงทุนสูง)

- [ ] Deploy workload identity (SPIFFE/SPIRE) สำหรับ service-to-service authentication
- [ ] Full IGA deployment: role mining, access certification, SOD enforcement
- [ ] AI agent identity framework: scoped credentials, per-task permissions, delegation controls
- [ ] Passwordless authentication organization-wide (ลด password ให้เหลือ 0 เป้าหมาย)
- [ ] DPoP (RFC 9449) token binding สำหรับ critical APIs
- [ ] Identity-based micro-segmentation (access decision ตาม identity + context ไม่ใช่ network)
- [ ] Continuous adaptive trust evaluation (real-time risk scoring ทุก session)
- [ ] Machine identity certificate automation (short-lived certificates, auto-renewal)
- [ ] Identity threat simulation / purple team exercises เฉพาะ identity attacks
- [ ] ThaID / NDID integration สำหรับ customer-facing identity verification (Thai sector)

---

### Framework References

| Framework              | Version          | Key Focus                                        | URL                                                     |
| ---------------------- | ---------------- | ------------------------------------------------ | ------------------------------------------------------- |
| NIST SP 800-63B        | Rev 4 (2024)     | Digital identity authentication assurance levels | https://csrc.nist.gov/pubs/sp/800/63b/r4/ipd            |
| NIST IR 8587           | IPD (2025)       | Token and session protection recommendations     | https://csrc.nist.gov/pubs/ir/8587/ipd                  |
| FIDO2/WebAuthn         | Level 2          | Phishing-resistant web authentication standard   | https://fidoalliance.org/fido2/                         |
| OAuth 2.1              | Draft            | Modern authorization framework                   | https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-1/ |
| SPIFFE/SPIRE           | 1.x              | Universal workload identity framework            | https://spiffe.io/                                      |
| CISA Identity Guidance | 2024             | Identity and access management best practices    | https://www.cisa.gov/identity-and-access-management     |
| NIST SP 800-207        | 2020             | Zero Trust Architecture (identity pillar)        | https://csrc.nist.gov/pubs/sp/800/207/final             |
| RFC 9449 (DPoP)        | 2023             | Demonstrating Proof-of-Possession for OAuth      | https://datatracker.ietf.org/doc/rfc9449/               |
| RFC 9700               | 2025             | OAuth 2.0 Security Best Current Practice         | https://datatracker.ietf.org/doc/rfc9700/               |
| PDPA                   | B.E. 2562 (2019) | Thai Personal Data Protection Act                | https://www.pdpc.or.th/                                 |

---

**NIST SP 800-63B Reference**: เมื่อสร้าง output ที่เกี่ยวข้องกับ identity security ต้องอ้างอิง
Authentication Assurance Level (AAL1-3) ตาม NIST SP 800-63B Rev 4 สำหรับกำหนดระดับ
authentication ที่เหมาะสมกับระดับความเสี่ยงของระบบ

> สำหรับ Zero Trust identity pillar → ดู references/zero-trust-architecture.md (Domain 11)
> สำหรับ OAuth 2.0 / JWT deep dive → ดู references/api-security.md (Domain 13)
> สำหรับ cloud IAM roles & policies → ดู references/cloud-security-cspm.md (Domain 10)
> สำหรับ AI agent identity patterns → ดู references/agentic-ai-security.md (Domain 19)
