#!/usr/bin/env bash
# check-framework-updates.sh — Ad-hoc CLI to check framework version staleness
# Usage:
#   bash tests/check-framework-updates.sh          # Show CRITICAL + DUE only
#   bash tests/check-framework-updates.sh --all    # Include OK frameworks too
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST="$REPO_ROOT/frameworks.json"

SHOW_ALL=false
[[ "${1:-}" == "--all" ]] && SHOW_ALL=true

# --- Colors ---
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'
CYAN='\033[36m'
BOLD='\033[1m'
RESET='\033[0m'

if [[ ! -f "$MANIFEST" ]]; then
  printf "${RED}ERROR${RESET}: frameworks.json not found at %s\n" "$MANIFEST"
  exit 1
fi

if ! python3 -c "import json; json.load(open('$MANIFEST'))" 2>/dev/null; then
  printf "${RED}ERROR${RESET}: frameworks.json has invalid JSON\n"
  exit 1
fi

# --- Calculate staleness ---
TODAY=$(date +%Y-%m-%d)

python3 - "$MANIFEST" "$TODAY" "$SHOW_ALL" <<'PYTHON_SCRIPT'
import json
import sys
from datetime import datetime, timedelta

manifest_path = sys.argv[1]
today_str = sys.argv[2]
show_all = sys.argv[3] == "True"

today = datetime.strptime(today_str, "%Y-%m-%d")

with open(manifest_path) as f:
    data = json.load(f)

# Staleness thresholds in days
THRESHOLDS = {
    "rare": 180,
    "annual": 90,
    "frequent": 30,
}

# ANSI colors
RED = "\033[31m"
YELLOW = "\033[33m"
GREEN = "\033[32m"
CYAN = "\033[36m"
BOLD = "\033[1m"
DIM = "\033[2m"
RESET = "\033[0m"

critical = []
due = []
ok = []

for fw in data["frameworks"]:
    fid = fw["id"]
    name = fw["name"]
    version = fw["version"]
    freq = fw.get("update_frequency", "rare")
    last_checked = fw.get("last_checked", "")
    source_url = fw.get("source_url", "")
    threshold = THRESHOLDS.get(freq, 180)

    if not last_checked:
        critical.append((fid, name, version, freq, "never", source_url, 9999))
        continue

    try:
        checked_date = datetime.strptime(last_checked, "%Y-%m-%d")
    except ValueError:
        critical.append((fid, name, version, freq, last_checked, source_url, 9999))
        continue

    days_since = (today - checked_date).days

    if days_since > threshold * 2:
        critical.append((fid, name, version, freq, last_checked, source_url, days_since))
    elif days_since > threshold:
        due.append((fid, name, version, freq, last_checked, source_url, days_since))
    else:
        ok.append((fid, name, version, freq, last_checked, source_url, days_since))

# --- Print report ---
last_review = data.get("last_full_review", "unknown")
total = len(data["frameworks"])
print(f"\n{BOLD}Framework Version Staleness Report{RESET}")
print(f"Last full review: {last_review}  |  Total frameworks: {total}")
print(f"Thresholds: rare={THRESHOLDS['rare']}d  annual={THRESHOLDS['annual']}d  frequent={THRESHOLDS['frequent']}d")
print(f"{'=' * 80}")

def print_section(label, color, items):
    if not items:
        return
    print(f"\n{color}{BOLD}{label} ({len(items)}){RESET}")
    print(f"  {'ID':<20} {'Name':<35} {'Version':<10} {'Freq':<10} {'Days':<6} Last Checked")
    print(f"  {'-'*20} {'-'*35} {'-'*10} {'-'*10} {'-'*6} {'-'*12}")
    for fid, name, version, freq, checked, url, days in sorted(items, key=lambda x: -x[6]):
        days_str = str(days) if days < 9999 else "never"
        print(f"  {color}{fid:<20}{RESET} {name:<35} {version:<10} {freq:<10} {days_str:<6} {checked}")
        if url:
            print(f"  {DIM}  -> {url}{RESET}")

print_section("CRITICAL (>2x threshold)", RED, critical)
print_section("DUE (>threshold)", YELLOW, due)

if show_all:
    print_section("OK", GREEN, ok)
else:
    if ok:
        print(f"\n{GREEN}{BOLD}OK ({len(ok)}){RESET} — {len(ok)} frameworks within threshold. Use --all to show details.")

# Summary
print(f"\n{'=' * 80}")
print(f"{BOLD}Summary:{RESET} {RED}{len(critical)} CRITICAL{RESET}  {YELLOW}{len(due)} DUE{RESET}  {GREEN}{len(ok)} OK{RESET}")

if critical or due:
    print(f"\n{BOLD}Next steps:{RESET}")
    print("  1. Visit source URLs above to check for newer versions")
    print("  2. Follow docs/FRAMEWORK-UPDATE-RUNBOOK.md for update procedure")
    print("  3. Update last_checked in frameworks.json after verifying")
    sys.exit(1 if critical else 0)
else:
    print(f"\n{GREEN}All frameworks are within check thresholds.{RESET}")
    sys.exit(0)
PYTHON_SCRIPT
