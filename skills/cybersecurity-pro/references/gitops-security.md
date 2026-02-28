# GitOps Security Workflows Reference

คู่มือการสร้าง GitOps-native Security Configurations และ Policy-as-Code

> สำหรับ DevSecOps CI/CD pipeline → ดู references/devsecops-pipeline.md (Domain 3)
> สำหรับ container security → ดู references/container-supply-chain.md (Domain 7)
> สำหรับ Zero Trust policies → ดู references/zero-trust-architecture.md (Domain 11)
> สำหรับ end-to-end supply chain workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 3: DevSecOps Pipeline → `references/devsecops-pipeline.md`
- Domain 7: Container & Supply Chain → `references/container-supply-chain.md`
- Domain 11: Zero Trust Architecture → `references/zero-trust-architecture.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 20: Post-Quantum Cryptography → `references/post-quantum-cryptography.md`

## Table of Contents

1. GitOps Security Architecture
2. ArgoCD Security Configurations
3. Flux Security Configurations
4. OPA/Gatekeeper Policies
5. Kyverno Policies
6. Git-based Secret Management
7. Drift Detection & Remediation
8. Compliance Automation
9. Security Monitoring in GitOps

---

## 1. GitOps Security Architecture

หลักการ GitOps สำหรับ Security: ทุก security configuration ต้องอยู่ใน Git เป็น single source of truth

```
┌─────────────────────────────────────────────────────────────┐
│                    Git Repository (Source of Truth)           │
│                                                              │
│  ├── policies/          # OPA/Gatekeeper/Kyverno policies   │
│  ├── network-policies/  # Kubernetes NetworkPolicy           │
│  ├── rbac/             # RBAC configurations                 │
│  ├── secrets/          # Sealed Secrets / SOPS encrypted     │
│  ├── admission/        # Admission controller configs        │
│  └── compliance/       # Compliance-as-code definitions      │
└──────────────┬──────────────────────────────────────────────┘
               │
               ▼ (Sync)
┌──────────────────────────┐     ┌─────────────────────────┐
│  ArgoCD / Flux            │────▶│  Kubernetes Cluster      │
│  (GitOps Operator)        │     │                          │
│  • Continuous sync         │     │  ├── Gatekeeper/Kyverno │
│  • Drift detection         │     │  ├── NetworkPolicies    │
│  • Auto-remediation        │     │  ├── RBAC bindings      │
│  • Audit logging           │     │  ├── Sealed Secrets     │
└──────────────────────────┘     │  └── Falco (Runtime)    │
                                  └─────────────────────────┘
```

---

## 2. ArgoCD Security Configurations

### ArgoCD RBAC (Security Hardening)

```yaml
# argocd-rbac-cm ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  # กำหนด RBAC policy ตาม principle of least privilege
  policy.csv: |
    # Role: security-admin — จัดการ security policies
    p, role:security-admin, applications, get, security/*, allow
    p, role:security-admin, applications, sync, security/*, allow
    p, role:security-admin, applications, override, security/*, allow

    # Role: security-viewer — ดูได้อย่างเดียว
    p, role:security-viewer, applications, get, */*, allow
    p, role:security-viewer, logs, get, */*, allow

    # Role: developer — จัดการ app ของตัวเอง, ไม่แตะ security
    p, role:developer, applications, get, dev/*, allow
    p, role:developer, applications, sync, dev/*, allow
    p, role:developer, applications, get, security/*, deny

    # Group mappings (OIDC/LDAP groups)
    g, security-team, role:security-admin
    g, soc-team, role:security-viewer
    g, dev-team, role:developer

  policy.default: role:''
  scopes: "[groups]"
```

### ArgoCD Application สำหรับ Security Policies

```yaml
# security-policies-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: security-policies
  namespace: argocd
  annotations:
    # แจ้งเตือนเมื่อ sync ไม่สำเร็จ
    notifications.argoproj.io/subscribe.on-sync-failed.slack: security-alerts
spec:
  project: security
  source:
    repoURL: https://git.example.com/security/policies.git
    targetRevision: main
    path: policies/
  destination:
    server: https://kubernetes.default.svc
    namespace: gatekeeper-system
  syncPolicy:
    automated:
      prune: true # ลบ resource ที่ไม่อยู่ใน Git
      selfHeal: true # แก้ไข drift อัตโนมัติ
      allowEmpty: false # ป้องกันการลบ policies ทั้งหมด
    syncOptions:
      - CreateNamespace=false
      - PruneLast=true
      - ApplyOutOfSyncOnly=true
    retry:
      limit: 3
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

---

## 3. OPA/Gatekeeper Policies

### Constraint Template: ห้ามใช้ Container ที่ run as root

```yaml
# templates/container-no-root.yaml
apiVersion: templates.gatekeeper.sh/v1
kind: ConstraintTemplate
metadata:
  name: k8scontainernorootuser
spec:
  crd:
    spec:
      names:
        kind: K8sContainerNoRootUser
      validation:
        openAPIV3Schema:
          type: object
          properties:
            exemptImages:
              type: array
              items:
                type: string
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package k8scontainernorootuser

        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not is_exempt(container.image)
          has_root_user(container)
          msg := sprintf("Container '%v' ห้าม run as root user. กรุณากำหนด runAsNonRoot: true", [container.name])
        }

        violation[{"msg": msg}] {
          container := input.review.object.spec.initContainers[_]
          not is_exempt(container.image)
          has_root_user(container)
          msg := sprintf("Init container '%v' ห้าม run as root user", [container.name])
        }

        has_root_user(container) {
          not container.securityContext.runAsNonRoot
        }
        has_root_user(container) {
          container.securityContext.runAsUser == 0
        }

        is_exempt(image) {
          exempt := input.parameters.exemptImages[_]
          startswith(image, exempt)
        }
```

### Constraint: Apply the template

```yaml
# constraints/container-no-root.yaml
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sContainerNoRootUser
metadata:
  name: container-must-not-run-as-root
spec:
  enforcementAction: deny # deny | dryrun | warn
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
      - apiGroups: ["apps"]
        kinds: ["Deployment", "StatefulSet", "DaemonSet"]
    namespaces:
      - production
      - staging
    excludedNamespaces:
      - kube-system
      - monitoring
  parameters:
    exemptImages:
      - "registry.example.com/infra/"
```

### Common Security Policies ที่ควรมี

| Policy                   | วัตถุประสงค์ (Purpose)             | Enforcement             |
| ------------------------ | ---------------------------------- | ----------------------- |
| no-root-containers       | ห้าม container run as root         | deny (prod), warn (dev) |
| require-resource-limits  | บังคับ CPU/memory limits           | deny (all)              |
| allowed-registries       | จำกัด image registries ที่อนุญาต   | deny (prod/staging)     |
| require-labels           | บังคับ labels (owner, team, env)   | deny (all)              |
| no-privileged-containers | ห้าม privileged mode               | deny (all)              |
| require-network-policy   | ทุก namespace ต้องมี NetworkPolicy | warn → deny             |
| no-latest-tag            | ห้ามใช้ :latest tag                | deny (prod), warn (dev) |
| require-probes           | บังคับ liveness/readiness probes   | deny (prod)             |
| limit-host-paths         | จำกัด hostPath volumes             | deny (all)              |
| require-encryption       | บังคับ TLS สำหรับ Ingress          | deny (prod)             |

---

## 4. Git-based Secret Management

### Option 1: Sealed Secrets

```bash
# ติดตั้ง Sealed Secrets controller
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/controller.yaml

# Encrypt secret ด้วย kubeseal
echo -n "<REPLACE_WITH_YOUR_SECRET>" | kubectl create secret generic db-creds \
  --from-file=password=/dev/stdin \
  --dry-run=client -o yaml | \
  kubeseal --format yaml > sealed-db-creds.yaml

# sealed-db-creds.yaml สามารถ commit ลง Git ได้อย่างปลอดภัย
```

### Option 2: SOPS + Age/KMS

```yaml
# .sops.yaml — config สำหรับ Mozilla SOPS
creation_rules:
  - path_regex: secrets/production/.*\.yaml$
    encrypted_regex: "^(data|stringData)$"
    kms: "arn:aws:kms:<REGION>:<ACCOUNT_ID>:key/<KEY_ID>" # AWS KMS
  - path_regex: secrets/staging/.*\.yaml$
    encrypted_regex: "^(data|stringData)$"
    age: "age1<YOUR_AGE_PUBLIC_KEY>" # Age key สำหรับ staging
```

```bash
# Encrypt
sops --encrypt secrets/production/db-creds.yaml > secrets/production/db-creds.enc.yaml

# Decrypt (สำหรับ edit)
sops secrets/production/db-creds.enc.yaml

# ArgoCD + SOPS plugin จะ decrypt อัตโนมัติตอน sync
```

### Option 3: External Secrets Operator

```yaml
# ExternalSecret — ดึง secret จาก AWS Secrets Manager / Vault
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-credentials
  namespace: production
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: db-credentials
    creationPolicy: Owner
  data:
    - secretKey: password
      remoteRef:
        key: production/database/credentials
        property: password
```

---

## 5. Drift Detection & Remediation

### ArgoCD Drift Detection

ArgoCD ตรวจ drift อัตโนมัติ — เมื่อ cluster state ไม่ตรงกับ Git:

```yaml
# ตั้งค่าให้ auto-heal (แก้ drift อัตโนมัติ)
syncPolicy:
  automated:
    selfHeal: true # แก้ drift กลับเป็นตาม Git


# สำหรับ security policies → แนะนำ selfHeal: true เสมอ
# เพราะ manual changes อาจเป็น unauthorized modifications
```

### Alerting on Drift

```yaml
# ArgoCD Notification — แจ้งเตือนเมื่อเกิด drift
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
data:
  trigger.on-health-degraded: |
    - when: app.status.health.status == 'Degraded'
      send: [slack-security-alert]
  trigger.on-sync-status-unknown: |
    - when: app.status.sync.status == 'Unknown'
      send: [slack-security-alert]
  template.slack-security-alert: |
    message: |
      ⚠️ Security Policy Drift Detected!
      Application: {{.app.metadata.name}}
      Status: {{.app.status.sync.status}}
      Health: {{.app.status.health.status}}
      Details: {{.context.argocdUrl}}/applications/{{.app.metadata.name}}
```

---

## 6. Compliance Automation

### Compliance-as-Code Structure

```
compliance/
├── cis-benchmark/
│   ├── kubernetes/
│   │   ├── 1.1-control-plane.yaml    # CIS K8s Benchmark
│   │   ├── 4.1-worker-nodes.yaml
│   │   └── 5.1-policies.yaml
│   └── docker/
│       └── docker-bench.yaml
├── nist-800-53/
│   ├── ac-access-control.yaml
│   ├── au-audit.yaml
│   └── sc-system-comms.yaml
├── pci-dss/
│   ├── req-1-firewall.yaml
│   ├── req-6-secure-dev.yaml
│   └── req-10-logging.yaml
└── pdpa-thailand/
    ├── data-classification.yaml
    └── data-protection.yaml
```

### Mapping Policies to Compliance Controls

```yaml
# Example: Policy with compliance annotations
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sRequireEncryption
metadata:
  name: require-tls-ingress
  labels:
    compliance.framework: "nist-800-53"
    compliance.control: "SC-8"
    compliance.requirement: "Transmission Confidentiality"
    compliance.framework-2: "pci-dss-v4"
    compliance.control-2: "4.2.1"
  annotations:
    description: "บังคับ TLS encryption สำหรับทุก Ingress ตาม NIST SC-8 และ PCI DSS 4.2.1"
```

---

## 7. Security Monitoring in GitOps

### Runtime Security with Falco

```yaml
# Falco rules ที่ deploy ผ่าน GitOps
- rule: Terminal Shell in Container
  desc: ตรวจจับการเปิด shell ใน container (อาจเป็น lateral movement)
  condition: >
    spawned_process and container and
    proc.name in (bash, sh, zsh, ksh, csh) and
    not proc.pname in (cron, crond, supervisord)
  output: >
    Shell opened in container
    (user=%user.name container=%container.name
     image=%container.image.repository
     command=%proc.cmdline
     k8s.pod=%k8s.pod.name
     k8s.ns=%k8s.ns.name)
  priority: WARNING
  tags: [container, shell, mitre_execution, T1059]

- rule: Sensitive File Access
  desc: ตรวจจับการเข้าถึงไฟล์ sensitive (credentials, keys)
  condition: >
    open_read and container and
    (fd.name startswith /etc/shadow or
     fd.name startswith /etc/kubernetes/pki or
     fd.name contains .kube/config)
  output: >
    Sensitive file accessed in container
    (file=%fd.name user=%user.name container=%container.name)
  priority: CRITICAL
  tags: [container, credential_access, mitre_credential_access, T1552]
```

### Security Audit Trail

ทุก Git commit ที่เปลี่ยน security configuration = audit trail อัตโนมัติ:

- **Who**: Git commit author (require signed commits ด้วย GPG)
- **What**: Diff ของ changes
- **When**: Commit timestamp
- **Why**: Commit message + PR description
- **Approval**: PR review + approval records

```bash
# บังคับ signed commits สำหรับ security repo
git config commit.gpgsign true

# Branch protection rules (ตั้งใน Git platform)
# - Require PR review จาก security team (อย่างน้อย 2 คน)
# - Require signed commits
# - No force push
# - Require status checks to pass
```
