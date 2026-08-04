#!/bin/bash
# codex-wrapper-readonly.sh - Codex CLI read-only実行のハーネスラッパー
#
# 機能:
#   - read-onlyモード専用
#   - リトライ (最大3回, exponential backoff)
#   - タイムアウト管理 (デフォルト600秒)
#   - 出力キャプチャ (構造化ログ)
#   - エラーログ
#
# 使い方:
#   codex-wrapper-readonly.sh -C <project_dir> "<prompt>"
#   codex-wrapper-readonly.sh -C <project_dir> -t 300 -r 2 "<prompt>"
#
# オプション:
#   -C <dir>          プロジェクトディレクトリ (必須)
#   -t <sec>          タイムアウト秒数 (デフォルト: 600)
#   -r <num>          最大リトライ回数 (デフォルト: 3)
#   -o <file>         出力ファイル (デフォルト: 自動生成)
#   --dry-run         実行せずコマンドを表示
#
# 4-section prompt format example:
#   codex-wrapper-readonly.sh -C /path/to/project "$(cat <<'EOF'
# [Context]
# - Repository: mlops-planner
# - Scope: deployment impact review
#
# [Task]
# Review the proposed MLOps planning changes and summarize risks.
#
# [Constraints]
# - Read-only analysis only
# - Do not propose file edits
#
# [Output Format]
# - Findings first
# - Include severity and affected areas
# EOF
# )"

set -euo pipefail

# --- 定数 ---
CODEX_BIN="/opt/homebrew/bin/codex"
LOG_DIR="${HOME}/.claude/logs/codex"
MAX_RETRIES=3
TIMEOUT=600
PROJECT_DIR=""
OUTPUT_FILE=""
DRY_RUN=false
PROMPT=""

# --- ログディレクトリ初期化 ---
mkdir -p "$LOG_DIR"

# --- ヘルパー関数 ---
timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log_info() {
  echo "[codex-wrapper $(timestamp)] INFO: $*" >&2
}

log_error() {
  echo "[codex-wrapper $(timestamp)] ERROR: $*" >&2
}

log_to_file() {
  local logfile="$1"
  shift
  echo "[$(timestamp)] $*" >> "$logfile"
}

# --- 引数パース ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    -C)
      PROJECT_DIR="$2"
      shift 2
      ;;
    -t)
      TIMEOUT="$2"
      shift 2
      ;;
    -r)
      MAX_RETRIES="$2"
      shift 2
      ;;
    -o)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -*)
      log_error "Unknown option: $1"
      exit 1
      ;;
    *)
      PROMPT="$1"
      shift
      ;;
  esac
done

# --- バリデーション ---
if [[ -z "$PROJECT_DIR" ]]; then
  log_error "プロジェクトディレクトリ (-C) は必須です"
  exit 1
fi

if [[ -z "$PROMPT" ]]; then
  log_error "プロンプトが指定されていません"
  exit 1
fi

if [[ ! -d "$PROJECT_DIR" ]]; then
  log_error "ディレクトリが存在しません: $PROJECT_DIR"
  exit 1
fi

if [[ ! -x "$CODEX_BIN" ]]; then
  log_error "Codex CLIが見つかりません: $CODEX_BIN"
  exit 2
fi

# --- セッションID生成 ---
SESSION_ID="codex-readonly-$(date '+%Y%m%d-%H%M%S')-$$"
SESSION_LOG="${LOG_DIR}/${SESSION_ID}.log"
OUTPUT_FILE="${OUTPUT_FILE:-${LOG_DIR}/${SESSION_ID}-output.md}"

# --- プロジェクトコンテキスト注入 ---
# CLAUDE.md規定の 4-section 形式 ([Context]/[Task]/[Constraints]/[Reference Code]) を破壊しないため、
# .codex-context.md がある場合は呼び出し元の [Context] セクション内に統合する。
# 呼び出し元プロンプトに `[Context]\n` ヘッダーがある場合のみ、その直後に context content を挿入する(in-place merge)。
# ヘッダーがない/見つからない場合は、4-section 形式が組まれていないとみなし、context は付与しない(警告ログのみ)。
ENHANCED_PROMPT="$PROMPT"
CONTEXT_FILE="${PROJECT_DIR}/.codex-context.md"
if [[ -f "$CONTEXT_FILE" ]]; then
  CONTEXT_CONTENT=$(cat "$CONTEXT_FILE")
  if [[ "$PROMPT" == *"[Context]"* ]]; then
    # [Context]\n の直後に注入(awkでin-place merge)
    ENHANCED_PROMPT=$(printf '%s' "$PROMPT" | awk -v ctx="$CONTEXT_CONTENT" '
      BEGIN { injected = 0 }
      {
        print
        if (!injected && $0 ~ /^\[Context\][[:space:]]*$/) {
          print "(プロジェクトコンテキスト統合)"
          print ctx
          print ""
          injected = 1
        }
      }
    ')
    log_info "プロジェクトコンテキストを [Context] セクションに統合: $CONTEXT_FILE"
  else
    log_info "プロンプトに [Context] セクションが見つからないため、コンテキスト注入をスキップ: $CONTEXT_FILE"
    log_info "(4-section形式 [Context]/[Task]/[Constraints]/[Reference Code] を使うとコンテキストが自動統合されます)"
  fi
fi

# --- Dry Run ---
if [[ "$DRY_RUN" == "true" ]]; then
  echo "=== Dry Run ==="
  echo "Session: $SESSION_ID"
  echo "Mode: readonly"
  echo "Project: $PROJECT_DIR"
  echo "Timeout: ${TIMEOUT}s"
  echo "Retries: $MAX_RETRIES"
  echo "Output: $OUTPUT_FILE"
  echo "Command: $CODEX_BIN exec -s read-only --skip-git-repo-check -C \"$PROJECT_DIR\" \"<prompt>\""
  echo ""
  echo "=== Prompt ==="
  echo "$ENHANCED_PROMPT"
  exit 0
fi

# --- OUTPUT_FILE親ディレクトリ保証 (MEDIUM-2 fix; dry-run後に実行してファイルシステム副作用を回避) ---
mkdir -p "$(dirname "$OUTPUT_FILE")"

# --- セッションログ開始 ---
log_to_file "$SESSION_LOG" "=== Codex Readonly Session Start ==="
log_to_file "$SESSION_LOG" "Session ID: $SESSION_ID"
log_to_file "$SESSION_LOG" "Mode: readonly"
log_to_file "$SESSION_LOG" "Project: $PROJECT_DIR"
log_to_file "$SESSION_LOG" "Timeout: ${TIMEOUT}s"
log_to_file "$SESSION_LOG" "Max Retries: $MAX_RETRIES"
log_to_file "$SESSION_LOG" "Prompt: $PROMPT"

# --- 実行 (リトライ付き) ---
ATTEMPT=0
EXIT_CODE=1
LAST_ERROR=""
CODEX_OUTPUT=""
EXEC_DURATION=0

while [[ $ATTEMPT -lt $MAX_RETRIES ]]; do
  ATTEMPT=$((ATTEMPT + 1))
  BACKOFF=$((2 ** (ATTEMPT - 1)))

  if [[ $ATTEMPT -gt 1 ]]; then
    log_info "リトライ ${ATTEMPT}/${MAX_RETRIES} (${BACKOFF}秒待機)"
    log_to_file "$SESSION_LOG" "Retry ${ATTEMPT}/${MAX_RETRIES} after ${BACKOFF}s backoff"
    sleep "$BACKOFF"
  fi

  log_info "Codex CLI [readonly] 実行開始 (attempt ${ATTEMPT}/${MAX_RETRIES})"
  log_to_file "$SESSION_LOG" "--- Attempt $ATTEMPT ---"

  EXEC_START=$(date +%s)

  set +e
  CODEX_OUTPUT=$(gtimeout "${TIMEOUT}s" "$CODEX_BIN" exec -s read-only --skip-git-repo-check \
    -o "$OUTPUT_FILE" \
    -C "$PROJECT_DIR" \
    "$ENHANCED_PROMPT" 2>&1)
  EXIT_CODE=$?
  set -e

  EXEC_END=$(date +%s)
  EXEC_DURATION=$((EXEC_END - EXEC_START))

  log_to_file "$SESSION_LOG" "Exit Code: $EXIT_CODE"
  log_to_file "$SESSION_LOG" "Duration: ${EXEC_DURATION}s"
  log_to_file "$SESSION_LOG" "Output: $CODEX_OUTPUT"

  if [[ $EXIT_CODE -eq 0 ]]; then
    log_info "Codex CLI [readonly] 成功 (${EXEC_DURATION}秒)"
    break
  fi

  if [[ $EXIT_CODE -eq 124 ]]; then
    LAST_ERROR="TIMEOUT after ${TIMEOUT}s"
    log_error "タイムアウト (${TIMEOUT}秒超過)"
    log_to_file "$SESSION_LOG" "TIMEOUT"
    continue
  fi

  LAST_ERROR="Exit code $EXIT_CODE: $CODEX_OUTPUT"
  log_error "失敗 (exit code: $EXIT_CODE)"
  log_to_file "$SESSION_LOG" "ERROR: $CODEX_OUTPUT"
done

# --- 全リトライ失敗 ---
if [[ $EXIT_CODE -ne 0 ]]; then
  log_to_file "$SESSION_LOG" "=== All retries exhausted ==="
  log_to_file "$SESSION_LOG" "Last Error: $LAST_ERROR"
  log_error "全${MAX_RETRIES}回のリトライが失敗"
  log_error "Last Error: $LAST_ERROR"
  log_error "セッションログ: $SESSION_LOG"

  cat <<HEREDOC >&2
[CODEX_WRAPPER_FAILURE]
session_id: $SESSION_ID
project_dir: $PROJECT_DIR
attempts: $ATTEMPT
last_error: $LAST_ERROR
log_file: $SESSION_LOG
action_required: ESCALATE_OR_FALLBACK
HEREDOC
  exit $EXIT_CODE
fi

# --- サマリー出力 ---
log_to_file "$SESSION_LOG" "=== Session Complete ==="
log_to_file "$SESSION_LOG" "Mode: readonly"
log_to_file "$SESSION_LOG" "Duration: ${EXEC_DURATION}s"
log_to_file "$SESSION_LOG" "Status: SUCCESS"

log_to_file "$SESSION_LOG" "Output saved to: $OUTPUT_FILE"

cat <<HEREDOC
[CODEX_READONLY_SUCCESS]
session_id: $SESSION_ID
mode: readonly
project_dir: $PROJECT_DIR
duration: ${EXEC_DURATION}s
attempts: $ATTEMPT
output_file: $OUTPUT_FILE
log_file: $SESSION_LOG
changed_files: 0
---
$(cat "$OUTPUT_FILE")
HEREDOC
