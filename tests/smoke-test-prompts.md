# Smoke Test Prompts — cybersecurity-pro Plugin

Manual functional tests for all 22 domains. Run each prompt in a Claude Code session with the plugin installed, then verify against the checklist.

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

## Domain 16: Cross-Domain Integration

**Test Prompt:**

```
ออกแบบ end-to-end security workflow ตั้งแต่ threat intelligence ถึง incident response พร้อม SOAR orchestration
```

**Pass Criteria:**

- [ ] Multiple domains referenced (at least 3 domain numbers: D1, D4, D15, etc.)
- [ ] Data flow diagram or workflow visualization (ASCII or structured)
- [ ] SOAR playbook template with cross-domain handoff steps
- [ ] Data exchange table showing what flows between domains
- [ ] MITRE ATT&CK technique IDs flowing across boundaries
- [ ] SLA/time markers for cross-domain handoffs
- [ ] NIST CSF 2.0 function mapping (Identify/Protect/Detect/Respond/Recover)
- [ ] Integration checklist or handoff checklist

---

## Domain 17: Security Governance & Executive Leadership

**Test Prompt:**

```
สร้าง security governance framework ตาม NIST CSF 2.0 GOVERN พร้อม board reporting template และ CISO/CAIO RACI matrix
```

**Pass Criteria:**

- [ ] NIST CSF 2.0 GOVERN function referenced (GV.OC, GV.RM, GV.RR, GV.PO, GV.OV, GV.SC)
- [ ] ISO 27014 governance processes mentioned (Evaluate/Direct/Monitor/Communicate/Assure)
- [ ] Executive roles defined (CISO at minimum, CAIO/CAISO if AI relevant)
- [ ] RACI matrix for key security activities
- [ ] Board reporting template or KPI dashboard (risk posture, operational, maturity)
- [ ] Maturity model reference (C2M2, CMMI, or CSF Tiers)
- [ ] SEC disclosure or regulatory governance reference
- [ ] Governance checklist or implementation roadmap

---

## Domain 18: OT/ICS Security

**Test Prompt:**

```
สร้าง OT security assessment ตาม NIST 800-82 และ IEC 62443 พร้อม Purdue Model network segmentation design และ PLC hardening checklist
```

**Pass Criteria:**

- [ ] NIST SP 800-82 Rev.3 referenced as primary framework
- [ ] IEC 62443 zones and conduits model explained
- [ ] Purdue Model levels (0-5) described with ASCII diagram or table
- [ ] IT/OT comparison table present (priority, protocols, lifespan)
- [ ] OT-specific considerations: safety-first, no active scanning, passive monitoring
- [ ] PLC/HMI/SCADA hardening checklist items
- [ ] MITRE ATT&CK for ICS technique IDs (e.g., T0858, T0831)
- [ ] Thai CII context or พ.ร.บ. ไซเบอร์ 2562 reference

---

## Domain 19: Agentic AI Security

**Test Prompt:**

```
สร้าง security checklist สำหรับ agentic AI system ที่ใช้ multi-agent orchestration
```

**Pass Criteria:**

- [ ] OWASP Agentic AI Top 10 2026 risks referenced
- [ ] Agent permission models (least-privilege, capability-based)
- [ ] Memory/context security (injection, poisoning, exfiltration)
- [ ] Tool-use authorization patterns (human-in-the-loop gates)
- [ ] Multi-agent trust boundaries and delegation chains
- [ ] Agent identity and authentication mechanisms
- [ ] Guardrails and safety layers for autonomous actions
- [ ] MITRE ATLAS mapping for agentic-specific techniques

---

## Domain 20: Post-Quantum Cryptography

**Test Prompt:**

```
ทำ crypto-agility assessment สำหรับองค์กรที่ต้อง migrate ไป post-quantum cryptography
```

**Pass Criteria:**

- [ ] NIST FIPS 203 (ML-KEM), FIPS 204 (ML-DSA), FIPS 205 (SLH-DSA) referenced
- [ ] CNSA 2.0 timeline milestones (2030 preference, 2035 mandatory)
- [ ] Crypto-agility assessment template (inventory → risk → migrate)
- [ ] Migration roadmap with phased approach
- [ ] Hybrid key exchange patterns (classical + PQC)
- [ ] Certificate and PKI migration considerations
- [ ] Impact analysis on TLS, VPN, code signing
- [ ] Quantum risk scoring (Harvest Now, Decrypt Later scenarios)

---

## Domain 21: Identity & Access Security

**Test Prompt:**

```
สร้าง non-human identity management policy สำหรับ Kubernetes workloads
```

**Pass Criteria:**

- [ ] SPIFFE/SPIRE framework referenced for workload identity
- [ ] Machine identity lifecycle (issuance → rotation → revocation)
- [ ] Non-human identity types covered (service accounts, API keys, certificates, tokens)
- [ ] ITDR (Identity Threat Detection and Response) capabilities
- [ ] OAuth 2.0 / OIDC patterns for machine-to-machine auth
- [ ] Secret management integration (Vault, cloud KMS)
- [ ] Privileged access management for service accounts
- [ ] Identity governance and orphan identity detection

---

## Domain 22: Web3 & Blockchain Security

**Test Prompt:**

```
ทำ smart contract security audit checklist สำหรับ DeFi protocol
```

**Pass Criteria:**

- [ ] OWASP Smart Contract Top 10 2026 risks referenced
- [ ] Reentrancy attack patterns and prevention (checks-effects-interactions)
- [ ] Flash loan attack scenarios and mitigations
- [ ] Access control patterns (OpenZeppelin Ownable/AccessControl)
- [ ] Formal verification and static analysis tools (Slither, Mythril, Certora)
- [ ] DeFi-specific risks (oracle manipulation, MEV, sandwich attacks)
- [ ] Gas optimization vs security tradeoffs
- [ ] Audit methodology and checklist (pre-deploy, post-deploy)

---

## Guided Fallback Test

**Test Prompt:**

```
ช่วยสร้างเอกสาร cybersecurity
```

**Pass Criteria:**

- [ ] Triggers guided domain selection fallback (not a specific domain)
- [ ] Asks clarifying questions: Task Type, Asset Type, Goal
- [ ] Presents domain categories or numbered options for user to choose
- [ ] Does NOT generate a full document without clarification
- [ ] Responds in Thai (matching input language)

---

## Meta: Framework Maintenance Validation

**Non-domain test** — validates the framework version maintenance tooling works correctly.

### Test 1: Framework Staleness Check

```bash
bash tests/check-framework-updates.sh --all
```

**Pass Criteria:**

- [ ] Script runs without errors
- [ ] Output shows color-coded status (CRITICAL/DUE/OK)
- [ ] All frameworks are listed with `--all` flag
- [ ] No CRITICAL frameworks (unless genuinely stale)

### Test 2: Plugin Validation Section 5

```bash
bash tests/validate-plugin.sh --skip-install-check 2>&1 | grep -A5 "Section 5"
```

**Pass Criteria:**

- [ ] Section 5 reports PASS for all framework pattern checks
- [ ] No FAIL or WARN for grep_pattern mismatches
- [ ] frameworks.json JSON validity confirmed

### Test 3: frameworks.json Integrity

```bash
# Verify entry count
jq '.frameworks | length' frameworks.json
# Expected: ~69

# Verify all entries have required fields
jq '[.frameworks[] | select(.name and .version and .grep_patterns and .used_in)] | length' frameworks.json
# Expected: ~69
```

**Pass Criteria:**

- [ ] frameworks.json has ~73 entries (54 base + 15 from D19-D22 + 4 gap-fill)
- [ ] All entries have name, version, grep_patterns, and used_in fields
- [ ] JSON is valid (no syntax errors)

---

## Quick Regression Test

For rapid regression after plugin updates, test these prompts (covers Thai, English, mixed, and new domains):

1. `สร้าง IR playbook สำหรับ phishing incident`
2. `Create a Semgrep rule to detect hardcoded secrets`
3. `สร้าง NIST 800-53 gap assessment พร้อม PCI DSS control mapping`
4. `สร้าง AI security assessment สำหรับ LLM application พร้อม prompt injection defense`
5. `สร้าง API security assessment ตาม OWASP API Top 10 พร้อม JWT validation checklist`
6. `สร้าง vulnerability prioritization matrix ด้วย CVSS+EPSS+KEV พร้อม SLA templates`
7. `สร้าง threat intelligence program ด้วย STIX/TAXII พร้อม MISP integration`
8. `ออกแบบ end-to-end security workflow แบบ cross-domain พร้อม SOAR orchestration template`
9. `สร้าง security governance framework พร้อม CISO/CAIO RACI matrix และ board KPI dashboard`
10. `สร้าง OT security assessment ตาม NIST 800-82 พร้อม Purdue Model segmentation และ PLC hardening checklist`
11. `สร้าง security checklist สำหรับ agentic AI system ที่ใช้ multi-agent orchestration`
12. `ทำ crypto-agility assessment สำหรับ post-quantum cryptography migration`
13. `สร้าง non-human identity management policy สำหรับ Kubernetes workloads`
14. `ทำ smart contract security audit checklist สำหรับ DeFi protocol`

Minimum pass: all prompts produce structured bilingual output with framework references.

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
