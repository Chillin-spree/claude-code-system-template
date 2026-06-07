#!/usr/bin/env python3
# PostToolUse(Edit|Write|MultiEdit): format the just-edited file with Prettier.
# Widen the extension list here when stack-setup retargets to a non-vanilla stack
# (e.g. add ".jsx", ".ts", ".tsx", ".vue", ".svelte").
import json
import subprocess
import sys

path = json.load(sys.stdin).get("tool_input", {}).get("file_path", "")
if path.endswith((".js", ".css", ".html")):
    subprocess.run(["npx", "prettier", "--write", path])
