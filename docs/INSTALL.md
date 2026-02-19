# Installation Guide

คู่มือการติดตั้ง cybersecurity-pro plugin สำหรับ Claude Code
รองรับทั้ง standard installation และ manual installation สำหรับ air-gapped servers

## Prerequisites (ข้อกำหนดเบื้องต้น)

| ข้อกำหนด        | ขั้นต่ำ              | ตรวจสอบด้วย                  |
| --------------- | -------------------- | ---------------------------- |
| Claude Code CLI | v2.1.x+              | `claude --version`           |
| Git             | 2.x+                 | `git --version`              |
| Network access  | github.com reachable | `curl -s https://github.com` |
| Shell           | bash หรือ zsh        | `echo $SHELL`                |

---

## Standard Installation (การติดตั้งมาตรฐาน)

วิธีนี้เหมาะสำหรับ server ที่เข้าถึง GitHub ได้ — **แนะนำให้ใช้วิธีนี้เสมอ**

### Step 1: เพิ่ม Marketplace

```bash
claude plugin marketplace add pitimon/claude-cybersecurity-skill
```

คำสั่งนี้จะ:

- Clone repository จาก GitHub
- สร้าง entry ใน `~/.claude/plugins/known_marketplaces.json` ด้วย `source: "github"`
- Cache source code ไว้ที่ `~/.claude/plugins/cache/pitimon/claude-cybersecurity-skill/`

### Step 2: ติดตั้ง Plugin

```bash
claude plugin install cybersecurity-pro@pitimon-cybersecurity
```

คำสั่งนี้จะ:

- Register plugin ใน `~/.claude/plugins/installed_plugins.json`
- เพิ่ม `cybersecurity-pro@pitimon-cybersecurity` ใน `~/.claude/settings.json` → `enabledPlugins`

### Step 3: ตรวจสอบ

```bash
claude doctor
```

ผลที่ต้องการ:

```
Plugin Check
  ✓ cybersecurity-pro@pitimon-cybersecurity - OK
```

### Verification Checklist

หลังติดตั้ง ตรวจสอบว่า:

```bash
# 1. Marketplace ถูก register
cat ~/.claude/plugins/known_marketplaces.json | jq 'has("pitimon-cybersecurity")'
# Expected: true

# 2. Plugin ถูก install
cat ~/.claude/plugins/installed_plugins.json | jq 'has("cybersecurity-pro@pitimon-cybersecurity")'
# Expected: true

# 3. Plugin ถูก enable
cat ~/.claude/settings.json | jq '.enabledPlugins | index("cybersecurity-pro@pitimon-cybersecurity")'
# Expected: ตัวเลข (ไม่ใช่ null)

# 4. Cache มีไฟล์ครบ
ls ~/.claude/plugins/cache/pitimon/claude-cybersecurity-skill/*/skills/cybersecurity-pro/SKILL.md
# Expected: แสดง path ของ SKILL.md
```

---

## Manual Installation (สำหรับ Air-Gapped Servers)

สำหรับ server ที่ไม่สามารถเข้าถึง GitHub ได้ เช่น เครือข่ายปิด หรือ restricted network

> **Warning**: วิธีนี้เสี่ยงต่อปัญหา config mismatch
> ดู [Troubleshooting Guide](TROUBLESHOOTING.md) หากพบปัญหา

### Step 1: เตรียมไฟล์บน machine ที่มี internet

```bash
# Clone repo
git clone https://github.com/pitimon/claude-cybersecurity-skill.git
cd claude-cybersecurity-skill

# สร้าง tarball สำหรับ transfer
tar czf cybersecurity-pro-plugin.tar.gz \
  .claude-plugin/ \
  skills/
```

### Step 2: Transfer ไปยัง target server

```bash
scp cybersecurity-pro-plugin.tar.gz user@target-server:/tmp/
```

### Step 3: ติดตั้งบน target server

```bash
ssh user@target-server
```

#### 3a. สร้าง cache directory

```bash
CACHE_DIR="$HOME/.claude/plugins/cache/pitimon/claude-cybersecurity-skill/1.0.0"
mkdir -p "$CACHE_DIR"
cd "$CACHE_DIR"
tar xzf /tmp/cybersecurity-pro-plugin.tar.gz
```

#### 3b. แก้ไข known_marketplaces.json

```bash
# สร้างหรือแก้ไข known_marketplaces.json
# หาก file มีอยู่แล้ว ให้เพิ่ม entry ใน JSON object
cat ~/.claude/plugins/known_marketplaces.json
```

**เพิ่ม entry นี้** (หรือสร้างใหม่หากยังไม่มีไฟล์):

```json
{
  "pitimon-cybersecurity": {
    "source": {
      "source": "github",
      "owner": "pitimon",
      "repo": "claude-cybersecurity-skill"
    }
  }
}
```

> **Critical**: source ต้องเป็น `"github"` เสมอ แม้ว่าจะติดตั้งแบบ manual
> **ห้ามใช้** `"source": "local"` เพราะ Claude Code validator จะ reject

#### 3c. แก้ไข installed_plugins.json

```bash
cat ~/.claude/plugins/installed_plugins.json
```

**เพิ่ม entry นี้:**

```json
{
  "cybersecurity-pro@pitimon-cybersecurity": {
    "version": "1.0.0",
    "installedAt": "2026-02-19T00:00:00.000Z"
  }
}
```

#### 3d. แก้ไข settings.json

```bash
cat ~/.claude/settings.json
```

**เพิ่มใน `enabledPlugins` array:**

```json
{
  "enabledPlugins": ["cybersecurity-pro@pitimon-cybersecurity"]
}
```

หากมี plugins อื่นอยู่แล้ว ให้เพิ่มต่อท้าย array

### Step 4: ตรวจสอบ

```bash
claude doctor
```

---

## Uninstallation (การถอนการติดตั้ง)

```bash
# 1. ถอน plugin
claude plugin uninstall cybersecurity-pro@pitimon-cybersecurity

# 2. ลบ marketplace (optional)
claude plugin marketplace remove pitimon-cybersecurity

# 3. ตรวจสอบ
claude doctor
```

### Manual Uninstall

หากคำสั่งด้านบนไม่ทำงาน ให้ลบ manual:

```bash
# 1. ลบ cache
rm -rf ~/.claude/plugins/cache/pitimon/claude-cybersecurity-skill

# 2. ลบ marketplace directory
rm -rf ~/.claude/plugins/marketplaces/pitimon-cybersecurity

# 3. แก้ known_marketplaces.json - ลบ key "pitimon-cybersecurity"
# 4. แก้ installed_plugins.json - ลบ key "cybersecurity-pro@pitimon-cybersecurity"
# 5. แก้ settings.json - ลบจาก enabledPlugins array
```

---

## Upgrade (การอัพเกรด)

### Standard Upgrade

```bash
# 1. Update marketplace cache
claude plugin marketplace update pitimon-cybersecurity

# 2. Reinstall plugin
claude plugin install cybersecurity-pro@pitimon-cybersecurity

# 3. ตรวจสอบ
claude doctor
```

### Manual Upgrade (Air-Gapped)

```bash
# 1. ลบ cache เก่า
rm -rf ~/.claude/plugins/cache/pitimon/claude-cybersecurity-skill

# 2. ทำตามขั้นตอน Manual Installation อีกครั้ง
# (transfer ไฟล์ใหม่, extract ไปยัง cache directory)

# 3. อัพเดท version ใน installed_plugins.json
# 4. Restart Claude Code session
```

---

## Appendix: Config File Reference

### File Locations

| ไฟล์                      | Path                                                          | Purpose               |
| ------------------------- | ------------------------------------------------------------- | --------------------- |
| `known_marketplaces.json` | `~/.claude/plugins/known_marketplaces.json`                   | Marketplace registry  |
| `installed_plugins.json`  | `~/.claude/plugins/installed_plugins.json`                    | Installed plugin list |
| `settings.json`           | `~/.claude/settings.json`                                     | Claude Code settings  |
| `config.json`             | `~/.claude/plugins/config.json`                               | Plugin system config  |
| Plugin cache              | `~/.claude/plugins/cache/pitimon/claude-cybersecurity-skill/` | Downloaded source     |
| Marketplace dir           | `~/.claude/plugins/marketplaces/pitimon-cybersecurity/`       | Marketplace metadata  |

### Expected known_marketplaces.json Entry

```json
{
  "pitimon-cybersecurity": {
    "source": {
      "source": "github",
      "owner": "pitimon",
      "repo": "claude-cybersecurity-skill"
    }
  }
}
```

### Expected installed_plugins.json Entry

```json
{
  "cybersecurity-pro@pitimon-cybersecurity": {
    "version": "1.0.0",
    "installedAt": "2026-02-19T00:00:00.000Z"
  }
}
```

### Expected settings.json Fragment

```json
{
  "enabledPlugins": ["cybersecurity-pro@pitimon-cybersecurity"]
}
```

### Cache Directory Structure

```
~/.claude/plugins/cache/pitimon/claude-cybersecurity-skill/
└── <version>/
    ├── .claude-plugin/
    │   ├── marketplace.json
    │   └── plugin.json
    └── skills/
        └── cybersecurity-pro/
            ├── SKILL.md
            ├── cybersecurity-pro.skill
            └── references/
                ├── devsecops-pipeline.md
                ├── dfir-reports.md
                ├── gitops-security.md
                ├── ir-playbooks.md
                └── soc-operations.md
```

---

## See Also

- [Troubleshooting Guide](TROUBLESHOOTING.md) -- แก้ไขปัญหาที่พบบ่อย
- [CHANGELOG](../CHANGELOG.md) -- ประวัติการเปลี่ยนแปลง
- [README](../README.md) -- ภาพรวมและการใช้งาน
