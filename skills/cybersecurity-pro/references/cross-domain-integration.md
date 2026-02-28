# Cross-Domain Integration Scenarios Reference

คู่มือการบูรณาการข้ามโดเมน (Cross-Domain Integration) — ออกแบบ workflow แบบ end-to-end ที่เชื่อมโยง
ทั้ง 17 domains เข้าด้วยกัน ครอบคลุม Incident Response lifecycle, Vulnerability-to-Exploit pipeline,
Supply Chain Security, Cloud Compliance Posture, AI/API Threat Surface และ Security Governance

> ไฟล์นี้เป็น **orchestration layer** — ไม่ทดแทน domain-specific references แต่เชื่อมโยงขั้นตอนข้ามโดเมน
> ให้เป็น workflow เดียวกัน เหมาะสำหรับผู้ที่ต้องการมองภาพรวมของ security operations ทั้งหมด

**Cross-references:** (ทุก domain)

- Domain 1: IR Playbooks → `references/ir-playbooks.md`
- Domain 2: DFIR Reports → `references/dfir-reports.md`
- Domain 3: DevSecOps Pipeline → `references/devsecops-pipeline.md`
- Domain 4: SOC Operations + SOAR → `references/soc-operations.md`
- Domain 5: GitOps Security → `references/gitops-security.md`
- Domain 6: Code Security Analysis → `references/code-security-analysis.md`
- Domain 7: Container & Supply Chain → `references/container-supply-chain.md`
- Domain 8: Threat Modeling & Risk → `references/compliance-threat-modeling.md`
- Domain 9: Compliance Frameworks → `references/compliance-frameworks.md`
- Domain 10: Cloud Security & CSPM → `references/cloud-security-cspm.md`
- Domain 11: Zero Trust Architecture → `references/zero-trust-architecture.md`
- Domain 12: AI/ML Security → `references/ai-ml-security.md`
- Domain 13: API Security → `references/api-security.md`
- Domain 14: Vulnerability Management → `references/vulnerability-management.md`
- Domain 15: Threat Intelligence → `references/threat-intelligence.md`
- Domain 17: Security Governance & Executive Leadership → `references/security-governance-executive.md`
- Domain 18: OT/ICS Security → `references/ot-ics-security.md`
- Domain 19: Agentic AI Security → `references/agentic-ai-security.md`
- Domain 20: Post-Quantum Cryptography → `references/post-quantum-cryptography.md`
- Domain 21: Identity & Access Security → `references/identity-access-security.md`
- Domain 22: Web3 & Blockchain Security → `references/web3-blockchain-security.md`

---

## Table of Contents

1. Cross-Domain Integration Overview
2. Scenario: Incident Response Lifecycle
3. Scenario: Vulnerability-to-Exploit Pipeline
4. Scenario: Supply Chain Security Pipeline
5. Scenario: Cloud Compliance Posture
6. Scenario: AI/API Threat Surface
7. Scenario: Post-Pentest Defensive Documentation (Shannon Integration)
8. Integration Orchestration Patterns
9. Cross-Domain Metrics & KPIs
10. Framework References & Integration Checklist

---

## 1. ภาพรวมการบูรณาการข้ามโดเมน (Cross-Domain Integration Overview)

### Domain Dependency Map

แผนผังแสดงความสัมพันธ์ระหว่าง 17 domains — ลูกศรแสดงทิศทางการไหลของข้อมูลหลัก:

```
                    ┌─────────────────────────────────────────────┐
                    │         NIST CSF 2.0 Orchestration          │
                    │   (Govern → Identify → Protect → Detect     │
                    │    → Respond → Recover)                     │
                    └──────────────────┬──────────────────────────┘
                                       │
              ┌────────────────────────┼─────────────────────────┐
              │                        │                         │
      ┌───────▼───────┐               │                         │
      │    GOVERN     │               │                         │
      │               │               │                         │
      │ D17:Governance│───────────────┼─────────────────────────┤
      │ D8:ThreatModel│               │                         │
      │ D9:Compliance │               │                         │
      └───────────────┘               │                         │
                                      │                         │
          ┌───────────────────────────┼─────────────────────────┤
          │                           │                         │
    ┌─────▼─────┐              ┌──────▼──────┐          ┌──────▼──────┐
    │ IDENTIFY  │              │   PROTECT   │          │   DETECT    │
    │           │              │             │          │             │
    │ D8:Threat │◄────────────►│ D3:DevSecOps│─────────►│ D4:SOC/SOAR │
    │   Model   │              │ D5:GitOps   │          │ D15:TI      │
    │ D9:Comply │              │ D6:CodeSec  │          │ D14:VulnMgmt│
    │           │              │ D7:Container│          │             │
    └─────┬─────┘              │ D10:Cloud   │          └──────┬──────┘
          │                    │ D11:ZeroTr  │                 │
          │                    │ D12:AI/ML   │                 │
          │                    │ D13:API     │                 │
          │                    └─────────────┘                 │
          │                                                    │
          │              ┌──────────────┐                      │
          └─────────────►│   RESPOND    │◄─────────────────────┘
                         │              │
                         │ D1:IR        │
                         │ D2:DFIR      │
                         └──────────────┘
```

### Integration Maturity Model

| Level       | คำอธิบาย                                            | ลักษณะ                                        |
| ----------- | --------------------------------------------------- | --------------------------------------------- |
| **Level 0** | Siloed — แต่ละทีมทำงานแยกกัน                        | ไม่มี data sharing, manual handoffs           |
| **Level 1** | Reactive — แชร์ข้อมูลเมื่อเกิดเหตุ                  | Ad-hoc email/ticket, ไม่มี automation         |
| **Level 2** | Connected — มี integration points เฉพาะจุด          | Shared SIEM, basic SOAR playbooks             |
| **Level 3** | Orchestrated — automated workflows ข้ามทีม          | SOAR-driven, standardized data formats        |
| **Level 4** | Unified — single pane of glass, continuous feedback | Full STIX/SARIF/CycloneDX pipeline, ML-driven |

### เมื่อไหร่ควรใช้ไฟล์นี้ (When to Use This File)

ใช้ไฟล์นี้เมื่อ:

- ต้องการออกแบบ **end-to-end security workflow** ที่ข้ามหลาย domain
- ต้องการ **SOAR playbook** ที่ orchestrate หลายทีม/เครื่องมือ
- ต้องการ **data flow diagram** ระหว่าง security tools
- ต้องการ **KPIs/metrics** ที่วัดผลข้าม domain (เช่น MTTD ที่รวม TI enrichment time)
- ต้องการ **integration checklist** สำหรับ security program maturity assessment

สำหรับรายละเอียดเฉพาะ domain → อ่าน reference file ของ domain นั้นโดยตรง

---

## 2. Scenario: Incident Response Lifecycle (การตอบสนองต่อเหตุการณ์แบบ End-to-End)

### Participating Domains

| Domain                    | บทบาทใน Scenario                             |
| ------------------------- | -------------------------------------------- |
| D15: Threat Intelligence  | Early warning, IOC feeds, context enrichment |
| D4: SOC Operations + SOAR | Alert triage, SIEM correlation, automation   |
| D1: IR Playbooks          | Structured response procedures               |
| D2: DFIR Reports          | Deep investigation, evidence handling        |
| D14: Vulnerability Mgmt   | Root cause identification, patch urgency     |

### Data Flow Diagram

```
  D15:TI                D4:SOC               D1:IR               D2:DFIR           D14:Vuln
  ┌──────┐             ┌──────┐             ┌──────┐            ┌──────┐          ┌──────┐
  │Threat│──IOC feed──►│SIEM  │──alert────►│Triage│──escalate─►│Invest│─root───►│Patch │
  │Feeds │             │Corr. │             │& IR  │            │iga-  │ cause   │Prior.│
  │      │◄─context───│      │◄─evidence──│Play- │◄─findings─│tion  │         │      │
  │      │  request    │      │  artifacts  │book  │            │      │         │      │
  └──────┘             └──────┘             └──────┘            └──────┘          └──────┘
     │                    │                    │                    │                 │
     └────────────────────┴────────────────────┴────────────────────┴─────────────────┘
                                    ▼
                        Post-Incident Feedback Loop
                    (IOC update, detection rule tuning,
                     playbook improvement, patch SLA review)
```

### Data Exchange Table

| From → To | ข้อมูลที่ส่ง                    | Format / Protocol            | SLA                  |
| --------- | ------------------------------- | ---------------------------- | -------------------- |
| D15 → D4  | IOC indicators, threat context  | STIX 2.1 via TAXII 2.1       | Near real-time       |
| D4 → D1   | Alert + enriched context        | SIEM alert (JSON/CEF)        | ≤ 15 min (Critical)  |
| D1 → D2   | Incident ticket + initial IOCs  | Ticketing system (JIRA/SOAR) | ≤ 1 hr after triage  |
| D2 → D14  | Exploited CVE, root cause       | CVE ID + CVSS context        | Within investigation |
| D2 → D15  | New IOCs from investigation     | STIX 2.1 objects             | Within 24 hr         |
| D14 → D4  | Patch status, compensating ctrl | Vulnerability report         | Per SLA tier         |

### SOAR Orchestration Template

```yaml
# SOAR Playbook: Incident Response Lifecycle (Cross-Domain)
name: ir_lifecycle_orchestration
trigger:
  - siem_alert_critical
  - siem_alert_high

phases:
  # Phase 1: TI Enrichment (D15 → D4)
  - name: threat_intelligence_enrichment
    domain: D15_TI
    actions:
      - lookup_ioc:
          sources: [misp, opencti, virustotal, abuseipdb]
          input: "{{alert.observables}}"
          output: enriched_context
      - check_tlp:
          indicator: "{{alert.observables}}"
          output: tlp_classification
      - mitre_attack_mapping:
          input: "{{enriched_context.techniques}}"
          output: attack_chain
    timeout: 5m
    sla: "IOC enrichment ภายใน 5 นาที"

  # Phase 2: SOC Triage (D4)
  - name: soc_triage
    domain: D4_SOC
    actions:
      - correlate_siem:
          query: "related events within 24h for {{alert.src_ip}}"
          output: correlated_events
      - determine_severity:
          input: [enriched_context, correlated_events]
          output: severity_assessment
      - assign_analyst:
          level: "{{severity_assessment.required_level}}"
    timeout: 15m
    sla: "Triage ภายใน 15 นาที (Critical), 1 ชั่วโมง (High)"

  # Phase 3: IR Execution (D1)
  - name: incident_response
    domain: D1_IR
    actions:
      - select_playbook:
          incident_type: "{{severity_assessment.classification}}"
          output: active_playbook
      - execute_containment:
          playbook: "{{active_playbook}}"
          actions: [isolate_host, block_ip, disable_account]
      - notify_stakeholders:
          template: "{{active_playbook.comms_template}}"
          channels: [slack_security, email_management]
    sla: "Containment ภายใน 4 ชั่วโมง (Critical)"

  # Phase 4: DFIR Investigation (D2)
  - name: forensic_investigation
    domain: D2_DFIR
    actions:
      - collect_evidence:
          targets: "{{incident.affected_hosts}}"
          types: [memory_dump, disk_image, network_pcap]
          chain_of_custody: true
      - analyze_artifacts:
          tools: [volatility, autopsy, wireshark]
          output: forensic_findings
      - extract_new_iocs:
          input: "{{forensic_findings}}"
          output: new_iocs
    sla: "Initial findings ภายใน 24 ชั่วโมง"

  # Phase 5: Vulnerability Remediation (D14)
  - name: vulnerability_remediation
    domain: D14_VULN
    actions:
      - identify_exploited_cve:
          input: "{{forensic_findings.root_cause}}"
          output: exploited_vulnerabilities
      - prioritize_patching:
          method: ssvc
          input: "{{exploited_vulnerabilities}}"
          kev_check: true
      - track_remediation:
          sla_tier: "{{exploited_vulnerabilities.severity}}"

  # Phase 6: Feedback Loop (D2 → D15, D1)
  - name: post_incident_feedback
    domain: cross_domain
    actions:
      - update_ti_platform:
          new_iocs: "{{new_iocs}}"
          platform: [misp, opencti]
          tlp: "TLP:AMBER"
      - update_detection_rules:
          sigma_rules: "{{forensic_findings.detection_signatures}}"
          deploy_to: [splunk, elastic]
      - update_playbook:
          lessons_learned: "{{incident.post_mortem}}"
          playbook: "{{active_playbook.id}}"
```

### MITRE ATT&CK Flow Across Boundaries

| Phase                   | ATT&CK Tactics                        | Example Techniques                   |
| ----------------------- | ------------------------------------- | ------------------------------------ |
| TI Detection (D15→D4)   | Reconnaissance, Resource Development  | T1595 Active Scanning, T1583 Domains |
| SOC Correlation (D4)    | Initial Access, Execution             | T1566 Phishing, T1059 Command Shell  |
| IR Containment (D1)     | Lateral Movement, Persistence         | T1021 Remote Services, T1053 Tasks   |
| DFIR Investigation (D2) | Collection, Exfiltration              | T1005 Local Data, T1041 C2 Channel   |
| Vuln Remediation (D14)  | Privilege Escalation, Defense Evasion | T1068 Exploitation, T1562 Disable    |

### Handoff Checklist

- [ ] **D15 → D4**: IOC package ส่งถึง SIEM พร้อม confidence score ≥ 70%
- [ ] **D4 → D1**: Alert enriched ด้วย correlated events, severity confirmed, analyst assigned
- [ ] **D1 → D2**: Incident ticket สร้างพร้อม scope, affected assets, initial containment status
- [ ] **D2 → D14**: Root cause CVE identified, CVSS+EPSS context attached
- [ ] **D2 → D15**: New IOCs extracted, STIX 2.1 formatted, TLP assigned
- [ ] **Post-incident**: Playbook updated, detection rules deployed, patch SLA reviewed

---

## 3. Scenario: Vulnerability-to-Exploit Pipeline (จาก Vulnerability สู่ Exploit Detection)

### Participating Domains

| Domain                    | บทบาทใน Scenario                       |
| ------------------------- | -------------------------------------- |
| D14: Vulnerability Mgmt   | Discovery, scanning, prioritization    |
| D15: Threat Intelligence  | Exploit context, KEV correlation, IOC  |
| D4: SOC Operations + SOAR | Detection rule deployment, monitoring  |
| D1: IR Playbooks          | Response when exploit detected in-wild |

### Data Flow Diagram

```
  D14:Vuln              D15:TI               D4:SOC              D1:IR
  ┌──────┐             ┌──────┐             ┌──────┐            ┌──────┐
  │Scan &│──CVE list──►│Enrich│──IOC+sig──►│Deploy│──alert───►│Respo-│
  │Prior.│             │ment  │             │Rules │            │nd    │
  │      │◄─exploit───│      │◄─detect───│      │◄─contain─│      │
  │      │  intel      │      │  feedback   │      │  status   │      │
  └──────┘             └──────┘             └──────┘            └──────┘
     │                    │                    │                    │
     ▼                    ▼                    ▼                    ▼
  CVSS+EPSS+KEV      STIX indicators     Sigma/YARA rules    Containment
  prioritization     w/ confidence        deployed to SIEM    playbook exec
```

### Data Exchange Table

| From → To | ข้อมูลที่ส่ง                    | Format / Protocol          | SLA                  |
| --------- | ------------------------------- | -------------------------- | -------------------- |
| D14 → D15 | Critical/High CVEs from scan    | CVE IDs + CVSS v4.0 vector | Within scan cycle    |
| D15 → D14 | Exploit availability, EPSS, KEV | STIX 2.1 vulnerability obj | ≤ 4 hr enrichment    |
| D15 → D4  | Detection signatures for CVEs   | Sigma rules, YARA rules    | ≤ 24 hr from publish |
| D4 → D1   | Alert: exploit attempt detected | SIEM alert (JSON/CEF)      | ≤ 15 min (Critical)  |
| D1 → D14  | Remediation urgency override    | Ticket update              | During IR            |

### SOAR Orchestration Template

```yaml
# SOAR Playbook: Vulnerability-to-Exploit Pipeline
name: vuln_to_exploit_pipeline
trigger:
  - new_critical_cve_published
  - kev_catalog_update
  - epss_score_spike

phases:
  # Phase 1: CVE Enrichment (D14 → D15)
  - name: cve_enrichment
    actions:
      - query_kev:
          cve_id: "{{trigger.cve_id}}"
          output: kev_status
      - query_epss:
          cve_id: "{{trigger.cve_id}}"
          output: epss_score
      - query_ti_platforms:
          sources: [misp, opencti, nvd]
          cve_id: "{{trigger.cve_id}}"
          output: exploit_context
      - ssvc_decision:
          input: [kev_status, epss_score, exploit_context]
          output: ssvc_priority

  # Phase 2: Detection Rule Generation (D15 → D4)
  - name: generate_detection
    condition: "ssvc_priority in ['Immediate', 'Out-of-Cycle']"
    actions:
      - generate_sigma_rule:
          cve: "{{trigger.cve_id}}"
          exploit_pattern: "{{exploit_context.iocs}}"
          output: sigma_rule
      - generate_yara_rule:
          exploit_samples: "{{exploit_context.samples}}"
          output: yara_rule
      - deploy_to_siem:
          rules: [sigma_rule, yara_rule]
          targets: [splunk, elastic, sentinel]

  # Phase 3: Active Monitoring (D4)
  - name: active_monitoring
    actions:
      - create_watchlist:
          indicators: "{{exploit_context.iocs}}"
          duration: 30d
      - configure_alert:
          severity: critical
          sla: 15m
          escalation: soc_l2

  # Phase 4: Exploit Detected Response (D4 → D1)
  - name: exploit_response
    trigger: siem_alert_match
    actions:
      - activate_ir_playbook:
          type: vulnerability_exploitation
          cve: "{{trigger.cve_id}}"
      - emergency_patch:
          priority: immediate
          notify: [ciso, it_ops, affected_team]
```

### MITRE ATT&CK Flow Across Boundaries

| Phase                 | ATT&CK Tactics            | Example Techniques                    |
| --------------------- | ------------------------- | ------------------------------------- |
| Vuln Discovery (D14)  | —                         | Scanning output (no ATT&CK mapping)   |
| TI Enrichment (D15)   | Resource Development      | T1587.004 Develop Exploits            |
| Detection Deploy (D4) | Initial Access, Execution | T1190 Exploit Public-Facing App       |
| IR Response (D1)      | Lateral Movement          | T1210 Exploitation of Remote Services |

### Automated Penetration Testing with Shannon

> สำหรับ automated vulnerability discovery และ exploitation testing ใช้ `shannon-pentest` plugin (`shannon-pentest@pitimon-shannon`)
> Shannon เป็น autonomous multi-agent pentester ที่รัน Docker-based scanning workflow ครอบคลุม OWASP Top 10
> ผลลัพธ์จาก Shannon สามารถ feed เข้า Vulnerability-to-Exploit Pipeline ได้โดยตรง:
>
> - Shannon findings → D14 (vulnerability prioritization ด้วย CVSS+EPSS+KEV)
> - Shannon auth/authz vulnerabilities → D13 (API Security analysis)
> - Shannon OWASP mapping → D8 (Threat Modeling risk assessment)

### Handoff Checklist

- [ ] **D14 → D15**: Critical CVEs ส่งพร้อม CVSS v4.0 vector, affected asset count
- [ ] **D15 → D14**: EPSS score + KEV status + exploit availability confirmed
- [ ] **D15 → D4**: Sigma/YARA rules generated, tested, deployed to SIEM
- [ ] **D4 → D1**: Alert fired with full context (CVE, affected hosts, exploit method)
- [ ] **Feedback**: Detection rule effectiveness reviewed, false positive rate < 5%

---

## 4. Scenario: Supply Chain Security Pipeline (ความปลอดภัย Supply Chain แบบ End-to-End)

### Participating Domains

| Domain                       | บทบาทใน Scenario                       |
| ---------------------------- | -------------------------------------- |
| D6: Code Security Analysis   | Source code scanning, variant analysis |
| D7: Container & Supply Chain | SBOM, image scanning, signing          |
| D3: DevSecOps Pipeline       | CI/CD integration, security gates      |
| D5: GitOps Security          | Policy-as-code, deployment gates       |
| D4: SOC Operations + SOAR    | Runtime monitoring, anomaly detection  |

### Data Flow Diagram

```
  D6:Code              D7:Container          D3:DevSecOps        D5:GitOps          D4:SOC
  ┌──────┐            ┌──────┐             ┌──────┐            ┌──────┐          ┌──────┐
  │SAST/ │──findings─►│SBOM &│──manifest──►│Gate  │──deploy──►│Policy│──events─►│Runt- │
  │SCA   │            │Scan  │             │Check │            │Check │          │ime   │
  │      │◄─variant──│      │◄─vuln fix──│      │◄─drift───│      │◄─alert──│Monit │
  │      │  patterns  │      │  rebuild    │      │  detect   │      │  rules   │      │
  └──────┘            └──────┘             └──────┘            └──────┘          └──────┘
     │                   │                    │                    │                │
     ▼                   ▼                    ▼                    ▼                ▼
  SARIF report      CycloneDX SBOM      Pipeline YAML       OPA/Rego policy   Falco alerts
  Semgrep/CodeQL    Trivy/Grype scan    Quality gates       ArgoCD sync       Runtime detect
```

### Data Exchange Table

| From → To | ข้อมูลที่ส่ง                     | Format / Protocol            | SLA                 |
| --------- | -------------------------------- | ---------------------------- | ------------------- |
| D6 → D3   | Code scan results                | SARIF 2.1.0                  | Per CI pipeline run |
| D6 → D7   | Dependency vulnerability list    | CycloneDX / SPDX             | Per CI pipeline run |
| D7 → D3   | Image scan + SBOM                | CycloneDX SBOM, JSON         | Pre-deploy gate     |
| D3 → D5   | Approved deployment manifest     | Kubernetes YAML + cosign sig | After gate pass     |
| D5 → D4   | Deployment events, policy status | Kubernetes events, OPA logs  | Continuous          |
| D4 → D3   | Runtime alert → rollback trigger | SOAR action / webhook        | ≤ 5 min (Critical)  |

### SOAR Orchestration Template

```yaml
# SOAR Playbook: Supply Chain Security Pipeline
name: supply_chain_security_pipeline
trigger:
  - code_commit_push
  - dependency_update
  - base_image_update

phases:
  # Phase 1: Code Security (D6)
  - name: code_scanning
    domain: D6_CODE
    actions:
      - run_sast:
          tools: [semgrep, codeql]
          output: sarif_results
      - run_sca:
          tools: [snyk, trivy_fs]
          output: dependency_findings
      - variant_analysis:
          based_on: "{{sarif_results.critical_findings}}"
          output: variant_matches
    gate: "critical_findings == 0 AND high_findings <= 3"

  # Phase 2: Container & SBOM (D7)
  - name: container_security
    domain: D7_CONTAINER
    actions:
      - build_image:
          dockerfile: hardened
          base: distroless
      - scan_image:
          tools: [trivy, grype]
          output: image_vulnerabilities
      - generate_sbom:
          format: cyclonedx
          tool: syft
          output: sbom
      - sign_image:
          tool: cosign
          keyless: true
    gate: "critical_cves == 0 AND sbom.generated == true AND image.signed == true"

  # Phase 3: Pipeline Gate (D3)
  - name: devsecops_gate
    domain: D3_DEVSECOPS
    actions:
      - aggregate_results:
          inputs: [sarif_results, image_vulnerabilities, sbom]
          output: security_summary
      - quality_gate:
          policy: "zero-critical, max-5-high, sbom-present, image-signed"
          output: gate_decision
      - generate_attestation:
          slsa_level: 3
          provenance: true

  # Phase 4: GitOps Deploy (D5)
  - name: gitops_deployment
    domain: D5_GITOPS
    condition: "gate_decision == 'PASS'"
    actions:
      - opa_policy_check:
          manifest: "{{deployment.yaml}}"
          policies: [no_privileged, resource_limits, network_policy]
      - argocd_sync:
          app: "{{target_app}}"
          strategy: canary
      - drift_detection:
          enabled: true
          alert_on_drift: true

  # Phase 5: Runtime Monitoring (D4)
  - name: runtime_monitoring
    domain: D4_SOC
    actions:
      - falco_rules:
          monitor: [unexpected_process, file_access, network_egress]
      - sbom_drift_check:
          compare: "{{sbom}}"
          runtime_packages: "{{container.installed_packages}}"
      - auto_rollback:
          trigger: critical_runtime_alert
          action: argocd_rollback
```

### MITRE ATT&CK Flow Across Boundaries

| Phase                | ATT&CK Tactics                  | Example Techniques                        |
| -------------------- | ------------------------------- | ----------------------------------------- |
| Code Scanning (D6)   | —                               | Prevention: detect T1195.002 Supply Chain |
| Container Build (D7) | Initial Access                  | Prevent T1195.002, T1525 Implant Image    |
| Pipeline Gate (D3)   | Defense Evasion                 | Block T1036 Masquerading                  |
| GitOps Deploy (D5)   | Persistence                     | Detect T1053.007 Container Orchestration  |
| Runtime Monitor (D4) | Execution, Privilege Escalation | T1610 Deploy Container, T1611 Escape      |

### Handoff Checklist

- [ ] **D6 → D7**: SARIF results passed, no critical code findings blocking build
- [ ] **D7 → D3**: SBOM generated (CycloneDX), image signed (cosign), scan complete
- [ ] **D3 → D5**: Quality gate passed, SLSA attestation generated
- [ ] **D5 → D4**: Deployment event logged, Falco rules active, drift detection enabled
- [ ] **Feedback**: Runtime findings feed back to D6 for variant analysis patterns

---

## 5. Scenario: Cloud Compliance Posture (ท่าทีความปลอดภัยบนคลาวด์และ Compliance)

### Participating Domains

| Domain                       | บทบาทใน Scenario                            |
| ---------------------------- | ------------------------------------------- |
| D9: Compliance Frameworks    | Control requirements, gap analysis          |
| D10: Cloud Security & CSPM   | Cloud-specific implementation, scanning     |
| D11: Zero Trust Architecture | Access control model, microsegmentation     |
| D14: Vulnerability Mgmt      | Verification scanning, remediation tracking |

### Data Flow Diagram

```
  D9:Comply            D10:Cloud            D11:ZeroTr           D14:Vuln
  ┌──────┐            ┌──────┐             ┌──────┐            ┌──────┐
  │Frame-│──controls─►│Cloud │──implement─►│Access│──verify──►│Scan &│
  │work  │            │Implem│             │Model │            │Track │
  │Reqs  │◄─evidence─│ent   │◄─policy────│      │◄─findings─│      │
  │      │  artifacts │      │  templates  │      │  status    │      │
  └──────┘            └──────┘             └──────┘            └──────┘
     │                   │                    │                    │
     ▼                   ▼                    ▼                    ▼
  NIST 800-53       CIS Benchmarks      NIST 800-207          CVSS+EPSS
  PCI DSS v4.0.1  CSA CCM v4.1        CISA ZT Maturity      patch SLA
  gap assessment   Prowler/ScoutSuite  microsegmentation     verification
```

### Data Exchange Table

| From → To | ข้อมูลที่ส่ง                       | Format / Protocol           | SLA                |
| --------- | ---------------------------------- | --------------------------- | ------------------ |
| D9 → D10  | Required controls per framework    | Control mapping spreadsheet | Per audit cycle    |
| D10 → D11 | Cloud IAM gaps, network findings   | CSPM report (JSON/CSV)      | After CSPM scan    |
| D11 → D10 | ZTA policy templates, access rules | Policy-as-code (Rego/JSON)  | Per implementation |
| D10 → D14 | Cloud misconfigurations as vulns   | CVE/CCE IDs + context       | After CSPM scan    |
| D14 → D9  | Remediation evidence, scan proof   | Vulnerability report        | Per audit evidence |

### SOAR Orchestration Template

```yaml
# SOAR Playbook: Cloud Compliance Posture
name: cloud_compliance_posture
trigger:
  - quarterly_compliance_cycle
  - new_cloud_deployment
  - framework_update

phases:
  # Phase 1: Requirements Mapping (D9)
  - name: compliance_requirements
    domain: D9_COMPLIANCE
    actions:
      - identify_frameworks:
          applicable: [nist_800_53, pci_dss_v4, cis_controls_v8]
          output: control_requirements
      - gap_analysis:
          current_state: "{{previous_assessment}}"
          required_state: "{{control_requirements}}"
          output: gaps

  # Phase 2: Cloud Implementation (D10)
  - name: cloud_security_scan
    domain: D10_CLOUD
    actions:
      - run_cspm:
          tools: [prowler, scoutsuite, cloud_custodian]
          scope: "{{cloud_accounts}}"
          benchmarks: [cis_aws, cis_azure, cis_gcp]
          output: cspm_findings
      - map_to_controls:
          findings: "{{cspm_findings}}"
          framework: "{{control_requirements}}"
          output: control_status

  # Phase 3: Zero Trust Enforcement (D11)
  - name: zero_trust_assessment
    domain: D11_ZEROTRUST
    actions:
      - assess_maturity:
          model: cisa_zt_maturity
          pillars: [identity, device, network, application, data]
          output: zt_maturity
      - deploy_policies:
          conditional_access: true
          microsegmentation: true
          output: zt_policies

  # Phase 4: Verification (D14)
  - name: verification_scanning
    domain: D14_VULN
    actions:
      - scan_remediated:
          scope: "{{gaps.remediated_items}}"
          tools: [nessus, qualys]
          output: verification_results
      - generate_evidence:
          for_frameworks: "{{control_requirements}}"
          proof: [scan_reports, policy_configs, access_logs]
          output: compliance_evidence
```

### Handoff Checklist

- [ ] **D9 → D10**: Control requirements mapped to cloud-specific CIS benchmarks
- [ ] **D10 → D11**: Cloud IAM gaps identified, ZTA policy templates requested
- [ ] **D11 → D14**: ZTA policies deployed, verification scan scope defined
- [ ] **D14 → D9**: Remediation evidence collected, gap status updated
- [ ] **Cycle**: Quarterly reassessment scheduled, continuous CSPM monitoring active

---

## 6. Scenario: AI/API Threat Surface (พื้นผิวภัยคุกคาม AI/API)

### Participating Domains

| Domain                     | บทบาทใน Scenario                         |
| -------------------------- | ---------------------------------------- |
| D13: API Security          | API inventory, authentication, gateway   |
| D12: AI/ML Security        | LLM guardrails, prompt injection defense |
| D8: Threat Modeling & Risk | STRIDE/PASTA for AI+API attack surfaces  |
| D6: Code Security Analysis | Static analysis of AI/API code           |

### Data Flow Diagram

```
  D13:API              D12:AI/ML            D8:ThreatModel       D6:Code
  ┌──────┐            ┌──────┐             ┌──────┐            ┌──────┐
  │API   │──surface──►│AI    │──threats──►│Risk  │──reqs────►│Code  │
  │Inven-│            │Threat│             │Assess│            │Scan  │
  │tory  │◄─guardrail│      │◄─priority──│      │◄─findings─│      │
  │      │  config    │      │  matrix     │      │  validate  │      │
  └──────┘            └──────┘             └──────┘            └──────┘
     │                   │                    │                    │
     ▼                   ▼                    ▼                    ▼
  OWASP API Top 10  OWASP LLM Top 10    STRIDE + PASTA      CWE Top 25
  API gateway cfg   MITRE ATLAS          Risk register       SARIF output
  OAuth 2.0 BCP     AI guardrail cfg     PDPA compliance     Semgrep rules
```

### Data Exchange Table

| From → To | ข้อมูลที่ส่ง                          | Format / Protocol        | SLA                 |
| --------- | ------------------------------------- | ------------------------ | ------------------- |
| D13 → D12 | API endpoints exposing AI models      | OpenAPI spec + inventory | Per discovery cycle |
| D12 → D8  | AI-specific threats, attack vectors   | Threat list (ATLAS IDs)  | Per assessment      |
| D8 → D6   | Security requirements from risk model | Requirements doc         | Per sprint          |
| D6 → D13  | API code vulnerabilities (BOLA, etc)  | SARIF 2.1.0              | Per CI pipeline run |
| D6 → D12  | AI code vulnerabilities (injection)   | SARIF 2.1.0              | Per CI pipeline run |

### SOAR Orchestration Template

```yaml
# SOAR Playbook: AI/API Threat Surface
name: ai_api_threat_surface
trigger:
  - new_api_endpoint_deployed
  - llm_model_update
  - quarterly_threat_review

phases:
  # Phase 1: API Surface Discovery (D13)
  - name: api_discovery
    domain: D13_API
    actions:
      - discover_apis:
          methods: [openapi_scan, traffic_analysis, code_scan]
          output: api_inventory
      - classify_apis:
          categories: [public, partner, internal, ai_serving]
          output: api_classification
      - check_owasp_api:
          inventory: "{{api_inventory}}"
          top10: owasp_api_2023
          output: api_risks

  # Phase 2: AI Security Assessment (D12)
  - name: ai_security
    domain: D12_AIML
    actions:
      - assess_llm_risks:
          model_endpoints: "{{api_classification.ai_serving}}"
          framework: owasp_llm_top10
          output: ai_risks
      - test_prompt_injection:
          targets: "{{api_classification.ai_serving}}"
          methods: [direct, indirect, jailbreak]
          output: injection_results
      - map_atlas:
          risks: "{{ai_risks}}"
          output: atlas_mapping

  # Phase 3: Threat Modeling (D8)
  - name: threat_modeling
    domain: D8_THREATMODEL
    actions:
      - stride_analysis:
          scope: [api_inventory, ai_risks]
          output: stride_threats
      - risk_assessment:
          threats: "{{stride_threats}}"
          method: pasta
          output: risk_matrix
      - derive_requirements:
          risks: "{{risk_matrix.high_critical}}"
          output: security_requirements

  # Phase 4: Code Security (D6)
  - name: code_scanning
    domain: D6_CODE
    actions:
      - scan_api_code:
          rules: [owasp_api, bola_detection, injection]
          tools: [semgrep, codeql]
          output: code_findings
      - scan_ai_code:
          rules: [prompt_injection, unsafe_deserialization, model_loading]
          tools: [semgrep]
          output: ai_code_findings
      - prioritize_fixes:
          input: [code_findings, ai_code_findings, security_requirements]
          output: fix_priorities
```

### MITRE ATT&CK + ATLAS Flow

| Phase                | Framework    | Techniques                                    |
| -------------------- | ------------ | --------------------------------------------- |
| API Discovery (D13)  | ATT&CK       | T1595.002 Vulnerability Scanning              |
| AI Assessment (D12)  | MITRE ATLAS  | AML.T0051 Prompt Injection, AML.T0054 Evasion |
| Threat Modeling (D8) | STRIDE/PASTA | Application-level threat enumeration          |
| Code Scanning (D6)   | CWE          | CWE-89 SQLi, CWE-79 XSS, CWE-918 SSRF         |

### Handoff Checklist

- [ ] **D13 → D12**: API inventory complete, AI-serving endpoints identified
- [ ] **D12 → D8**: AI-specific threats documented with ATLAS IDs
- [ ] **D8 → D6**: Security requirements derived, risk-priority scanning rules created
- [ ] **D6 → D13/D12**: Code findings mapped to OWASP API + LLM risks
- [ ] **Cycle**: API inventory refreshed per deployment, AI guardrails updated per model change

---

## 7. Scenario: Post-Pentest Defensive Documentation (Shannon Integration)

### Participating Domains

| Domain                     | บทบาทใน Scenario                                  |
| -------------------------- | ------------------------------------------------- |
| D14: Vulnerability Mgmt    | Vulnerability prioritization matrix, patch SLAs   |
| D1: Incident Response      | IR playbook for critical/validated findings       |
| D6: Code Security Analysis | Remediation roadmap, code-level fix guidance      |
| D9: Compliance Frameworks  | Compliance gap assessment, control mapping        |
| D13: API Security          | API security assessment (for auth/authz findings) |
| D17: Security Governance   | Executive summary, board-ready reporting          |

### Data Flow Diagram

```
  Shannon                D14:Vuln              D1:IR                D17:Exec
  ┌──────┐              ┌──────┐             ┌──────┐            ┌──────┐
  │Pentest│──manifest──►│Priori│──critical──►│Play- │──summary─►│Exec  │
  │Findings│            │tize  │             │book  │            │Report│
  │(Phase5)│            │Matrix│             │      │            │      │
  └──────┘              └──────┘             └──────┘            └──────┘
     │                     │                                        ▲
     │                     ▼                                        │
     │                  ┌──────┐             ┌──────┐              │
     ├──auth findings─►│D13   │             │D9    │──evidence──┘
     │                  │API   │             │Comply│
     │                  │Assess│             │      │
     │                  └──────┘             └──────┘
     │                                          ▲
     └──all findings──►┌──────┐                │
                        │D6    │──roadmap───────┘
                        │Remed │
                        │iation│
                        └──────┘
```

### Data Exchange Table

| From → To     | ข้อมูลที่ส่ง                          | Format / Protocol          | SLA               |
| ------------- | ------------------------------------- | -------------------------- | ----------------- |
| Shannon → D14 | All findings + severity + OWASP cats  | handoff-manifest.json      | Post-pentest      |
| Shannon → D1  | Critical/validated PoC findings       | Shannon deliverables (.md) | Post-pentest      |
| D14 → D6      | Prioritized vulns needing remediation | Vuln priority matrix       | Per assessment    |
| D6 → D9       | Remediation roadmap with timelines    | Remediation roadmap (.md)  | Per assessment    |
| D9 → D17      | Compliance gaps + control mapping     | Gap assessment (.md)       | Per assessment    |
| Shannon → D13 | Auth/AuthZ exploitation evidence      | Shannon deliverables (.md) | Per assessment    |
| All → D17     | All domain outputs                    | Individual reports (.md)   | Final aggregation |

### Trigger Mechanism

1. Shannon Phase 5 เขียน `handoff-manifest.json` ลง `audit-logs/<session>/handoff/`
2. User พิมพ์ `/cybersecurity-pro` พร้อม keyword "Shannon handoff" หรือ "defensive docs"
3. Cybersecurity-pro ตรวจพบ manifest → เข้า Post-Pentest Mode
4. อ่าน `requested_documents` จาก manifest → สร้างเอกสารตาม domain mapping

### Handoff Checklist

- [ ] **Shannon → manifest**: handoff-manifest.json valid, findings count ตรง, paths ถูกต้อง
- [ ] **manifest → D14**: Vuln matrix สร้างเรียบร้อย, severity mapping ครบ
- [ ] **D14 → D1**: IR playbook สร้างสำหรับ critical findings (ถ้ามี)
- [ ] **D14+D6 → remediation**: Roadmap มี timeline + responsible party
- [ ] **D9**: Compliance gaps mapped to OWASP categories from findings
- [ ] **D13**: API security assessment covers auth/authz findings (ถ้ามี)
- [ ] **D17**: Executive summary aggregates all domain outputs
- [ ] **Output**: ทุกไฟล์อยู่ใน `output_dir` ตาม manifest

---

## 8. รูปแบบการ Orchestrate ข้ามโดเมน (Integration Orchestration Patterns)

### SOAR Backbone Architecture

SOAR platform ทำหน้าที่เป็น central orchestrator เชื่อมทุก domain:

```
┌──────────────────────────────────────────────────┐
│                 SOAR Platform                     │
│  (Cortex XSOAR / Splunk SOAR / Shuffle / n8n)   │
├──────────────────────────────────────────────────┤
│  Playbook Engine  │  Case Management  │  Metrics │
├───────────────────┼───────────────────┼──────────┤
│                   │                   │          │
│  ┌─TI─┐ ┌─SOC─┐ │ ┌─IR──┐ ┌─DFIR┐  │  MTTD    │
│  │D15 │ │D4   │ │ │D1   │ │D2   │  │  MTTR    │
│  └────┘ └─────┘ │ └─────┘ └─────┘  │  SLA%    │
│  ┌Vuln┐ ┌Code─┐ │ ┌Cont─┐ ┌Cloud┐  │          │
│  │D14 │ │D6   │ │ │D7   │ │D10  │  │          │
│  └────┘ └─────┘ │ └─────┘ └─────┘  │          │
└──────────────────────────────────────────────────┘
```

### Data Format Standards

| Format      | ใช้สำหรับ                 | Domains ที่เกี่ยวข้อง |
| ----------- | ------------------------- | --------------------- |
| STIX 2.1    | Threat intelligence, IOCs | D15, D4, D1, D2       |
| SARIF 2.1.0 | Code/API scanning results | D6, D3, D13           |
| CycloneDX   | SBOM, dependency data     | D7, D3, D5            |
| CVSS v4.0   | Vulnerability scoring     | D14, D4, D1           |
| Sigma       | Detection rules           | D4, D15               |
| YARA        | Malware/IOC matching      | D15, D2, D4           |
| OPA/Rego    | Policy enforcement        | D5, D11, D10          |
| OpenAPI     | API specifications        | D13, D6               |
| CEF/LEEF    | Log forwarding            | D4, D10               |

### Shared Severity / SLA Taxonomy

เพื่อให้ทุก domain สื่อสารกันได้ ใช้ severity scale เดียวกัน:

| Severity          | SLA: Detect | SLA: Respond | SLA: Remediate | Escalation       |
| ----------------- | ----------- | ------------ | -------------- | ---------------- |
| **Critical (P1)** | ≤ 15 min    | ≤ 1 hr       | ≤ 24 hr        | CISO + Exec      |
| **High (P2)**     | ≤ 1 hr      | ≤ 4 hr       | ≤ 7 days       | Security Lead    |
| **Medium (P3)**   | ≤ 4 hr      | ≤ 24 hr      | ≤ 30 days      | Security Team    |
| **Low (P4)**      | ≤ 24 hr     | ≤ 72 hr      | ≤ 90 days      | Standard process |

---

## 9. ตัวชี้วัดและ KPIs ข้ามโดเมน (Cross-Domain Metrics & KPIs)

### End-to-End Metrics

| Metric                      | คำอธิบาย                                           | Target          | Domains วัดผล  |
| --------------------------- | -------------------------------------------------- | --------------- | -------------- |
| **E2E MTTD**                | เวลาจาก threat เกิดถึง detection                   | ≤ 30 min (P1)   | D15 → D4       |
| **E2E MTTR**                | เวลาจาก detection ถึง remediation complete         | ≤ 24 hr (P1)    | D4 → D1 → D14  |
| **TI-to-Detection Latency** | เวลาจาก IOC publish ถึง detection rule deploy      | ≤ 4 hr          | D15 → D4       |
| **Vuln-to-Patch Latency**   | เวลาจาก vuln discovery ถึง patch deployed          | ≤ 7 days (Crit) | D14 → D3/D10   |
| **Pipeline Block Rate**     | % builds blocked by security gates                 | 5-15%           | D6 → D3 → D5   |
| **SBOM Coverage**           | % deployed containers with valid SBOM              | ≥ 95%           | D7 → D3        |
| **Compliance Score**        | % controls passing across frameworks               | ≥ 85%           | D9 → D10 → D14 |
| **ZT Maturity Score**       | CISA ZT Maturity Model level                       | ≥ Advanced      | D11            |
| **IOC Feedback Rate**       | % incidents producing new IOCs back to TI platform | ≥ 80%           | D2 → D15       |

### Cross-Domain SLA Dashboard Template

```
╔══════════════════════════════════════════════════════╗
║          Cross-Domain Security SLA Dashboard         ║
╠══════════════════════════════════════════════════════╣
║                                                      ║
║  E2E MTTD (P1)      █████████░ 25 min (Target: 30)  ║
║  E2E MTTR (P1)      ███████░░░ 18 hr  (Target: 24)  ║
║  TI→Detection        ████████░░ 3.2 hr (Target: 4)   ║
║  Vuln→Patch (Crit)   ██████░░░░ 5.1 d  (Target: 7)   ║
║  Pipeline Block       █████████░ 12%   (Target: 5-15) ║
║  SBOM Coverage        ██████████ 97%   (Target: 95)   ║
║  Compliance Score     ████████░░ 88%   (Target: 85)   ║
║  IOC Feedback Rate    ████████░░ 82%   (Target: 80)   ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
```

---

## 10. อ้างอิง Framework และ Integration Checklist (Framework References & Integration Checklist)

### NIST CSF 2.0 as Orchestration Framework

NIST Cybersecurity Framework 2.0 เป็น meta-framework ที่เชื่อมทุก domain:

| CSF 2.0 Function  | Domains ที่ Map                    | Activities                                                  |
| ----------------- | ---------------------------------- | ----------------------------------------------------------- |
| **GOVERN (GV)**   | D8, D9, D17                        | Risk management, compliance oversight, executive governance |
| **IDENTIFY (ID)** | D8, D9, D13, D14                   | Asset inventory, risk assessment, vuln scan                 |
| **PROTECT (PR)**  | D3, D5, D6, D7, D10, D11, D12, D13 | Secure development, ZTA, cloud hardening                    |
| **DETECT (DE)**   | D4, D15                            | SOC monitoring, TI-driven detection                         |
| **RESPOND (RS)**  | D1, D2                             | IR execution, forensic investigation                        |
| **RECOVER (RC)**  | D1, D14                            | System restoration, patch deployment                        |

### Integration Checklist

#### Quick Wins (สามารถทำได้ทันที)

- [ ] เชื่อม TI feed (D15) เข้า SIEM (D4) ด้วย STIX/TAXII
- [ ] เปิด SARIF output จาก code scanner (D6) ส่งเข้า CI/CD dashboard (D3)
- [ ] สร้าง SBOM (D7) ทุก build, attach ไปกับ deployment manifest
- [ ] Map CSPM findings (D10) เข้า compliance controls (D9)
- [ ] ส่ง IR post-mortem IOCs (D1/D2) กลับเข้า TI platform (D15)

#### Standard (ใช้เวลา 1-3 เดือน)

- [ ] Deploy SOAR playbook สำหรับ IR lifecycle (Scenario 2)
- [ ] Implement supply chain security pipeline (Scenario 4) แบบ end-to-end
- [ ] สร้าง cross-domain severity/SLA taxonomy ใช้ร่วมกันทุกทีม
- [ ] Deploy Sigma rules จาก TI (D15) ไปยัง SIEM (D4) แบบ automated
- [ ] Implement ZTA policies (D11) สำหรับ cloud environment (D10)

#### Advanced (ใช้เวลา 3-6 เดือน)

- [ ] Implement full Vuln-to-Exploit pipeline (Scenario 3) ด้วย SOAR
- [ ] สร้าง AI/API threat surface management (Scenario 6) ครบวงจร
- [ ] Deploy cross-domain metrics dashboard พร้อม real-time E2E MTTD/MTTR
- [ ] Automate compliance evidence collection (D9/D10/D14) แบบ continuous
- [ ] Implement ML-driven alert correlation ข้าม SOC (D4) + TI (D15) + Vuln (D14)

### Framework Quick Reference

| Framework        | Version | ใช้ใน Scenario                | Purpose                      |
| ---------------- | ------- | ----------------------------- | ---------------------------- |
| NIST CSF         | 2.0     | All                           | Meta-orchestration framework |
| NIST 800-61      | Rev 2   | Scenario 2 (IR Lifecycle)     | IR process structure         |
| NIST 800-207     | —       | Scenario 5 (Cloud Compliance) | Zero Trust architecture      |
| NIST 800-53      | Rev 5   | Scenario 5 (Cloud Compliance) | Security control catalog     |
| MITRE ATT&CK     | v15     | Scenarios 2, 3, 4             | Threat technique mapping     |
| MITRE ATLAS      | —       | Scenario 6 (AI/API)           | AI threat landscape          |
| OWASP API Top 10 | 2023    | Scenario 6 (AI/API)           | API vulnerability risks      |
| OWASP LLM Top 10 | 2025    | Scenario 6 (AI/API)           | LLM application risks        |
| STIX/TAXII       | 2.1     | Scenarios 2, 3                | Threat intel exchange        |
| SARIF            | 2.1.0   | Scenario 4 (Supply Chain)     | Code scanning results        |
| CycloneDX        | 1.6     | Scenario 4 (Supply Chain)     | SBOM format                  |
| SLSA             | 1.0     | Scenario 4 (Supply Chain)     | Supply chain assurance       |
| CVSS             | 4.0     | Scenarios 3, 5                | Vulnerability scoring        |
| Sigma            | —       | Scenarios 2, 3                | Detection rule format        |

---

_Document version: 3.7.0 — Cross-Domain Integration Scenarios_
_Frameworks: NIST CSF 2.0, MITRE ATT&CK, STIX 2.1, SARIF 2.1.0, CycloneDX_
