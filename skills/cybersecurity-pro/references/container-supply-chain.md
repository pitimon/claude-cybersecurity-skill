# Container & Supply Chain Security Reference

คู่มือความปลอดภัยของ Container Image และ Software Supply Chain

> สำหรับ DevSecOps CI/CD pipeline → ดู references/devsecops-pipeline.md (Domain 3)
> สำหรับ code security analysis → ดู references/code-security-analysis.md (Domain 6)
> สำหรับ vulnerability management → ดู references/vulnerability-management.md (Domain 14)
> สำหรับ end-to-end supply chain workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 3: DevSecOps Pipeline → `references/devsecops-pipeline.md`
- Domain 6: Code Security Analysis → `references/code-security-analysis.md`
- Domain 14: Vulnerability Management → `references/vulnerability-management.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 22: Web3 & Blockchain Security → `references/web3-blockchain-security.md`

## Table of Contents

1. Container Security Lifecycle
2. Dockerfile Hardening
3. Vulnerability Scanning
4. SBOM & Supply Chain
5. Runtime Security
6. CI/CD Integration
7. CIS Docker Benchmark & Compliance
8. Security Checklist

---

## 1. วงจรความปลอดภัยของ Container (Container Security Lifecycle)

```
Pre-Build          Build              Post-Build          Runtime
┌──────────┐    ┌──────────┐      ┌──────────┐      ┌──────────┐
│Base image │ →  │Multi-stage│  →   │ Vuln scan │  →   │Read-only │
│selection  │    │builds     │      │ SBOM gen  │      │filesystem│
│Pin version│    │Non-root   │      │ Sign image│      │Drop caps │
│Scan base  │    │Min layers │      │ Push to   │      │Seccomp   │
│Review     │    │No secrets │      │ registry  │      │Monitoring│
│Dockerfile │    │           │      │           │      │           │
└──────────┘    └──────────┘      └──────────┘      └──────────┘
```

**หลักการ**: Shift security left — scan เร็ว, scan บ่อย, แก้ก่อน deploy

---

## 2. การทำ Dockerfile ให้ปลอดภัย (Dockerfile Hardening)

### ใช้ Base Image ที่เล็กที่สุด

```dockerfile
# ไม่ดี: Full OS image (attack surface ใหญ่)
FROM ubuntu:22.04

# ดี: Minimal image
FROM alpine:3.19

# ดีกว่า: Distroless (ไม่มี shell, package manager)
FROM gcr.io/distroless/static-debian12

# ดีที่สุด: Scratch (สำหรับ static binaries)
FROM scratch
COPY myapp /
ENTRYPOINT ["/myapp"]
```

### Pin Version ทุกครั้ง

```dockerfile
# ไม่ดี: Mutable tag (เปลี่ยนได้ทุกเมื่อ)
FROM node:latest

# ดี: Specific version
FROM node:20.10.0-alpine3.19

# ดีที่สุด: SHA digest (immutable)
FROM node@sha256:abc123...
```

### ไม่ Run เป็น Root

```dockerfile
# สร้าง non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# สลับไป non-root
USER appuser

WORKDIR /app

# Copy พร้อม ownership ที่ถูกต้อง
COPY --chown=appuser:appgroup . .
```

### Multi-Stage Builds (ลด Attack Surface)

```dockerfile
# Build stage — มี build tools ทั้งหมด
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o myapp .

# Runtime stage — เฉพาะ binary ที่ต้องการ
FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/myapp /
USER nonroot:nonroot
ENTRYPOINT ["/myapp"]
```

### Minimize Layers และ Attack Surface

```dockerfile
# ดี: Single layer, cleanup ใน layer เดียวกัน
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

---

## 3. การ Scan Vulnerabilities

### เครื่องมือ (Tool Overview)

| Tool         | จุดเด่น (Best For)                             | ประเภท (Type) |
| ------------ | ---------------------------------------------- | ------------- |
| Trivy        | All-in-one scanner, default choice             | Open-source   |
| Grype        | Fast vulnerability scanning, Anchore ecosystem | Open-source   |
| Syft         | SBOM generation, detailed dependency analysis  | Open-source   |
| Docker Scout | Docker Desktop integration                     | Commercial    |

### Trivy Commands

```bash
# Basic scan
trivy image nginx:latest

# Scan เฉพาะ HIGH/CRITICAL (สำหรับ CI/CD gate)
trivy image --severity HIGH,CRITICAL nginx:latest

# Fail on HIGH/CRITICAL (exit code 1 สำหรับ CI/CD)
trivy image --exit-code 1 --severity HIGH,CRITICAL nginx:latest

# ไม่แสดง vulnerabilities ที่ยังไม่มี fix
trivy image --ignore-unfixed nginx:latest

# Output เป็น SARIF (สำหรับ GitHub Security)
trivy image --format sarif --output results.sarif nginx:latest

# Scan filesystem (รวม secrets และ misconfig)
trivy fs --scanners vuln,secret,misconfig .

# Scan Kubernetes cluster
trivy k8s --report summary cluster

# Scan Dockerfile สำหรับ misconfigurations
trivy config Dockerfile
```

### Grype Commands

```bash
# Basic scan
grype nginx:latest

# Fail on severity
grype -f high nginx:latest

# Output เป็น JSON
grype -o json nginx:latest > results.json

# Scan จาก SBOM
grype sbom:./sbom.json
```

### Trivy Configuration

```yaml
# .trivy.yaml
severity:
  - HIGH
  - CRITICAL
ignore-unfixed: true
exit-code: 1
scanners:
  - vuln
  - secret
  - misconfig
timeout: 10m
ignorefile: .trivyignore
```

```text
# .trivyignore
CVE-2023-12345
CVE-2023-67890  # Won't fix - accepted risk
```

### Vulnerability Prioritization ด้วย EPSS

| Level    | CVSS Score | Action    | SLA        |
| -------- | ---------- | --------- | ---------- |
| CRITICAL | 9.0-10.0   | แก้ทันที  | 24 ชั่วโมง |
| HIGH     | 7.0-8.9    | แก้เร็ว   | 7 วัน      |
| MEDIUM   | 4.0-6.9    | วางแผนแก้ | 30 วัน     |
| LOW      | 0.1-3.9    | ติดตาม    | 90 วัน     |

**ปัจจัยเพิ่มเติมในการจัดลำดับ:**

1. **Exploitability** — มี exploit สาธารณะหรือไม่? EPSS score สูงหรือไม่?
2. **Reachability** — Vulnerable code path ถูกเรียกใช้จริงหรือไม่?
3. **Environment** — Production vs Development?
4. **Fix availability** — มี patch แล้วหรือยัง?

```bash
# ตรวจสอบ EPSS score สำหรับ CVE
curl -s "https://api.first.org/data/v1/epss?cve=CVE-2024-1234" | jq .
```

---

## 4. SBOM & Supply Chain Security

### SBOM Generation ด้วย Syft

```bash
# Generate CycloneDX SBOM จาก image
syft -o cyclonedx-json nginx:latest > sbom.cdx.json

# Generate SPDX SBOM
syft -o spdx-json nginx:latest > sbom.spdx.json

# Scan directory
syft dir:/path/to/project

# รวม all layers
syft nginx:latest --scope all-layers
```

### SBOM Generation ด้วย Trivy

```bash
# CycloneDX format
trivy image --format cyclonedx --output sbom.json nginx:latest

# SPDX format
trivy image --format spdx-json --output sbom.spdx.json nginx:latest

# Scan SBOM ที่มีอยู่แล้ว
trivy sbom sbom.json
```

### Image Signing ด้วย cosign

```bash
# Sign image (keyless, ใช้ Sigstore)
cosign sign <image-reference>

# Verify signature
cosign verify <image-reference>

# Sign ด้วย key pair
cosign generate-key-pair
cosign sign --key cosign.key <image-reference>
```

### Supply Chain Security Checklist

| ขั้นตอน (Step)     | เครื่องมือ (Tool) | วัตถุประสงค์ (Purpose)           |
| ------------------ | ----------------- | -------------------------------- |
| SBOM generation    | Syft / Trivy      | สร้าง inventory ของ dependencies |
| Vulnerability scan | Trivy / Grype     | ตรวจหา CVEs ใน dependencies      |
| Image signing      | cosign            | ยืนยัน integrity ของ image       |
| Provenance         | SLSA framework    | พิสูจน์ที่มาของ build            |
| License check      | Syft              | ตรวจสอบ license compliance       |

---

## 5. Runtime Security

### SecurityContext (Kubernetes)

```yaml
apiVersion: v1
kind: Pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 65534
    fsGroup: 65534
  containers:
    - name: app
      image: myapp:latest
      securityContext:
        readOnlyRootFilesystem: true
        allowPrivilegeEscalation: false
        capabilities:
          drop:
            - ALL
          add:
            - NET_BIND_SERVICE # เฉพาะที่จำเป็น
        seccompProfile:
          type: RuntimeDefault
      volumeMounts:
        - name: tmp
          mountPath: /tmp
  volumes:
    - name: tmp
      emptyDir: {}
```

### Docker Runtime Security

```bash
# Read-only filesystem
docker run --read-only --tmpfs /tmp myapp

# Drop all capabilities
docker run --cap-drop ALL myapp

# Resource limits
docker run --memory=512m --cpus=1 myapp
```

### Falco Runtime Detection Rules

```yaml
# ตรวจจับ shell ใน container
- rule: Shell Spawned in Container
  desc: ตรวจพบ shell process ถูกเปิดใน container
  condition: >
    spawned_process and container and
    proc.name in (bash, sh, zsh, dash)
  output: >
    Shell spawned in container
    (user=%user.name container=%container.name shell=%proc.name)
  priority: WARNING
  tags: [container, shell, mitre_execution]

# ตรวจจับการเขียนไฟล์ใน sensitive directories
- rule: Write Below Etc in Container
  desc: ตรวจพบการเขียนไฟล์ใน /etc ภายใน container
  condition: >
    open_write and container and fd.name startswith /etc
  output: >
    File written below /etc in container
    (file=%fd.name container=%container.name)
  priority: ERROR
  tags: [container, filesystem, mitre_persistence]
```

---

## 6. CI/CD Integration

### GitHub Actions — Container Security Pipeline

```yaml
name: Container Security

on:
  push:
    branches: [main]
  pull_request:

jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build image
        run: docker build -t myapp:${{ github.sha }} .

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: "myapp:${{ github.sha }}"
          format: "sarif"
          output: "trivy-results.sarif"
          severity: "HIGH,CRITICAL"
          exit-code: "1"

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v3
        if: always()
        with:
          sarif_file: "trivy-results.sarif"

      - name: Generate SBOM
        uses: anchore/sbom-action@v0
        with:
          image: myapp:${{ github.sha }}
          format: cyclonedx-json
          output-file: sbom.json

      - name: Upload SBOM
        uses: actions/upload-artifact@v4
        with:
          name: sbom
          path: sbom.json
```

### Gate Criteria สำหรับ CI/CD

| Gate               | เงื่อนไข (Condition)      | Action           |
| ------------------ | ------------------------- | ---------------- |
| Vulnerability gate | CRITICAL CVE found        | Block deployment |
| SBOM gate          | SBOM ไม่ถูก generate      | Block deployment |
| Base image gate    | Base image > 30 days old  | Warning          |
| Signature gate     | Image unsigned            | Block deployment |
| License gate       | Copyleft license detected | Warning          |

---

## 7. CIS Docker Benchmark & Compliance

### Docker Bench Security

```bash
# Run CIS Docker Benchmark
docker run --rm --net host --pid host --userns host \
  --cap-add audit_control \
  -v /etc:/etc:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  docker/docker-bench-security
```

### Trivy Compliance Checks

```bash
# CIS Docker Benchmark
trivy image --compliance docker-cis nginx:latest

# CIS Kubernetes Benchmark
trivy k8s --compliance k8s-cis cluster
```

### CIS Docker Benchmark Key Areas

| Section                       | คำอธิบาย (Description) | ตัวอย่าง (Examples)                   |
| ----------------------------- | ---------------------- | ------------------------------------- |
| 1. Host Configuration         | Host OS hardening      | Audit Docker daemon, restrict network |
| 2. Docker Daemon              | Daemon configuration   | TLS, ulimits, logging                 |
| 3. Docker Files               | File permissions       | Socket, config files                  |
| 4. Container Images           | Image security         | No secrets, minimal packages          |
| 5. Container Runtime          | Runtime security       | No privileged, read-only              |
| 6. Docker Security Operations | Operational security   | Vulnerability scanning, monitoring    |

---

## 8. Security Checklist (เช็คลิสต์ความปลอดภัย)

### Pre-Build (ก่อน Build)

- [ ] ใช้ minimal base image (Alpine, Distroless, Scratch)
- [ ] Pin image versions ด้วย SHA digest
- [ ] Scan base image สำหรับ CVEs
- [ ] Review Dockerfile สำหรับ misconfigurations
- [ ] ไม่มี secrets ใน Dockerfile

### Build (ระหว่าง Build)

- [ ] ใช้ multi-stage builds
- [ ] Run เป็น non-root user
- [ ] ไม่มี secrets ใน image layers
- [ ] Install เฉพาะ packages ที่จำเป็น
- [ ] ใช้ `.dockerignore` เพื่อ exclude files ที่ไม่ต้องการ

### Post-Build (หลัง Build)

- [ ] Scan image สำหรับ vulnerabilities (Trivy/Grype)
- [ ] Generate SBOM (Syft/Trivy)
- [ ] Sign image ด้วย cosign
- [ ] Push ไปยัง secure registry
- [ ] Tag ด้วย build metadata (SHA, timestamp)

### Runtime (ขณะ Run)

- [ ] Read-only root filesystem
- [ ] Drop ALL capabilities (add เฉพาะที่จำเป็น)
- [ ] Resource limits (memory, CPU)
- [ ] Network policies applied
- [ ] Seccomp profile enabled
- [ ] No privileged mode
- [ ] Monitoring ด้วย Falco หรือเทียบเท่า
