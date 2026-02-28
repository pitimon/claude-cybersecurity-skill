# Cloud Security & CSPM Reference

คู่มือความปลอดภัยบนคลาวด์และ Cloud Security Posture Management (CSPM) — ครอบคลุม multi-cloud (AWS, Azure, GCP)
พร้อม IAM hardening, storage security, network controls, IaC security และ compliance checklists

> สำหรับ container security และ supply chain → ดู references/container-supply-chain.md
> สำหรับ compliance frameworks (NIST 800-53, PCI DSS, CIS Controls) → ดู references/compliance-frameworks.md
> สำหรับ end-to-end cloud compliance workflow → ดู references/cross-domain-integration.md (Domain 16)

**Cross-references:**

- Domain 7: Container & Supply Chain → `references/container-supply-chain.md`
- Domain 9: Compliance Frameworks → `references/compliance-frameworks.md`
- Domain 16: Cross-Domain Integration → `references/cross-domain-integration.md`
- Domain 18: OT/ICS Security → `references/ot-ics-security.md`
- Domain 21: Identity & Access Security → `references/identity-access-security.md`

## Table of Contents

1. Cloud Security Architecture Overview
2. IAM Security Policies
3. Cloud Storage Security
4. Network Security Controls
5. CSPM Tools & Rules
6. Cloud Audit & Logging
7. Infrastructure as Code Security
8. Cloud Security Checklist

---

## 1. สถาปัตยกรรมความปลอดภัยบนคลาวด์ (Cloud Security Architecture Overview)

### Shared Responsibility Model

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Shared Responsibility Model                          │
├─────────────────────┬──────────────────┬────────────────────────────────┤
│       IaaS          │      PaaS        │          SaaS                  │
├─────────────────────┼──────────────────┼────────────────────────────────┤
│ Customer รับผิดชอบ:  │ Customer:        │ Customer:                      │
│ ├── Data            │ ├── Data         │ ├── Data                       │
│ ├── Applications    │ ├── Applications │ ├── User access                │
│ ├── OS & Patching   │ ├── User access  │ └── Configuration              │
│ ├── Network config  │ └── Configuration│                                │
│ ├── Firewall rules  │                  │                                │
│ └── IAM             │                  │                                │
├─────────────────────┼──────────────────┼────────────────────────────────┤
│ Provider รับผิดชอบ:  │ Provider:        │ Provider:                      │
│ ├── Hypervisor      │ ├── OS & Runtime │ ├── Applications               │
│ ├── Physical host   │ ├── Hypervisor   │ ├── OS & Runtime               │
│ ├── Network infra   │ ├── Physical     │ ├── Hypervisor                 │
│ ├── Storage infra   │ ├── Network      │ ├── Physical                   │
│ └── Facility        │ └── Facility     │ └── Network + Facility         │
└─────────────────────┴──────────────────┴────────────────────────────────┘

หลักการ: ยิ่งเป็น managed service (PaaS/SaaS) มากขึ้น provider รับผิดชอบมากขึ้น
แต่ Customer ยังรับผิดชอบ Data และ Access Control เสมอ
```

### Cloud Security Pillars

```
                    Cloud Security Pillars
┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐
│ Identity  │ │ Network   │ │   Data    │ │Application│ │  Infra    │
│           │ │           │ │           │ │           │ │           │
│ • IAM     │ │ • VPC     │ │ • Encrypt │ │ • WAF     │ │ • Patching│
│ • MFA     │ │ • SG/NSG  │ │ • DLP     │ │ • API GW  │ │ • Hardening│
│ • SSO     │ │ • Private │ │ • Classify│ │ • Runtime │ │ • CIS     │
│ • Least   │ │   Link    │ │ • Backup  │ │   protect │ │   Benchmark│
│   Privilege│ │ • Firewall│ │ • Retain  │ │ • Secrets │ │ • CSPM    │
└───────────┘ └───────────┘ └───────────┘ └───────────┘ └───────────┘
```

### Multi-Cloud vs Single-Cloud Strategy

| ปัจจัย (Factor)     | Single-Cloud                    | Multi-Cloud                                     |
| ------------------- | ------------------------------- | ----------------------------------------------- |
| Complexity          | ต่ำ — เรียนรู้ ecosystem เดียว  | สูง — ต้อง maintain ความรู้หลาย providers       |
| Vendor lock-in      | สูง — ผูกกับ provider เดียว     | ต่ำ — กระจายความเสี่ยง                          |
| Security tooling    | Native tools ครบ, integrated ดี | ต้องใช้ third-party tools ที่รองรับ multi-cloud |
| IAM management      | ง่าย — policy model เดียว       | ซับซ้อน — ต้อง map IAM ข้าม providers           |
| Compliance          | ง่ายกว่า — audit scope เล็ก     | ต้อง audit แต่ละ provider แยก                   |
| Cost optimization   | Commitment discounts ได้มาก     | Spot/preemptible ข้าม providers ได้             |
| Disaster recovery   | Cross-region ภายใน provider     | Cross-provider DR ที่แข็งแกร่งกว่า              |
| เหมาะกับ (Best for) | Startups, เริ่มต้น, team เล็ก   | Enterprise, regulated industries                |

---

## 2. นโยบายการจัดการตัวตนและสิทธิ์ (IAM Security Policies)

### AWS IAM Least Privilege Policy Template

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSpecificS3Access",
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::my-app-bucket",
        "arn:aws:s3:::my-app-bucket/*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "ap-southeast-1"
        }
      }
    },
    {
      "Sid": "DenyAccessWithoutMFA",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    },
    {
      "Sid": "DenyAccessOutsideTrustedNetwork",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": ["10.0.0.0/8", "172.16.0.0/12"]
        },
        "StringNotLike": {
          "aws:PrincipalArn": "arn:aws:iam::*:role/aws-service-role/*"
        }
      }
    }
  ]
}
```

### Cross-Cloud IAM Comparison

| Feature               | AWS IAM                      | Azure RBAC / Entra ID          | GCP IAM                          |
| --------------------- | ---------------------------- | ------------------------------ | -------------------------------- |
| Identity provider     | IAM Users, Roles, Groups     | Entra ID (Azure AD)            | Google Workspace, Cloud Identity |
| Policy model          | JSON policy documents        | Role definitions + assignments | IAM roles + bindings             |
| Least privilege tool  | IAM Access Analyzer          | Entra ID Access Reviews        | IAM Recommender                  |
| Service accounts      | IAM Roles (AssumeRole)       | Managed Identity               | Service Accounts + WIF           |
| Cross-account access  | AssumeRole + trust policy    | Lighthouse / B2B               | Cross-project IAM bindings       |
| MFA enforcement       | IAM Policy condition         | Conditional Access Policies    | Context-aware access             |
| Temporary credentials | STS AssumeRole (max 12h)     | Managed Identity (auto-rotate) | Workload Identity Federation     |
| Audit tool            | CloudTrail + Access Analyzer | Entra ID Sign-in Logs          | Cloud Audit Logs + Recommender   |
| Permission boundary   | Permissions Boundary         | Management Group scope         | Organization Policy constraints  |

### Service Account Security Checklist

- [ ] ไม่ใช้ long-lived access keys — ใช้ temporary credentials หรือ workload identity แทน
- [ ] Service accounts มี least privilege permissions เท่านั้น
- [ ] Rotate credentials ทุก 90 วัน (หากใช้ keys)
- [ ] ไม่ embed credentials ใน source code หรือ container images
- [ ] ใช้ Workload Identity Federation (GCP) / IAM Roles for Service Accounts (AWS) / Managed Identity (Azure)
- [ ] Disable unused service accounts หลัง 90 วัน inactive
- [ ] Monitor service account usage ผ่าน audit logs
- [ ] ห้ามให้ service account มี console login access
- [ ] จำกัด scope ของ service account ให้เฉพาะ resource ที่จำเป็น
- [ ] ใช้ separate service accounts ต่อ workload (ไม่ share)

### Cross-Account / Cross-Project Access Patterns

```
AWS Cross-Account Access:
┌──────────────┐    AssumeRole     ┌──────────────┐
│ Account A    │ ─────────────────▶│ Account B    │
│ (Source)     │    Trust Policy    │ (Target)     │
│              │                    │              │
│ Role: caller │                    │ Role: target │
│ Policy:      │                    │ Trust:       │
│  Allow       │                    │  Account A   │
│  AssumeRole  │                    │  principal   │
└──────────────┘                    └──────────────┘

Azure Cross-Tenant:
Entra ID B2B → Guest access → RBAC assignment → Resource scope

GCP Cross-Project:
IAM binding → serviceAccount:sa@project-a → roles/viewer → project-b
```

### IAM Audit Queries

```sql
-- AWS CloudTrail: ตรวจสอบ IAM changes ใน 7 วัน
SELECT eventTime, eventName, userIdentity.arn, sourceIPAddress, requestParameters
FROM cloudtrail_logs
WHERE eventSource = 'iam.amazonaws.com'
  AND eventName IN ('CreateUser', 'AttachUserPolicy', 'CreateAccessKey',
                     'PutUserPolicy', 'AddUserToGroup', 'CreateRole')
  AND eventTime > date_add('day', -7, now())
ORDER BY eventTime DESC;
```

```kql
// Azure Activity Log: ตรวจสอบ role assignment changes
AzureActivity
| where OperationNameValue has_any ("Microsoft.Authorization/roleAssignments/write",
    "Microsoft.Authorization/roleAssignments/delete")
| where TimeGenerated > ago(7d)
| project TimeGenerated, Caller, OperationNameValue, Properties, ResourceGroup
| order by TimeGenerated desc
```

```sql
-- GCP Audit Log: ตรวจสอบ IAM policy changes
SELECT timestamp, protopayload_auditlog.methodName,
       protopayload_auditlog.authenticationInfo.principalEmail,
       protopayload_auditlog.resourceName
FROM `project.dataset.cloudaudit_googleapis_com_activity`
WHERE protopayload_auditlog.methodName LIKE '%SetIamPolicy%'
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
ORDER BY timestamp DESC;
```

---

## 3. ความปลอดภัยของ Storage บนคลาวด์ (Cloud Storage Security)

### S3 Bucket Security Checklist

- [ ] **Block Public Access** — เปิด S3 Block Public Access ทุก 4 settings ที่ account level
- [ ] **Encryption at rest** — เปิด SSE-S3 (default) หรือ SSE-KMS สำหรับ sensitive data
- [ ] **Encryption in transit** — Enforce TLS ผ่าน bucket policy (`aws:SecureTransport`)
- [ ] **Versioning** — เปิด versioning สำหรับ critical data (ป้องกัน accidental delete)
- [ ] **MFA Delete** — เปิดสำหรับ production buckets ที่สำคัญ
- [ ] **Access Logging** — เปิด Server Access Logging หรือ CloudTrail data events
- [ ] **Lifecycle rules** — กำหนด retention policy และ transition ไป cheaper tiers
- [ ] **Object Lock** — ใช้สำหรับ compliance data ที่ต้อง immutable (WORM)
- [ ] **Bucket policy** — Review ว่าไม่มี wildcard principal (`"Principal": "*"`)
- [ ] **ACL disabled** — ใช้ bucket policies แทน ACLs (ACL disabled = recommended)

### Multi-Cloud Storage Security Comparison

| Security Control         | AWS S3                   | Azure Blob Storage              | GCP Cloud Storage               |
| ------------------------ | ------------------------ | ------------------------------- | ------------------------------- |
| Public access block      | S3 Block Public Access   | Allow Blob Public Access: false | Public Access Prevention        |
| Default encryption       | SSE-S3 (AES-256) default | SSE with Microsoft-managed keys | Google-managed encryption keys  |
| Customer-managed keys    | SSE-KMS (AWS KMS)        | SSE with CMK (Azure Key Vault)  | CMEK (Cloud KMS)                |
| Access logging           | Server Access Logging    | Azure Monitor / Diagnostic Logs | Cloud Audit Logs (Data Access)  |
| Versioning               | Bucket Versioning        | Blob Versioning                 | Object Versioning               |
| Immutable storage        | Object Lock (WORM)       | Immutable Blob Storage          | Retention Policy + Bucket Lock  |
| Data classification      | Macie                    | Microsoft Purview               | Cloud DLP                       |
| Cross-region replication | S3 Replication Rules     | Object Replication              | Dual-region / Turbo Replication |
| Access control model     | Bucket Policy + IAM      | Azure RBAC + SAS tokens         | IAM + ACLs + Signed URLs        |

### Data Classification for Cloud Storage

| Classification   | คำอธิบาย (Description)                      | Encryption            | Access Control                       | Logging          | ตัวอย่าง (Examples)        |
| ---------------- | ------------------------------------------- | --------------------- | ------------------------------------ | ---------------- | -------------------------- |
| **Public**       | ข้อมูลเปิดเผยได้ ไม่มี impact               | SSE default           | Read-only public                     | Standard         | Marketing assets, docs     |
| **Internal**     | ข้อมูลภายในองค์กร ไม่ควรเปิดเผย             | SSE default           | IAM authenticated                    | Standard         | Internal reports, code     |
| **Confidential** | ข้อมูลที่ leak แล้วเกิด business impact     | SSE-KMS (CMK)         | Strict IAM + MFA                     | Data event logs  | Financial data, PII        |
| **Restricted**   | ข้อมูลที่ leak แล้วเกิด severe/legal impact | SSE-KMS + Object Lock | Least privilege + MFA + VPC endpoint | Full audit trail | PHI, payment data, secrets |

---

## 4. การควบคุมความปลอดภัยเครือข่าย (Network Security Controls)

### VPC / VNet Design Patterns

```
┌─────────────────────────────────────────────────────────────────┐
│                         VPC / VNet                               │
│                         10.0.0.0/16                              │
│                                                                  │
│  ┌─────────────────────┐     ┌─────────────────────┐            │
│  │  Public Subnet       │     │  Public Subnet       │            │
│  │  10.0.1.0/24 (AZ-a) │     │  10.0.2.0/24 (AZ-b) │            │
│  │  ├── ALB/NLB         │     │  ├── ALB/NLB         │            │
│  │  ├── NAT Gateway     │     │  ├── NAT Gateway     │            │
│  │  └── Bastion Host    │     │  └── (redundancy)    │            │
│  └──────────┬──────────┘     └──────────┬──────────┘            │
│             │                            │                       │
│  ┌──────────▼──────────┐     ┌──────────▼──────────┐            │
│  │  Private Subnet      │     │  Private Subnet      │            │
│  │  10.0.10.0/24 (AZ-a)│     │  10.0.20.0/24 (AZ-b)│            │
│  │  ├── App servers     │     │  ├── App servers     │            │
│  │  └── Containers      │     │  └── Containers      │            │
│  └──────────┬──────────┘     └──────────┬──────────┘            │
│             │                            │                       │
│  ┌──────────▼──────────┐     ┌──────────▼──────────┐            │
│  │  Data Subnet         │     │  Data Subnet         │            │
│  │  10.0.100.0/24 (AZ-a)│    │  10.0.200.0/24 (AZ-b)│           │
│  │  ├── RDS / Database  │     │  ├── RDS replica     │            │
│  │  └── ElastiCache     │     │  └── ElastiCache     │            │
│  └─────────────────────┘     └─────────────────────┘            │
│                                                                  │
│  VPC Endpoints: S3, DynamoDB, KMS, Secrets Manager, ECR          │
│  Flow Logs: Enabled → CloudWatch Logs / S3                       │
└─────────────────────────────────────────────────────────────────┘
```

### Security Group / NSG Review Checklist

- [ ] ไม่มี rule ที่เปิด `0.0.0.0/0` inbound ยกเว้น port 80/443 สำหรับ public load balancer
- [ ] SSH (port 22) / RDP (port 3389) ไม่เปิดให้ `0.0.0.0/0` — ใช้ bastion หรือ SSM/IAP แทน
- [ ] Database ports (3306, 5432, 27017, 6379) accessible เฉพาะจาก application subnet
- [ ] Outbound rules จำกัดเฉพาะ destinations ที่จำเป็น (ไม่ใช่ allow all)
- [ ] ใช้ security group references แทน IP ranges เมื่อทำได้
- [ ] Review และ remove unused security groups ทุกไตรมาส
- [ ] Document purpose ของทุก rule ด้วย description field
- [ ] ใช้ VPC Flow Logs เพื่อ validate ว่า rules ตรงกับ actual traffic

### Network Segmentation Best Practices

| Layer             | Segmentation Method              | ตัวอย่างการใช้งาน                          |
| ----------------- | -------------------------------- | ------------------------------------------ |
| VPC/VNet level    | Separate VPCs per environment    | Production VPC, Staging VPC, Dev VPC       |
| Subnet level      | Public / Private / Data subnets  | ALB → App → Database (3-tier)              |
| Security Group    | Per-service / per-role SG        | web-sg, app-sg, db-sg, bastion-sg          |
| Network ACL       | Subnet-level stateless filtering | Block known malicious CIDR ranges          |
| Service Mesh      | mTLS between microservices       | Istio / Linkerd sidecar proxies            |
| Private endpoints | VPC Endpoints / PrivateLink      | Access AWS services without internet       |
| Transit Gateway   | Hub-and-spoke network topology   | Centralize VPC-to-VPC routing + inspection |

### Private Endpoint / PrivateLink Patterns

```
แนะนำ: ใช้ Private Endpoint สำหรับทุก managed service ที่รองรับ

AWS:
  VPC Endpoint (Gateway)  → S3, DynamoDB (ไม่มีค่าใช้จ่ายเพิ่ม)
  VPC Endpoint (Interface) → KMS, Secrets Manager, ECR, STS, CloudWatch
  PrivateLink              → Cross-account / third-party services

Azure:
  Private Endpoint → Storage, SQL Database, Key Vault, ACR
  Service Endpoint → ง่ายกว่าแต่ traffic ยังผ่าน Microsoft backbone

GCP:
  Private Google Access     → Access Google APIs from private subnet
  Private Service Connect   → Managed services via private IP
  VPC Service Controls      → Data exfiltration prevention perimeter
```

### Multi-Cloud Network Security Comparison

| Feature                  | AWS                         | Azure                       | GCP                          |
| ------------------------ | --------------------------- | --------------------------- | ---------------------------- |
| Virtual network          | VPC                         | VNet                        | VPC                          |
| Firewall (stateful)      | Security Groups             | NSG + Azure Firewall        | Firewall Rules               |
| Firewall (managed)       | AWS Network Firewall        | Azure Firewall Premium      | Cloud Armor + Cloud Firewall |
| DDoS protection          | Shield Standard/Advanced    | DDoS Protection Standard    | Cloud Armor                  |
| DNS security             | Route 53 Resolver + DNSSEC  | Azure DNS + Private DNS     | Cloud DNS + DNSSEC           |
| Private connectivity     | VPC Endpoints / PrivateLink | Private Endpoint            | Private Service Connect      |
| Network monitoring       | VPC Flow Logs               | NSG Flow Logs               | VPC Flow Logs                |
| Web application firewall | AWS WAF                     | Azure WAF (with Front Door) | Cloud Armor WAF              |

---

## 5. เครื่องมือและกฎ CSPM (CSPM Tools & Rules)

### CSPM Overview

Cloud Security Posture Management (CSPM) คือกระบวนการตรวจสอบ configuration ของ cloud resources
อย่างต่อเนื่อง เพื่อหา misconfiguration, compliance violations, และ security risks

```
CSPM ทำอะไร:
├── Misconfiguration detection   → S3 public, SG open, no encryption
├── Compliance monitoring        → CIS Benchmark, NIST 800-53 mapping
├── Risk prioritization          → Severity scoring, blast radius analysis
├── Auto-remediation             → Fix misconfigs via Lambda/Azure Functions
├── Drift detection              → Alert เมื่อ config เปลี่ยนจาก baseline
└── Multi-cloud visibility       → Dashboard รวมทุก providers
```

### Prowler — Top 20 Critical Checks

| #   | Check ID             | คำอธิบาย                                          | AWS CLI Equivalent                                                                                 |
| --- | -------------------- | ------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| 1   | iam_root_mfa         | Root account ต้องมี MFA                           | `aws iam get-account-summary \| jq .SummaryMap.AccountMFAEnabled`                                  |
| 2   | iam_no_root_keys     | Root account ต้องไม่มี access keys                | `aws iam get-account-summary \| jq .SummaryMap.AccountAccessKeysPresent`                           |
| 3   | iam_password_policy  | Password policy ต้อง enforce complexity           | `aws iam get-account-password-policy`                                                              |
| 4   | s3_public_access     | S3 buckets ต้องไม่เปิด public                     | `aws s3api get-public-access-block --bucket BUCKET`                                                |
| 5   | s3_encryption        | S3 buckets ต้องเปิด encryption                    | `aws s3api get-bucket-encryption --bucket BUCKET`                                                  |
| 6   | ec2_sg_open_ssh      | Security groups ต้องไม่เปิด SSH จาก 0.0.0.0/0     | `aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=22"`                |
| 7   | ec2_sg_open_rdp      | Security groups ต้องไม่เปิด RDP จาก 0.0.0.0/0     | `aws ec2 describe-security-groups --filters "Name=ip-permission.to-port,Values=3389"`              |
| 8   | cloudtrail_enabled   | CloudTrail ต้องเปิดใช้ทุก region                  | `aws cloudtrail describe-trails`                                                                   |
| 9   | cloudtrail_encrypted | CloudTrail logs ต้อง encrypt ด้วย KMS             | `aws cloudtrail describe-trails \| jq '.trailList[].KmsKeyId'`                                     |
| 10  | rds_encryption       | RDS instances ต้องเปิด encryption at rest         | `aws rds describe-db-instances \| jq '.DBInstances[].StorageEncrypted'`                            |
| 11  | rds_public           | RDS instances ต้องไม่เปิด public access           | `aws rds describe-db-instances \| jq '.DBInstances[].PubliclyAccessible'`                          |
| 12  | vpc_flow_logs        | VPCs ต้องเปิด Flow Logs                           | `aws ec2 describe-flow-logs --filter "Name=resource-id,Values=VPC_ID"`                             |
| 13  | ebs_encryption       | EBS volumes ต้องเปิด encryption                   | `aws ec2 describe-volumes \| jq '.Volumes[].Encrypted'`                                            |
| 14  | kms_key_rotation     | KMS keys ต้องเปิด automatic rotation              | `aws kms get-key-rotation-status --key-id KEY_ID`                                                  |
| 15  | guardduty_enabled    | GuardDuty ต้องเปิดใช้งาน                          | `aws guardduty list-detectors`                                                                     |
| 16  | config_enabled       | AWS Config ต้องเปิดใช้ทุก region                  | `aws configservice describe-configuration-recorders`                                               |
| 17  | iam_unused_creds     | IAM credentials ที่ไม่ใช้ > 90 วัน ต้อง disable   | `aws iam generate-credential-report`                                                               |
| 18  | lambda_public        | Lambda functions ต้องไม่มี public resource policy | `aws lambda get-policy --function-name FUNC`                                                       |
| 19  | eks_public_endpoint  | EKS cluster endpoint ต้องไม่เปิด public           | `aws eks describe-cluster --name CLUSTER \| jq '.cluster.resourcesVpcConfig.endpointPublicAccess'` |
| 20  | ecr_image_scan       | ECR repositories ต้องเปิด image scanning          | `aws ecr describe-repositories \| jq '.repositories[].imageScanningConfiguration'`                 |

### Cloud Custodian Policy Examples

```yaml
# cloud-custodian-policies.yml
# Policy 1: ปิด S3 buckets ที่เปิด public access
policies:
  - name: s3-remove-public-access
    resource: s3
    filters:
      - type: global-grants
    actions:
      - type: set-public-block
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

  # Policy 2: Tag EC2 instances ที่ไม่มี Owner tag
  - name: ec2-require-owner-tag
    resource: ec2
    filters:
      - "tag:Owner": absent
    actions:
      - type: mark-for-op
        tag: custodian_cleanup
        op: terminate
        days: 7

  # Policy 3: ปิด security groups ที่เปิด SSH จาก internet
  - name: sg-close-open-ssh
    resource: security-group
    filters:
      - type: ingress
        Ports: [22]
        Cidr: "0.0.0.0/0"
    actions:
      - type: remove-permissions
        ingress: matched
```

### CSPM Tool Comparison

| Feature               | Prowler          | ScoutSuite     | Checkov        | Cloud Custodian    | Commercial (Prisma/Wiz) |
| --------------------- | ---------------- | -------------- | -------------- | ------------------ | ----------------------- |
| License               | Apache 2.0 (CLI) | GPL-2.0        | Apache 2.0     | Apache 2.0         | Proprietary             |
| AWS support           | Excellent        | Good           | IaC focus      | Excellent          | Excellent               |
| Azure support         | Good             | Good           | IaC focus      | Good               | Excellent               |
| GCP support           | Good             | Good           | IaC focus      | Good               | Excellent               |
| Runtime scanning      | Yes              | Yes            | No (IaC only)  | Yes                | Yes                     |
| IaC scanning          | Limited          | No             | Excellent      | No                 | Yes                     |
| Auto-remediation      | Limited          | No             | No             | Excellent          | Yes                     |
| CIS Benchmark mapping | Yes              | Yes            | Yes            | Manual             | Yes                     |
| CI/CD integration     | GitHub Actions   | CLI            | GitHub Actions | CLI                | Full integration        |
| Custom rules          | Python checks    | Limited        | Python/YAML    | YAML policies      | GUI + code              |
| เหมาะกับ (Best for)   | AWS-first audit  | Quick overview | IaC pipelines  | Policy enforcement | Enterprise multi-cloud  |

---

## 6. การตรวจสอบและ Logging บนคลาวด์ (Cloud Audit & Logging)

### Cloud-Native Logging Setup

| Component             | AWS                          | Azure                    | GCP                               |
| --------------------- | ---------------------------- | ------------------------ | --------------------------------- |
| Management plane logs | CloudTrail                   | Azure Activity Log       | Cloud Audit Logs (Admin Activity) |
| Data plane logs       | CloudTrail Data Events       | Diagnostic Settings      | Cloud Audit Logs (Data Access)    |
| Network logs          | VPC Flow Logs                | NSG Flow Logs            | VPC Flow Logs                     |
| DNS logs              | Route 53 Resolver Query Logs | DNS Analytics            | Cloud DNS Logging                 |
| Application logs      | CloudWatch Logs              | Log Analytics Workspace  | Cloud Logging                     |
| Central aggregation   | CloudWatch / S3 + Athena     | Log Analytics / Sentinel | Cloud Logging + BigQuery          |
| SIEM integration      | Security Lake → SIEM         | Sentinel (native)        | Chronicle / Third-party SIEM      |
| Retention (default)   | CloudTrail: 90 days (free)   | Activity Log: 90 days    | Admin Activity: 400 days          |

### Critical Events to Monitor

```markdown
## IAM Events (สำคัญที่สุด — ตรวจสอบทุกวัน)

- [ ] Root account login (ต้องไม่เกิดขึ้นใน normal operations)
- [ ] IAM user/role creation or deletion
- [ ] Policy attachment (inline or managed)
- [ ] Access key creation for IAM users
- [ ] MFA device changes (enable/disable)
- [ ] Cross-account role assumption from unknown accounts

## Network Events

- [ ] Security group / NSG rule changes
- [ ] VPC / VNet creation or deletion
- [ ] Route table modifications
- [ ] VPN / Direct Connect / ExpressRoute changes
- [ ] Public IP association with resources

## Data Events

- [ ] S3 bucket policy changes
- [ ] Encryption settings changes (KMS key deletion schedule)
- [ ] Database snapshot sharing to external accounts
- [ ] Storage account public access changes

## Compute Events

- [ ] EC2/VM instances launched in unusual regions
- [ ] Lambda/Functions with public resource policies
- [ ] Container images pulled from untrusted registries
- [ ] Privileged container execution
```

### Log Analysis Queries

```sql
-- AWS Athena: Unauthorized API calls ใน 24 ชั่วโมง
SELECT eventTime, eventName, userIdentity.arn, errorCode, sourceIPAddress,
       awsRegion, requestParameters
FROM cloudtrail_logs
WHERE errorCode IN ('AccessDenied', 'UnauthorizedAccess', 'Client.UnauthorizedAccess')
  AND eventTime > date_add('hour', -24, now())
ORDER BY eventTime DESC
LIMIT 100;
```

```kql
// Azure KQL: Suspicious sign-in activity
SigninLogs
| where TimeGenerated > ago(24h)
| where ResultType != "0"  // Failed sign-ins
| summarize FailedAttempts = count(), DistinctIPs = dcount(IPAddress)
    by UserPrincipalName, AppDisplayName, bin(TimeGenerated, 1h)
| where FailedAttempts > 10
| order by FailedAttempts desc
```

```sql
-- GCP BigQuery: Data access anomalies
SELECT timestamp, protopayload_auditlog.authenticationInfo.principalEmail,
       protopayload_auditlog.methodName, protopayload_auditlog.resourceName,
       protopayload_auditlog.status.code
FROM `project.dataset.cloudaudit_googleapis_com_data_access`
WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
  AND protopayload_auditlog.methodName LIKE '%storage.objects%'
GROUP BY 1, 2, 3, 4, 5
ORDER BY timestamp DESC
LIMIT 100;
```

### Retention and Compliance Requirements

| Regulation / Standard    | Minimum Retention | ประเภท Logs ที่ต้อง retain                      |
| ------------------------ | ----------------- | ----------------------------------------------- |
| PCI DSS v4.0.1           | 12 months         | Access logs, authentication, system events      |
| HIPAA                    | 6 years           | Access to PHI, system activity, user actions    |
| SOC 2                    | 12 months         | All security-relevant events                    |
| GDPR                     | Per data mapping  | Processing activities, consent, access requests |
| NIST 800-53 (AU-11)      | Per policy        | Audit records per retention policy              |
| CIS Controls v8.1 (8.10) | 90 days minimum   | Audit log data                                  |
| Thai PDPA                | Per data mapping  | Personal data processing activities             |

---

## 7. ความปลอดภัยของ IaC (Infrastructure as Code Security)

### Terraform Security Patterns

```hcl
# terraform/providers.tf — Secure provider configuration
terraform {
  required_version = ">= 1.6.0"

  # State encryption and remote storage
  backend "s3" {
    bucket         = "myorg-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:ap-southeast-1:ACCOUNT:key/KEY_ID"
    dynamodb_table = "terraform-locks"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"  # Pin provider version
    }
  }
}

# ห้ามใช้ default VPC
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = var.team_name
    }
  }
}
```

```hcl
# terraform/secrets.tf — Secrets handling (ห้าม hardcode secrets)
# ดี: ดึง secrets จาก Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "production/db-password"
}

# ดี: ใช้ variable ที่ mark เป็น sensitive
variable "api_key" {
  type      = string
  sensitive = true  # ไม่แสดงใน plan/apply output
}
```

### IaC Scanning Tools Configuration

```yaml
# .checkov.yaml — Checkov configuration
framework:
  - terraform
  - cloudformation
  - kubernetes
  - dockerfile
soft-fail-on:
  - CKV_AWS_18 # S3 access logging (warning only)
skip-check:
  - CKV_AWS_999 # Skip specific checks with documented reason
output:
  - cli
  - sarif
```

```yaml
# .tfsec.yml — tfsec configuration
severity_overrides:
  aws-s3-enable-versioning: LOW # Override severity
  aws-vpc-no-public-ingress: CRITICAL

exclude:
  - modules/legacy/** # Skip legacy modules (documented exception)
```

```yaml
# .pre-commit-config.yaml — IaC security pre-commit hooks
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.96.1
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_tflint

  - repo: https://github.com/bridgecrewio/checkov
    rev: v3.2.0
    hooks:
      - id: checkov
        args: ["--framework", "terraform"]

  - repo: https://github.com/aquasecurity/tfsec
    rev: v1.28.0
    hooks:
      - id: tfsec

  - repo: https://github.com/Checkmarx/kics
    rev: v2.0.0
    hooks:
      - id: kics-scan
```

### IaC Security Tool Comparison

| Feature               | Checkov         | tfsec               | KICS            | Terrascan      |
| --------------------- | --------------- | ------------------- | --------------- | -------------- |
| Terraform             | Yes             | Yes                 | Yes             | Yes            |
| CloudFormation        | Yes             | No                  | Yes             | Yes            |
| Kubernetes manifests  | Yes             | No                  | Yes             | Yes            |
| Dockerfile            | Yes             | No                  | Yes             | Yes            |
| Custom rules          | Python + YAML   | Rego                | Rego            | Rego           |
| SARIF output          | Yes             | Yes                 | Yes             | Yes            |
| IDE integration       | VS Code         | VS Code             | VS Code         | Limited        |
| CI/CD integration     | GitHub Actions  | GitHub Actions      | GitHub Actions  | GitHub Actions |
| CIS Benchmark mapping | Yes             | Partial             | Yes             | Yes            |
| Auto-fix suggestions  | Yes             | No                  | No              | No             |
| เหมาะกับ (Best for)   | Multi-framework | Archived; use Trivy | Multi-framework | Policy-as-code |

### Drift Detection and Remediation

```bash
# Terraform drift detection
# ตรวจสอบว่า actual infrastructure ตรงกับ state
terraform plan -detailed-exitcode
# Exit code 0 = no changes, 1 = error, 2 = changes detected (drift)

# AWS Config สำหรับ continuous drift detection
# ตัวอย่าง rule: ตรวจสอบ S3 encryption ต้องเปิดเสมอ
aws configservice put-config-rule --config-rule '{
  "ConfigRuleName": "s3-default-encryption-kms",
  "Source": {
    "Owner": "AWS",
    "SourceIdentifier": "S3_DEFAULT_ENCRYPTION_KMS"
  },
  "Scope": {
    "ComplianceResourceTypes": ["AWS::S3::Bucket"]
  }
}'
```

```
Drift Remediation Workflow:
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Detect       │ ──▶ │  Alert       │ ──▶ │  Remediate   │
│               │     │               │     │               │
│ • tf plan     │     │ • Slack/Teams │     │ • tf apply    │
│ • AWS Config  │     │ • PagerDuty   │     │ • Auto-fix    │
│ • CSPM tools  │     │ • JIRA ticket │     │ • Manual fix  │
└──────────────┘     └──────────────┘     └──────────────┘

หลักการ: IaC เป็น source of truth — ถ้า drift เกิดขึ้น ต้อง reconcile กลับไปที่ IaC
ห้าม manual change ใน production โดยไม่ update IaC
```

---

## 8. รายการตรวจสอบความปลอดภัยบนคลาวด์ (Cloud Security Checklist)

### Identity & Access Management

- [ ] Root / Global Admin account มี MFA enabled (hardware key preferred)
- [ ] Root account ไม่มี access keys
- [ ] IAM password policy: min 14 chars, complexity, 90-day rotation
- [ ] ทุก human user ใช้ SSO/federation (ไม่สร้าง IAM users)
- [ ] Service accounts ใช้ temporary credentials / workload identity
- [ ] Unused credentials (>90 days) ถูก disable
- [ ] Cross-account access ใช้ roles (ไม่ share credentials)
- [ ] Permission boundaries set สำหรับ delegated admin roles
- [ ] IAM Access Analyzer / Recommender เปิดใช้งาน

### Network Security

- [ ] Default VPC/VNet ถูก remove หรือไม่ใช้งาน
- [ ] VPC Flow Logs / NSG Flow Logs เปิดทุก VPC/VNet
- [ ] No security group rules allowing 0.0.0.0/0 inbound (except 80/443 on ALB)
- [ ] SSH/RDP access ผ่าน bastion / SSM Session Manager / IAP เท่านั้น
- [ ] Private subnets ใช้ NAT Gateway สำหรับ outbound (ไม่มี public IP)
- [ ] VPC Endpoints เปิดสำหรับ managed services ที่ใช้
- [ ] WAF เปิดสำหรับ public-facing applications
- [ ] DDoS protection enabled สำหรับ production workloads

### Data Protection

- [ ] Encryption at rest เปิดสำหรับทุก storage services
- [ ] Encryption in transit (TLS 1.2+) enforced ทุก endpoint
- [ ] Customer-managed keys (CMK) สำหรับ sensitive data
- [ ] S3 Block Public Access เปิดที่ account level
- [ ] Database backups encrypted และ retention ตาม policy
- [ ] Data classification labels applied ตาม sensitivity
- [ ] DLP scanning enabled สำหรับ sensitive data stores
- [ ] Cross-region replication สำหรับ critical data

### Logging & Monitoring

- [ ] CloudTrail / Activity Log / Audit Logs เปิดทุก region
- [ ] Log centralization ไป SIEM หรือ central logging
- [ ] Alerts สำหรับ root login, IAM changes, security group changes
- [ ] GuardDuty / Defender for Cloud / Security Command Center เปิดใช้
- [ ] Log retention ตาม compliance requirements (min 12 months)
- [ ] VPC Flow Logs ส่งไป analysis platform

### Compute Security

- [ ] AMI/VM images hardened ตาม CIS Benchmark
- [ ] Auto-patching enabled สำหรับ OS และ middleware
- [ ] No EC2/VM instances with public IP (ใช้ load balancer)
- [ ] IMDSv2 enforced (AWS) — ป้องกัน SSRF → credential theft
- [ ] Container images scanned ก่อน deploy (→ ดู references/container-supply-chain.md)
- [ ] Serverless functions มี least privilege execution role

### Infrastructure as Code

- [ ] Terraform state encrypted และ stored remotely
- [ ] IaC scanning ใน CI/CD pipeline (Checkov, tfsec, KICS)
- [ ] Pre-commit hooks สำหรับ IaC validation
- [ ] No secrets hardcoded ใน IaC files
- [ ] Provider versions pinned (ไม่ใช้ latest)
- [ ] Drift detection alerts เปิดใช้งาน

### CSPM & Compliance

- [ ] CSPM tool เปิดใช้งาน (Prowler, ScoutSuite, หรือ commercial)
- [ ] CIS Benchmark scan ทำอย่างน้อยรายสัปดาห์
- [ ] Critical findings remediated ภายใน 48 ชั่วโมง
- [ ] High findings remediated ภายใน 7 วัน
- [ ] Compliance dashboard พร้อมสำหรับ audit
- [ ] Auto-remediation สำหรับ known misconfigurations

### Framework References

| Framework                              | เนื้อหาที่เกี่ยวข้อง                           | Section ในไฟล์นี้   |
| -------------------------------------- | ---------------------------------------------- | ------------------- |
| CIS AWS Foundations Benchmark v3.0     | IAM, Logging, Monitoring, Networking           | Sections 2, 4, 5, 6 |
| CIS Azure Foundations Benchmark v2.1   | Identity, Networking, Logging, Storage         | Sections 2, 3, 4, 6 |
| CIS GCP Foundations Benchmark v3.0     | IAM, Networking, Logging, Storage              | Sections 2, 3, 4, 6 |
| NIST SP 800-144                        | Cloud security and privacy guidelines          | Sections 1, 8       |
| CSA CCM v4.1                           | Cloud Controls Matrix — comprehensive controls | Sections 1-8        |
| AWS Well-Architected — Security Pillar | Security best practices for AWS                | Sections 2, 4, 6, 8 |
| NIST SP 800-53 (→ Domain 9)            | Comprehensive security controls catalog        | Cross-reference     |
| CIS Controls v8.1 (→ Domain 9)         | Prioritized security actions                   | Cross-reference     |
