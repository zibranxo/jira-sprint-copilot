#!/usr/bin/env bash
# Jira Sprint Copilot - Skill Installer Wrapper

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/copilot.sh" install "$@"
