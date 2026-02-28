# Code Security Analysis Reference

คู่มือการวิเคราะห์ความปลอดภัยของ code ด้วย Static Analysis, SARIF Processing และ Variant Analysis

> สำหรับ DevSecOps CI/CD pipeline → ดู references/devsecops-pipeline.md (Domain 3)
> สำหรับ container security → ดู references/container-supply-chain.md (Domain 7)
> สำหรับ API security analysis → ดู references/api-security.md (Domain 13)
> สำหรับ end-to-end supply chain workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 3: DevSecOps Pipeline → `references/devsecops-pipeline.md`
- Domain 7: Container & Supply Chain → `references/container-supply-chain.md`
- Domain 13: API Security → `references/api-security.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 22: Web3 & Blockchain Security → `references/web3-blockchain-security.md`
- **Runtime Exploitation Testing** → `shannon-pentest` plugin (`shannon-pentest@pitimon-shannon`) — สำหรับ runtime security testing ที่เสริม static analysis จากไฟล์นี้ด้วย dynamic exploitation testing ครอบคลุม OWASP Top 10 (XSS, SQLi, SSRF, auth bypass)

## Table of Contents

1. Tool Selection Decision Tree
2. Semgrep Quick Reference
3. CodeQL Quick Reference
4. SARIF Result Processing
5. Variant Analysis Methodology
6. Combined CI/CD Pipeline
7. CWE Top 25 (2025 Edition)
8. Claude Code Security (Reasoning-Based Scanner)

---

## 1. การเลือกเครื่องมือ (Tool Selection Decision Tree)

```
ต้องการวิเคราะห์ code security
├── ต้องการ scan เร็ว, ไม่ต้อง build
│   ├── Pattern matching ง่ายๆ → Semgrep (auto rules)
│   └── ต้องการ taint tracking ภายใน file → Semgrep taint mode
│
├── ต้องการ deep interprocedural analysis
│   ├── Source code + build ได้ → CodeQL
│   └── Build ไม่ได้ / interpreted language → Semgrep taint mode
│
├── ต้อง process ผลลัพธ์จากหลาย tools
│   └── SARIF Processing (jq / sarif-tools)
│
└── พบ bug แล้ว ต้องหา variants
    └── Variant Analysis (5-Step Process)

เลือกตามบริบท:
| สถานการณ์ (Scenario)        | เครื่องมือ (Tool)       | เหตุผล (Why)                   |
|-----------------------------|------------------------|-------------------------------|
| Quick security scan         | Semgrep                | เร็ว, ไม่ต้อง build, auto rules |
| PR review / CI gate         | Semgrep                | รองรับ diff-aware scanning     |
| Deep vulnerability audit    | CodeQL                 | Interprocedural taint tracking |
| Multi-tool result analysis  | SARIF + jq             | Aggregate, dedup, prioritize  |
| Post-incident variant hunt  | Variant Analysis       | Systematic pattern expansion   |
```

---

## 2. Semgrep Quick Reference

### Core Rulesets

```bash
# Auto-detect rules (เริ่มต้นด้วยคำสั่งนี้)
semgrep --config auto .

# Security-focused rulesets
semgrep --config p/security-audit --config p/owasp-top-ten .

# Language-specific
semgrep --config p/python .
semgrep --config p/javascript .
```

| Ruleset            | คำอธิบาย (Description)       |
| ------------------ | ---------------------------- |
| `p/security-audit` | Comprehensive security rules |
| `p/owasp-top-ten`  | OWASP Top 10 vulnerabilities |
| `p/cwe-top-25`     | CWE Top 25 vulnerabilities   |
| `p/trailofbits`    | Trail of Bits security rules |

### Custom Rule Structure

```yaml
rules:
  - id: hardcoded-credential-detection
    languages: [python, javascript]
    message: "Hardcoded credential detected in assignment to $VAR"
    severity: ERROR
    metadata:
      cwe: "CWE-798: Use of Hard-coded Credentials"
      owasp: "A07:2021 - Identification and Authentication Failures"
      confidence: HIGH
    patterns:
      - pattern: $VAR = "$VALUE"
      - metavariable-regex:
          metavariable: $VAR
          regex: ".*(secret|token|credential|api_key).*"
      - pattern-not: $VAR = ""
```

### Pattern Operators

| Operator             | คำอธิบาย (Description)  | ตัวอย่าง (Example)       |
| -------------------- | ----------------------- | ------------------------ |
| `pattern`            | Match exact pattern     | `func(...)`              |
| `patterns`           | All must match (AND)    | ใช้ร่วมกับ `pattern-not` |
| `pattern-either`     | Any matches (OR)        | Match หลาย patterns      |
| `pattern-not`        | Exclude matches         | กรอง false positives     |
| `pattern-inside`     | Match ภายใน context     | เช่น ภายใน function      |
| `pattern-not-inside` | Match นอก context       | เช่น นอก try/except      |
| `metavariable-regex` | Regex on captured value | Filter ค่าที่จับได้      |

### Taint Mode (Data Flow Tracking)

Semgrep taint mode ติดตาม data flow จาก source ถึง sink:

```yaml
rules:
  - id: sql-injection-taint
    languages: [python]
    message: "SQL injection: user input flows to query without parameterization"
    severity: ERROR
    metadata:
      cwe: "CWE-89: SQL Injection"
      owasp: "A03:2021 - Injection"
    mode: taint
    pattern-sources:
      - pattern: request.args.get(...)
      - pattern: request.form[...]
      - pattern: request.json
    pattern-sinks:
      - pattern: cursor.execute($QUERY)
      - pattern: db.execute($QUERY)
    pattern-sanitizers:
      - pattern: int(...)
```

**ข้อจำกัด**: Taint mode ของ Semgrep ทำงานได้ดีภายใน file เดียวหรือ function chains ที่ไม่ซับซ้อน ถ้าต้องการ cross-file interprocedural tracking ให้ใช้ CodeQL

### Output Formats

```bash
# SARIF (สำหรับ GitHub Security, integration)
semgrep --config p/security-audit --sarif -o results.sarif .

# JSON (สำหรับ scripting)
semgrep --config p/security-audit --json -o results.json .

# With data flow traces (แสดง taint path)
semgrep --config p/security-audit --dataflow-traces .
```

### Suppress False Positives

```python
value = get_from_vault()  # nosemgrep: hardcoded-credential-detection
```

---

## 3. CodeQL Quick Reference

### เมื่อไหร่ควรใช้ CodeQL

ใช้ CodeQL เมื่อต้องการ **interprocedural taint tracking** ข้ามหลาย functions/files:

```
HTTP Handler → Input Parser → Business Logic → Database Query
     ↓              ↓              ↓              ↓
   source      transforms       passes       sink (SQL)
```

Semgrep อาจพลาด flow ที่ผ่านหลาย function calls แต่ CodeQL ติดตามได้ทั้ง path

### Database Creation

```bash
codeql database create codeql.db --language=<LANG> [--command='<BUILD>'] --source-root=.
```

| Language              | `--language=` | Build Required                      |
| --------------------- | ------------- | ----------------------------------- |
| Python                | `python`      | No                                  |
| JavaScript/TypeScript | `javascript`  | No                                  |
| Go                    | `go`          | No                                  |
| Java/Kotlin           | `java`        | Yes (`--command='./gradlew build'`) |
| C/C++                 | `cpp`         | Yes (`--command='make -j8'`)        |

### Run Security Analysis

```bash
# Standard security queries
codeql database analyze codeql.db \
  --format=sarif-latest \
  --output=results.sarif \
  -- codeql/python-queries:codeql-suites/python-security-extended.qls

# With Trail of Bits queries (ถ้า install แล้ว)
codeql database analyze codeql.db \
  --format=sarif-latest \
  --output=results.sarif \
  -- trailofbits/go-queries
```

### Custom Query Template

```ql
/**
 * @name Find SQL injection vulnerabilities
 * @description Identifies potential SQL injection from user input
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id py/sql-injection-custom
 * @tags security
 *       external/cwe/cwe-089
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

module SqlInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // กำหนด taint sources (user input)
    exists(source)
  }
  predicate isSink(DataFlow::Node sink) {
    // กำหนด dangerous sinks (SQL execution)
    exists(sink)
  }
}

module SqlInjectionFlow = TaintTracking::Global<SqlInjectionConfig>;

from SqlInjectionFlow::PathNode source, SqlInjectionFlow::PathNode sink
where SqlInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "SQL injection from $@.", source.getNode(), "user input"
```

### Query Metadata

| Field                | คำอธิบาย (Description) | ค่า (Values)                         |
| -------------------- | ---------------------- | ------------------------------------ |
| `@kind`              | ประเภท query           | `problem`, `path-problem`            |
| `@problem.severity`  | ความรุนแรง             | `error`, `warning`, `recommendation` |
| `@security-severity` | CVSS score             | `0.0` - `10.0`                       |
| `@precision`         | ความมั่นใจ             | `very-high`, `high`, `medium`, `low` |

---

## 4. SARIF Result Processing

SARIF (Static Analysis Results Interchange Format) เป็นมาตรฐาน OASIS สำหรับแลกเปลี่ยนผลลัพธ์ static analysis

### SARIF Structure

```
sarifLog
├── version: "2.1.0"
└── runs[]
    ├── tool.driver.name
    ├── tool.driver.rules[] (rule definitions)
    └── results[]
        ├── ruleId
        ├── level (error/warning/note)
        ├── message.text
        ├── locations[].physicalLocation
        │   ├── artifactLocation.uri
        │   └── region.startLine
        └── fingerprints{} / partialFingerprints{}
```

### jq Queries สำหรับ SARIF Analysis

```bash
# นับจำนวน findings ทั้งหมด
jq '[.runs[].results[]] | length' results.sarif

# แสดง rule IDs ที่พบ
jq '[.runs[].results[].ruleId] | unique' results.sarif

# ดึงเฉพาะ errors
jq '.runs[].results[] | select(.level == "error")' results.sarif

# ดึง findings พร้อม file location
jq '.runs[].results[] | {
  rule: .ruleId,
  message: .message.text,
  file: .locations[0].physicalLocation.artifactLocation.uri,
  line: .locations[0].physicalLocation.region.startLine
}' results.sarif

# นับ findings แยกตาม severity และ rule
jq '[.runs[].results[] | select(.level == "error")] |
  group_by(.ruleId) |
  map({rule: .[0].ruleId, count: length})' results.sarif

# ดึง findings สำหรับ file เฉพาะ
jq --arg file "src/auth.py" \
  '.runs[].results[] | select(.locations[].physicalLocation.artifactLocation.uri | contains($file))' \
  results.sarif
```

### Aggregating Multiple SARIF Files

เมื่อใช้หลาย tools (Semgrep + CodeQL) ต้อง aggregate และ deduplicate:

```bash
# Merge หลาย SARIF files ด้วย jq
jq -s '{
  version: "2.1.0",
  "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
  runs: [.[].runs[]]
}' semgrep.sarif codeql.sarif > combined.sarif
```

### Deduplication Strategy

ใช้ fingerprints เป็นหลัก เพราะ path อาจต่างกันระหว่าง environments:

| Strategy               | ใช้เมื่อ (When to Use)              |
| ---------------------- | ----------------------------------- |
| `partialFingerprints`  | Tool มี fingerprint ให้ (preferred) |
| `ruleId + file + line` | Fallback เมื่อไม่มี fingerprint     |
| Content hash           | เมื่อ line numbers เปลี่ยนบ่อย      |

### Baseline Comparison (CI/CD)

```bash
# เช็ค high severity ใหม่ (ไม่มีใน baseline)
HIGH_COUNT=$(jq '[.runs[].results[] | select(.level == "error")] | length' results.sarif)
if [ "$HIGH_COUNT" -gt 0 ]; then
  echo "Found $HIGH_COUNT high severity issues"
  exit 1
fi
```

---

## 5. Variant Analysis Methodology (กระบวนการหา Bug Variants)

เมื่อพบ vulnerability แล้ว ให้ค้นหา variants ทั้ง codebase ด้วย 5-Step Process:

### Step 1: วิเคราะห์ Root Cause

ก่อน search ต้องเข้าใจ **ทำไม** ถึง vulnerable:

> "Vulnerability นี้เกิดเพราะ [UNTRUSTED DATA] ไปถึง [DANGEROUS OPERATION] โดยไม่มี [REQUIRED PROTECTION]"

ตัวอย่าง:

- "User input ไปถึง `eval()` โดยไม่ผ่าน sanitization"
- "Attacker-controlled size ไปถึง `malloc()` โดยไม่มี overflow check"

### Step 2: สร้าง Exact Match

เริ่มจาก pattern ที่ match **เฉพาะ** instance ที่รู้แล้ว:

```bash
rg -n "exact_vulnerable_code_here"
# ต้อง match แค่ 1 ที่ (ตำแหน่ง bug ต้นฉบับ)
```

### Step 3: ระบุจุดที่ Abstract ได้

| Element        | Keep Specific      | Abstract ได้               |
| -------------- | ------------------ | -------------------------- |
| Function name  | ถ้า unique กับ bug | ถ้า pattern ใช้กับ family  |
| Variable names | ไม่เคย             | ใช้ metavariables เสมอ     |
| Literal values | ถ้า value สำคัญ    | ถ้า value ใดก็ trigger bug |
| Arguments      | ถ้า position สำคัญ | ใช้ `...` wildcards        |

### Step 4: Generalize ทีละขั้น (Abstraction Ladder)

**เปลี่ยนทีละ element เดียว:**

| Level                     | ลักษณะ (Approach)                | False Positive Rate | ใช้เมื่อ (Use When)      |
| ------------------------- | -------------------------------- | ------------------- | ------------------------ |
| 0: Exact Match            | Match literal code               | ~0%                 | ยืนยัน bug               |
| 1: Variable Abstraction   | เปลี่ยน var names เป็น wildcards | Low                 | หา copy-paste variants   |
| 2: Structural Abstraction | Generalize structure             | Medium              | Audit component          |
| 3: Semantic Abstraction   | Taint mode (source→sink)         | High                | Full security assessment |

**หยุด** เมื่อ false positive rate เกิน ~50%

### Step 5: Analyze และ Triage

สำหรับทุก match ที่พบ, document:

```markdown
## Variant Analysis: [Original Bug ID]

### Root Cause

[Statement of the vulnerability pattern]

### Confirmed Variants

| Location  | Severity | Exploitability                | Status |
| --------- | -------- | ----------------------------- | ------ |
| file:line | High     | Reachable, controllable input | Open   |

### False Positive Patterns

- Pattern X: Always FP because [reason]
```

### Critical Pitfalls ที่ต้องหลีกเลี่ยง

| Pitfall                             | ผลกระทบ (Impact)                                | วิธีป้องกัน (Prevention)               |
| ----------------------------------- | ----------------------------------------------- | -------------------------------------- |
| Search เฉพาะ module ที่พบ bug       | พลาด variants ใน module อื่น                    | Search ทั้ง codebase เสมอ              |
| Pattern เฉพาะเจาะจงเกินไป           | พลาด variants ที่ใช้ construct อื่น             | Enumerate related attributes/functions |
| Focus แค่ vulnerability class เดียว | พลาด manifestations อื่นของ root cause เดียวกัน | List ทุก manifestation ก่อน search     |
| ไม่ test edge cases                 | พลาด bugs ที่ trigger ด้วย null/empty           | Test ด้วย null, empty, boundary values |

---

## 6. Combined CI/CD Pipeline

GitHub Actions workflow ที่รวม Semgrep + CodeQL + SARIF processing:

```yaml
name: Code Security Analysis

on:
  push:
    branches: [main]
  pull_request:
  schedule:
    - cron: "0 0 * * 1" # Weekly full scan

jobs:
  semgrep:
    name: Semgrep Scan
    runs-on: ubuntu-latest
    container:
      image: returntocorp/semgrep
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Run Semgrep
        run: |
          if [ "${{ github.event_name }}" = "pull_request" ]; then
            semgrep ci --baseline-commit ${{ github.event.pull_request.base.sha }}
          else
            semgrep ci
          fi
        env:
          SEMGREP_RULES: >-
            p/security-audit
            p/owasp-top-ten
      - name: Upload SARIF
        if: always()
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: semgrep.sarif

  codeql:
    name: CodeQL Analysis
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write
    strategy:
      matrix:
        language: ["python", "javascript"]
    steps:
      - uses: actions/checkout@v4
      - name: Initialize CodeQL
        uses: github/codeql-action/init@v3
        with:
          languages: ${{ matrix.language }}
          queries: security-extended
      - uses: github/codeql-action/autobuild@v3
      - uses: github/codeql-action/analyze@v3
        with:
          category: "/language:${{ matrix.language }}"

  aggregate-results:
    name: Aggregate & Gate
    needs: [semgrep, codeql]
    runs-on: ubuntu-latest
    if: always()
    steps:
      - name: Download SARIF artifacts
        uses: actions/download-artifact@v4
      - name: Check for critical findings
        run: |
          CRITICAL=$(jq -s '[.[].runs[].results[] | select(.level == "error")] | length' *.sarif 2>/dev/null || echo 0)
          echo "Critical findings: $CRITICAL"
          if [ "$CRITICAL" -gt 0 ]; then
            echo "::error::Found $CRITICAL critical security issues"
            exit 1
          fi
```

### Pipeline Decision Guide

| สถานการณ์ (Scenario) | การตั้งค่า (Configuration)          |
| -------------------- | ----------------------------------- |
| PR review (เร็ว)     | Semgrep diff-aware only             |
| Main branch push     | Semgrep full + CodeQL               |
| Weekly audit         | Semgrep + CodeQL + extended queries |
| Post-incident hunt   | Variant analysis + custom rules     |

---

## 7. CWE Top 25 (2025 Edition)

MITRE CWE Top 25 Most Dangerous Software Weaknesses อัปเดตเป็น **2025 edition** โดยคำนวณจาก real-world vulnerability data ใน NVD ช่วง 2 ปีล่าสุด ตาราง Top 10 ด้านล่างครอบคลุม weakness ที่พบบ่อยและมีผลกระทบสูงสุด:

| Rank | CWE     | Weakness                          | Score | Category       |
| ---- | ------- | --------------------------------- | ----- | -------------- |
| 1    | CWE-79  | Cross-site Scripting (XSS)        | 60.38 | Injection      |
| 2    | CWE-89  | SQL Injection                     | 28.72 | Injection      |
| 3    | CWE-352 | Cross-Site Request Forgery (CSRF) | 13.64 | Session        |
| 4    | CWE-862 | Missing Authorization             | 13.28 | Access Control |
| 5    | CWE-787 | Out-of-bounds Write               | 12.68 | Memory         |
| 6    | CWE-22  | Path Traversal                    | 8.99  | Injection      |
| 7    | CWE-416 | Use After Free                    | 8.47  | Memory         |
| 8    | CWE-125 | Out-of-bounds Read                | 7.88  | Memory         |
| 9    | CWE-78  | OS Command Injection              | 7.85  | Injection      |
| 10   | CWE-94  | Code Injection                    | 7.57  | Injection      |

**การเปลี่ยนแปลงจาก 2024 (Changes from 2024)**:

- CWE-862 (Missing Authorization) กระโดดขึ้น 5 อันดับมาอยู่ที่ **#4** สะท้อนถึง broken access control attacks ที่เพิ่มขึ้น
- CWE-352 (CSRF) ขึ้นมาอยู่ที่ **#3** แสดงว่า session management weaknesses ยังเป็นปัญหาสำคัญ
- มี **6 entries ใหม่** ใน full top 25 เทียบกับปี 2024

**การใช้งานกับ SAST tools**:

- Semgrep: ใช้ ruleset `p/cwe-top-25` สำหรับ pattern matching ตาม CWE Top 25
- CodeQL: ใช้ `security-extended` query suite ซึ่งครอบคลุม CWE Top 25 ทั้งหมด
- ทั้ง Semgrep rules และ CodeQL queries มี `metadata.cwe` tags ที่ map กลับมาที่ CWE IDs ในตารางนี้

---

## 8. Claude Code Security (Reasoning-Based Scanner)

Anthropic เปิดตัว Claude Code Security เมื่อ February 2026 เป็น vulnerability scanner แบบ reasoning-based ที่แตกต่างจาก traditional rule-based SAST อย่างมีนัยสำคัญ:

| Aspect           | Rule-Based SAST (Semgrep/CodeQL)                            | Reasoning-Based (Claude Code Security)                          |
| ---------------- | ----------------------------------------------------------- | --------------------------------------------------------------- |
| Detection method | Pattern matching / data flow rules                          | Contextual reasoning over code semantics                        |
| Strengths        | Fast, deterministic, low false positives for known patterns | Business logic flaws, broken access control, complex data flows |
| Weaknesses       | Misses novel patterns, requires rule updates                | Slower, may hallucinate, requires validation                    |
| Best for         | CI/CD pipeline gates, known vulnerability patterns          | Deep review, pre-release audit, complex codebases               |

**Recommendation**: ใช้ร่วมกัน — rule-based SAST เป็น first pass ใน CI/CD, reasoning-based เป็น second pass สำหรับ deep review

### Workflow Integration

```
CI/CD Pipeline
├── Stage 1: Rule-Based SAST (Semgrep/CodeQL)
│   ├── เร็ว, deterministic — เหมาะเป็น gate check
│   ├── Block PR ถ้าพบ known vulnerability patterns
│   └── Output: SARIF → GitHub Security tab
│
└── Stage 2: Reasoning-Based (Claude Code Security)
    ├── Deep review สำหรับ business logic flaws
    ├── ตรวจ broken access control ที่ rule-based พลาด
    └── ใช้เป็น pre-release audit หรือ periodic deep scan
```

### ข้อควรระวัง (Caveats)

- **Hallucination risk**: Reasoning-based scanner อาจ report false positives ที่ดูน่าเชื่อ — ต้อง validate ทุก finding ด้วย manual review
- **Non-deterministic**: ผลอาจต่างกันใน runs ที่ต่างกัน — ไม่เหมาะเป็น hard gate ใน CI/CD
- **Cost & latency**: ใช้ LLM inference ซึ่งช้าและแพงกว่า rule-based — เหมาะกับ periodic scan มากกว่า every-commit scan
- **Complementary, not replacement**: ใช้เสริม rule-based SAST ไม่ใช่แทนที่ — ทั้งสองมี strengths ที่ต่างกัน
