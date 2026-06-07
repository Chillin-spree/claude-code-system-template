#!/usr/bin/env python3
# PreToolUse(Bash): on a `git commit` / `git push`, run the shared safety gate and block
# the operation (exit 2) if it fails. Other Bash commands pass straight through.
import json
import re
import subprocess
import sys

command = json.load(sys.stdin).get("tool_input", {}).get("command", "")
if not re.search(r"(^|[\n;&|]\s*)git\s+(commit|push)\b", command):
    sys.exit(0)

result = subprocess.run(["sh", ".claude/hooks/precommit-safety.sh", command])
sys.exit(2 if result.returncode != 0 else 0)
