# Man-Day Cost Estimation: cybersecurity-pro Plugin

ประเมิน man-day cost สำหรับโปรเจค cybersecurity-pro plugin ทั้งหมด
อ้างอิงจาก project metrics ณ v3.5.0 (2026-02-22)

## Project Overview

| Metric                 | Value                     |
| ---------------------- | ------------------------- |
| **Total files**        | 33                        |
| **Total lines**        | 14,073                    |
| **Git commits**        | 19                        |
| **Net insertions**     | 15,408 (deletions: 1,318) |
| **Development period** | 4 days (Feb 19-22, 2026)  |
| **Domains**            | 17                        |
| **Frameworks tracked** | 50                        |

---

## Work Breakdown Structure

### Phase 1: Research & Architecture Design (12 man-days)

| Task                           | Man-Days | Rationale                                                                                                               |
| ------------------------------ | -------- | ----------------------------------------------------------------------------------------------------------------------- |
| Plugin system research         | 2        | Claude Code plugin architecture, marketplace mechanics, naming conventions, cache structure                             |
| Framework landscape survey     | 5        | Survey 50+ international frameworks (NIST, MITRE, OWASP, ISO, CIS, etc.) — determine versions, relevance, cross-mapping |
| Domain taxonomy design         | 2        | Define 17 domain boundaries, avoid overlap, determine routing logic                                                     |
| Bilingual output policy design | 1        | Thai+English hybrid format rules, term preservation policy, header conventions                                          |
| NIST CSF 2.0 mapping           | 2        | Map all 17 domains to 6 CSF functions, identify coverage gaps                                                           |

### Phase 2: Core Skill Engine (3 man-days)

| Task                    | Man-Days | Rationale                                                                     |
| ----------------------- | -------- | ----------------------------------------------------------------------------- |
| SKILL.md decision tree  | 1.5      | 366 lines — keyword triggers, framework table, 17-branch router, output rules |
| Plugin metadata         | 0.5      | plugin.json, marketplace.json, naming consistency                             |
| Architecture validation | 1        | Token budget analysis, on-demand loading verification, context < 5%           |

### Phase 3: Domain Reference Files (34 man-days)

**Senior cybersecurity engineer** rate — each file requires deep domain expertise, framework accuracy, template design, and bilingual writing.

| Domain                  | File                             | Lines      | Sections | Man-Days | Complexity                                                  |
| ----------------------- | -------------------------------- | ---------- | -------- | -------- | ----------------------------------------------------------- |
| D1 IR Playbooks         | ir-playbooks.md                  | 334        | 28       | 1.5      | NIST 800-61 lifecycle, MITRE mapping, SLA matrices          |
| D2 DFIR Reports         | dfir-reports.md                  | 309        | 19       | 1.5      | Chain of custody, evidence handling, forensic methodology   |
| D3 DevSecOps            | devsecops-pipeline.md            | 298        | 7        | 1.5      | GitHub Actions YAML, OWASP SAMM, CI/CD security gates       |
| D4 SOC+SOAR             | soc-operations.md                | 468        | 18       | 2.5      | L1-L3 workflows, SIEM rules (SPL/KQL), SOAR playbooks       |
| D5 GitOps               | gitops-security.md               | 447        | 8        | 2        | OPA/Rego, Gatekeeper, Falco rules, ArgoCD RBAC              |
| D6 Code Security        | code-security-analysis.md        | 510        | 8        | 2.5      | Semgrep rules, CodeQL, SARIF 2.1.0, taint analysis          |
| D7 Container/Supply     | container-supply-chain.md        | 492        | 9        | 2        | Dockerfile hardening, Trivy, SBOM, cosign, SLSA             |
| D8 Threat Modeling      | compliance-threat-modeling.md    | 300        | 7        | 1.5      | STRIDE/PASTA, risk matrices, SOC 2/ISO mapping              |
| D9 Compliance           | compliance-frameworks.md         | 734        | 14       | 3        | NIST 800-53 (20 families), PCI DSS, GDPR, HIPAA, CIS        |
| D10 Cloud Security      | cloud-security-cspm.md           | 806        | 13       | 3        | AWS/Azure/GCP, CIS Benchmarks, CSPM tools, IAM              |
| D11 Zero Trust          | zero-trust-architecture.md       | 665        | 10       | 2.5      | NIST 800-207, CISA maturity model, microsegmentation        |
| D12 AI/ML Security      | ai-ml-security.md                | 786        | 33       | 3        | OWASP LLM Top 10, MITRE ATLAS, NIST AI RMF, EU AI Act       |
| D13 API Security        | api-security.md                  | 783        | 10       | 2.5      | OWASP API Top 10, JWT, OAuth BCP, API gateway               |
| D14 Vuln Management     | vulnerability-management.md      | 575        | 11       | 2        | CVSS v4.0, EPSS, KEV, SSVC, patch workflows                 |
| D15 Threat Intel        | threat-intelligence.md           | 660        | 10       | 2.5      | STIX 2.1, TAXII 2.1, MISP, OpenCTI, TLP 2.0                 |
| D16 Cross-Domain        | cross-domain-integration.md      | 942        | 10       | 3.5      | 5 integration scenarios, SOAR templates, data flow diagrams |
| D17 Security Governance | security-governance-executive.md | 797        | 10       | 3        | NIST CSF GOVERN, ISO 27014, C2M2, SEC disclosure, RACI      |
| **Subtotal**            | **17 files**                     | **10,906** | **225**  | **34**   |                                                             |

> Note: ประเมินจาก senior cybersecurity engineer ที่มีประสบการณ์ frameworks เหล่านี้ — ต้อง research ข้อมูลให้ถูกต้อง, ออกแบบ template, เขียน bilingual content, ตรวจสอบ framework version/control IDs

### Phase 4: Testing & QA Infrastructure (5 man-days)

| Task                                   | Man-Days | Rationale                                                                        |
| -------------------------------------- | -------- | -------------------------------------------------------------------------------- |
| validate-plugin.sh (461 lines)         | 2        | 58 structural checks: JSON, naming, integrity, decision tree, framework patterns |
| smoke-test-prompts.md (459 lines)      | 1.5      | 17 domain test prompts + 8 pass criteria each + framework meta-tests             |
| check-framework-updates.sh (139 lines) | 0.5      | Staleness checker with color-coded output, threshold logic                       |
| CI workflows                           | 0.5      | validate.yml + framework-review.yml quarterly automation                         |
| QA iterations (3 rounds)               | 0.5      | Version string fixes, framework accuracy, cross-reference validation             |

### Phase 5: Documentation (6 man-days)

| Task                                    | Man-Days | Rationale                                                                    |
| --------------------------------------- | -------- | ---------------------------------------------------------------------------- |
| README.md (548 lines)                   | 2        | Professional redesign: badges, CSF map, demo, comparison, contributing guide |
| INSTALL.md (381 lines)                  | 1.5      | Standard + air-gapped installation, config reference, cache structure        |
| TROUBLESHOOTING.md (334 lines)          | 1        | 6 symptom-cause sections from real debugging experience                      |
| CHANGELOG.md (280 lines)                | 0.5      | Keep-a-changelog format, 12 version entries                                  |
| CLAUDE.md (100 lines)                   | 0.5      | Developer guidance, architecture, naming, contributing                       |
| FRAMEWORK-UPDATE-RUNBOOK.md (128 lines) | 0.5      | Maintenance procedure, post-update checklist                                 |

### Phase 6: Framework Tracking System (3 man-days)

| Task                                | Man-Days | Rationale                                                                  |
| ----------------------------------- | -------- | -------------------------------------------------------------------------- |
| frameworks.json design & population | 2        | 50 entries with versions, URLs, grep patterns, used_in, staleness metadata |
| Integration with validation         | 0.5      | Section 5 grep pattern matching, JSON validity, staleness warnings         |
| Quarterly review workflow           | 0.5      | GitHub Actions cron, issue template generation                             |

---

## Summary

| Phase                          | Man-Days        | % of Total |
| ------------------------------ | --------------- | ---------- |
| 1. Research & Architecture     | 12              | 19%        |
| 2. Core Skill Engine           | 3               | 5%         |
| 3. Domain Reference Files (17) | 34              | 54%        |
| 4. Testing & QA                | 5               | 8%         |
| 5. Documentation               | 6               | 10%        |
| 6. Framework Tracking          | 3               | 5%         |
| **Total**                      | **63 man-days** | **100%**   |

---

## Cost Scenarios

| Role                                      | Rate (THB/day) | Total Cost          |
| ----------------------------------------- | -------------- | ------------------- |
| Senior Cybersecurity Engineer (TH)        | 8,000-12,000   | 504,000-756,000     |
| Senior Security Consultant (TH)           | 15,000-25,000  | 945,000-1,575,000   |
| Freelance Security Expert (International) | 30,000-50,000  | 1,890,000-3,150,000 |

> **Estimate range: 500K - 1.5M THB** (typical Thai market rate)

---

## Key Assumptions

1. **"Man-day"** = 1 senior cybersecurity engineer working 8 hours/day
2. ต้องมี **domain expertise จริง** — ไม่ใช่แค่เขียน markdown ต้องรู้ NIST, MITRE, OWASP, ISO frameworks ในระดับที่ตรวจสอบ control IDs, version numbers, technique mappings ได้ถูกต้อง
3. **Bilingual writing** เพิ่มเวลา ~20% เทียบกับเขียนภาษาเดียว
4. **QA iterations** — framework version accuracy ต้องตรวจซ้ำหลายรอบ (เช่น PCI DSS v4.0 to v4.0.1, CIS v8 to v8.1)
5. ไม่รวม project management, stakeholder review, หรือ deployment support

---

## AI Acceleration Factor

| Metric                  | Manual                 | With AI (Claude Code) |
| ----------------------- | ---------------------- | --------------------- |
| **Calendar time**       | ~3 months (1 engineer) | 4 days (12 sessions)  |
| **Man-days equivalent** | 63                     | ~4                    |
| **Acceleration**        | 1x                     | **~15x**              |

Actual development time with AI assistance: ~4 days (12 sessions) — AI accelerated the work by approximately **15x** compared to manual effort.
