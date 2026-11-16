#!/usr/bin/env bash
# Jira Sprint Copilot - Unix CLI Runner

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PYTHON_CLI="$ROOT_DIR/copilot.py"
VENV_PYTHON="$ROOT_DIR/../.venv-jira-tools/bin/python"

# Resolve Python interpreter
PYTHON_BIN=""
if [[ -x "$VENV_PYTHON" ]]; then
  PYTHON_BIN="$VENV_PYTHON"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="$(command -v python3)"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="$(command -v python)"
else
  printf 'Error: Python interpreter not found.\n' >&2
  exit 1
fi

exec "$PYTHON_BIN" "$PYTHON_CLI" "$@"
