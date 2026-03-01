# Post-Quantum Cryptography Migration Reference

คู่มือการเปลี่ยนผ่านสู่ Post-Quantum Cryptography (PQC) — NIST PQC Standards,
Crypto-Agility Assessment, Migration Roadmap, Hybrid Cryptography และ Thai Context

> สำหรับ Zero Trust architecture → ดู references/zero-trust-architecture.md (Domain 11)
> สำหรับ GitOps secret management → ดู references/gitops-security.md (Domain 5)
> สำหรับ compliance frameworks → ดู references/compliance-frameworks.md (Domain 9)
> สำหรับ end-to-end integration → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 5: GitOps Security → `references/gitops-security.md`
- Domain 9: Compliance Frameworks → `references/compliance-frameworks.md`
- Domain 11: Zero Trust Architecture → `references/zero-trust-architecture.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 22: Web3 & Blockchain Security → `references/web3-blockchain-security.md`

## Table of Contents

1. Quantum Threat Landscape & Timeline
2. NIST PQC Standards Overview
3. Crypto-Agility Assessment Framework
4. Cryptographic Inventory & Discovery
5. Migration Planning & Roadmap
6. Hybrid Cryptography Transition Patterns
7. TLS/PKI/Certificate Migration
8. Thai Context (บริบทประเทศไทย)
9. PQC Migration Checklist

---

## Quick Reference (สรุปย่อ)

> ใช้ section นี้สำหรับตอบคำถามเร็ว — deep-dive ดู sections ด้านล่าง

**Frameworks:** NIST FIPS 203/204/205 | CNSA 2.0 | NIST IR 8547 | NIST CSWP 39

**NIST PQC Standards (Finalized Aug 2024):**

| FIPS | Algorithm          | Type      | Use Case            | Key Sizes      |
| ---- | ------------------ | --------- | ------------------- | -------------- |
| 203  | ML-KEM (Kyber)     | KEM       | Key exchange, TLS   | 512/768/1024   |
| 204  | ML-DSA (Dilithium) | Signature | Code signing, certs | 44/65/87       |
| 205  | SLH-DSA (SPHINCS+) | Signature | Long-term signing   | 128f/192f/256f |

**CNSA 2.0 Timeline:**

| Year | Milestone                                                   |
| ---- | ----------------------------------------------------------- |
| 2025 | Code/firmware signing: prefer PQC. Browsers: support PQC    |
| 2027 | OS must support PQC. New acquisitions: CNSA 2.0 compliant   |
| 2030 | Networking: exclusively PQC. Code signing: mandatory        |
| 2035 | All quantum-vulnerable algorithms disallowed (NIST IR 8547) |

**Mosca's Theorem:** ถ้า X (shelf life) + Y (migration time) > Z (time to CRQC) → ต้องเริ่ม migrate วันนี้

**Hybrid Pattern:** X25519Kyber768 (TLS 1.3) — ใช้ classic + PQC ร่วมกันในช่วงเปลี่ยนผ่าน

**CRQC Threat Window:** 2028–2035 (คาดการณ์)

**Thai Context:** สกมช. ยังไม่มี PQC guidance — เสนอเริ่มจาก CNSA 2.0 timeline, BoT cryptography requirements

---

## 1. ภาพรวมภัยคุกคามควอนตัมและไทม์ไลน์ (Quantum Threat Landscape & Timeline)

### Quantum Computing คุกคามอะไรบ้าง

Quantum computers ที่มี qubit เพียงพอจะทำลาย cryptographic algorithms ที่ใช้กันอยู่ในปัจจุบัน
ผ่าน 2 algorithms หลัก:

```
┌─────────────────────────────────────────────────────────────────────┐
│                  QUANTUM THREAT LANDSCAPE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Shor's Algorithm                    Grover's Algorithm             │
│  ─────────────────                   ──────────────────             │
│  ● Breaks: RSA, ECC, DH, DSA        ● Weakens: AES, SHA           │
│  ● Impact: COMPLETE BREAK            ● Impact: Halves effective    │
│    (polynomial time factoring)          key length                  │
│  ● RSA-2048 → broken                 ● AES-128 → ~64-bit security │
│  ● ECDSA P-256 → broken              ● AES-256 → ~128-bit security│
│  ● ECDH X25519 → broken              ● Still secure with          │
│  ● All public-key crypto → broken       larger key sizes           │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│  ผลกระทบต่อ Cryptographic Primitives:                               │
│                                                                     │
│  Algorithm Type    │ Classical Security │ Post-Quantum Security     │
│  ──────────────────┼────────────────────┼──────────────────────     │
│  RSA-2048          │ 112-bit            │ BROKEN (Shor's)           │
│  RSA-4096          │ 140-bit            │ BROKEN (Shor's)           │
│  ECDSA P-256       │ 128-bit            │ BROKEN (Shor's)           │
│  ECDH X25519       │ 128-bit            │ BROKEN (Shor's)           │
│  AES-128           │ 128-bit            │ ~64-bit (Grover's)        │
│  AES-256           │ 256-bit            │ ~128-bit (Grover's)       │
│  SHA-256           │ 256-bit            │ ~128-bit (Grover's)       │
│  SHA-384           │ 384-bit            │ ~192-bit (Grover's)       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### "Harvest Now, Decrypt Later" (HNDL) — ภัยคุกคามที่เกิดขึ้นแล้ววันนี้

**สิ่งที่หลายคนมองข้าม**: ภัยคุกคาม quantum ไม่ได้เริ่มเมื่อ quantum computer พร้อม
แต่เริ่มตั้งแต่ **วันนี้** ผ่านการโจมตีแบบ "Harvest Now, Decrypt Later" (HNDL / Store-Now-Decrypt-Later):

```
Today (2025-2026)                    Future (2030-2040?)
┌──────────────────┐                ┌──────────────────┐
│  Adversary       │                │  Adversary       │
│  intercepts and  │──── stores ───→│  decrypts with   │
│  stores encrypted│  encrypted     │  quantum computer│
│  traffic/data    │  data          │  (Shor's algo)   │
└──────────────────┘                └──────────────────┘
      ↑                                    ↓
  VPN, TLS, SSH,                    Classified docs,
  encrypted email,                  trade secrets,
  key exchanges                     personal data EXPOSED
```

**ข้อมูลที่มี shelf life ยาว** เสี่ยงมากที่สุด:

- ข้อมูลความมั่นคงแห่งชาติ (classified data) — shelf life 25+ ปี
- ข้อมูลทางการแพทย์ (medical records) — shelf life ตลอดชีวิตผู้ป่วย
- ข้อมูลทางการเงิน (financial records) — shelf life 7-10 ปี
- ทรัพย์สินทางปัญญา (intellectual property) — shelf life 5-20 ปี
- Personal Identifiable Information (PII) — shelf life ตลอดชีวิตบุคคล

### Quantum Computing Timeline Estimates

| Milestone                                          | Conservative | Moderate  | Aggressive |
| -------------------------------------------------- | ------------ | --------- | ---------- |
| Logical qubit error correction                     | 2027-2030    | 2026-2028 | 2025-2027  |
| 1,000 logical qubits                               | 2033-2040    | 2030-2035 | 2028-2032  |
| Cryptographically Relevant Quantum Computer (CRQC) | 2035-2045    | 2030-2038 | 2028-2035  |
| RSA-2048 broken                                    | 2040+        | 2033-2040 | 2030-2035  |

**CRQC** (Cryptographically Relevant Quantum Computer) = quantum computer ที่มี qubit เพียงพอ
สำหรับ break RSA-2048 (~4,000 logical qubits หรือ ~20 million physical qubits ด้วย current error rates)

### ทำไมต้องเริ่มตอนนี้ — Mosca's Theorem

```
Mosca's Theorem:

If  x + y > z  then you need to worry NOW

Where:
  x = shelf life of data (how long data must remain confidential)
  y = migration time (how long it takes to deploy PQC)
  z = time until CRQC exists

Example:
  x = 10 years (financial data confidentiality)
  y = 5 years  (typical enterprise migration timeline)
  z = 12 years (moderate CRQC estimate from today)

  10 + 5 = 15 > 12  →  MUST START MIGRATION NOW

┌────────────────────────────────────────────────────────────┐
│  Timeline Visualization:                                    │
│                                                             │
│  ├─── shelf life (x=10) ───┤                               │
│  ├── migration (y=5) ──┤                                    │
│  NOW                    ├────── CRQC arrives (z=12) ──┤     │
│  │                      │                              │     │
│  │    ◄── window ──►    │     DATA EXPOSED            │     │
│  │    to start PQC      │     if not migrated         │     │
│                                                             │
│  ถ้า x + y > z → ข้อมูลจะถูก expose ก่อนหมดอายุ              │
│  ถ้า x + y ≤ z → ยังมีเวลา (แต่อย่าชะล่าใจ)                │
└────────────────────────────────────────────────────────────┘
```

### สรุปเหตุผลที่ต้องเริ่มเตรียมพร้อม

1. **HNDL attacks เกิดขึ้นแล้ว** — state-level adversaries กำลัง harvest encrypted traffic วันนี้
2. **Migration ใช้เวลานาน** — การเปลี่ยน cryptographic infrastructure ทั้งองค์กรใช้เวลา 3-10 ปี
3. **Standards พร้อมแล้ว** — NIST finalized FIPS 203/204/205 ในเดือนสิงหาคม 2024
4. **Compliance mandates กำลังมา** — CNSA 2.0, NIST IR 8547, EU directives
5. **Supply chain dependencies** — ต้องรอ vendors update products ที่ใช้ crypto

---

## 2. มาตรฐาน NIST PQC (NIST PQC Standards Overview)

### NIST PQC Standardization Process

NIST เริ่ม PQC standardization process ในปี 2016 ผ่าน 4 รอบการคัดเลือก:

```
2016: Call for Proposals (82 submissions)
  ↓
2019: Round 2 (26 algorithms)
  ↓
2020: Round 3 Finalists (7 algorithms)
  ↓
2022: Selected for Standardization (4 algorithms)
  ↓
August 2024: FIPS 203, 204, 205 FINALIZED
  ↓
2025: FIPS 206 (FN-DSA/FALCON) — draft expected
  ↓
March 2025: HQC selected as backup KEM
```

### 3+1 มาตรฐานที่ได้รับการรับรอง (Finalized + Draft Standards)

| Standard             | Algorithm | Original Name      | Purpose                                 | Mathematical Basis     |
| -------------------- | --------- | ------------------ | --------------------------------------- | ---------------------- |
| **FIPS 203**         | ML-KEM    | CRYSTALS-Kyber     | Key encapsulation (general encryption)  | Module Lattice         |
| **FIPS 204**         | ML-DSA    | CRYSTALS-Dilithium | Digital signatures (primary)            | Module Lattice         |
| **FIPS 205**         | SLH-DSA   | SPHINCS+           | Digital signatures (backup, hash-based) | Hash-based (stateless) |
| **FIPS 206** (draft) | FN-DSA    | FALCON             | Digital signatures (compact)            | NTRU Lattice           |

**HQC** (Hamming Quasi-Cyclic) ถูกเลือกเมื่อมีนาคม 2025 เป็น backup KEM
ใช้ code-based cryptography (ไม่ใช่ lattice) เพื่อ diversity ของ mathematical assumptions

### Parameter Sets Comparison

#### ML-KEM (FIPS 203) — Key Encapsulation

| Parameter Set | Security Level          | Public Key (bytes) | Ciphertext (bytes) | Shared Secret (bytes) |
| ------------- | ----------------------- | ------------------ | ------------------ | --------------------- |
| ML-KEM-512    | NIST Level 1 (≈AES-128) | 800                | 768                | 32                    |
| ML-KEM-768    | NIST Level 3 (≈AES-192) | 1,184              | 1,088              | 32                    |
| ML-KEM-1024   | NIST Level 5 (≈AES-256) | 1,568              | 1,568              | 32                    |

#### ML-DSA (FIPS 204) — Digital Signatures (Primary)

| Parameter Set | Security Level          | Public Key (bytes) | Signature (bytes) | Secret Key (bytes) |
| ------------- | ----------------------- | ------------------ | ----------------- | ------------------ |
| ML-DSA-44     | NIST Level 2 (≈SHA-256) | 1,312              | 2,420             | 2,560              |
| ML-DSA-65     | NIST Level 3 (≈AES-192) | 1,952              | 3,309             | 4,032              |
| ML-DSA-87     | NIST Level 5 (≈AES-256) | 2,592              | 4,627             | 4,896              |

#### SLH-DSA (FIPS 205) — Digital Signatures (Hash-based Backup)

| Parameter Set | Security Level | Public Key (bytes) | Signature (bytes) | Performance             |
| ------------- | -------------- | ------------------ | ----------------- | ----------------------- |
| SLH-DSA-128s  | NIST Level 1   | 32                 | 7,856             | Small signature, slower |
| SLH-DSA-128f  | NIST Level 1   | 32                 | 17,088            | Fast sign, larger sig   |
| SLH-DSA-192s  | NIST Level 3   | 48                 | 16,224            | Small signature, slower |
| SLH-DSA-192f  | NIST Level 3   | 48                 | 35,664            | Fast sign, larger sig   |
| SLH-DSA-256s  | NIST Level 5   | 64                 | 29,792            | Small signature, slower |
| SLH-DSA-256f  | NIST Level 5   | 64                 | 49,856            | Fast sign, larger sig   |

### Key/Signature Size Comparison vs Classical Algorithms

```
Key + Signature Size Comparison (bytes, approximate):

Algorithm           Public Key   Signature    Total     Security Level
─────────────────   ──────────   ─────────   ───────   ──────────────
RSA-2048               256          256         512     ~112-bit
RSA-4096               512          512       1,024     ~140-bit
ECDSA P-256             64           64         128     ~128-bit
Ed25519                 32           64          96     ~128-bit
ML-DSA-44            1,312        2,420       3,732     Level 2
ML-DSA-65            1,952        3,309       5,261     Level 3
ML-DSA-87            2,592        4,627       7,219     Level 5
SLH-DSA-128s            32        7,856       7,888     Level 1
FN-DSA-512             897          666       1,563     Level 1 (draft)
FN-DSA-1024          1,793        1,280       3,073     Level 5 (draft)

Key Exchange / KEM:

Algorithm           Public Key   Ciphertext   Total     Security Level
─────────────────   ──────────   ──────────   ───────   ──────────────
ECDH P-256              64           64         128     ~128-bit
X25519                  32           32          64     ~128-bit
ML-KEM-768           1,184        1,088       2,272     Level 3
ML-KEM-1024          1,568        1,568       3,136     Level 5

→ PQC keys/signatures มีขนาดใหญ่กว่า 10-50x
→ ต้องพิจารณาผลกระทบต่อ bandwidth, storage, latency
```

### Performance Benchmarks (Approximate, Modern x86-64)

| Operation       | RSA-2048 | ECDSA P-256 | ML-DSA-65 | SLH-DSA-128f | ML-KEM-768 |
| --------------- | -------- | ----------- | --------- | ------------ | ---------- |
| Key generation  | ~2 ms    | ~0.04 ms    | ~0.15 ms  | ~3.5 ms      | ~0.05 ms   |
| Sign / Encaps   | ~2 ms    | ~0.06 ms    | ~0.5 ms   | ~60 ms       | ~0.07 ms   |
| Verify / Decaps | ~0.06 ms | ~0.12 ms    | ~0.2 ms   | ~3.5 ms      | ~0.08 ms   |

**Key Observations:**

- **ML-KEM**: เร็วกว่า RSA key exchange มาก, ช้ากว่า ECDH เล็กน้อย — bandwidth impact มากกว่า CPU impact
- **ML-DSA**: เร็วกว่า RSA signing, ช้ากว่า ECDSA เล็กน้อย — signature size เป็นปัจจัยหลัก
- **SLH-DSA**: ช้ามาก (signing) — ใช้เป็น backup เท่านั้น, conservative hash-based security guarantee
- **FN-DSA**: Compact signatures แต่ implementation ซับซ้อน (ต้อง Gaussian sampling) จึงยัง draft

---

## 3. กรอบการประเมิน Crypto-Agility (Crypto-Agility Assessment Framework)

### Crypto-Agility คืออะไร

Crypto-Agility หมายถึงความสามารถขององค์กรในการเปลี่ยนแปลง cryptographic algorithms, protocols
และ key lengths ได้อย่างรวดเร็ว **โดยไม่ต้อง redesign ระบบทั้งหมด** — NIST CSWP 39 (2025)
กำหนดเป็น strategic capability ที่จำเป็นสำหรับการรับมือ quantum threat

```
Crypto-Agility Architecture:

┌──────────────────────────────────────────────────────┐
│                    Application Layer                  │
│    (ไม่ผูกกับ algorithm เฉพาะ, ใช้ abstract API)      │
├──────────────────────────────────────────────────────┤
│              Crypto Abstraction Layer                 │
│    ┌───────────┐  ┌────────────┐  ┌──────────────┐  │
│    │ Algorithm  │  │ Key Mgmt   │  │ Policy       │  │
│    │ Registry   │  │ Abstraction│  │ Engine       │  │
│    └───────────┘  └────────────┘  └──────────────┘  │
├──────────────────────────────────────────────────────┤
│            Crypto Provider Layer                      │
│    ┌────────┐ ┌────────┐ ┌────────┐ ┌────────────┐  │
│    │OpenSSL │ │BouncyC.│ │  HSM   │ │Cloud KMS   │  │
│    │ 3.x   │ │        │ │Provider│ │(AWS/Azure)  │  │
│    └────────┘ └────────┘ └────────┘ └────────────┘  │
├──────────────────────────────────────────────────────┤
│              Hardware Layer                           │
│    ┌────────┐ ┌────────┐ ┌─────────┐ ┌───────────┐  │
│    │ HSM    │ │ TPM    │ │Smart    │ │ Embedded  │  │
│    │ FIPS   │ │ 2.0    │ │Cards    │ │ Crypto    │  │
│    └────────┘ └────────┘ └─────────┘ └───────────┘  │
└──────────────────────────────────────────────────────┘
```

### Crypto-Agility Maturity Model (5 Levels)

| Level | ชื่อ (Name) | คำอธิบาย (Description)                                                    | Indicators                                                    |
| ----- | ----------- | ------------------------------------------------------------------------- | ------------------------------------------------------------- |
| **1** | Ad Hoc      | ไม่มี cryptographic inventory, algorithm hardcoded ทั่ว codebase          | Crypto choices scattered in code, no central policy           |
| **2** | Documented  | มี crypto inventory เบื้องต้น, รู้ว่าใช้ algorithm อะไรบ้าง               | Spreadsheet-based inventory, manual tracking                  |
| **3** | Managed     | มี crypto abstraction layer, สามารถเปลี่ยน algorithm ได้บางส่วน           | Central crypto library, configuration-driven algorithms       |
| **4** | Automated   | Crypto policy engine, automated discovery, hybrid crypto deployed         | CI/CD crypto scanning, automated key rotation, PQC testing    |
| **5** | Optimized   | Full crypto-agility, real-time algorithm switching, continuous monitoring | Algorithm negotiation, automated migration, PQC in production |

### Crypto-Agility Assessment Questionnaire

```
=== CRYPTO-AGILITY ASSESSMENT QUESTIONNAIRE ===

Section A: Cryptographic Inventory (20 points)
───────────────────────────────────────────────
A1. [  /5] องค์กรมี cryptographic inventory ที่ครอบคลุมทุก system หรือไม่?
     □ 0: ไม่มี inventory
     □ 2: มีบางส่วน (>50% ของ systems)
     □ 4: ครอบคลุม (>80% ของ systems)
     □ 5: Complete inventory + automated discovery

A2. [  /5] Inventory ระบุ algorithm, key length, protocol version หรือไม่?
     □ 0: ไม่ระบุรายละเอียด
     □ 3: ระบุ algorithm + key length
     □ 5: ระบุครบ + classification ตาม quantum vulnerability

A3. [  /5] มีการ classify systems ตามระดับ quantum risk หรือไม่?
     □ 0: ไม่มี classification
     □ 3: มี basic classification (high/medium/low)
     □ 5: Detailed classification with data shelf life analysis

A4. [  /5] มี third-party/vendor crypto dependency mapping หรือไม่?
     □ 0: ไม่ทราบ vendor crypto dependencies
     □ 3: ระบุ major vendors
     □ 5: Complete mapping + vendor PQC roadmap tracked

Section B: Architecture & Abstraction (20 points)
──────────────────────────────────────────────────
B1. [  /5] มี crypto abstraction layer หรือไม่?
     □ 0: Algorithm hardcoded ทั่ว codebase
     □ 3: Central crypto library แต่ไม่ทุก system ใช้
     □ 5: Unified abstraction layer ทุก system ใช้

B2. [  /5] สามารถเปลี่ยน algorithm ได้โดยไม่ต้อง redeploy application หรือไม่?
     □ 0: ต้อง code change + rebuild
     □ 3: Configuration change + redeploy
     □ 5: Runtime configuration / policy-driven

B3. [  /5] Certificate และ key management รองรับ PQC algorithms หรือไม่?
     □ 0: ไม่รองรับ
     □ 3: PKI vendor มี PQC roadmap
     □ 5: PKI/KMS tested กับ PQC algorithms แล้ว

B4. [  /5] HSM/Hardware security modules รองรับ PQC หรือไม่?
     □ 0: HSM ไม่รองรับ, ไม่มีแผน upgrade
     □ 3: HSM vendor มี PQC firmware roadmap
     □ 5: HSM tested/certified กับ PQC algorithms

Section C: Process & Governance (20 points)
───────────────────────────────────────────
C1. [  /5] มี cryptographic policy ที่ระบุ approved algorithms หรือไม่?
     □ 0: ไม่มี crypto policy
     □ 3: มี policy แต่ไม่ enforce
     □ 5: Enforced policy + regular review cycle

C2. [  /5] มี PQC migration plan/roadmap หรือไม่?
     □ 0: ไม่มีแผน
     □ 3: มีแผนเบื้องต้น
     □ 5: Detailed roadmap + budget + timeline approved

C3. [  /5] มี crypto change management process หรือไม่?
     □ 0: ไม่มี process
     □ 3: Informal process
     □ 5: Formal process + testing + rollback plan

C4. [  /5] มี training program สำหรับ PQC/crypto-agility หรือไม่?
     □ 0: ไม่มี training
     □ 3: Awareness-level training
     □ 5: Technical training + hands-on labs

Section D: Testing & Validation (20 points)
────────────────────────────────────────────
D1. [  /5] มีการ test PQC algorithms ใน non-production หรือไม่?
     □ 0: ยังไม่ได้ทดสอบ
     □ 3: PoC level testing
     □ 5: Comprehensive testing + performance benchmarks

D2. [  /5] มีการ test hybrid crypto (classical + PQC) หรือไม่?
     □ 0: ยังไม่ได้ทดสอบ
     □ 3: PoC level
     □ 5: Production-like testing + interop validation

D3. [  /5] มี automated crypto scanning ใน CI/CD หรือไม่?
     □ 0: ไม่มี scanning
     □ 3: Manual periodic scanning
     □ 5: Automated CI/CD gate + crypto SBOM

D4. [  /5] มี interoperability testing กับ partners/vendors หรือไม่?
     □ 0: ไม่ได้ทดสอบ
     □ 3: บาง vendors
     □ 5: All critical partners + documented results

Section E: Monitoring & Response (20 points)
────────────────────────────────────────────
E1. [  /5] มี crypto monitoring/alerting หรือไม่?
     □ 0: ไม่มี
     □ 3: Manual monitoring
     □ 5: Automated alerts สำหรับ deprecated algorithms

E2. [  /5] มีแผน emergency crypto migration (crypto-break response) หรือไม่?
     □ 0: ไม่มีแผน
     □ 3: Basic playbook
     □ 5: Detailed playbook + tested via tabletop exercise

E3. [  /5] มี quantum threat intelligence monitoring หรือไม่?
     □ 0: ไม่ได้ติดตาม
     □ 3: Passive monitoring (news/blogs)
     □ 5: Active tracking of CRQC timeline + NIST updates

E4. [  /5] สามารถ revoke/rotate keys ได้รวดเร็วเพียงใด?
     □ 0: Manual process, หลายวัน
     □ 3: Semi-automated, ภายใน 24 ชั่วโมง
     □ 5: Fully automated, ภายใน 1 ชั่วโมง

=== SCORING ===
Total: [    /100]

90-100: Level 5 — Optimized (พร้อมสำหรับ PQC migration)
70-89:  Level 4 — Automated (มี foundation ดี, เร่ง PQC testing)
50-69:  Level 3 — Managed (ต้องสร้าง abstraction + inventory)
30-49:  Level 2 — Documented (ต้องเร่ง inventory + planning)
0-29:   Level 1 — Ad Hoc (ต้องเริ่มจาก awareness + inventory)
```

---

## 4. การสำรวจและจัดทำ Cryptographic Inventory (Cryptographic Inventory & Discovery)

### ทำไมต้องทำ Cryptographic Inventory

Cryptographic inventory คือ **ขั้นตอนแรกที่สำคัญที่สุด** ของ PQC migration
ถ้าไม่รู้ว่าองค์กรใช้ crypto อะไร ที่ไหน อย่างไร — ไม่สามารถวางแผน migration ได้

### สิ่งที่ต้องสำรวจ (Inventory Scope)

```
┌─────────────────────────────────────────────────────────────────┐
│               CRYPTOGRAPHIC INVENTORY SCOPE                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Network & Transport Layer                                    │
│     ├── TLS configurations (versions, cipher suites)            │
│     ├── VPN tunnels (IPsec IKEv2 algorithm negotiation)         │
│     ├── SSH key types + key exchange algorithms                 │
│     ├── Wi-Fi encryption (WPA3/WPA2 configurations)             │
│     └── DNS security (DNSSEC algorithm)                         │
│                                                                  │
│  2. Certificate & PKI Infrastructure                             │
│     ├── TLS/SSL certificates (CA hierarchy, key types)          │
│     ├── Code signing certificates                               │
│     ├── S/MIME / email encryption certificates                  │
│     ├── Client authentication certificates                      │
│     ├── Internal CA infrastructure                              │
│     └── Certificate pinning configurations                      │
│                                                                  │
│  3. Key Management & Storage                                     │
│     ├── HSM inventory (vendor, model, firmware, PQC support)    │
│     ├── Cloud KMS (AWS KMS, Azure Key Vault, GCP Cloud KMS)    │
│     ├── Key stores (Java keystore, PKCS#11, PKCS#12)           │
│     ├── Secrets managers (Vault, AWS Secrets Manager)           │
│     └── SSH key management (authorized_keys, known_hosts)       │
│                                                                  │
│  4. Application & Code Libraries                                 │
│     ├── Crypto libraries (OpenSSL, BouncyCastle, libsodium)    │
│     ├── Application-level encryption (database, file)           │
│     ├── API authentication (JWT signing, HMAC, API keys)        │
│     ├── Password hashing (bcrypt, Argon2, PBKDF2)              │
│     └── Random number generators (CSPRNG sources)               │
│                                                                  │
│  5. Data at Rest                                                 │
│     ├── Disk/volume encryption (LUKS, BitLocker, FileVault)     │
│     ├── Database encryption (TDE, column-level)                 │
│     ├── Backup encryption                                       │
│     ├── Archive/tape encryption                                 │
│     └── Cloud storage encryption (S3 SSE, Azure Blob)          │
│                                                                  │
│  6. Embedded & IoT Devices                                       │
│     ├── Firmware signing algorithms                             │
│     ├── Secure boot chain crypto                                │
│     ├── Device identity certificates                            │
│     ├── OTA update verification                                 │
│     └── Hardware crypto accelerators                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Quantum Vulnerability Classification

| Classification | คำอธิบาย (Description)                             | Algorithm Examples                | Action                              |
| -------------- | -------------------------------------------------- | --------------------------------- | ----------------------------------- |
| **CRITICAL**   | Completely broken by Shor's algorithm              | RSA, ECDSA, ECDH, DH, DSA         | Replace with PQC (FIPS 203/204/205) |
| **HIGH**       | Weakened by Grover's, below 128-bit post-quantum   | AES-128, SHA-1, 3DES              | Upgrade to AES-256, SHA-384+        |
| **MEDIUM**     | Weakened by Grover's but still secure post-quantum | AES-256, SHA-256                  | Monitor, no immediate action        |
| **LOW**        | Not affected by known quantum algorithms           | AES-256 (symmetric), SHA-384+     | No action needed                    |
| **N/A**        | Not a quantum-vulnerable primitive                 | Argon2, bcrypt (password hashing) | No action needed                    |

### Discovery Tools

| Tool                          | Type              | Coverage                       | License              |
| ----------------------------- | ----------------- | ------------------------------ | -------------------- |
| **IBM Crypto Asset Scanner**  | Agent-based       | Network, code, certificates    | Commercial           |
| **Venafi TLS Protect**        | Agent + agentless | Certificate lifecycle + crypto | Commercial           |
| **Qualys SSL/TLS Assessment** | Network scan      | TLS configurations             | Commercial/Free      |
| **SSLyze**                    | Network scan      | TLS server configurations      | Open source (AGPL)   |
| **Cryptosense Analyzer**      | Code analysis     | Java/JCA crypto usage          | Commercial           |
| **CryptoGuard**               | SAST              | Java/Android crypto misuse     | Open source (Apache) |
| **testssl.sh**                | Network scan      | TLS/SSL cipher assessment      | Open source (GPL)    |
| **ssh-audit**                 | Network scan      | SSH algorithm configuration    | Open source (MIT)    |
| **step CLI**                  | Certificate       | Certificate chain inspection   | Open source (Apache) |

### Cryptographic Inventory Template (YAML)

```yaml
# cryptographic-inventory.yaml
# PQC Migration Cryptographic Asset Inventory
# Version: 1.0
# Last Updated: 2026-02-28
# Owner: Security Architecture Team

organization:
  name: "Example Corp"
  assessment_date: "2026-02-28"
  assessor: "Security Team"

assets:
  # --- TLS/Network ---
  - id: CRYPTO-001
    name: "Public Web Application TLS"
    category: network_transport
    system: "www.example.com"
    environment: production
    algorithm: "ECDHE-RSA-AES256-GCM-SHA384"
    key_exchange: "ECDHE (P-256)"
    authentication: "RSA-2048"
    encryption: "AES-256-GCM"
    hash: "SHA-384"
    tls_version: "1.3"
    quantum_vulnerability: CRITICAL # RSA + ECDHE broken by Shor's
    data_shelf_life_years: 5
    migration_priority: HIGH
    pqc_replacement: "ML-KEM-768 + ML-DSA-65 hybrid"
    vendor: "Nginx / Let's Encrypt"
    vendor_pqc_support: "Pending (2026 roadmap)"
    notes: "Primary customer-facing endpoint"

  - id: CRYPTO-002
    name: "Internal API mTLS"
    category: network_transport
    system: "api.internal.example.com"
    environment: production
    algorithm: "ECDHE-ECDSA-AES256-GCM-SHA384"
    key_exchange: "ECDHE (X25519)"
    authentication: "ECDSA (P-256)"
    encryption: "AES-256-GCM"
    hash: "SHA-384"
    tls_version: "1.3"
    quantum_vulnerability: CRITICAL
    data_shelf_life_years: 3
    migration_priority: HIGH
    pqc_replacement: "X25519Kyber768 hybrid"
    vendor: "Envoy proxy"
    vendor_pqc_support: "Supported (experimental)"

  # --- Certificates ---
  - id: CRYPTO-010
    name: "Code Signing Certificate"
    category: certificate_pki
    system: "CI/CD pipeline"
    environment: production
    algorithm: "RSA-4096 + SHA-256"
    quantum_vulnerability: CRITICAL
    data_shelf_life_years: 10
    migration_priority: CRITICAL # CNSA 2.0: prefer PQC by 2025
    pqc_replacement: "ML-DSA-65"
    vendor: "DigiCert"
    vendor_pqc_support: "PQC code signing available (2025)"

  # --- Key Management ---
  - id: CRYPTO-020
    name: "AWS KMS Customer Master Keys"
    category: key_management
    system: "AWS KMS (us-east-1)"
    environment: production
    algorithm: "AES-256 (symmetric CMK)"
    quantum_vulnerability: MEDIUM # AES-256 still secure post-quantum
    data_shelf_life_years: 7
    migration_priority: LOW
    pqc_replacement: "No change needed (symmetric)"
    vendor: "AWS"
    vendor_pqc_support: "N/A for symmetric keys"

  - id: CRYPTO-021
    name: "HSM Root of Trust"
    category: key_management
    system: "Thales Luna Network HSM 7"
    environment: production
    algorithm: "RSA-4096 (root key), ECDSA P-384 (signing)"
    quantum_vulnerability: CRITICAL
    data_shelf_life_years: 15
    migration_priority: CRITICAL
    pqc_replacement: "ML-DSA-87 (pending HSM firmware update)"
    vendor: "Thales"
    vendor_pqc_support: "PQC firmware roadmap Q3 2026"

  # --- Application Code ---
  - id: CRYPTO-030
    name: "JWT Token Signing"
    category: application_code
    system: "Authentication Service"
    environment: production
    algorithm: "ES256 (ECDSA P-256)"
    quantum_vulnerability: CRITICAL
    data_shelf_life_years: 0 # Short-lived tokens (15 min)
    migration_priority: MEDIUM # Short shelf life reduces urgency
    pqc_replacement: "ML-DSA-44 (or hybrid)"
    library: "jose4j"
    library_pqc_support: "Not yet"

  # --- Data at Rest ---
  - id: CRYPTO-040
    name: "Database TDE"
    category: data_at_rest
    system: "PostgreSQL (production)"
    environment: production
    algorithm: "AES-256-CBC"
    quantum_vulnerability: MEDIUM # Symmetric, Grover's halves to 128-bit
    data_shelf_life_years: 10
    migration_priority: LOW # AES-256 remains secure
    pqc_replacement: "No change needed"

summary:
  total_assets: 42
  critical_vulnerability: 18
  high_vulnerability: 7
  medium_vulnerability: 12
  low_vulnerability: 5
  migration_priority_critical: 5
  migration_priority_high: 13
  migration_priority_medium: 15
  migration_priority_low: 9
```

---

## 5. แผนการ Migration และ Roadmap (Migration Planning & Roadmap)

### CNSA 2.0 & NIST IR 8547 Timelines

NSA's CNSA 2.0 (Commercial National Security Algorithm Suite 2.0) และ NIST IR 8547
กำหนด timeline สำหรับการเลิกใช้ quantum-vulnerable algorithms:

| Year     | CNSA 2.0 Milestone                                            | NIST IR 8547                                 |
| -------- | ------------------------------------------------------------- | -------------------------------------------- |
| **2025** | Code/firmware signing: prefer PQC. Web browsers: support PQC  | --                                           |
| **2026** | Networking equipment: support and prefer PQC                  | --                                           |
| **2027** | OS must support PQC. New NSS acquisitions: CNSA 2.0 compliant | --                                           |
| **2030** | Networking: exclusively PQC. Code signing: mandatory          | 112-bit security algorithms deprecated       |
| **2033** | Web/cloud/OS/legacy: exclusively PQC                          | --                                           |
| **2035** | --                                                            | All quantum-vulnerable algorithms disallowed |

```
CNSA 2.0 + NIST IR 8547 Timeline Visualization:

2024  2025  2026  2027  2028  2029  2030  2031  2032  2033  2034  2035
  │     │     │     │                       │                 │           │
  │     ├─ Code signing: prefer PQC         │                 │           │
  │     ├─ Browsers: support PQC            │                 │           │
  │     │     │     │                       │                 │           │
  │     │     ├─ Network: support+prefer    │                 │           │
  │     │     │     │                       │                 │           │
  │     │     │     ├─ OS: must support     │                 │           │
  │     │     │     ├─ New NSS: CNSA 2.0    │                 │           │
  │     │     │     │                       │                 │           │
  │     │     │     │                       ├─ Network: PQC only         │
  │     │     │     │                       ├─ Code signing: mandatory   │
  │     │     │     │                       ├─ NIST: 112-bit deprecated  │
  │     │     │     │                       │                 │           │
  │     │     │     │                       │                 ├─ All PQC  │
  │     │     │     │                       │                 │  (CNSA)   │
  │     │     │     │                       │                 │           │
  │     │     │     │                       │                 │           ├─ NIST:
  │     │     │     │                       │                 │           │  all QV
  ▼     ▼     ▼     ▼                       ▼                 ▼           ▼  disallowed
  FIPS  Prefer Support OS                  Excl.             Excl.       Disallow
  203/4 PQC   PQC   PQC                   Network           All         All QV
  /205                                                       (CNSA)      (NIST)
```

### What Replaces What — PQC Algorithm Replacement Map

| Legacy Algorithm       | Quantum Threat                  | PQC Replacement   | Standard     | Priority |
| ---------------------- | ------------------------------- | ----------------- | ------------ | -------- |
| RSA (enc/key exchange) | Shor's — complete break         | ML-KEM            | FIPS 203     | CRITICAL |
| ECDH / DH              | Shor's — complete break         | ML-KEM            | FIPS 203     | CRITICAL |
| RSA (signatures)       | Shor's — complete break         | ML-DSA / SLH-DSA  | FIPS 204/205 | CRITICAL |
| ECDSA / EdDSA / DSA    | Shor's — complete break         | ML-DSA / SLH-DSA  | FIPS 204/205 | CRITICAL |
| AES-128                | Grover's — halves security      | AES-256           | Existing     | HIGH     |
| SHA-1                  | Grover's + collision attacks    | SHA-384 / SHA-512 | Existing     | HIGH     |
| 3DES                   | Grover's + meet-in-middle       | AES-256           | Existing     | HIGH     |
| AES-256                | Grover's — 128-bit post-quantum | No change needed  | Existing     | LOW      |
| SHA-256                | Grover's — 128-bit post-quantum | Monitor           | Existing     | LOW      |

### Migration Priority Matrix

```
Migration Priority Matrix:

                    Data Shelf Life
                    Short (<2yr)    Medium (2-10yr)   Long (>10yr)
                 ┌─────────────────┬─────────────────┬─────────────────┐
  Quantum        │                 │                 │                 │
  Vulnerable     │    MEDIUM       │    HIGH         │    CRITICAL     │
  (RSA/ECC)      │ Phase 3 (2028+) │ Phase 2 (2027) │ Phase 1 (NOW)  │
                 ├─────────────────┼─────────────────┼─────────────────┤
  Weakened       │                 │                 │                 │
  (AES-128)      │    LOW          │    MEDIUM       │    HIGH         │
                 │ Phase 4 (2030+) │ Phase 3 (2028+) │ Phase 2 (2027) │
                 ├─────────────────┼─────────────────┼─────────────────┤
  Quantum        │                 │                 │                 │
  Safe           │    LOW          │    LOW          │    LOW          │
  (AES-256)      │ Monitor         │ Monitor         │ Monitor         │
                 └─────────────────┴─────────────────┴─────────────────┘
```

### Phased Migration Rollout Template

```
=== PQC MIGRATION PHASED ROLLOUT ===

Phase 0: Foundation (Q1-Q2 2026) — ไม่เปลี่ยน crypto ใดๆ
─────────────────────────────────────────────────────────
□ Complete cryptographic inventory (Section 4)
□ Conduct crypto-agility assessment (Section 3)
□ Establish PQC migration team + governance
□ Identify critical systems (Mosca's Theorem analysis)
□ Request vendor PQC roadmaps
□ Budget approval for Phase 1-2

Phase 1: Quick Wins + Symmetric Upgrades (Q3-Q4 2026)
─────────────────────────────────────────────────────────
□ Upgrade AES-128 → AES-256 everywhere
□ Deprecate SHA-1 → SHA-256/384 minimum
□ Remove 3DES, RC4, any legacy ciphers
□ Enable PQC key exchange in browsers (Chrome/Firefox already support)
□ Test ML-KEM/ML-DSA in development environments
□ Deploy hybrid TLS (X25519Kyber768) for internal services

Phase 2: Hybrid Deployment (2027-2028)
─────────────────────────────────────────────────────────
□ Deploy hybrid TLS (classical + PQC) for external services
□ Update code signing to PQC or hybrid (CNSA 2.0 deadline 2025)
□ Migrate VPN/IPsec to hybrid key exchange
□ Update certificate management for PQC-aware PKI
□ HSM firmware upgrades for PQC support
□ API gateway PQC configuration
□ Interoperability testing with partners

Phase 3: PQC Primary (2029-2030)
─────────────────────────────────────────────────────────
□ Make PQC the primary algorithm (classical as fallback)
□ Migrate internal PKI to PQC certificates
□ Update all S/MIME and email encryption
□ IoT/embedded device firmware updates for PQC
□ Full PQC deployment for new systems (CNSA 2.0: networking PQC-only by 2030)
□ Retire classical-only configurations

Phase 4: PQC Exclusive (2031-2035)
─────────────────────────────────────────────────────────
□ Remove classical algorithm support where possible
□ Legacy system remediation or isolation
□ Compliance verification (CNSA 2.0 full compliance by 2033)
□ NIST IR 8547 full compliance by 2035
□ Continuous monitoring + crypto-agility maintenance
```

---

## 6. รูปแบบการเปลี่ยนผ่านด้วย Hybrid Cryptography (Hybrid Cryptography Transition Patterns)

### ทำไมต้อง Hybrid — Defense in Depth

**Hybrid cryptography** = ใช้ classical algorithm + PQC algorithm ร่วมกัน เพื่อ:

1. **ป้องกัน quantum attack** — PQC algorithm ป้องกัน Shor's
2. **ป้องกัน PQC algorithm break** — ถ้า PQC algorithm มีจุดอ่อนที่ยังไม่ค้นพบ, classical algorithm ยัง protect
3. **Backward compatibility** — ระบบที่ยังไม่รองรับ PQC ยังสื่อสารได้
4. **Incremental migration** — ค่อยๆ เปลี่ยนโดยไม่ต้อง big bang

```
Hybrid Cryptography Model:

Classical Only          Hybrid Mode              PQC Only
(TODAY)                 (TRANSITION)             (TARGET)

┌──────────┐           ┌──────────────┐          ┌──────────┐
│ X25519   │     →     │ X25519       │    →     │ ML-KEM   │
│ (ECDH)   │           │    +         │          │ (PQC)    │
│          │           │ ML-KEM-768   │          │          │
└──────────┘           └──────────────┘          └──────────┘

Security:              Security:                Security:
- Classical safe       - Safe against BOTH      - PQC safe
- Quantum vulnerable   - Classical + quantum    - Classical N/A
                       - Defense in depth
```

### Composite Key Exchange Patterns

#### Pattern 1: Concatenated Shared Secret (KEM Combiner)

```
Client                                        Server
  │                                              │
  ├── Generate X25519 keypair                    │
  ├── Generate ML-KEM-768 keypair                │
  │                                              │
  ├── ClientHello + key_share:                   │
  │     [X25519 public key]                      │
  │     [ML-KEM-768 public key]         ────────→│
  │                                              ├── ECDH shared secret (ss_c)
  │                                              ├── ML-KEM encaps (ss_q)
  │                                              │
  │   ←──────── ServerHello + key_share:         │
  │               [X25519 public key]            │
  │               [ML-KEM-768 ciphertext]        │
  │                                              │
  ├── ECDH shared secret (ss_c)                  │
  ├── ML-KEM decaps (ss_q)                       │
  │                                              │
  ├── Combined: SS = KDF(ss_c || ss_q)           │
  │   (both must be broken to compromise)        │
  └──────────────────────────────────────────────┘
```

#### Pattern 2: Nested Key Exchange

```
Outer: ML-KEM-768 encapsulation
  └── Inner: X25519 key exchange
        └── Combined shared secret

SS = HKDF-SHA384(
  ML-KEM-shared-secret || X25519-shared-secret,
  "hybrid-kem-v1"
)
```

### Hybrid TLS 1.3 — X25519Kyber768Draft00

**Chrome, Firefox, Cloudflare** รองรับ X25519Kyber768 hybrid key exchange ใน TLS 1.3 แล้ว
(Chrome enabled by default ตั้งแต่ version 124, Q2 2024)

TLS 1.3 NamedGroup values สำหรับ hybrid:

| NamedGroup            | Value  | Description                                    |
| --------------------- | ------ | ---------------------------------------------- |
| X25519Kyber768Draft00 | 0x6399 | X25519 + ML-KEM-768 hybrid (Cloudflare/Chrome) |
| SecP256r1MLKEM768     | 0x4588 | P-256 + ML-KEM-768 hybrid                      |
| X25519MLKEM768        | 0x4588 | X25519 + ML-KEM-768 (IETF draft)               |

### Hybrid Signature Patterns

```
Hybrid Signature Approaches:

1. Composite Signature (single cert, two algorithms):
   sig = (ECDSA-P256-sig, ML-DSA-65-sig)
   verify = ECDSA-verify(msg, sig.0) AND ML-DSA-verify(msg, sig.1)

2. Nested Signature:
   inner = ML-DSA-65-sign(message)
   outer = ECDSA-P256-sign(message || inner)
   verify = ECDSA-verify AND ML-DSA-verify

3. Dual Certificate (two separate certs):
   cert_classical = ECDSA-P256 signed cert
   cert_pqc = ML-DSA-65 signed cert
   Server presents both, client verifies both
```

### Implementation Patterns

#### OpenSSL 3.x — PQC via oqs-provider

```bash
# Install liboqs + oqs-provider for OpenSSL 3.x
# (Open Quantum Safe project)

# Build liboqs
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j$(nproc) && sudo make install

# Build oqs-provider
git clone https://github.com/open-quantum-safe/oqs-provider.git
cd oqs-provider && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j$(nproc) && sudo make install

# Configure OpenSSL to load oqs-provider
# In openssl.cnf:
[openssl_init]
providers = provider_sect

[provider_sect]
default = default_sect
oqsprovider = oqs_sect

[default_sect]
activate = 1

[oqs_sect]
activate = 1
module = /usr/local/lib/ossl-modules/oqsprovider.so

# Test hybrid TLS
openssl s_server -cert server.pem -key server.key \
  -groups x25519_mlkem768:x25519

openssl s_client -connect localhost:4433 \
  -groups x25519_mlkem768
```

#### Go — crypto/tls (Go 1.23+)

```go
// Go 1.23+ มี experimental PQC support ผ่าน crypto/tls
// Enable hybrid key exchange with GODEBUG

// Environment: GODEBUG=tlskyber=1

package main

import (
    "crypto/tls"
    "fmt"
    "net/http"
)

func main() {
    tlsConfig := &tls.Config{
        MinVersion: tls.VersionTLS13,
        // Go 1.23+ automatically negotiates X25519Kyber768Draft00
        // when both client and server support it
        CurvePreferences: []tls.CurveID{
            tls.X25519Kyber768Draft00,  // hybrid PQC
            tls.X25519,                  // fallback classical
        },
    }

    server := &http.Server{
        Addr:      ":8443",
        TLSConfig: tlsConfig,
    }

    fmt.Println("Starting PQC-hybrid TLS server...")
    server.ListenAndServeTLS("cert.pem", "key.pem")
}
```

#### Java — BouncyCastle PQC Provider

```java
// BouncyCastle 1.78+ (bcprov-jdk18on) มี PQC algorithm support

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.KyberParameterSpec;
import org.bouncycastle.pqc.jcajce.spec.DilithiumParameterSpec;
import javax.crypto.KEM;
import java.security.*;

public class PQCExample {
    static {
        Security.addProvider(new BouncyCastleProvider());
        Security.addProvider(new BouncyCastlePQCProvider());
    }

    // ML-KEM Key Encapsulation
    public static void mlKemExample() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("Kyber", "BCPQC");
        kpg.initialize(KyberParameterSpec.kyber768);
        KeyPair kp = kpg.generateKeyPair();

        // Encapsulate (sender side)
        KEM kemSender = KEM.getInstance("Kyber", "BCPQC");
        KEM.Encapsulator enc = kemSender.newEncapsulator(kp.getPublic());
        KEM.Encapsulated encapsulated = enc.encapsulate();
        byte[] ciphertext = encapsulated.encapsulation();
        byte[] sharedSecret1 = encapsulated.key().getEncoded();

        // Decapsulate (receiver side)
        KEM kemReceiver = KEM.getInstance("Kyber", "BCPQC");
        KEM.Decapsulator dec = kemReceiver.newDecapsulator(kp.getPrivate());
        byte[] sharedSecret2 = dec.decapsulate(ciphertext).key().getEncoded();

        assert java.util.Arrays.equals(sharedSecret1, sharedSecret2);
    }

    // ML-DSA Digital Signature
    public static void mlDsaExample() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("Dilithium", "BCPQC");
        kpg.initialize(DilithiumParameterSpec.dilithium3);
        KeyPair kp = kpg.generateKeyPair();

        Signature sig = Signature.getInstance("Dilithium", "BCPQC");
        sig.initSign(kp.getPrivate());
        sig.update("Hello PQC World".getBytes());
        byte[] signature = sig.sign();

        sig.initVerify(kp.getPublic());
        sig.update("Hello PQC World".getBytes());
        boolean valid = sig.verify(signature);

        System.out.println("ML-DSA signature valid: " + valid);
    }
}
```

---

## 7. การ Migrate TLS/PKI/Certificate (TLS/PKI/Certificate Migration)

### TLS 1.3 + PQC Key Exchange

TLS 1.3 รองรับ PQC key exchange ผ่าน hybrid NamedGroup extensions
โดยไม่ต้องเปลี่ยน TLS protocol version:

```
TLS 1.3 Handshake with Hybrid PQC Key Exchange:

Client                                               Server
  │                                                      │
  ├── ClientHello                                        │
  │   ├── supported_versions: [TLS 1.3]                 │
  │   ├── supported_groups: [X25519Kyber768, X25519]     │
  │   ├── key_share: [X25519Kyber768 client share]       │
  │   │   (X25519 pubkey + ML-KEM-768 encaps key)        │
  │   └── signature_algorithms: [ecdsa_secp256r1_sha256, │
  │        ml-dsa-65, rsa_pss_rsae_sha256]      ────────→│
  │                                                      │
  │                                                      ├── Select X25519Kyber768
  │                                                      ├── Compute X25519 SS
  │                                                      ├── ML-KEM-768 encapsulate
  │                                                      │
  │   ←────────── ServerHello                            │
  │               ├── key_share: [X25519Kyber768         │
  │               │   server share + ciphertext]         │
  │               └── selected cipher suite              │
  │                                                      │
  │   ←────────── {EncryptedExtensions}                  │
  │   ←────────── {Certificate}                          │
  │   ←────────── {CertificateVerify} (ML-DSA-65 sig)   │
  │   ←────────── {Finished}                             │
  │                                                      │
  ├── Derive hybrid shared secret                        │
  │   SS = HKDF(X25519_SS || ML-KEM-768_SS)             │
  ├── {Finished}                                ────────→│
  │                                                      │
  ├══════ Application Data (AES-256-GCM) ═══════════════→│
  │   Protected by quantum-resistant key exchange         │
  └──────────────────────────────────────────────────────┘
```

### Certificate Chain Migration Strategy

```
Current PKI Hierarchy:          Hybrid Transition:              PQC Target:

┌──────────────┐               ┌──────────────────┐           ┌──────────────┐
│  Root CA     │               │  Root CA         │           │  Root CA     │
│  RSA-4096    │               │  RSA-4096 +      │           │  ML-DSA-87   │
│              │               │  ML-DSA-87       │           │              │
└──────┬───────┘               └──────┬───────────┘           └──────┬───────┘
       │                              │                               │
┌──────┴───────┐               ┌──────┴───────────┐           ┌──────┴───────┐
│  Issuing CA  │               │  Issuing CA      │           │  Issuing CA  │
│  RSA-2048    │     →         │  RSA-2048 +      │    →      │  ML-DSA-65   │
│  or ECDSA    │               │  ML-DSA-65       │           │              │
└──────┬───────┘               └──────┬───────────┘           └──────┬───────┘
       │                              │                               │
┌──────┴───────┐               ┌──────┴───────────┐           ┌──────┴───────┐
│  End Entity  │               │  End Entity      │           │  End Entity  │
│  RSA/ECDSA   │               │  Dual cert or    │           │  ML-DSA-44   │
│              │               │  Composite cert  │           │  or ML-DSA-65│
└──────────────┘               └──────────────────┘           └──────────────┘
```

### CA Migration Considerations

| Consideration                | คำอธิบาย                                                            | Recommendation                                           |
| ---------------------------- | ------------------------------------------------------------------- | -------------------------------------------------------- |
| **Root CA key ceremony**     | Root CA key ต้องใช้ได้ 20+ ปี, ต้อง PQC-safe                        | สร้าง new PQC root CA parrallel กับ existing, cross-sign |
| **Certificate size**         | PQC certificates ใหญ่กว่า 5-10x (ML-DSA-65 cert ~4KB vs ECDSA ~1KB) | ทดสอบ bandwidth impact, ปรับ TLS buffer sizes            |
| **Hardware compatibility**   | HSM ต้องรองรับ PQC key types                                        | Verify HSM vendor PQC firmware roadmap                   |
| **Certificate transparency** | CT logs ต้องรองรับ PQC signatures                                   | Coordinate with CT log operators                         |
| **OCSP/CRL**                 | OCSP responses + CRL ลงนามด้วย PQC                                  | Update OCSP responder + CRL signing                      |
| **Certificate pinning**      | Pinned certificates ต้อง update                                     | Plan pin rotation, prefer certificate chain pinning      |
| **Certificate lifecycle**    | Shorter certificate lifetimes ลด quantum exposure                   | Automate renewal, target 90-day lifecycle                |

### Public CA PQC Readiness

| Certificate Authority     | PQC Status                        | Timeline         | Notes                                   |
| ------------------------- | --------------------------------- | ---------------- | --------------------------------------- |
| **DigiCert**              | PQC hybrid certificates available | 2024+            | PQC toolkit for testing                 |
| **Sectigo**               | PQC research + pilot              | 2025+            | Composite certificate pilot             |
| **GlobalSign**            | PQC readiness program             | 2025+            | Atlas platform PQC support              |
| **Let's Encrypt**         | Research phase                    | 2026-2027 (est.) | Waiting for IETF standards finalization |
| **Google Trust Services** | Chrome PQC key exchange deployed  | 2024+            | Certificate PQC TBD                     |
| **AWS Private CA**        | PQC hybrid support planned        | 2025-2026        | AWS CloudHSM PQC pending                |
| **HashiCorp Vault**       | PKI engine PQC roadmap            | 2026 (est.)      | Depends on Go crypto/PQC                |

### Internal PKI Migration Steps

```
Step 1: Assessment (Month 1-2)
───────────────────────────────
□ Inventory all internal CAs (root, intermediate, issuing)
□ List all certificate types (TLS, mTLS, code signing, S/MIME)
□ Identify HSM models and PQC firmware availability
□ Map certificate consumers (apps, services, devices)
□ Assess certificate management tools (ACME, EST, CMP)

Step 2: Parallel PQC CA Setup (Month 3-4)
──────────────────────────────────────────
□ Create new PQC root CA (ML-DSA-87)
□ Cross-sign with existing RSA/ECDSA root CA
□ Create PQC intermediate/issuing CAs
□ Update certificate templates for PQC algorithms
□ Test certificate issuance + renewal

Step 3: Hybrid Certificate Deployment (Month 5-8)
──────────────────────────────────────────────────
□ Issue hybrid certificates (dual algorithm) for new services
□ Update TLS termination endpoints (load balancers, ingress)
□ Deploy PQC-aware OCSP responder
□ Update CRL distribution points
□ Interoperability testing with clients

Step 4: Migration + Cutover (Month 9-12)
────────────────────────────────────────
□ Replace existing certificates with hybrid/PQC certificates
□ Update certificate pinning configurations
□ Retire classical-only intermediate CAs
□ Monitor for compatibility issues
□ Document rollback procedures

Step 5: Classical Deprecation (Month 12+)
─────────────────────────────────────────
□ Remove classical algorithm support from new certificates
□ Set end-of-life dates for remaining classical certificates
□ Retire classical root CA (after all certs expire)
□ Update policies to mandate PQC-only
```

---

## 8. บริบทประเทศไทย (Thai Context — บริบทประเทศไทย)

### ธนาคารแห่งประเทศไทย (ธปท. / Bank of Thailand) — Financial Sector Requirements

ธปท. ยังไม่มี PQC-specific mandate ณ ปัจจุบัน แต่มี cybersecurity frameworks ที่เกี่ยวข้อง:

| Regulation / Guideline                           | ความเกี่ยวข้องกับ PQC                                                                 | สถานะ     |
| ------------------------------------------------ | ------------------------------------------------------------------------------------- | --------- |
| **ประกาศ ธปท. เรื่อง IT Risk Management**        | กำหนดให้สถาบันการเงินใช้ encryption ที่เหมาะสม, ต้อง review crypto standards เป็นระยะ | บังคับใช้ |
| **ประกาศ ธปท. เรื่อง Cyber Resilience**          | กำหนดให้ประเมิน emerging threats รวมถึง quantum, มี risk assessment process           | บังคับใช้ |
| **แนวปฏิบัติ Cloud Computing**                   | กำหนด encryption standards สำหรับ cloud, อ้างอิง international standards              | บังคับใช้ |
| **Payment Systems Act (พ.ร.บ. ระบบการชำระเงิน)** | ความปลอดภัยของระบบชำระเงิน, encryption ของ transaction data                           | บังคับใช้ |

**คำแนะนำ:**

- สถาบันการเงินไทยควรเริ่ม cryptographic inventory ตั้งแต่ปัจจุบัน
- ธปท. มีแนวโน้มจะออก guidance ตาม NIST/BIS (Bank for International Settlements) recommendations
- ระบบ BAHTNET, PromptPay ใช้ PKI ที่ต้องวางแผน PQC migration
- Financial Messaging (SWIFT) กำลัง evaluate PQC สำหรับ SWIFT network

### ระบบ PKI ภาครัฐ — Thai Government NPKI

Thai National Public Key Infrastructure (NPKI) ภายใต้สำนักงานพัฒนาธุรกรรมทางอิเล็กทรอนิกส์ (ETDA):

| Component                        | Current State                          | PQC Consideration                                  |
| -------------------------------- | -------------------------------------- | -------------------------------------------------- |
| **Thai Root CA**                 | RSA-4096, SHA-384                      | ต้องวางแผน PQC root CA parallel                    |
| **Government CA**                | RSA-2048 certificates                  | ต้อง upgrade ก่อน quantum-vulnerable timeline      |
| **e-Signature**                  | พ.ร.บ. ว่าด้วยธุรกรรมทางอิเล็กทรอนิกส์ | Algorithm approved list ต้อง update ให้รวม PQC     |
| **e-Tax / e-Withholding**        | กรมสรรพากร digital signatures          | Certificate migration ต้อง coordinate กับ CA       |
| **National Digital ID**          | DOPA, ThaID application                | Long-lived credentials ต้อง plan PQC early         |
| **Thai Smart Card / Citizen ID** | Chip-based PKI                         | Hardware constraint — ต้อง assess PQC key size fit |

### PDPA (พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล) — Data Protection Implications

PDPA กำหนดให้ใช้ "มาตรการรักษาความมั่นคงปลอดภัยที่เหมาะสม" สำหรับ personal data:

| PDPA Requirement                                          | PQC Relevance                                                                        |
| --------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| **มาตรา 37(1)** — มาตรการรักษาความมั่นคงปลอดภัยที่เหมาะสม | Encryption ที่ใช้ต้อง "เหมาะสม" — เมื่อ quantum threats ชัดเจน, อาจตีความว่าต้อง PQC |
| **Data Retention** — เก็บข้อมูลตามระยะเวลาที่จำเป็น       | ข้อมูลที่เก็บนาน (medical, financial) เสี่ยง HNDL attack                             |
| **Cross-border Transfer** — มาตรา 28-29                   | ถ้า transfer ข้อมูลไปประเทศที่มี PQC requirement, ต้อง comply                        |
| **Data Breach Notification** — มาตรา 37(4)                | Quantum decryption ของ historical data อาจถือเป็น breach event                       |

### สกมช. (NCSA) — National Cyber Security Agency

สกมช. ในฐานะหน่วยงานกำกับดูแล cybersecurity ตาม พ.ร.บ. การรักษาความมั่นคงปลอดภัยไซเบอร์ พ.ศ. 2562:

- ยังไม่มี PQC-specific guidance ณ เดือนกุมภาพันธ์ 2026
- สกมช. ติดตามมาตรฐาน NIST และ international developments
- CII (Critical Information Infrastructure) sectors ที่เกี่ยวข้อง:
  - **การเงิน**: ระบบ payment, internet banking — quantum threat ต่อ TLS/PKI
  - **พลังงาน**: SCADA encryption — long-lived systems ที่ upgrade ยาก
  - **โทรคมนาคม**: 5G encryption (already AES-based), certificate infrastructure
  - **สาธารณสุข**: ข้อมูลผู้ป่วยมี shelf life ตลอดชีวิต — HNDL risk สูงมาก

### คำแนะนำสำหรับองค์กรในประเทศไทย

```
Thai Organization PQC Readiness Recommendations:

1. เริ่มทำ Cryptographic Inventory ตอนนี้
   - ไม่ต้องรอ regulation mandate
   - ใช้ template จาก Section 4

2. ติดตาม ธปท. / ETDA / สกมช. guidance
   - คาดว่าจะมี guidance ภายใน 2027-2028
   - BOT จะ follow BIS/FSB recommendations

3. Plan NPKI Migration
   - Thai Government PKI (NPKI) ต้อง migrate
   - Organization certificates ที่ chain กับ NPKI ต้องรอ ETDA timeline

4. PDPA Compliance Review
   - Review encryption ของ personal data
   - ข้อมูลที่มี shelf life ยาว (medical, financial) = priority

5. Vendor Engagement
   - สอบถาม vendors (HSM, PKI, cloud) เรื่อง PQC roadmap
   - Include PQC requirements ใน procurement specifications

6. Awareness & Training
   - ฝึกอบรม security team เรื่อง PQC fundamentals
   - NIST SP 1800-38C (Migration to PQC) เป็น reference ที่ดี
```

### CNSA 2.0 Timeline Mapping สำหรับ CII ประเทศไทย

สำหรับหน่วยงาน CII (Critical Information Infrastructure) ภายใต้ พ.ร.บ. ไซเบอร์ 2562
ควร map กับ CNSA 2.0 timeline ดังนี้:

| CII Sector | ตัวอย่างองค์กร               | Priority Level | เริ่ม Inventory | Hybrid Transition | Full PQC |
| ---------- | ---------------------------- | -------------- | --------------- | ----------------- | -------- |
| การเงิน    | ธปท., ตลาดหลักทรัพย์, ธนาคาร | Critical       | 2025 (ตอนนี้)   | 2027-2029         | 2030     |
| พลังงาน    | กฟผ., ปตท., กฟน./กฟภ.        | Critical       | 2025-2026       | 2028-2030         | 2032     |
| โทรคมนาคม  | AIS, TRUE, DTAC, NT          | High           | 2026            | 2028-2030         | 2032     |
| สาธารณสุข  | รพ.รัฐ, สปสช., สธ.           | High           | 2026-2027       | 2029-2031         | 2033     |
| ราชการ     | สกมช., ETDA, DOPA            | High           | 2026            | 2028-2030         | 2032     |
| ขนส่ง      | การบินไทย, รฟท., AOT         | Medium         | 2027            | 2030-2032         | 2035     |

**หมายเหตุ:** สกมช. ยังไม่มี PQC-specific mandate (ณ มีนาคม 2026) — timeline ข้างต้นเป็น
คำแนะนำที่ align กับ CNSA 2.0 + NIST IR 8547 โดยองค์กรไทยควร:

- ภาคการเงิน: follow ธปท. IT Risk Management + BIS/FSB recommendations
- ภาค NPKI/e-Government: รอ ETDA migration timeline สำหรับ Thai Government PKI
- BAHTNET/PromptPay: ธปท. ควรเริ่ม PQC feasibility study ภายใน 2026-2027

### ผลกระทบต่อ Blockchain & Web3 (PQC Impact on Blockchain)

> Cross-reference: ดู Domain 22 `references/web3-blockchain-security.md` Section 1 สำหรับ blockchain-specific PQC analysis

Blockchain เป็น sector ที่ได้รับผลกระทบจาก quantum computing สูงมาก เนื่องจากพึ่งพา ECDSA/EdDSA
ทั้งหมดสำหรับ transaction signing และ transactions บน public ledger เป็น permanent record (HNDL risk):

- **Ethereum (secp256k1):** addresses ที่เคยส่ง tx expose public key → quantum target โดยตรง
- **Bitcoin (secp256k1):** Taproot (BIP-341) เตรียม upgrade path สำหรับ future PQC signatures
- **DeFi TVL >$100B:** ทั้งหมด protected ด้วย ECDSA — quantum break = systemic risk
- **Smart contracts:** immutable contracts ที่ verify ECDSA on-chain ต้องมี proxy pattern สำหรับ migration

**คำแนะนำสำหรับ crypto/Web3 organizations ในไทย:**

- เริ่ม cryptographic inventory ของ on-chain assets ตั้งแต่วันนี้
- ใช้ account abstraction (EIP-7702) เพื่อเตรียม signature scheme upgrade
- ก.ล.ต. ควร issue PQC guidance สำหรับ digital asset custodians

---

## 9. Checklist การ Migrate PQC (PQC Migration Checklist)

### Framework Reference Table

| Framework                   | Version          | Organization | Focus Area                                     | URL                                             |
| --------------------------- | ---------------- | ------------ | ---------------------------------------------- | ----------------------------------------------- |
| **NIST FIPS 203 (ML-KEM)**  | Final (Aug 2024) | NIST         | Key encapsulation standard                     | csrc.nist.gov/pubs/fips/203/final               |
| **NIST FIPS 204 (ML-DSA)**  | Final (Aug 2024) | NIST         | Digital signature standard (primary)           | csrc.nist.gov/pubs/fips/204/final               |
| **NIST FIPS 205 (SLH-DSA)** | Final (Aug 2024) | NIST         | Backup signature standard (hash-based)         | csrc.nist.gov/pubs/fips/205/final               |
| **NIST FIPS 206 (FN-DSA)**  | Draft (2025)     | NIST         | Compact signature standard (NTRU)              | csrc.nist.gov/pubs/fips/206/ipd                 |
| **NIST IR 8547**            | IPD (Nov 2024)   | NIST         | Transition guidance & deprecation timeline     | csrc.nist.gov/pubs/ir/8547/ipd                  |
| **NIST CSWP 39**            | Final (2025)     | NIST         | Crypto-agility strategies & considerations     | csrc.nist.gov/pubs/cswp/39/final                |
| **CNSA 2.0**                | 1.0 (Sep 2022)   | NSA          | NSA PQC migration requirements & timeline      | media.defense.gov/cnsa-suite                    |
| **NIST SP 1800-38**         | Draft (2024)     | NIST         | Migration to Post-Quantum Cryptography (NCCoE) | nccoe.nist.gov/pqc                              |
| **ETSI QSC**                | Various          | ETSI         | Quantum-Safe Cryptography standards            | etsi.org/technologies/quantum-safe-cryptography |

### PQC Migration Checklist — Quick Win / Standard / Advanced

#### Quick Win (ดำเนินการได้ทันที, ไม่ต้อง budget มาก)

- [ ] ทำ cryptographic inventory เบื้องต้น (ใช้ template Section 4)
- [ ] ระบุระบบที่มี data shelf life ยาว + ใช้ quantum-vulnerable algorithms
- [ ] ทำ Mosca's Theorem analysis สำหรับ critical systems
- [ ] ทดสอบ PQC algorithms ใน non-production environment (liboqs, BouncyCastle)
- [ ] Enable hybrid key exchange (X25519Kyber768) ใน Chrome/Firefox สำหรับ internal use
- [ ] Upgrade AES-128 → AES-256 ทุกที่ที่ยังใช้อยู่
- [ ] Deprecate SHA-1 จาก crypto configurations ทั้งหมด
- [ ] สำรวจ vendor PQC roadmaps (HSM, PKI, cloud providers)
- [ ] จัดอบรม PQC awareness สำหรับ security + development teams
- [ ] ประเมิน crypto-agility maturity ขององค์กร (Section 3 questionnaire)

#### Standard (ดำเนินการภายใน 6-12 เดือน, ลงทุนปานกลาง)

- [ ] Implement hybrid TLS (X25519Kyber768) สำหรับ external-facing services
- [ ] Deploy crypto abstraction layer (ไม่ hardcode algorithm ใน application code)
- [ ] Update certificate management infrastructure สำหรับ PQC certificate types
- [ ] ประเมิน HSM firmware upgrade requirements + timeline
- [ ] Implement automated cryptographic discovery ใน CI/CD pipeline
- [ ] สร้าง PQC migration roadmap + budget proposal + executive sponsorship
- [ ] ทดสอบ hybrid certificates (composite หรือ dual) กับ internal PKI
- [ ] Conduct vendor PQC readiness assessment สำหรับ critical suppliers
- [ ] ทดสอบ performance impact ของ PQC (bandwidth, latency, CPU)
- [ ] Update procurement specifications ให้ include PQC requirements

#### Advanced (ดำเนินการภายใน 12-24 เดือน, ลงทุนสูง)

- [ ] Full PQC migration สำหรับ high-priority systems (long shelf life data)
- [ ] Migrate internal PKI to PQC (new root CA + intermediate CAs)
- [ ] Upgrade HSM fleet ให้รองรับ PQC key generation + storage
- [ ] Deploy PQC-native TLS สำหรับ all services (not just hybrid)
- [ ] Implement crypto-agility framework — runtime algorithm selection + policy engine
- [ ] Update VPN/IPsec infrastructure ให้ใช้ PQC key exchange
- [ ] Migrate code signing to PQC algorithms (CNSA 2.0 compliance)
- [ ] Implement crypto monitoring + alerting สำหรับ deprecated algorithms
- [ ] สร้าง emergency crypto migration playbook (crypto-break response plan)
- [ ] Achieve CNSA 2.0 compliance milestones ตาม organizational timeline
- [ ] Interoperability testing กับ partners + supply chain PQC readiness

---

**NIST PQC Reference**: เมื่อสร้าง output ที่เกี่ยวข้องกับ PQC migration ต้องอ้างอิง
NIST FIPS 203/204/205 standards, CNSA 2.0 timeline, และ NIST IR 8547 transition guidance
พร้อม hybrid cryptography patterns ตาม Section 6 เป็นแนวทาง transition

> สำหรับ compliance frameworks ที่เกี่ยวข้อง → ดู references/compliance-frameworks.md (Domain 9)
> สำหรับ zero trust architecture กับ PQC → ดู references/zero-trust-architecture.md (Domain 11)
> สำหรับ GitOps secret management → ดู references/gitops-security.md (Domain 5)
> สำหรับ cross-domain integration → ดู references/cross-domain-integration.md (Domain 16)
