# API Security Reference

คู่มือความปลอดภัยของ API เชิงลึก — OWASP API Security Top 10, OAuth 2.0, JWT Validation,
API Gateway Patterns, API Inventory & Testing พร้อม implementation templates และ CI/CD integration

> สำหรับ DevSecOps pipeline configs → ดู references/devsecops-pipeline.md (Domain 3)
> สำหรับ code security analysis → ดู references/code-security-analysis.md (Domain 6)
> สำหรับ Zero Trust architecture → ดู references/zero-trust-architecture.md (Domain 11)

**Cross-references:**

- Domain 3: DevSecOps Pipeline → `references/devsecops-pipeline.md`
- Domain 6: Code Security Analysis → `references/code-security-analysis.md`
- Domain 11: Zero Trust Architecture → `references/zero-trust-architecture.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 19: Agentic AI Security → `references/agentic-ai-security.md`
- Domain 21: Identity & Access Security → `references/identity-access-security.md`

---

## Table of Contents

1. OWASP API Security Top 10 2023
2. API Authentication Matrix
3. JWT Validation Checklist
4. OAuth 2.0 Security Best Practices (RFC 9700)
5. API Gateway Security Patterns
6. API Inventory & Discovery
7. API Fuzzing & Security Testing
8. API Security in CI/CD Pipeline
9. Framework References & Remediation Checklist

---

## 1. OWASP API Security Top 10 2023

OWASP API Security Top 10 เป็นรายการความเสี่ยงด้านความปลอดภัยที่พบบ่อยและร้ายแรงที่สุดสำหรับ API
ใช้เป็น baseline ในการ design, develop และ test API security

### ภาพรวมความเสี่ยง (Risk Overview)

```
API Security Threat Landscape:

Client ──▶ API Gateway ──▶ Backend Services ──▶ Database
  │              │                │                  │
  │  API1: BOLA  │  API8: Misconfig  API4: Resource │  API3: Property
  │  API2: Auth  │  API5: BFLA       Consumption    │  Level AuthZ
  │  API6: Biz   │  API7: SSRF                      │
  │  Flow Abuse  │  API9: Inventory                  │
  │  API10:      │                                   │
  │  Unsafe      │                                   │
  │  Consumption │                                   │
```

### ตารางความเสี่ยง OWASP API Top 10

| Risk ID    | Risk Name                                       | คำอธิบาย                                                                                  | Detection Method                         | Mitigation Template                                           |
| ---------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------- | ------------------------------------------------------------- |
| API1:2023  | Broken Object Level Authorization (BOLA)        | ผู้โจมตีเข้าถึง object ของผู้ใช้อื่นโดยเปลี่ยน object ID ใน request                       | DAST fuzzing on object IDs, access logs  | ตรวจสอบ ownership ทุก request ด้วย authorization logic        |
| API2:2023  | Broken Authentication                           | ระบบ authentication มีช่องโหว่ ทำให้ผู้โจมตีปลอมตัวเป็นผู้ใช้อื่น                         | Brute-force detection, token analysis    | ใช้ OAuth 2.0 + PKCE, rate limit login attempts               |
| API3:2023  | Broken Object Property Level Authorization      | API เปิดเผยหรือยอมรับ properties ที่ไม่ควรให้ผู้ใช้เข้าถึง (mass assignment)              | SAST rules, schema diff analysis         | Allowlist properties ที่ return/accept อย่างชัดเจน            |
| API4:2023  | Unrestricted Resource Consumption               | API ไม่จำกัด request rate, payload size หรือ resource usage ทำให้ถูก DoS ได้              | Load testing, rate limit monitoring      | Rate limiting, request size limits, pagination                |
| API5:2023  | Broken Function Level Authorization             | ผู้ใช้ธรรมดาเรียกใช้ admin endpoints ได้เพราะขาด function-level authorization             | DAST crawling, role-based test cases     | RBAC/ABAC enforcement ทุก endpoint                            |
| API6:2023  | Unrestricted Access to Sensitive Business Flows | ผู้โจมตี automate business flows (เช่น สร้าง account จำนวนมาก) เพราะไม่มี anti-abuse      | Traffic anomaly detection, bot detection | CAPTCHA, device fingerprinting, business logic limits         |
| API7:2023  | Server Side Request Forgery (SSRF)              | API รับ URL จาก user input แล้ว fetch โดยไม่ validate ทำให้เข้าถึง internal resources     | SAST taint analysis, DAST SSRF payloads  | Allowlist URLs, block internal IPs, validate schemes          |
| API8:2023  | Security Misconfiguration                       | API server, gateway หรือ middleware มี default config ที่ไม่ปลอดภัย                       | Configuration audit, CIS benchmark scan  | Harden configs, disable debug, set security headers           |
| API9:2023  | Improper Inventory Management                   | Shadow APIs, deprecated endpoints ยังถูก expose โดยไม่มีการจัดการ                         | API discovery tools, traffic analysis    | API catalog, version deprecation policy, gateway rules        |
| API10:2023 | Unsafe Consumption of APIs                      | Application เรียก third-party APIs โดยไม่ validate response ทำให้ถูก inject ข้อมูลอันตราย | Code review, SAST on API client code     | Validate all external API responses, timeout, circuit breaker |

### BOLA Prevention Pattern (API1)

```javascript
// Node.js/Express — BOLA prevention middleware
// ตรวจสอบ ownership ของ resource ก่อน return ข้อมูล

const checkResourceOwnership = (resourceType) => {
  return async (req, res, next) => {
    const { id } = req.params;
    const userId = req.user.id; // จาก JWT/session

    const resource = await db.findOne(resourceType, {
      where: { id, ownerId: userId },
    });

    if (!resource) {
      return res.status(404).json({
        error: "Resource not found",
      });
    }

    req.resource = resource;
    next();
  };
};

// Usage
app.get(
  "/api/v1/orders/:id",
  authenticate,
  checkResourceOwnership("orders"),
  (req, res) => res.json(req.resource),
);
```

### Mass Assignment Prevention (API3)

```javascript
// ป้องกัน mass assignment ด้วย allowlist pattern
const allowedFields = ["name", "email", "phone"];

const sanitizeInput = (body, allowedFields) => {
  return Object.fromEntries(
    Object.entries(body).filter(([key]) => allowedFields.includes(key)),
  );
};

app.put("/api/v1/users/:id", authenticate, (req, res) => {
  const sanitized = sanitizeInput(req.body, allowedFields);
  // sanitized จะมีเฉพาะ fields ที่อนุญาต
  // ไม่มี isAdmin, role, balance ฯลฯ
});
```

---

## 2. เมทริกซ์การ Authenticate API (API Authentication Matrix)

### เปรียบเทียบวิธี Authentication

| Feature                      | API Key                        | OAuth 2.0 + PKCE                     | mTLS                          | JWT Bearer                             |
| ---------------------------- | ------------------------------ | ------------------------------------ | ----------------------------- | -------------------------------------- |
| Security Level               | ต่ำ — ง่ายต่อการ leak          | สูง — industry standard              | สูงมาก — certificate-based    | ปานกลาง-สูง — ขึ้นกับ implementation   |
| Use Case                     | Public APIs, rate limiting     | User-facing apps, third-party access | Service-to-service, B2B       | Microservices, stateless auth          |
| Rotation                     | Manual, ต้อง re-deploy clients | Automatic (refresh token rotation)   | Certificate renewal (90d-1y)  | Short-lived (15m-1h) + refresh token   |
| Implementation Complexity    | ต่ำมาก — header/query param    | ปานกลาง-สูง — ต้อง auth server       | สูง — ต้อง PKI infrastructure | ปานกลาง — ต้อง key management          |
| Revocation                   | Immediate (delete key)         | Token revocation endpoint            | CRL/OCSP                      | ยาก — ต้อง blocklist หรือ short expiry |
| Supports Scopes              | ไม่รองรับ                      | รองรับ (fine-grained)                | ไม่รองรับ (identity-based)    | รองรับ (embedded in claims)            |
| Man-in-the-Middle Protection | ขึ้นกับ TLS                    | PKCE ป้องกัน code interception       | Mutual authentication         | ขึ้นกับ TLS                            |
| Replay Attack Protection     | ไม่มี (ต้องเพิ่ม nonce)        | State parameter + PKCE               | TLS session                   | exp claim + jti claim                  |

### คำแนะนำการเลือก (Selection Guide)

```
ต้องเลือก Authentication สำหรับ API:
│
├── Service-to-service (internal)?
│   ├── High security (financial/health) → mTLS
│   └── Standard microservices → JWT Bearer + short expiry
│
├── User-facing application?
│   ├── Third-party integration → OAuth 2.0 + PKCE
│   ├── First-party web/mobile → OAuth 2.0 + PKCE
│   └── Simple SPA → OAuth 2.0 Authorization Code + PKCE
│
├── Public API (read-only, rate limiting)?
│   └── API Key (ใช้คู่กับ rate limiting เท่านั้น)
│
└── B2B partner integration?
    ├── High trust → mTLS + OAuth 2.0
    └── Standard → OAuth 2.0 Client Credentials + API Key
```

---

## 3. รายการตรวจสอบ JWT (JWT Validation Checklist)

### Algorithm Validation

- [ ] Reject `alg: "none"` — ป้องกัน algorithm confusion attack
- [ ] Allowlist algorithms — รับเฉพาะ RS256, ES256, EdDSA (ห้ามใช้ HS256 สำหรับ public APIs)
- [ ] ตรวจสอบว่า algorithm ใน token header ตรงกับ expected algorithm ของ server
- [ ] ห้ามใช้ symmetric algorithms (HS256) เมื่อ verification key เป็น public

### Claims Validation

- [ ] **iss** (issuer) — ตรวจสอบว่ามาจาก trusted issuer
- [ ] **aud** (audience) — ตรวจสอบว่า token ถูก issue สำหรับ API นี้
- [ ] **exp** (expiration) — ตรวจสอบว่า token ยังไม่หมดอายุ (max 15 นาที สำหรับ access token)
- [ ] **nbf** (not before) — ตรวจสอบว่า token เริ่มใช้ได้แล้ว
- [ ] **iat** (issued at) — ตรวจสอบว่าไม่เก่าเกินไป
- [ ] **jti** (JWT ID) — ใช้ป้องกัน replay attack (optional แต่แนะนำ)
- [ ] **sub** (subject) — ตรวจสอบว่าตรงกับ user ที่ request

### Key Management

- [ ] ใช้ JWKS endpoint สำหรับ public key distribution
- [ ] Cache JWKS response พร้อม cache invalidation (max 24h)
- [ ] Key rotation ทุก 90 วัน (อย่างน้อย)
- [ ] Support multiple keys ใน JWKS สำหรับ seamless rotation
- [ ] ใช้ kid (key ID) header เพื่อ select correct key

### Token Storage

- [ ] Access token: httpOnly, Secure, SameSite=Strict cookie (preferred)
- [ ] ห้ามเก็บ token ใน localStorage (vulnerable ต่อ XSS)
- [ ] Refresh token: httpOnly cookie + rotation ทุกครั้งที่ใช้
- [ ] ห้ามส่ง token ผ่าน URL query parameter

### JWT Validation Code Example (Node.js)

```javascript
// JWT validation ด้วย jose library (แนะนำแทน jsonwebtoken)
import { createRemoteJWKSet, jwtVerify } from "jose";

const JWKS = createRemoteJWKSet(
  new URL("https://auth.example.com/.well-known/jwks.json"),
);

async function validateToken(token) {
  const { payload, protectedHeader } = await jwtVerify(token, JWKS, {
    issuer: "https://auth.example.com",
    audience: "https://api.example.com",
    algorithms: ["RS256", "ES256"], // Allowlist algorithms
    maxTokenAge: "15m", // Max age of access token
    clockTolerance: "30s", // Clock skew tolerance
  });

  // Additional custom validations
  if (!payload.sub) {
    throw new Error("Token missing subject claim");
  }

  if (!payload.scope?.includes("api:read")) {
    throw new Error("Insufficient scope");
  }

  return payload;
}

// Express middleware
const authenticateJWT = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Missing bearer token" });
  }

  try {
    const token = authHeader.slice(7);
    req.user = await validateToken(token);
    next();
  } catch (error) {
    return res.status(401).json({ error: "Invalid token" });
  }
};
```

---

## 4. แนวปฏิบัติด้านความปลอดภัย OAuth 2.0 (OAuth 2.0 Security Best Practices — RFC 9700)

### Authorization Code Flow with PKCE (บังคับสำหรับทุก client)

```
Client (SPA/Mobile/Server)          Authorization Server          Resource Server
│                                   │                              │
│ 1. Generate code_verifier         │                              │
│    + code_challenge (S256)        │                              │
│                                   │                              │
│ ──── /authorize ─────────────────▶│                              │
│   response_type=code              │                              │
│   code_challenge=...              │                              │
│   code_challenge_method=S256      │                              │
│   redirect_uri=...                │                              │
│   state=... (CSRF protection)     │                              │
│                                   │                              │
│ ◀──── redirect with code ─────────│                              │
│                                   │                              │
│ ──── /token ─────────────────────▶│                              │
│   grant_type=authorization_code   │                              │
│   code=...                        │                              │
│   code_verifier=...               │                              │
│                                   │                              │
│ ◀──── access_token + refresh ─────│                              │
│                                   │                              │
│ ──── /api/resource ──────────────────────────────────────────────▶│
│   Authorization: Bearer <token>   │                              │
│                                   │                              │
│ ◀──── resource data ─────────────────────────────────────────────│
```

### Token Management Best Practices

| Aspect                 | แนวปฏิบัติ                                                              |
| ---------------------- | ----------------------------------------------------------------------- |
| Access token lifetime  | 5-15 นาที (ยิ่งสั้นยิ่งปลอดภัย)                                         |
| Refresh token lifetime | 8-24 ชั่วโมง (หรือ absolute max 30 วัน)                                 |
| Refresh token rotation | บังคับ — ออก refresh token ใหม่ทุกครั้งที่ใช้, revoke token เก่าทันที   |
| Token binding          | ผูก token กับ client instance (DPoP preferred)                          |
| Sender constraint      | ใช้ DPoP (RFC 9449) หรือ mTLS certificate-bound tokens                  |
| Revocation             | Implement token revocation endpoint (RFC 7009) สำหรับ logout/compromise |
| Introspection          | ใช้ token introspection (RFC 7662) สำหรับ opaque tokens                 |

### Redirect URI Validation

```
กฎสำคัญ:
1. Exact match เท่านั้น — ห้ามใช้ wildcards ใน redirect_uri
2. HTTPS บังคับ — ยกเว้น localhost สำหรับ development
3. ห้ามใช้ custom URI schemes สำหรับ web apps
4. Mobile apps ใช้ claimed HTTPS redirect URIs (Universal Links / App Links)

ตัวอย่างที่ถูก:
  https://app.example.com/callback         ✅ exact match
  https://app.example.com/auth/callback    ✅ exact match

ตัวอย่างที่ผิด:
  https://app.example.com/*                ❌ wildcard
  https://*.example.com/callback           ❌ subdomain wildcard
  http://app.example.com/callback          ❌ ไม่ใช้ HTTPS
```

### Scope Minimization

```yaml
# ตัวอย่าง scope design — ใช้ least privilege
scopes:
  # Read scopes
  api:read: "Read access to API resources"
  profile:read: "Read user profile"
  orders:read: "Read order history"

  # Write scopes
  orders:write: "Create/update orders"
  profile:write: "Update user profile"

  # Admin scopes (ต้องผ่าน approval flow)
  admin:users: "Manage user accounts"
  admin:config: "Modify system configuration"

# หลักการ: ขอ scopes เท่าที่จำเป็นเท่านั้น
# ห้ามขอ scope กว้างๆ เช่น "api:*" หรือ "admin:*"
```

---

## 5. รูปแบบความปลอดภัย API Gateway (API Gateway Security Patterns)

### Kong Gateway Security Configuration

```yaml
# kong.yml — Declarative configuration
_format_version: "3.0"

services:
  - name: backend-api
    url: http://backend:8080
    routes:
      - name: api-route
        paths:
          - /api/v1
        strip_path: true

plugins:
  # Rate Limiting — ป้องกัน API4:2023 Unrestricted Resource Consumption
  - name: rate-limiting
    config:
      minute: 60
      hour: 1000
      policy: redis
      redis_host: redis
      redis_port: 6379
      fault_tolerant: true
      hide_client_headers: false

  # Request Size Limiting — ป้องกัน large payload attack
  - name: request-size-limiting
    config:
      allowed_payload_size: 1 # MB
      size_unit: megabytes
      require_content_length: true

  # IP Restriction — allowlist/blocklist
  - name: ip-restriction
    config:
      allow:
        - 10.0.0.0/8
        - 172.16.0.0/12
      status: 403
      message: "IP not allowed"

  # CORS — ป้องกัน cross-origin abuse
  - name: cors
    config:
      origins:
        - "https://app.example.com"
      methods:
        - GET
        - POST
        - PUT
        - DELETE
      headers:
        - Authorization
        - Content-Type
      max_age: 3600
      credentials: true

  # Response Transformer — security headers
  - name: response-transformer
    config:
      add:
        headers:
          - "X-Content-Type-Options: nosniff"
          - "X-Frame-Options: DENY"
          - "Strict-Transport-Security: max-age=31536000; includeSubDomains"
          - "Content-Security-Policy: default-src 'self'"

  # Bot Detection — ป้องกัน API6:2023
  - name: bot-detection
    config:
      deny:
        - "curl"
        - "wget"
        - "python-requests"
```

### mTLS Termination at Gateway

```
Client ──── mTLS ────▶ API Gateway ──── internal TLS ────▶ Backend
                         │
                         ├── Validate client certificate
                         ├── Check certificate against CA
                         ├── Extract client identity from CN/SAN
                         ├── Forward identity as header (X-Client-CN)
                         └── Terminate mTLS, forward with internal TLS

Kong mTLS config:
  plugins:
    - name: mtls-auth
      config:
        ca_certificates:
          - <ca-certificate-id>
        skip_consumer_lookup: false
        revocation_check_mode: SKIP  # or IGNORE_CA_ERROR
```

---

## 6. การจัดการคลัง API (API Inventory & Discovery)

### OpenAPI Schema Validation

```bash
# Validate OpenAPI spec ด้วย Spectral
npx @stoplight/spectral-cli lint openapi.yaml --ruleset .spectral.yaml

# Custom Spectral ruleset สำหรับ security
# .spectral.yaml
cat <<'EOF'
extends: ["spectral:oas"]
rules:
  operation-security-defined:
    description: "ทุก operation ต้องมี security scheme"
    severity: error
    given: "$.paths[*][get,post,put,patch,delete]"
    then:
      field: "security"
      function: truthy

  no-http-basic:
    description: "ห้ามใช้ HTTP Basic authentication"
    severity: error
    given: "$.components.securitySchemes[*]"
    then:
      field: "scheme"
      function: pattern
      functionOptions:
        notMatch: "^basic$"

  rate-limit-header:
    description: "ทุก response ควรมี rate limit headers"
    severity: warn
    given: "$.paths[*][*].responses[*].headers"
    then:
      field: "X-RateLimit-Limit"
      function: truthy
EOF
```

### Shadow API Detection Techniques

```
Shadow API Detection Strategy:

1. Traffic Analysis (Passive)
   ├── Deploy API traffic mirror ที่ gateway
   ├── วิเคราะห์ paths ที่ไม่มีใน OpenAPI spec
   ├── เครื่องมือ: Akto, API Clarity, Salt Security
   └── ตรวจสอบทุกสัปดาห์

2. Network Scanning (Active)
   ├── Scan internal networks สำหรับ HTTP/HTTPS services
   ├── Enumerate endpoints ด้วย wordlists
   ├── เครื่องมือ: Nuclei, ffuf, Amass
   └── ตรวจสอบทุกเดือน

3. Code Repository Analysis
   ├── Grep สำหรับ route definitions ใน source code
   ├── เปรียบเทียบกับ API catalog
   ├── เครื่องมือ: Semgrep, custom scripts
   └── ทำอัตโนมัติใน CI/CD

4. DNS & Certificate Monitoring
   ├── Monitor subdomain creation (api-*, *-api.*)
   ├── Certificate Transparency logs
   ├── เครื่องมือ: Amass, crt.sh, subfinder
   └── Real-time monitoring
```

### API Catalog Fields

```yaml
# api-catalog.yaml — required fields ต่อ API entry
apis:
  - name: "User Service API"
    version: "v2.1.0"
    status: "active" # active | deprecated | retired
    owner: "platform-team"
    spec_url: "https://api.example.com/docs/openapi.yaml"
    authentication: "OAuth 2.0"
    data_classification: "Confidential" # Public | Internal | Confidential | Restricted
    pii_exposure: true
    rate_limit: "1000/hour"
    deprecation_date: null # ระบุเมื่อ status = deprecated
    sunset_date: null # วันที่จะ retire API ถาวร
```

### Schema Drift Detection

```bash
# เปรียบเทียบ OpenAPI spec กับ actual API behavior
# ใช้ oasdiff สำหรับ breaking change detection

# Install
go install github.com/tufin/oasdiff@latest

# ตรวจสอบ breaking changes ระหว่าง versions
oasdiff breaking openapi-v1.yaml openapi-v2.yaml

# ตรวจสอบ diff ทั้งหมด
oasdiff diff openapi-v1.yaml openapi-v2.yaml --format yaml

# ใช้ใน CI/CD — fail ถ้ามี breaking changes
oasdiff breaking openapi-v1.yaml openapi-v2.yaml --fail-on ERR
```

---

## 7. การทดสอบความปลอดภัย API (API Fuzzing & Security Testing)

### OWASP ZAP API Scan

```bash
# ZAP API scan ด้วย OpenAPI spec
docker run --rm -v $(pwd):/zap/wrk:rw \
  ghcr.io/zaproxy/zaproxy:stable \
  zap-api-scan.py \
    -t https://api.example.com/openapi.yaml \
    -f openapi \
    -r api-scan-report.html \
    -J api-scan-report.json \
    -c zap-api-config.conf

# zap-api-config.conf — custom scan configuration
# 10049 = STOCSRF (disable สำหรับ API-only scan)
# 10021 = X-Content-Type-Options
cat <<'EOF'
10049	IGNORE	(Anti-CSRF Tokens Check)
90022	IGNORE	(Application Error Disclosure)
EOF
```

### Nuclei API Security Templates

```bash
# Nuclei scan ด้วย API-specific templates
nuclei -u https://api.example.com \
  -t http/vulnerabilities/ \
  -t http/misconfiguration/ \
  -tags api,jwt,oauth,ssrf \
  -severity critical,high \
  -json-export nuclei-results.json

# Custom Nuclei template สำหรับ JWT none algorithm
cat <<'EOF'
id: jwt-none-algorithm
info:
  name: JWT None Algorithm Check
  severity: critical
  tags: jwt,api,auth
  reference:
    - https://owasp.org/API-Security/

http:
  - raw:
      - |
        GET /api/v1/profile HTTP/1.1
        Host: {{Hostname}}
        Authorization: Bearer eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJzdWIiOiIxMjM0NTY3ODkwIn0.

    matchers-condition: and
    matchers:
      - type: status
        status:
          - 200
      - type: word
        part: body
        words:
          - "email"
          - "name"
        condition: or
EOF
```

### Manual API Testing Checklist

```
Manual API Security Testing Workflow:
│
├── 1. BOLA Testing (API1)
│   ├── เปลี่ยน object IDs → ต้อง return 403/404
│   └── ลอง IDOR ทุก endpoint ที่มี path parameter
│
├── 2. Authentication Testing (API2)
│   ├── JWT alg:none, expired token, tampered claims
│   └── Brute-force login, credential stuffing
│
├── 3. Authorization Testing (API3, API5)
│   ├── Mass assignment: เพิ่ม fields (isAdmin, role) ใน JSON body
│   └── BFLA: เรียก admin endpoints ด้วย user token
│
├── 4. Resource & Rate Limit (API4)
│   ├── ตรวจสอบ X-RateLimit-* headers
│   └── Large payload, pagination abuse
│
├── 5. SSRF Testing (API7)
│   ├── URL parameters → internal IPs, cloud metadata
│   └── DNS rebinding, redirect chains
│
└── Tools: Burp Suite (Repeater/Intruder), Postman, OWASP ZAP
```

---

## 8. ความปลอดภัย API ใน CI/CD Pipeline (API Security in CI/CD Pipeline)

> Cross-reference: Domain 3 (DevSecOps Pipeline) → `references/devsecops-pipeline.md`

### Pipeline Stages

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Pre-Commit   │  │  Build        │  │  Deploy       │  │  Runtime      │
│               │  │               │  │               │  │               │
│ • OpenAPI     │  │ • SAST for    │  │ • DAST API    │  │ • API         │
│   linting     │  │   API code    │  │   scanning    │  │   monitoring  │
│   (Spectral)  │  │ • Schema      │  │ • Contract    │  │ • Anomaly     │
│ • Secret      │  │   validation  │  │   testing     │  │   detection   │
│   detection   │  │ • Breaking    │  │ • Fuzzing     │  │ • Rate limit  │
│               │  │   change      │  │               │  │   alerting    │
│               │  │   detection   │  │               │  │               │
└──────────────┘  └──────────────┘  └──────────────┘  └──────────────┘
```

### GitHub Actions Pipeline for API Security

```yaml
# .github/workflows/api-security.yml
name: API Security Pipeline
on:
  push:
    paths: ["src/api/**", "openapi/**"]
  pull_request:
    paths: ["src/api/**", "openapi/**"]

jobs:
  openapi-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: stoplightio/spectral-action@latest
        with:
          file_glob: "openapi/*.yaml"
          spectral_ruleset: ".spectral.yaml"

  breaking-change:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Check Breaking Changes
        run: |
          go install github.com/tufin/oasdiff@latest
          git show origin/main:openapi/api.yaml > /tmp/base-spec.yaml
          oasdiff breaking /tmp/base-spec.yaml openapi/api.yaml --fail-on ERR

  api-sast:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: semgrep/semgrep-action@v1
        with:
          config: "p/owasp-top-ten p/jwt p/nodejs"
          generateSarif: "1"
      - uses: github/codeql-action/upload-sarif@v3
        with: { sarif_file: semgrep.sarif }

  api-dast:
    runs-on: ubuntu-latest
    needs: [openapi-lint, api-sast]
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: zaproxy/action-api-scan@v0.9.0
        with:
          target: "https://staging-api.example.com/openapi.yaml"
          format: openapi
          cmd_options: "-J report.json"

  # Security Gate: CRITICAL → block, HIGH → review, MEDIUM/LOW → create issues
```

---

## 9. อ้างอิงมาตรฐานและรายการตรวจสอบ (Framework References & Remediation Checklist)

### Framework References

| Framework                   | Version / Year | Key Focus                                     | URL                                            |
| --------------------------- | -------------- | --------------------------------------------- | ---------------------------------------------- |
| OWASP API Security Top 10   | 2023           | ความเสี่ยง 10 อันดับแรกสำหรับ API             | https://owasp.org/API-Security/                |
| OAuth 2.0 Security BCP      | RFC 9700       | แนวปฏิบัติความปลอดภัย OAuth 2.0               | https://datatracker.ietf.org/doc/rfc9700/      |
| OpenAPI Specification       | 3.1.0          | มาตรฐาน API schema definition                 | https://spec.openapis.org/oas/v3.1.0           |
| RFC 7519 (JWT)              | 2015           | JSON Web Token specification                  | https://datatracker.ietf.org/doc/rfc7519/      |
| RFC 9449 (DPoP)             | 2023           | Demonstrating Proof-of-Possession             | https://datatracker.ietf.org/doc/rfc9449/      |
| RFC 7009 (Token Revocation) | 2013           | OAuth 2.0 Token Revocation                    | https://datatracker.ietf.org/doc/rfc7009/      |
| NIST SP 800-204             | Rev 1          | Security for Microservices-based Applications | https://csrc.nist.gov/pubs/sp/800/204/r1/final |
| CWE Top 25                  | 2023           | Most Dangerous Software Weaknesses            | https://cwe.mitre.org/top25/archive/2023/      |

### CWE Mapping สำหรับ API Vulnerabilities

| OWASP API Risk   | CWE ID   | CWE Name                                                                       |
| ---------------- | -------- | ------------------------------------------------------------------------------ |
| API1 (BOLA)      | CWE-639  | Authorization Bypass Through User-Controlled Key                               |
| API2 (Auth)      | CWE-287  | Improper Authentication                                                        |
| API3 (Property)  | CWE-915  | Improperly Controlled Modification of Dynamically-Determined Object Attributes |
| API4 (Resource)  | CWE-770  | Allocation of Resources Without Limits or Throttling                           |
| API5 (BFLA)      | CWE-285  | Improper Authorization                                                         |
| API6 (Biz Flow)  | CWE-799  | Improper Control of Interaction Frequency                                      |
| API7 (SSRF)      | CWE-918  | Server-Side Request Forgery                                                    |
| API8 (Misconfig) | CWE-16   | Configuration                                                                  |
| API9 (Inventory) | CWE-1059 | Insufficient Technical Documentation                                           |
| API10 (Unsafe)   | CWE-20   | Improper Input Validation                                                      |

### Remediation Checklist

#### Quick Win (ดำเนินการได้ภายใน 1-2 วัน)

- [ ] **[Quick Win]** เปิด rate limiting บนทุก API endpoints — ป้องกัน API4:2023
- [ ] **[Quick Win]** Validate JWT algorithm — reject `alg: "none"` — ป้องกัน API2:2023
- [ ] **[Quick Win]** กำหนด request size limits (max 1MB default) — ป้องกัน API4:2023
- [ ] **[Quick Win]** เพิ่ม security headers: `X-Content-Type-Options`, `Strict-Transport-Security`
- [ ] **[Quick Win]** ปิด debug mode และ verbose error messages ใน production — ป้องกัน API8:2023
- [ ] **[Quick Win]** Enforce HTTPS บนทุก endpoints, redirect HTTP → HTTPS

#### Medium Effort (ดำเนินการได้ภายใน 1-2 สัปดาห์)

- [ ] **[Medium Effort]** Implement BOLA checks — ตรวจสอบ object ownership ทุก request — ป้องกัน API1:2023
- [ ] **[Medium Effort]** Deploy API gateway พร้อม security policies (rate limit, IP restriction, CORS)
- [ ] **[Medium Effort]** สร้าง API inventory จาก OpenAPI specs — ป้องกัน API9:2023
- [ ] **[Medium Effort]** Integrate API security scanning ใน CI/CD pipeline (Spectral + ZAP)
- [ ] **[Medium Effort]** Implement RBAC/ABAC สำหรับ function-level authorization — ป้องกัน API5:2023
- [ ] **[Medium Effort]** Validate และ sanitize ทุก input ด้วย schema validation (Zod, Joi, JSON Schema)
- [ ] **[Medium Effort]** Implement OAuth 2.0 + PKCE แทน API keys สำหรับ user-facing APIs

#### Long-term (ดำเนินการ 1-3 เดือน)

- [ ] **[Long-term]** Implement mTLS สำหรับ service-to-service communication — ป้องกัน API2:2023
- [ ] **[Long-term]** Deploy runtime API anomaly detection — traffic baseline + ML-based detection
- [ ] **[Long-term]** ครอบคลุม API lifecycle security ทั้งหมด — design, develop, test, deploy, monitor, retire
- [ ] **[Long-term]** Implement API versioning strategy พร้อม deprecation policy — ป้องกัน API9:2023
- [ ] **[Long-term]** Deploy DPoP (RFC 9449) สำหรับ proof-of-possession token binding
- [ ] **[Long-term]** Automated API contract testing ใน CI/CD (consumer-driven contracts)
