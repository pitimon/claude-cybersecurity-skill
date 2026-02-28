#!/usr/bin/env bash
# validate-plugin.sh — Structural integrity tests for cybersecurity-pro plugin
# Usage: bash tests/validate-plugin.sh [--skip-install-check]
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_DIR="$REPO_ROOT/.claude-plugin"
SKILLS_DIR="$REPO_ROOT/skills/cybersecurity-pro"
REFS_DIR="$SKILLS_DIR/references"
CLAUDE_HOME="${HOME}/.claude"

PASS=0
FAIL=0
SKIP=0
SKIP_INSTALL=false

[[ "${1:-}" == "--skip-install-check" ]] && SKIP_INSTALL=true

# --- Helpers ---

pass() { PASS=$((PASS + 1)); printf "  \033[32mPASS\033[0m %s\n" "$1"; }
fail() { FAIL=$((FAIL + 1)); printf "  \033[31mFAIL\033[0m %s\n" "$1"; }
skip() { SKIP=$((SKIP + 1)); printf "  \033[33mSKIP\033[0m %s\n" "$1"; }
section() { printf "\n\033[1;36m[%s]\033[0m\n" "$1"; }

json_field() {
  # Extract a top-level string field from JSON (portable, no jq required)
  python3 -c "import json,sys; d=json.load(open('$1')); print(d.get('$2',''))" 2>/dev/null
}

json_valid() {
  python3 -c "import json; json.load(open('$1'))" 2>/dev/null
}

# ============================================================
# 1. JSON Validation
# ============================================================
section "1. JSON Validation"

for f in "$PLUGIN_DIR/plugin.json" "$PLUGIN_DIR/marketplace.json"; do
  fname="$(basename "$(dirname "$f")")/$(basename "$f")"
  if json_valid "$f"; then
    pass "$fname is valid JSON"
  else
    fail "$fname has JSON syntax errors"
  fi
done

# Required fields in plugin.json
for field in name version description author skills keywords; do
  val=$(python3 -c "
import json, sys
d = json.load(open('$PLUGIN_DIR/plugin.json'))
v = d.get('$field')
if v is None: sys.exit(1)
if isinstance(v, str) and not v.strip(): sys.exit(1)
print('ok')
" 2>/dev/null || true)
  if [[ "$val" == "ok" ]]; then
    pass "plugin.json has required field '$field'"
  else
    fail "plugin.json missing or empty field '$field'"
  fi
done

# Required fields in marketplace.json
for field in name description plugins; do
  val=$(python3 -c "
import json, sys
d = json.load(open('$PLUGIN_DIR/marketplace.json'))
v = d.get('$field')
if v is None: sys.exit(1)
if isinstance(v, str) and not v.strip(): sys.exit(1)
if isinstance(v, list) and len(v) == 0: sys.exit(1)
print('ok')
" 2>/dev/null || true)
  if [[ "$val" == "ok" ]]; then
    pass "marketplace.json has required field '$field'"
  else
    fail "marketplace.json missing or empty field '$field'"
  fi
done

# ============================================================
# 2. Cross-File Naming Consistency
# ============================================================
section "2. Cross-File Naming Consistency"

# 2.1 Marketplace name
mkt_name=$(json_field "$PLUGIN_DIR/marketplace.json" "name")
if [[ "$mkt_name" == "pitimon-cybersecurity" ]]; then
  pass "Marketplace name = 'pitimon-cybersecurity'"
else
  fail "Marketplace name = '$mkt_name' (expected 'pitimon-cybersecurity')"
fi

# 2.2 Plugin name consistency across files
plugin_name_pj=$(json_field "$PLUGIN_DIR/plugin.json" "name")
plugin_name_mkt=$(python3 -c "
import json
d = json.load(open('$PLUGIN_DIR/marketplace.json'))
print(d['plugins'][0].get('name',''))
" 2>/dev/null)
plugin_name_skill=$(python3 -c "
import sys
with open('$SKILLS_DIR/SKILL.md') as f:
    for line in f:
        if line.startswith('name:'):
            print(line.split(':',1)[1].strip())
            sys.exit(0)
print('')
" 2>/dev/null)

for src_label in "plugin.json:$plugin_name_pj" "marketplace.json plugins[0]:$plugin_name_mkt" "SKILL.md frontmatter:$plugin_name_skill"; do
  label="${src_label%%:*}"
  val="${src_label#*:}"
  if [[ "$val" == "cybersecurity-pro" ]]; then
    pass "Plugin name in $label = 'cybersecurity-pro'"
  else
    fail "Plugin name in $label = '$val' (expected 'cybersecurity-pro')"
  fi
done

# 2.3 Version sync between plugin.json and marketplace.json
ver_pj=$(json_field "$PLUGIN_DIR/plugin.json" "version")
ver_mkt=$(python3 -c "
import json
d = json.load(open('$PLUGIN_DIR/marketplace.json'))
print(d['plugins'][0].get('version',''))
" 2>/dev/null)
if [[ "$ver_pj" == "$ver_mkt" ]]; then
  pass "Version sync: plugin.json ($ver_pj) == marketplace.json ($ver_mkt)"
else
  fail "Version mismatch: plugin.json ($ver_pj) != marketplace.json ($ver_mkt)"
fi

# 2.4 Skills path resolves to SKILL.md
skills_path=$(json_field "$PLUGIN_DIR/plugin.json" "skills")
resolved="$REPO_ROOT/${skills_path#./}cybersecurity-pro/SKILL.md"
if [[ -f "$resolved" ]]; then
  pass "Skills path '$skills_path' resolves to cybersecurity-pro/SKILL.md"
else
  fail "Skills path '$skills_path' does not resolve (looked for $resolved)"
fi

# ============================================================
# 3. File Integrity
# ============================================================
section "3. File Integrity"

# 3.1 All 22 reference files exist and are non-trivial (>100 lines)
EXPECTED_REFS=(
  ir-playbooks.md
  dfir-reports.md
  devsecops-pipeline.md
  soc-operations.md
  gitops-security.md
  code-security-analysis.md
  container-supply-chain.md
  compliance-threat-modeling.md
  compliance-frameworks.md
  cloud-security-cspm.md
  zero-trust-architecture.md
  ai-ml-security.md
  api-security.md
  vulnerability-management.md
  threat-intelligence.md
  cross-domain-integration.md
  security-governance-executive.md
  ot-ics-security.md
  agentic-ai-security.md
  post-quantum-cryptography.md
  identity-access-security.md
  web3-blockchain-security.md
)

for ref in "${EXPECTED_REFS[@]}"; do
  fpath="$REFS_DIR/$ref"
  if [[ ! -f "$fpath" ]]; then
    fail "Reference file missing: $ref"
    continue
  fi
  lines=$(wc -l < "$fpath" | tr -d ' ')
  if (( lines > 100 )); then
    pass "$ref exists ($lines lines)"
  else
    fail "$ref too short ($lines lines, expected >100)"
  fi
done

# 3.2 SKILL.md frontmatter required fields
section "3.2 SKILL.md Frontmatter"

for field in name description user-invocable allowed-tools; do
  if python3 -c "
import sys
in_front = False
with open('$SKILLS_DIR/SKILL.md') as f:
    for line in f:
        if line.strip() == '---':
            if in_front: break
            in_front = True; continue
        if in_front and line.startswith('$field:'):
            val = line.split(':',1)[1].strip()
            if val: sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
    pass "SKILL.md frontmatter has '$field'"
  else
    fail "SKILL.md frontmatter missing '$field'"
  fi
done

# 3.3 Decision tree references all 22 files
section "3.3 Decision Tree References"

for ref in "${EXPECTED_REFS[@]}"; do
  if grep -q "references/$ref" "$SKILLS_DIR/SKILL.md"; then
    pass "SKILL.md references 'references/$ref'"
  else
    fail "SKILL.md missing reference to 'references/$ref'"
  fi
done

# ============================================================
# 4. Installation State (optional)
# ============================================================
section "4. Installation State"

if $SKIP_INSTALL; then
  skip "Installation checks skipped (--skip-install-check)"
else
  INSTALL_KEY="cybersecurity-pro@pitimon-cybersecurity"
  PLUGINS_FILE="$CLAUDE_HOME/plugins/installed_plugins.json"
  SETTINGS_FILE="$CLAUDE_HOME/settings.json"
  MARKETS_FILE="$CLAUDE_HOME/plugins/known_marketplaces.json"

  # 4.1 installed_plugins.json has the install key
  if [[ -f "$PLUGINS_FILE" ]]; then
    if python3 -c "
import json, sys
d = json.load(open('$PLUGINS_FILE'))
if '$INSTALL_KEY' in str(d): sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
      pass "installed_plugins.json contains '$INSTALL_KEY'"
    else
      fail "installed_plugins.json missing '$INSTALL_KEY'"
    fi
  else
    skip "installed_plugins.json not found (plugin not installed?)"
  fi

  # 4.2 settings.json has plugin enabled
  if [[ -f "$SETTINGS_FILE" ]]; then
    if python3 -c "
import json, sys
d = json.load(open('$SETTINGS_FILE'))
enabled = d.get('enabledPlugins', {})
# enabledPlugins is a dict with boolean values: {\"key\": true}
if isinstance(enabled, dict) and enabled.get('$INSTALL_KEY', False) is True: sys.exit(0)
# fallback: check array format for older Claude Code versions
if isinstance(enabled, list) and '$INSTALL_KEY' in enabled: sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
      pass "settings.json: plugin enabled = true"
    else
      fail "settings.json: plugin not enabled"
    fi
  else
    skip "settings.json not found"
  fi

  # 4.3 known_marketplaces.json source type = "github"
  if [[ -f "$MARKETS_FILE" ]]; then
    src_type=$(python3 -c "
import json
d = json.load(open('$MARKETS_FILE'))
entry = d.get('pitimon-cybersecurity', {})
print(entry.get('source', {}).get('source', ''))
" 2>/dev/null || true)
    if [[ "$src_type" == "github" ]]; then
      pass "known_marketplaces.json source type = 'github'"
    else
      fail "known_marketplaces.json source type = '$src_type' (expected 'github')"
    fi
  else
    skip "known_marketplaces.json not found"
  fi

  # 4.4 Cache vs repo file count comparison
  CACHE_DIR="$CLAUDE_HOME/plugins/cache/pitimon-cybersecurity/cybersecurity-pro"
  # Cache uses versioned subdirectories: <marketplace>/<plugin>/<version>/
  if [[ -d "$CACHE_DIR" ]]; then
    # Find the latest version directory
    CACHE_VERSION_DIR=$(ls -1d "$CACHE_DIR"/*/ 2>/dev/null | head -1)
    if [[ -n "$CACHE_VERSION_DIR" ]]; then
      # Check for critical file: SKILL.md must exist in cache
      SKILL_IN_CACHE="$CACHE_VERSION_DIR/skills/cybersecurity-pro/SKILL.md"
      if [[ -f "$SKILL_IN_CACHE" ]]; then
        pass "Cache has SKILL.md at $CACHE_VERSION_DIR"
      else
        fail "Cache missing SKILL.md at $SKILL_IN_CACHE"
      fi
      # Check reference files exist in cache
      CACHE_REFS_DIR="$CACHE_VERSION_DIR/skills/cybersecurity-pro/references"
      if [[ -d "$CACHE_REFS_DIR" ]]; then
        cache_ref_count=$(ls -1 "$CACHE_REFS_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')
        if (( cache_ref_count >= 22 )); then
          pass "Cache has all $cache_ref_count reference files"
        else
          fail "Cache has only $cache_ref_count reference files (expected 22)"
        fi
      else
        fail "Cache missing references directory"
      fi
    else
      skip "No version directory found in cache"
    fi
  else
    skip "Plugin cache directory not found"
  fi
fi

# ============================================================
# 5. Framework Version Consistency
# ============================================================
section "5. Framework Version Consistency"

FRAMEWORKS_JSON="$REPO_ROOT/frameworks.json"
WARN=0
warn() { WARN=$((WARN + 1)); printf "  \033[33mWARN\033[0m %s\n" "$1"; }

# 5.1 frameworks.json exists and is valid JSON
if [[ ! -f "$FRAMEWORKS_JSON" ]]; then
  fail "frameworks.json not found"
else
  if json_valid "$FRAMEWORKS_JSON"; then
    pass "frameworks.json is valid JSON"
  else
    fail "frameworks.json has JSON syntax errors"
  fi
fi

# 5.2 For each framework: every file in used_in contains at least one grep_patterns match
if [[ -f "$FRAMEWORKS_JSON" ]] && json_valid "$FRAMEWORKS_JSON" 2>/dev/null; then
  section "5.2 Framework Pattern Matching"
  pattern_errors=$(python3 -c "
import json, subprocess, sys, os

repo_root = '$REPO_ROOT'
skills_dir = os.path.join(repo_root, 'skills', 'cybersecurity-pro')
refs_dir = os.path.join(skills_dir, 'references')

with open('$FRAMEWORKS_JSON') as f:
    data = json.load(f)

errors = []
for fw in data['frameworks']:
    fid = fw['id']
    patterns = fw.get('grep_patterns', [])
    used_in = fw.get('used_in', [])

    if not patterns or not used_in:
        continue

    for filename in used_in:
        # Resolve file path
        if filename == 'SKILL.md':
            fpath = os.path.join(skills_dir, 'SKILL.md')
        elif filename in ('README.md', 'CLAUDE.md'):
            fpath = os.path.join(repo_root, filename)
        else:
            fpath = os.path.join(refs_dir, filename)

        if not os.path.isfile(fpath):
            errors.append(f'{fid}: file not found: {filename}')
            continue

        with open(fpath, encoding='utf-8') as fh:
            content = fh.read()

        import re
        found = False
        for pattern in patterns:
            try:
                if re.search(pattern, content):
                    found = True
                    break
            except re.error:
                if pattern in content:
                    found = True
                    break

        if not found:
            errors.append(f'{fid}: no pattern match in {filename}')

for e in errors:
    print(e)
" 2>/dev/null || true)

  if [[ -z "$pattern_errors" ]]; then
    pass "All framework patterns match in declared files"
  else
    while IFS= read -r line; do
      fail "Pattern mismatch: $line"
    done <<< "$pattern_errors"
  fi

  # 5.3 Staleness warning (non-blocking)
  section "5.3 Framework Staleness (advisory)"
  stale_warnings=$(python3 -c "
import json, sys
from datetime import datetime

with open('$FRAMEWORKS_JSON') as f:
    data = json.load(f)

today = datetime.now()
thresholds = {'rare': 180, 'annual': 90, 'frequent': 30}
warnings = []

for fw in data['frameworks']:
    freq = fw.get('update_frequency', 'rare')
    threshold = thresholds.get(freq, 180)
    last_checked = fw.get('last_checked', '')

    if freq == 'rare':
        continue  # Skip rare frameworks for staleness warning

    if not last_checked:
        warnings.append(f\"{fw['id']}: never checked (frequency={freq})\")
        continue

    try:
        checked = datetime.strptime(last_checked, '%Y-%m-%d')
        days = (today - checked).days
        if days > threshold:
            warnings.append(f\"{fw['id']}: {days}d since last check (threshold={threshold}d)\")
    except ValueError:
        warnings.append(f\"{fw['id']}: invalid date '{last_checked}'\")

for w in warnings:
    print(w)
" 2>/dev/null || true)

  if [[ -z "$stale_warnings" ]]; then
    pass "No staleness warnings for annual/frequent frameworks"
  else
    while IFS= read -r line; do
      warn "Stale: $line"
    done <<< "$stale_warnings"
  fi
fi

# ============================================================
# Summary
# ============================================================
printf "\n\033[1m========================================\033[0m\n"
printf "\033[1mResults: \033[32m%d PASS\033[0m  \033[31m%d FAIL\033[0m  \033[33m%d SKIP\033[0m  \033[33m%d WARN\033[0m\n" "$PASS" "$FAIL" "$SKIP" "$WARN"
printf "\033[1m========================================\033[0m\n"

if (( FAIL > 0 )); then
  exit 1
fi
exit 0
