#!/usr/bin/env python3
# PreToolUse(Edit|Write|MultiEdit|NotebookEdit): block writes to secret/credential paths.
# Blocks `.env` and `.env.*` and anything under `.git/`, but allows committable templates
# (`.env.example` / `.sample` / `.template`), matching .gitignore + precommit-safety.sh.
import json
import os
import sys

path = json.load(sys.stdin).get("tool_input", {}).get("file_path", "")
name = os.path.basename(path)

is_env = name == ".env" or name.startswith(".env.")
is_template = name.endswith((".example", ".sample", ".template"))
is_git = name == ".git" or "/.git/" in path

if (is_env and not is_template) or is_git:
    sys.stderr.write(f"Blocked write to protected path: {path}\n")
    sys.exit(2)
