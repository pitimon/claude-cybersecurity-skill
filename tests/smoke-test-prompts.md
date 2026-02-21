# Smoke Test Prompts — cybersecurity-pro Plugin

Manual functional tests for all 9 domains. Run each prompt in a Claude Code session with the plugin installed, then verify against the checklist.

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

## Quick Regression Test

For rapid regression after plugin updates, test these 3 prompts (covers Thai, English, and mixed):

1. `สร้าง IR playbook สำหรับ phishing incident`
2. `Create a Semgrep rule to detect hardcoded secrets`
3. `สร้าง NIST 800-53 gap assessment พร้อม PCI DSS control mapping`

Minimum pass: all 3 produce structured bilingual output with framework references.

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
