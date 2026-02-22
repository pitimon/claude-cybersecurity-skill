# Troubleshooting Guide

คู่มือแก้ไขปัญหาการติดตั้งและใช้งาน cybersecurity-pro plugin สำหรับ Claude Code
จัดทำจากประสบการณ์จริงในการ debug บน production server

## Quick Diagnosis (การวินิจฉัยเบื้องต้น)

รันคำสั่งนี้เพื่อตรวจสอบสถานะ plugin ภายใน 30 วินาที:

```bash
# 1. ตรวจสอบ Claude Code version
claude --version

# 2. ตรวจสอบ plugin health
claude doctor

# 3. ตรวจสอบว่า plugin ถูก enable
claude plugin list
```

หาก `claude doctor` แสดง `All checks passed` แสดงว่า plugin ทำงานปกติ

---

## Symptom-Cause Reference Table

| อาการ (Symptom)                                  | สาเหตุ (Cause)                                 | วิธีแก้ (Solution)                                            |
| ------------------------------------------------ | ---------------------------------------------- | ------------------------------------------------------------- |
| `claude doctor` แสดง "Invalid input"             | `source: "local"` ใน `known_marketplaces.json` | [แก้ source type](#error-invalid-input-from-claude-doctor)    |
| Plugin ไม่แสดงใน `plugin list`                   | marketplace ไม่ถูก register หรือชื่อไม่ตรง     | [ตรวจสอบ marketplace name](#plugin-not-showing-after-install) |
| Skill ไม่ trigger เมื่อถาม cybersecurity         | keyword ไม่ตรง หรือยังไม่ restart session      | [ตรวจสอบ trigger keywords](#skill-not-triggering)             |
| `claude plugin install` ล้มเหลว                  | cache เก่าค้างอยู่ หรือ network error          | [ล้าง cache](#cache-corruption)                               |
| Plugin ใช้งานได้บน server A แต่ไม่ได้บน server B | copy config แบบ manual ข้าม server             | [ใช้ standard install](#server-migration)                     |

---

## Error: "Invalid input" from `claude doctor`

### อาการ

```
$ claude doctor
...
Plugin Check
  x cybersecurity-pro@somapa-cybersecurity - Invalid input
```

### สาเหตุหลัก (Root Cause)

ปัญหานี้เกิดจาก `known_marketplaces.json` ที่ใช้ `source: "local"` ซึ่ง **Claude Code ไม่รองรับ**
Claude Code validator ต้องการ source type เป็น `"github"` เท่านั้น

ปัญหานี้มักเกิดเมื่อติดตั้ง plugin แบบ manual (copy ไฟล์ลง server โดยตรง) แทนที่จะผ่านคำสั่ง `claude plugin marketplace add`

### ตรวจสอบ

```bash
# ดู known_marketplaces.json
cat ~/.claude/plugins/known_marketplaces.json | jq '.'
```

**ค่าที่ผิด:**

```json
{
  "somapa-cybersecurity": {
    "source": {
      "source": "local",
      "path": "/home/<username>/.claude/plugins/marketplaces/somapa-cybersecurity"
    }
  }
}
```

ปัญหา 3 จุด:

1. `"source": "local"` -- ไม่ถูกต้อง ต้องเป็น `"github"`
2. ชื่อ marketplace `somapa-cybersecurity` -- ไม่ตรงกับ GitHub repo
3. ไม่มี `owner` และ `repo` fields

### วิธีแก้

แก้ไข `~/.claude/plugins/known_marketplaces.json` โดยเปลี่ยน entry เป็น:

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

จากนั้นแก้ `~/.claude/plugins/installed_plugins.json` ให้ key ตรง:

```json
{
  "cybersecurity-pro@pitimon-cybersecurity": {
    "version": "2.0.0",
    "installedAt": "2026-02-20T00:00:00.000Z"
  }
}
```

แก้ `~/.claude/settings.json` ให้ `enabledPlugins` อ้างชื่อที่ถูกต้อง:

```json
{
  "enabledPlugins": {
    "cybersecurity-pro@pitimon-cybersecurity": true
  }
}
```

สุดท้าย ตรวจสอบผล:

```bash
claude doctor
```

---

## Plugin Not Showing After Install

### อาการ

ติดตั้งด้วย `claude plugin install` สำเร็จ แต่ `claude plugin list` ไม่แสดง plugin

### ตรวจสอบ

```bash
# 1. ตรวจสอบว่า marketplace ถูก register
cat ~/.claude/plugins/known_marketplaces.json | jq 'keys'

# 2. ตรวจสอบว่า plugin ถูก install
cat ~/.claude/plugins/installed_plugins.json | jq 'keys'

# 3. ตรวจสอบว่า plugin ถูก enable ใน settings
cat ~/.claude/settings.json | jq '.enabledPlugins'
```

### สาเหตุที่พบบ่อย

1. **ชื่อ marketplace ไม่ตรง** -- `known_marketplaces.json` ใช้ชื่อหนึ่ง แต่ `installed_plugins.json` อ้างอีกชื่อ
2. **plugin ไม่ถูก enable** -- ติดตั้งแล้วแต่ไม่ได้เพิ่มใน `settings.json` → `enabledPlugins`
3. **cache directory ไม่ครบ** -- ไม่มี directory ใน `~/.claude/plugins/cache/`

### วิธีแก้

ตรวจสอบว่าทั้ง 3 ไฟล์ใช้ชื่อตรงกัน:

| ไฟล์                      | Key / Value ที่ต้องตรง                                              |
| ------------------------- | ------------------------------------------------------------------- |
| `known_marketplaces.json` | key: `"pitimon-cybersecurity"`                                      |
| `installed_plugins.json`  | key: `"cybersecurity-pro@pitimon-cybersecurity"`                    |
| `settings.json`           | enabledPlugins: `{"cybersecurity-pro@pitimon-cybersecurity": true}` |

---

## Skill Not Triggering

### อาการ

Plugin ติดตั้งสำเร็จ, `claude doctor` ผ่าน, แต่เมื่อถาม cybersecurity questions ไม่ได้ response จาก skill

### ตรวจสอบ

1. **Restart Claude Code session** -- skill จะถูก load เมื่อเริ่ม session ใหม่เท่านั้น

   ```bash
   # ใน Claude Code ใช้ /clear หรือปิดแล้วเปิดใหม่
   ```

2. **ใช้ trigger keywords ที่ตรง** -- skill จะ trigger เมื่อ prompt มีคำเหล่านี้:
   - English: `incident response`, `IR playbook`, `runbook`, `SOC triage`, `threat hunting`, `digital forensics`, `DFIR`, `DevSecOps`, `SAST`, `DAST`, `GitOps`, `MITRE ATT&CK`, `NIST 800-61`, `NIST 800-53`, `CIS Controls`, `PCI DSS`, `gap assessment`, `gap analysis`
   - Thai: `การตอบสนองต่อเหตุการณ์`, `วิเคราะห์ภัยคุกคาม`, `ความปลอดภัยไซเบอร์`, `นิติวิทยาศาสตร์ดิจิทัล`, `การปฏิบัติตามกฎระเบียบ`

3. **ตรวจสอบ SKILL.md** -- ดูว่า skill definition ถูกต้อง:
   ```bash
   cat ~/.claude/plugins/cache/pitimon-cybersecurity/cybersecurity-pro/*/skills/cybersecurity-pro/SKILL.md
   ```

---

## Cache Corruption

### อาการ

`claude plugin install` ล้มเหลว หรือ plugin ทำงานผิดปกติหลัง update

### วิธีแก้

```bash
# 1. ลบ cache ของ marketplace นี้
rm -rf ~/.claude/plugins/cache/pitimon-cybersecurity/cybersecurity-pro

# 2. ลบ marketplace directory (ถ้ามี)
rm -rf ~/.claude/plugins/marketplaces/pitimon-cybersecurity

# 3. ลบ entry จาก installed_plugins.json
# แก้ไขไฟล์เพื่อลบ key "cybersecurity-pro@pitimon-cybersecurity"

# 4. ติดตั้งใหม่
claude plugin marketplace add pitimon/claude-cybersecurity-skill
claude plugin install cybersecurity-pro@pitimon-cybersecurity

# 5. ตรวจสอบ
claude doctor
```

---

## Server Migration

### อาการ

ต้องการย้าย plugin จาก server หนึ่งไปอีก server

### Best Practice

**ห้าม** copy config files ข้าม server แบบ manual เพราะ:

- path อาจไม่ตรง (เช่น `$HOME` ต่างกันระหว่าง server)
- source type อาจกลายเป็น `"local"` ซึ่ง Claude Code ไม่รองรับ
- cache structure อาจไม่ครบ

**ให้ใช้ standard installation บน server ใหม่:**

```bash
# บน server ใหม่
claude plugin marketplace add pitimon/claude-cybersecurity-skill
claude plugin install cybersecurity-pro@pitimon-cybersecurity
claude doctor
```

คำสั่งเหล่านี้จะ:

1. Clone repo จาก GitHub มาที่ cache
2. สร้าง `known_marketplaces.json` ด้วย `source: "github"` ที่ถูกต้อง
3. Register plugin ใน `installed_plugins.json` ด้วยชื่อที่ถูกต้อง

---

## Config File Reference

| ไฟล์                      | ตำแหน่ง                                   | หน้าที่                                      |
| ------------------------- | ----------------------------------------- | -------------------------------------------- |
| `known_marketplaces.json` | `~/.claude/plugins/`                      | Registry ของ marketplaces ที่เพิ่มแล้ว       |
| `installed_plugins.json`  | `~/.claude/plugins/`                      | รายการ plugins ที่ติดตั้งแล้ว                |
| `settings.json`           | `~/.claude/`                              | การตั้งค่า Claude Code รวมถึง enabledPlugins |
| `config.json`             | `~/.claude/plugins/`                      | Plugin system configuration                  |
| Cache directory           | `~/.claude/plugins/cache/<owner>/<repo>/` | Source code ของ plugin ที่ download แล้ว     |
| Marketplace directory     | `~/.claude/plugins/marketplaces/<name>/`  | Marketplace metadata (symlink/copy)          |

---

## Framework Validation Errors

### อาการ: Section 5 FAIL — grep patterns don't match

`validate-plugin.sh` Section 5 reports FAIL because grep patterns in `frameworks.json` don't match content in the declared `used_in` files.

### ตรวจสอบ

```bash
# รัน Section 5 เท่านั้น
bash tests/validate-plugin.sh --skip-install-check 2>&1 | grep -A2 "Section 5"

# ตรวจสอบ framework ที่มีปัญหา
cat frameworks.json | jq '.[] | select(.grep_pattern) | {name, grep_pattern, used_in}'
```

### สาเหตุที่พบบ่อย

1. **grep_pattern ไม่ตรงกับ content จริง** — pattern ใน `frameworks.json` ไม่ตรงกับ version string ในไฟล์ reference
2. **used_in ไฟล์ไม่ถูกต้อง** — ไฟล์ที่ระบุใน `used_in` ไม่ได้อ้างถึง framework นั้นจริง
3. **Version ถูก update แต่ไม่ได้ update frameworks.json** — framework version ในไฟล์ reference ถูกเปลี่ยนแต่ `grep_pattern` ยังเป็นค่าเดิม

### วิธีแก้

```bash
# 1. ตรวจสอบว่า pattern match ได้จริง
grep -r "PATTERN" skills/cybersecurity-pro/references/

# 2. แก้ไข frameworks.json
# - broaden grep_pattern ให้ตรงกับ content จริง
# - แก้ used_in ให้ชี้ไปยังไฟล์ที่ถูกต้อง

# 3. รัน validation อีกครั้ง
bash tests/validate-plugin.sh --skip-install-check
```

### อาการ: Stale framework WARN messages

`check-framework-updates.sh` แสดง CRITICAL หรือ DUE สำหรับ frameworks ที่ไม่ได้ตรวจสอบนาน

```bash
# ตรวจสอบ framework ที่ต้อง update
bash tests/check-framework-updates.sh

# ดูทั้งหมดรวม OK
bash tests/check-framework-updates.sh --all
```

### วิธีแก้

ดูขั้นตอนการ update ที่ [FRAMEWORK-UPDATE-RUNBOOK.md](FRAMEWORK-UPDATE-RUNBOOK.md):

1. อัพเดท `frameworks.json` — แก้ `version`, `grep_pattern`, `last_checked`
2. อัพเดท reference files ตาม `used_in` list
3. รัน `bash tests/validate-plugin.sh --skip-install-check` เพื่อ verify

### อาการ: frameworks.json syntax errors

```bash
# ตรวจสอบ JSON validity
jq '.' frameworks.json > /dev/null

# หาก error ให้ใช้ jq เพื่อดู error location
jq '.' frameworks.json
```

---

## Getting Help

หากปัญหายังไม่หาย:

1. ตรวจสอบ Claude Code version: `claude --version` (ต้องการ v2.1.x ขึ้นไป)
2. ดู [installation guide](INSTALL.md) สำหรับขั้นตอนติดตั้งที่ถูกต้อง
3. เปิด issue ที่ [GitHub Issues](https://github.com/pitimon/claude-cybersecurity-skill/issues)
