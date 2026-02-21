# Smoke Test Prompts — cybersecurity-pro Plugin

Manual functional tests for all 15 domains. Run each prompt in a Claude Code session with the plugin installed, then verify against the checklist.

## Prerequisites

- Plugin installed: `cybersecurity-pro@pitimon-cybersecurity`
- Plugin enabled in `~/.claude/settings.json`
- Run `claude doctor` — no errors related to plugin

## Global Quality Checks (apply to ALL domains)

Every output must pass these bilingual quality checks:

- [ ] Thai prose used as primary language
- [ ] English technical terms preserved (never translated)
- [ ] Section headers: Thai (English) format
- [ ] Framework references are specific (not generic)
- [ ] MITRE ATT&CK IDs present where applicable (e.g., T1566.001)
- [ ] Severity scale used: Critical/High/Medium/Low/Informational
- [ ] SLA/time markers present where applicable

---

## Domain 1: IR Playbooks

**Test Prompt:**

```
สร้าง IR playbook สำหรับ ransomware incident ตาม NIST 800-61
```

**Pass Criteria:**

- [ ] Contains all 4 NIST 800-61 phases: Preparation, Detection & Analysis, Containment/Eradication/Recovery, Post-Incident Activity
- [ ] MITRE ATT&CK Technique IDs for ransomware (e.g., T1486 Data Encrypted for Impact)
- [ ] SLA timelines per severity level
- [ ] Escalation matrix with L1/L2/L3 responsibilities
- [ ] Communication templates (internal + external)
- [ ] Tool recommendations (commercial + open-source)
- [ ] Recovery procedures with rollback steps
- [ ] Post-mortem template or lessons learned section

---

## Domain 2: DFIR Reports

**Test Prompt:**

```
สร้าง forensic investigation report สำหรับ memory forensics case
```

**Pass Criteria:**

- [ ] Chain of Custody section with evidence integrity fields
- [ ] SHA-256 hash values for evidence items
- [ ] Timeline reconstruction section with timestamps
- [ ] IOC (Indicators of Compromise) extraction table
- [ ] Memory analysis methodology (Volatility/Rekall references)
- [ ] Evidence handling procedures following forensic standards
- [ ] Findings mapped to MITRE ATT&CK techniques
- [ ] Executive summary + technical detail sections

---

## Domain 3: DevSecOps Pipeline

**Test Prompt:**

```
Create DevSecOps CI/CD pipeline with SAST/SCA for GitHub Actions
```

**Pass Criteria:**

- [ ] Valid GitHub Actions YAML syntax
- [ ] SAST tool integration (Semgrep, CodeQL, or equivalent)
- [ ] SCA/dependency scanning step (Snyk, Trivy, or Grype)
- [ ] OWASP Top 10 mapping for detected vulnerability categories
- [ ] Security gate (fail pipeline on critical findings)
- [ ] SBOM generation step
- [ ] Secret scanning step
- [ ] OWASP SAMM maturity reference

---

## Domain 4: SOC Operations + SOAR

**Test Prompt:**

```
สร้าง SOC triage procedure สำหรับ L1 analyst พร้อม SIEM rules
```

**Pass Criteria:**

- [ ] L1/L2/L3 workflow with clear handoff criteria
- [ ] SIEM correlation rules (Splunk SPL, Elastic KQL, or Sigma)
- [ ] Escalation matrix with severity-based routing
- [ ] MITRE ATT&CK technique IDs in triage criteria
- [ ] Alert classification taxonomy
- [ ] Response SLA per severity level
- [ ] SOAR automation/playbook suggestions
- [ ] KPI/metrics for SOC performance

---

## Domain 5: GitOps Security

**Test Prompt:**

```
สร้าง GitOps security policies ด้วย OPA/Gatekeeper
```

**Pass Criteria:**

- [ ] ConstraintTemplate YAML (valid Rego syntax)
- [ ] Constraint resource YAML
- [ ] Falco runtime detection rules
- [ ] ArgoCD security configuration snippets
- [ ] Git-based secret management recommendations
- [ ] Drift detection policies
- [ ] Namespace/RBAC isolation patterns
- [ ] Policy testing methodology

---

## Domain 6: Code Security Analysis

**Test Prompt:**

```
สร้าง Semgrep rules ตรวจจับ SQL injection พร้อม SARIF output
```

**Pass Criteria:**

- [ ] Valid Semgrep YAML rule syntax
- [ ] CWE IDs mapped (e.g., CWE-89 SQL Injection)
- [ ] Taint mode configuration (source/sink/sanitizer)
- [ ] SARIF 2.1.0 output format explanation or config
- [ ] Multiple language patterns (Python, Java, or JS)
- [ ] Fix suggestions / autofix patterns
- [ ] CI integration example
- [ ] Variant analysis methodology reference

---

## Domain 7: Container & Supply Chain Security

**Test Prompt:**

```
Create container hardening guide with Trivy scanning and SBOM generation
```

**Pass Criteria:**

- [ ] Dockerfile hardening best practices (multi-stage, non-root, minimal base)
- [ ] Trivy scanning commands and configuration
- [ ] SBOM generation (Syft/CycloneDX format)
- [ ] Image signing with cosign/Sigstore
- [ ] SLSA supply chain level reference
- [ ] Runtime SecurityContext configuration
- [ ] CIS Docker Benchmark controls referenced
- [ ] Vulnerability threshold / policy gate

---

## Domain 8: Threat Modeling & Risk Assessment

**Test Prompt:**

```
สร้าง STRIDE threat model สำหรับ web application พร้อม risk assessment matrix
```

**Pass Criteria:**

- [ ] All 6 STRIDE categories: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege
- [ ] Threat-to-mitigation mapping table
- [ ] Risk matrix (likelihood x impact)
- [ ] SOC 2 or ISO 27001 quick reference
- [ ] PASTA methodology reference
- [ ] PDPA (Thai data protection) reference
- [ ] Risk register template
- [ ] Data flow diagram or DFD reference

---

## Domain 9: Compliance Frameworks

**Test Prompt:**

```
สร้าง NIST 800-53 gap assessment สำหรับ cloud environment พร้อม PCI DSS v4.0 control mapping
```

**Pass Criteria:**

- [ ] NIST 800-53 control families referenced
- [ ] PCI DSS v4.0 requirements listed
- [ ] Cross-framework mapping table
- [ ] Gap assessment template with remediation roadmap
- [ ] Implementation priority (baselines or Implementation Groups)
- [ ] CIS Controls reference for quick baseline
- [ ] Compliance metrics and evidence collection plan
- [ ] GDPR or HIPAA safeguards if applicable

---

## Domain 10: Cloud Security & CSPM

**Test Prompt:**

```
สร้าง cloud security audit checklist สำหรับ AWS environment ตาม CIS Benchmarks
```

**Pass Criteria:**

- [ ] Shared responsibility model reference
- [ ] IAM policy review checklist (least privilege, MFA, key rotation)
- [ ] S3 bucket security checks (public access, encryption, logging)
- [ ] Security Group / VPC review items
- [ ] CSPM tool recommendations (Prowler, ScoutSuite, or equivalent)
- [ ] CloudTrail logging configuration
- [ ] CIS AWS Foundations Benchmark controls referenced
- [ ] Multi-cloud comparison or alternatives mentioned

---

## Domain 11: Zero Trust Architecture

**Test Prompt:**

```
สร้าง Zero Trust implementation roadmap ตาม NIST 800-207 สำหรับองค์กรขนาดกลาง
```

**Pass Criteria:**

- [ ] NIST 800-207 tenets referenced
- [ ] 5 pillars covered: Identity, Device, Network, Application, Data
- [ ] CISA Zero Trust Maturity Model levels (Traditional→Optimal)
- [ ] Phase-by-phase implementation timeline
- [ ] Microsegmentation or ZTNA migration pattern
- [ ] Conditional access policy template or example
- [ ] Maturity assessment checklist
- [ ] KPIs/metrics for measuring Zero Trust progress

---

## Domain 12: AI/ML Security

**Test Prompt:**

```
สร้าง AI security assessment สำหรับ LLM-based chatbot application
```

**Pass Criteria:**

- [ ] OWASP LLM Top 10 risks referenced
- [ ] Prompt injection defense patterns (direct + indirect)
- [ ] MITRE ATLAS technique mapping
- [ ] AI governance policy or responsible AI checklist
- [ ] Model supply chain security considerations
- [ ] LLM guardrails configuration (input/output filtering)
- [ ] AI incident response procedures
- [ ] EU AI Act or NIST AI RMF reference

---

## Domain 13: API Security

**Test Prompt:**

```
สร้าง API security assessment ตาม OWASP API Top 10 สำหรับ REST API
```

**Pass Criteria:**

- [ ] OWASP API Security Top 10 2023 risks referenced
- [ ] BOLA (API1) detection and mitigation covered
- [ ] JWT validation checklist or code example
- [ ] OAuth 2.0 best practices (PKCE, token rotation)
- [ ] Rate limiting and resource consumption controls
- [ ] API gateway configuration template or recommendations
- [ ] Security headers (HSTS, X-Content-Type-Options)
- [ ] API inventory / shadow API detection mentioned

---

## Domain 14: Vulnerability Management

**Test Prompt:**

```
สร้าง vulnerability management program พร้อม CVSS+EPSS prioritization matrix
```

**Pass Criteria:**

- [ ] Vulnerability lifecycle workflow (discover → assess → prioritize → remediate → verify)
- [ ] CVSS v4.0 scoring explanation or severity table
- [ ] EPSS (Exploit Prediction Scoring System) integration
- [ ] CISA KEV catalog reference and override logic
- [ ] Combined prioritization matrix (CVSS + EPSS + KEV)
- [ ] SLA templates per severity level
- [ ] Scanning tool recommendations (Nessus, Qualys, or equivalents)
- [ ] Vulnerability metrics (MTTD, MTTR, SLA compliance)

---

## Domain 15: Threat Intelligence

**Test Prompt:**

```
สร้าง threat intelligence program ด้วย STIX/TAXII integration พร้อม IOC lifecycle management
```

**Pass Criteria:**

- [ ] STIX 2.1 object types referenced (SDO, SRO, SCO)
- [ ] TAXII 2.1 server/client configuration or API endpoints
- [ ] TI platform recommendations (MISP, OpenCTI, or commercial)
- [ ] IOC lifecycle workflow (collection → validation → enrichment → dissemination → expiration)
- [ ] TLP 2.0 classification definitions (RED, AMBER+STRICT, AMBER, GREEN, CLEAR)
- [ ] Threat feed integration patterns (open-source and commercial)
- [ ] TI-driven detection (Sigma rules, YARA rules, or MITRE ATT&CK mapping)
- [ ] SOAR automation for TI workflows

---

## Quick Regression Test

For rapid regression after plugin updates, test these 4 prompts (covers Thai, English, mixed, and new domains):

1. `สร้าง IR playbook สำหรับ phishing incident`
2. `Create a Semgrep rule to detect hardcoded secrets`
3. `สร้าง NIST 800-53 gap assessment พร้อม PCI DSS control mapping`
4. `สร้าง AI security assessment สำหรับ LLM application พร้อม prompt injection defense`
5. `สร้าง API security assessment ตาม OWASP API Top 10 พร้อม JWT validation checklist`
6. `สร้าง vulnerability prioritization matrix ด้วย CVSS+EPSS+KEV พร้อม SLA templates`
7. `สร้าง threat intelligence program ด้วย STIX/TAXII พร้อม MISP integration`

Minimum pass: all 4 produce structured bilingual output with framework references.

---

## Reporting Results

Record results as:

```
Date: YYYY-MM-DD
Plugin Version: X.Y.Z
Domains Tested: 1,2,3...
Pass/Fail: X/Y
Notes: [any observations]
```
