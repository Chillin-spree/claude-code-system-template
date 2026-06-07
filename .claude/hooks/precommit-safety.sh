#!/bin/sh
# .claude/hooks/precommit-safety.sh [mode-or-command] — dependency-free safety + security gate.
#
# Arg 1 selects what to scan:
#   "commit" (or empty)  -> staged changes (git diff --cached)         [pre-commit]
#   "push"               -> unpushed commits (@{u}..HEAD, else branch) [pre-push]
#   a full git command   -> auto-detect commit vs push from it         [Claude hook]
#
# Exits non-zero with a clear message on a hard failure (secrets, credential files,
# failing lint/test); warns but passes on soft issues (large/binary files).
# Stack-aware: lint/test come from the CLAUDE.md project block. Secret/file scans are
# stack-agnostic. False positive? Put `allowlist-secret` on the line to skip it.
set -u
red='\033[31m'
ylw='\033[33m'
grn='\033[32m'
nc='\033[0m'
fail() {
  printf "%bBLOCKED:%b %s\n" "$red" "$nc" "$1" >&2
  exit 1
}
warn() { printf "%bWARN:%b %s\n" "$ylw" "$nc" "$1" >&2; }
ok() { printf "%bok:%b %s\n" "$grn" "$nc" "$1"; }

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || fail "not inside a git repository"

# --- pick mode (commit | push) from the argument ---
arg="${1:-commit}"
case "$arg" in
  push) mode=push ;;
  commit | "") mode=commit ;;
  *)
    if printf '%s' "$arg" | grep -Eq '(^|[;&|[:space:]])git[[:space:]]+push([[:space:]]|$)'; then
      mode=push
    else
      mode=commit
    fi
    ;;
esac

# --- gather the change set for the chosen mode ---
if [ "$mode" = push ]; then
  if up=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    range="$up..HEAD"
  else
    range="$(git hash-object -t tree /dev/null)..HEAD" # no upstream: scan whole branch
  fi
  files=$(git diff --name-only --diff-filter=ACM "$range")
  added=$(git diff -U0 --diff-filter=ACM "$range" | grep -E '^\+' | grep -Ev '^\+\+\+' || true)
  bins=$(git diff --numstat --diff-filter=ACM "$range" | awk '$1=="-"&&$2=="-"{print $3}')
  scope="unpushed commits ($range)"
else
  files=$(git diff --cached --name-only --diff-filter=ACM)
  added=$(git diff --cached -U0 --diff-filter=ACM | grep -E '^\+' | grep -Ev '^\+\+\+' || true)
  bins=$(git diff --cached --numstat --diff-filter=ACM | awk '$1=="-"&&$2=="-"{print $3}')
  scope="staged changes"
fi

[ -n "$files$added" ] || {
  ok "no $scope to scan"
  exit 0
}

# Allowlist: drop lines the author marked as a known-safe false positive.
added=$(printf "%s\n" "$added" | grep -v "allowlist-secret" || true)

# 1) Secret / credential FILES in the change set ------------------------------
badf=$(printf "%s\n" "$files" | grep -Ei '(^|/)(\.env(\.[^/]+)?|id_rsa|.*\.pem|.*\.key|.*\.p12|.*\.pfx|.*\.keystore|credentials(\.json)?|\.npmrc|\.pypirc)$' | grep -Ev '\.(example|sample|template)$' || true)
[ -z "$badf" ] || fail "secret/credential file(s) in $scope:
$badf
Remove them and add to .gitignore."

# 2) SECRETS in added lines ---------------------------------------------------
hits=$(printf "%s\n" "$added" | grep -nEi \
  -e '-----BEGIN ([A-Z ]+ )?PRIVATE KEY-----' \
  -e 'AKIA[0-9A-Z]{16}' -e 'ASIA[0-9A-Z]{16}' \
  -e 'gh[pousr]_[A-Za-z0-9]{20,}' \
  -e 'xox[baprs]-[A-Za-z0-9-]{10,}' \
  -e 'AIza[0-9A-Za-z_-]{35}' \
  -e 'eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}' \
  -e '(password|passwd|secret|api[_-]?key|access[_-]?key|client[_-]?secret|auth[_-]?token|token)[[:space:]]*[:=][[:space:]]*["'\'']?[^"'\''[:space:]]{6,}' \
  || true)
hits=$(printf "%s\n" "$hits" | grep -Ev 'process\.env|import\.meta\.env|os\.environ|getenv|<[^>]+>|\$\{|\b(TBD|xxxx*|changeme|example|placeholder|redacted|your[_-])' || true)
[ -z "$hits" ] || fail "possible secret(s) in $scope:
$hits
Move secrets to env vars / a gitignored file, or add 'allowlist-secret' on the line if it's a false positive."

# high-entropy assignment heuristic (mixed case + digits, >=32 chars)
ent=$(printf "%s\n" "$added" | grep -nE '[:=][[:space:]]*["'\'']?[A-Za-z0-9+/_-]{32,}' \
  | grep -E '[a-z]' | grep -E '[A-Z]' | grep -E '[0-9]' \
  | grep -Ev 'https?://|sha[0-9]+|md5|integrity|[0-9a-f]{40,}|process\.env|import\.meta\.env' || true)
[ -z "$ent" ] || fail "high-entropy credential-like string(s) in $scope:
$ent
If it's a false positive, add 'allowlist-secret' on the line, or remove the value."

# 3) PROJECT CHECKS — stack-aware lint + test from the CLAUDE.md project block -
lint_cmd=""
test_cmd=""
if [ -f CLAUDE.md ]; then
  lint_cmd=$(grep -E '^[[:space:]]*-[[:space:]]*lint[[:space:]]' CLAUDE.md | sed -n 's/.*`\(.*\)`.*/\1/p' | head -n1)
  test_cmd=$(grep -E '^[[:space:]]*-[[:space:]]*test[[:space:]]' CLAUDE.md | sed -n 's/.*`\(.*\)`.*/\1/p' | head -n1)
fi
[ -n "$lint_cmd" ] || lint_cmd="npm run lint"
[ -n "$test_cmd" ] || test_cmd="node --test"
if [ -f package.json ] && [ ! -d node_modules ]; then
  warn "package.json present but node_modules missing — run 'npm install' to enable checks (skipping lint/test)"
elif [ -f package.json ]; then
  printf "lint: %s\n" "$lint_cmd"
  sh -c "$lint_cmd" || fail "lint failed: $lint_cmd"
  case "$test_cmd" in
    "" | "(none)") : ;;
    *)
      printf "test: %s\n" "$test_cmd"
      sh -c "$test_cmd" || fail "tests failed: $test_cmd"
      ;;
  esac
else
  warn "no package.json — skipping lint/test (bare template or pre-init project)"
fi

# 4) LARGE / BINARY files (warn only) -----------------------------------------
printf "%s\n" "$files" | while IFS= read -r f; do
  [ -f "$f" ] || continue
  sz=$(wc -c <"$f" 2>/dev/null | tr -d ' ')
  case "$sz" in '' | *[!0-9]*) sz=0 ;; esac
  [ "$sz" -gt 1048576 ] && warn "large file (${sz} bytes): $f"
done
[ -z "${bins:-}" ] || warn "binary file(s) in change set:
$bins"

ok "safety + security checks passed ($scope)"
exit 0
