# DevSecOps Pipeline Configs Reference

คู่มือการสร้าง Security-integrated CI/CD Pipeline และ DevSecOps configurations

> สำหรับ code security analysis (Semgrep/CodeQL) → ดู references/code-security-analysis.md (Domain 6)
> สำหรับ container security และ SBOM → ดู references/container-supply-chain.md (Domain 7)
> สำหรับ API security testing → ดู references/api-security.md (Domain 13)
> สำหรับ end-to-end supply chain workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 6: Code Security Analysis → `references/code-security-analysis.md`
- Domain 7: Container & Supply Chain → `references/container-supply-chain.md`
- Domain 13: API Security → `references/api-security.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`

## Table of Contents

1. DevSecOps Pipeline Architecture
2. Security Scanning Tools Matrix
3. GitHub Actions Security Pipeline
4. GitLab CI Security Pipeline
5. Jenkins Security Pipeline
6. Container Security
7. Infrastructure as Code (IaC) Security
8. SBOM & Dependency Management
9. Secret Detection
10. Compliance Gates
11. OWASP Integration

---

## 1. DevSecOps Pipeline Architecture

แนวคิด Shift-Left: ย้าย security testing เข้ามาใน development lifecycle ให้เร็วที่สุด

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  Commit   │──▶│  Build   │──▶│  Test    │──▶│  Deploy  │──▶│ Monitor  │──▶│ Respond  │
│           │   │          │   │          │   │  (Stage)  │   │          │   │          │
│ • Secret  │   │ • SCA    │   │ • DAST   │   │ • IaC    │   │ • RASP   │   │ • SIEM   │
│   detect  │   │ • SAST   │   │ • Pen    │   │   scan   │   │ • WAF    │   │ • SOAR   │
│ • Pre-    │   │ • SBOM   │   │   test   │   │ • Config │   │ • Log    │   │ • IR     │
│   commit  │   │ • License│   │ • API    │   │   check  │   │   monitor│   │   auto   │
│   hooks   │   │   check  │   │   scan   │   │ • Sign   │   │ • Vuln   │   │          │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
```

---

## 2. Security Scanning Tools Matrix

| ประเภท (Category)          | Open Source                                             | Commercial                         | OWASP Reference         |
| -------------------------- | ------------------------------------------------------- | ---------------------------------- | ----------------------- |
| SAST (Static Analysis)     | Semgrep, SonarQube CE, Bandit (Python), ESLint-security | Snyk Code, Checkmarx, Fortify      | OWASP Code Review Guide |
| DAST (Dynamic Analysis)    | OWASP ZAP, Nuclei, Nikto                                | Burp Suite Enterprise, Qualys WAS  | OWASP Testing Guide     |
| SCA (Software Composition) | OWASP Dependency-Check, Trivy, Grype                    | Snyk Open Source, Black Duck, Mend | OWASP Top 10 A06        |
| Container Security         | Trivy, Grype, Clair, Syft                               | Snyk Container, Prisma Cloud, Aqua | -                       |
| IaC Scanning               | Checkov, tfsec, KICS, Terrascan                         | Snyk IaC, Prisma Cloud             | -                       |
| Secret Detection           | Gitleaks, TruffleHog, detect-secrets                    | GitGuardian, SpectralOps           | -                       |
| SBOM Generation            | Syft, CycloneDX                                         | Anchore Enterprise                 | -                       |
| License Compliance         | FOSSology, ScanCode                                     | Snyk, FOSSA                        | -                       |
| API Security               | OWASP ZAP, Dredd                                        | 42Crunch, Salt Security            | OWASP API Top 10        |

---

## 3. GitHub Actions Security Pipeline

```yaml
# .github/workflows/devsecops-pipeline.yml
name: DevSecOps Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

permissions:
  contents: read
  security-events: write
  actions: read

jobs:
  # ──────────────────────────────────────────
  # Phase 1: Secret Detection (Pre-build)
  # ──────────────────────────────────────────
  secret-scan:
    name: "🔐 Secret Detection"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Gitleaks Scan
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  # ──────────────────────────────────────────
  # Phase 2: SAST + SCA (Build)
  # ──────────────────────────────────────────
  sast:
    name: "🔍 SAST - Static Analysis"
    runs-on: ubuntu-latest
    needs: secret-scan
    steps:
      - uses: actions/checkout@v4
      - name: Semgrep SAST Scan
        uses: semgrep/semgrep-action@v1
        with:
          config: >-
            p/owasp-top-ten
            p/security-audit
          generateSarif: "1"
      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif

  sca:
    name: "📦 SCA - Dependency Check"
    runs-on: ubuntu-latest
    needs: secret-scan
    steps:
      - uses: actions/checkout@v4
      - name: Trivy SCA Scan
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: "fs"
          scan-ref: "."
          format: "sarif"
          output: "trivy-sca.sarif"
          severity: "CRITICAL,HIGH"

  sbom:
    name: "📋 SBOM Generation"
    runs-on: ubuntu-latest
    needs: secret-scan
    steps:
      - uses: actions/checkout@v4
      - name: Generate SBOM with Syft
        uses: anchore/sbom-action@v0
        with:
          format: cyclonedx-json
          output-file: sbom.cyclonedx.json
      - name: Upload SBOM
        uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.cyclonedx.json

  # ──────────────────────────────────────────
  # Phase 3: Container Security
  # ──────────────────────────────────────────
  container-scan:
    name: "🐳 Container Security"
    runs-on: ubuntu-latest
    needs: [sast, sca]
    steps:
      - uses: actions/checkout@v4
      - name: Build image
        run: docker build -t app:${{ github.sha }} .
      - name: Trivy Container Scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: "app:${{ github.sha }}"
          format: "sarif"
          output: "trivy-container.sarif"
          severity: "CRITICAL,HIGH"

  # ──────────────────────────────────────────
  # Phase 4: IaC Security
  # ──────────────────────────────────────────
  iac-scan:
    name: "🏗️ IaC Security Scan"
    runs-on: ubuntu-latest
    needs: secret-scan
    steps:
      - uses: actions/checkout@v4
      - name: Checkov IaC Scan
        uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          framework: terraform,kubernetes,dockerfile
          output_format: sarif
          output_file_path: checkov.sarif

  # ──────────────────────────────────────────
  # Phase 5: Security Gate (Decision)
  # ──────────────────────────────────────────
  security-gate:
    name: "🚦 Security Gate"
    runs-on: ubuntu-latest
    needs: [sast, sca, container-scan, iac-scan]
    steps:
      - name: Evaluate Security Results
        run: |
          echo "Evaluating security scan results..."
          # ถ้ามี CRITICAL findings → fail the pipeline
          # ถ้ามี HIGH findings → require manual approval
          # MEDIUM/LOW → create tickets, continue
```

---

## 4. GitLab CI Security Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - secret-detection
  - build
  - test-sast
  - test-sca
  - test-container
  - test-dast
  - security-gate
  - deploy

include:
  - template: Security/Secret-Detection.gitlab-ci.yml
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Container-Scanning.gitlab-ci.yml
  - template: Security/DAST.gitlab-ci.yml

# Override หรือ extend ตาม needs ขององค์กร
sast:
  stage: test-sast
  variables:
    SAST_EXCLUDED_ANALYZERS: "spotbugs"

security-gate:
  stage: security-gate
  script:
    - echo "Checking for critical/high vulnerabilities..."
    # Custom gate logic
  rules:
    - if: $CI_MERGE_REQUEST_ID
```

---

## 5. Compliance Gates

### Gate Criteria (เกณฑ์ผ่าน/ไม่ผ่าน)

| Severity | Production             | Staging                     | Development            |
| -------- | ---------------------- | --------------------------- | ---------------------- |
| Critical | ❌ Block + Alert       | ❌ Block + Alert            | ⚠️ Warn + Create Issue |
| High     | ❌ Block               | ⚠️ Warn + Approval Required | ⚠️ Warn + Create Issue |
| Medium   | ⚠️ Approval Required   | ✅ Pass + Create Issue      | ✅ Pass + Log          |
| Low      | ✅ Pass + Create Issue | ✅ Pass + Log               | ✅ Pass                |

### OWASP Top 10 Mapping for Pipeline

| OWASP Top 10 (2021)            | Pipeline Stage | Tool Type                       |
| ------------------------------ | -------------- | ------------------------------- |
| A01: Broken Access Control     | SAST + DAST    | Semgrep rules, ZAP active scan  |
| A02: Cryptographic Failures    | SAST           | Semgrep crypto rules            |
| A03: Injection                 | SAST + DAST    | Semgrep injection, ZAP SQLi/XSS |
| A04: Insecure Design           | Code Review    | Manual + SAST design patterns   |
| A05: Security Misconfiguration | IaC Scan       | Checkov, tfsec                  |
| A06: Vulnerable Components     | SCA            | Trivy, Dependency-Check         |
| A07: Auth Failures             | SAST + DAST    | Custom rules + ZAP auth         |
| A08: Software/Data Integrity   | SBOM + SCA     | Syft, signature verification    |
| A09: Logging Failures          | SAST           | Custom logging rules            |
| A10: SSRF                      | SAST + DAST    | Semgrep SSRF, ZAP SSRF          |

---

## 6. SBOM & Supply Chain Security

### SBOM Generation Commands

```bash
# Syft — CycloneDX format
syft packages dir:. -o cyclonedx-json > sbom.json

# Syft — SPDX format
syft packages dir:. -o spdx-json > sbom.spdx.json

# For container images
syft packages registry:myapp:latest -o cyclonedx-json > container-sbom.json

# Validate SBOM
# ตรวจสอบว่า SBOM ครบถ้วนและถูก format
```

### Supply Chain Security Checklist

- [ ] SBOM generated สำหรับทุก release
- [ ] Dependencies pinned to specific versions (ไม่ใช้ `latest`)
- [ ] Signature verification enabled สำหรับ packages
- [ ] Private registry configured สำหรับ internal packages
- [ ] Dependabot / Renovate enabled สำหรับ automated updates
- [ ] License compliance checked (no GPL in proprietary code)
