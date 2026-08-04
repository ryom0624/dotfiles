#!/bin/bash
set -euo pipefail

# WARNING: Test failure stub for [CODEX_WRAPPER_FAILURE] detection testing.
# MUST NOT be used in production.
# Use via PATH shadowing: PATH="$(dirname "$0"):$PATH"
# Or symlink/copy it into place as codex-wrapper.sh or codex-wrapper-readonly.sh.
# Example: PATH="/path/to/stub-dir:$PATH" codex-wrapper.sh -C /project "prompt"

PROJECT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -C)
      if [[ $# -ge 2 ]]; then
        PROJECT_DIR="$2"
        shift 2
      else
        PROJECT_DIR=""
        shift
      fi
      ;;
    -m|-t|-r|-o|--base|--commit|--title)
      if [[ $# -ge 2 ]]; then
        shift 2
      else
        shift
      fi
      ;;
    -q|--dry-run|--uncommitted)
      shift
      ;;
    -*)
      shift
      ;;
    *)
      shift
      ;;
  esac
done

SESSION_ID="stub-failure-$(date +%Y%m%d-%H%M%S)-$$"
ATTEMPT=3
LAST_ERROR="STUB_FORCED_FAILURE: This is a test failure stub. The real wrapper was shadowed by codex-wrapper-test-failure-stub.sh."
SESSION_LOG="/dev/null"

cat <<EOF >&2
[CODEX_WRAPPER_FAILURE]
session_id: $SESSION_ID
project_dir: $PROJECT_DIR
attempts: $ATTEMPT
last_error: $LAST_ERROR
log_file: $SESSION_LOG
action_required: ESCALATE_OR_FALLBACK
EOF

exit 1
