#!/bin/bash
# codex-wrapper.sh - Codex CLI実行のハーネスラッパー
#
# 機能:
#   - exec / review 両モード対応
#   - リトライ (最大3回, exponential backoff)
#   - タイムアウト管理 (デフォルト600秒)
#   - 出力キャプチャ (構造化ログ)
#   - 実行前後のgit diffキャプチャ (execモード)
#   - エラーログ
#
# 使い方:
#   codex-wrapper.sh -C <project_dir> "<prompt>"
#   codex-wrapper.sh -C <project_dir> -t 300 -r 2 "<prompt>"
#   codex-wrapper.sh -C <project_dir> -m review --uncommitted "<review_instructions>"
#   codex-wrapper.sh -C <project_dir> -m review --base main "<review_instructions>"
#   codex-wrapper.sh -C <project_dir> -m review --commit abc123 "<review_instructions>"
#
# オプション:
#   -C <dir>          プロジェクトディレクトリ (必須)
#   -m <mode>         実行モード: exec (デフォルト) / review
#   -t <sec>          タイムアウト秒数 (デフォルト: 600)
#   -r <num>          最大リトライ回数 (デフォルト: 3)
#   -o <file>         出力ファイル (デフォルト: 自動生成)
#   -q                品質検証スキップ
#   --dry-run         実行せずコマンドを表示
#   --uncommitted     [review] 未コミットの変更をレビュー
#   --base <branch>   [review] 指定ブランチとの差分をレビュー
#   --commit <sha>    [review] 特定コミットの変更をレビュー
#   --title <title>   [review] レビューサマリーのタイトル

set -euo pipefail

# --- 定数 ---
CODEX_BIN="/opt/homebrew/bin/codex"
LOG_DIR="${HOME}/.claude/logs/codex"
MAX_RETRIES=3
TIMEOUT=600
PROJECT_DIR=""
OUTPUT_FILE=""
SKIP_QUALITY=false
DRY_RUN=false
PROMPT=""
MODE="exec"
# review モード用オプション
REVIEW_UNCOMMITTED=false
REVIEW_BASE=""
REVIEW_COMMIT=""
REVIEW_TITLE=""

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
    -m)
      MODE="$2"
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
    -q)
      SKIP_QUALITY=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --uncommitted)
      REVIEW_UNCOMMITTED=true
      shift
      ;;
    --base)
      REVIEW_BASE="$2"
      shift 2
      ;;
    --commit)
      REVIEW_COMMIT="$2"
      shift 2
      ;;
    --title)
      REVIEW_TITLE="$2"
      shift 2
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

if [[ "$MODE" != "exec" && "$MODE" != "review" ]]; then
  log_error "無効なモード: $MODE (exec または review を指定)"
  exit 1
fi

# execモードではプロンプト必須、reviewモードでは任意（カスタム指示）
if [[ "$MODE" == "exec" && -z "$PROMPT" ]]; then
  log_error "プロンプトが指定されていません"
  exit 1
fi

# reviewモードではレビュー対象の指定が必要
if [[ "$MODE" == "review" ]]; then
  if [[ "$REVIEW_UNCOMMITTED" != "true" && -z "$REVIEW_BASE" && -z "$REVIEW_COMMIT" ]]; then
    log_error "reviewモードでは --uncommitted, --base, --commit のいずれかを指定してください"
    exit 1
  fi
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
SESSION_ID="codex-${MODE}-$(date '+%Y%m%d-%H%M%S')-$$"
SESSION_LOG="${LOG_DIR}/${SESSION_ID}.log"
OUTPUT_FILE="${OUTPUT_FILE:-${LOG_DIR}/${SESSION_ID}-output.md}"

# --- プロジェクトコンテキスト注入 (execモードのみ) ---
ENHANCED_PROMPT="$PROMPT"

if [[ "$MODE" == "exec" ]]; then
  CONTEXT_FILE="${PROJECT_DIR}/.codex-context.md"
  if [[ -f "$CONTEXT_FILE" ]]; then
    CONTEXT_CONTENT=$(cat "$CONTEXT_FILE")
    ENHANCED_PROMPT="[Project Context]
${CONTEXT_CONTENT}

[Task]
${PROMPT}"
    log_info "プロジェクトコンテキストを注入: $CONTEXT_FILE"
  fi
fi

# --- Dry Run ---
if [[ "$DRY_RUN" == "true" ]]; then
  echo "=== Dry Run ==="
  echo "Session: $SESSION_ID"
  echo "Mode: $MODE"
  echo "Project: $PROJECT_DIR"
  echo "Timeout: ${TIMEOUT}s"
  echo "Retries: $MAX_RETRIES"
  echo "Output: $OUTPUT_FILE"
  if [[ "$MODE" == "exec" ]]; then
    echo "Command: $CODEX_BIN exec --full-auto -C \"$PROJECT_DIR\" -o \"$OUTPUT_FILE\" \"<prompt>\""
  else
    REVIEW_OPTS=""
    [[ "$REVIEW_UNCOMMITTED" == "true" ]] && REVIEW_OPTS+=" --uncommitted"
    [[ -n "$REVIEW_BASE" ]] && REVIEW_OPTS+=" --base $REVIEW_BASE"
    [[ -n "$REVIEW_COMMIT" ]] && REVIEW_OPTS+=" --commit $REVIEW_COMMIT"
    if [[ -n "$PROMPT" && ("$REVIEW_UNCOMMITTED" == "true" || -n "$REVIEW_BASE" || -n "$REVIEW_COMMIT") ]]; then
      # --uncommitted等と PROMPT は排他的 → --title 経由
      [[ -z "$REVIEW_TITLE" ]] && REVIEW_OPTS+=" --title \"<prompt>\""
    elif [[ -n "$PROMPT" ]]; then
      REVIEW_OPTS+=" \"<prompt>\""
    fi
    [[ -n "$REVIEW_TITLE" ]] && REVIEW_OPTS+=" --title \"$REVIEW_TITLE\""
    echo "Command: cd \"$PROJECT_DIR\" && $CODEX_BIN review${REVIEW_OPTS}"
  fi
  echo ""
  echo "=== Prompt ==="
  echo "$ENHANCED_PROMPT"
  exit 0
fi

# --- セッションログ開始 ---
log_to_file "$SESSION_LOG" "=== Codex Session Start ==="
log_to_file "$SESSION_LOG" "Session ID: $SESSION_ID"
log_to_file "$SESSION_LOG" "Mode: $MODE"
log_to_file "$SESSION_LOG" "Project: $PROJECT_DIR"
log_to_file "$SESSION_LOG" "Timeout: ${TIMEOUT}s"
log_to_file "$SESSION_LOG" "Max Retries: $MAX_RETRIES"
log_to_file "$SESSION_LOG" "Prompt: $PROMPT"
if [[ "$MODE" == "review" ]]; then
  log_to_file "$SESSION_LOG" "Review uncommitted: $REVIEW_UNCOMMITTED"
  log_to_file "$SESSION_LOG" "Review base: $REVIEW_BASE"
  log_to_file "$SESSION_LOG" "Review commit: $REVIEW_COMMIT"
fi

# --- Pre-execution: Git状態キャプチャ (execモードのみ) ---
PRE_GIT_SHA=""
ALL_CHANGES=""
if [[ "$MODE" == "exec" ]] && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  PRE_GIT_SHA=$(git -C "$PROJECT_DIR" rev-parse HEAD 2>/dev/null || echo "none")
  PRE_GIT_STATUS=$(git -C "$PROJECT_DIR" status --short 2>/dev/null || echo "")
  log_to_file "$SESSION_LOG" "Pre-execution Git SHA: $PRE_GIT_SHA"
  log_to_file "$SESSION_LOG" "Pre-execution Git Status:"
  log_to_file "$SESSION_LOG" "$PRE_GIT_STATUS"
fi

# --- 実行 (リトライ付き) ---
ATTEMPT=0
EXIT_CODE=1
LAST_ERROR=""

while [[ $ATTEMPT -lt $MAX_RETRIES ]]; do
  ATTEMPT=$((ATTEMPT + 1))
  BACKOFF=$((2 ** (ATTEMPT - 1)))

  if [[ $ATTEMPT -gt 1 ]]; then
    log_info "リトライ ${ATTEMPT}/${MAX_RETRIES} (${BACKOFF}秒待機)"
    log_to_file "$SESSION_LOG" "Retry ${ATTEMPT}/${MAX_RETRIES} after ${BACKOFF}s backoff"
    sleep "$BACKOFF"
  fi

  log_info "Codex CLI [${MODE}] 実行開始 (attempt ${ATTEMPT}/${MAX_RETRIES})"
  log_to_file "$SESSION_LOG" "--- Attempt $ATTEMPT ---"

  EXEC_START=$(date +%s)

  # タイムアウト付きで実行
  set +e
  if [[ "$MODE" == "exec" ]]; then
    CODEX_OUTPUT=$(gtimeout "${TIMEOUT}s" "$CODEX_BIN" exec --full-auto \
      -C "$PROJECT_DIR" \
      -o "$OUTPUT_FILE" \
      "$ENHANCED_PROMPT" 2>&1)
  else
    # review モード: オプション組み立て
    # 注意: codex review は -C フラグ未対応のため、cd で移動してから実行する
    REVIEW_ARGS=()
    [[ "$REVIEW_UNCOMMITTED" == "true" ]] && REVIEW_ARGS+=(--uncommitted)
    [[ -n "$REVIEW_BASE" ]] && REVIEW_ARGS+=(--base "$REVIEW_BASE")
    [[ -n "$REVIEW_COMMIT" ]] && REVIEW_ARGS+=(--commit "$REVIEW_COMMIT")
    [[ -n "$REVIEW_TITLE" ]] && REVIEW_ARGS+=(--title "$REVIEW_TITLE")
    # プロンプト（カスタムレビュー指示）: --uncommitted/--base/--commit と PROMPT は排他的
    # v0.101.0 以降、--uncommitted 等と [PROMPT] を同時に渡すとエラーになるため、
    # カスタム指示がある場合は --title 経由で渡す
    if [[ -n "$ENHANCED_PROMPT" ]]; then
      if [[ "$REVIEW_UNCOMMITTED" == "true" || -n "$REVIEW_BASE" || -n "$REVIEW_COMMIT" ]]; then
        # レビュー対象指定ありの場合: カスタム指示は --title に付与
        if [[ -z "$REVIEW_TITLE" ]]; then
          REVIEW_ARGS+=(--title "$ENHANCED_PROMPT")
        fi
        log_info "reviewモード: カスタム指示を --title 経由で渡します"
      else
        # レビュー対象指定なしの場合: PROMPT をそのまま渡す
        REVIEW_ARGS+=("$ENHANCED_PROMPT")
      fi
    fi

    CODEX_OUTPUT=$(cd "$PROJECT_DIR" && gtimeout "${TIMEOUT}s" "$CODEX_BIN" review "${REVIEW_ARGS[@]}" 2>&1)
  fi
  EXIT_CODE=$?
  set -e

  EXEC_END=$(date +%s)
  EXEC_DURATION=$((EXEC_END - EXEC_START))

  log_to_file "$SESSION_LOG" "Exit Code: $EXIT_CODE"
  log_to_file "$SESSION_LOG" "Duration: ${EXEC_DURATION}s"
  log_to_file "$SESSION_LOG" "Output: $CODEX_OUTPUT"

  # 成功
  if [[ $EXIT_CODE -eq 0 ]]; then
    log_info "Codex CLI [${MODE}] 成功 (${EXEC_DURATION}秒)"
    break
  fi

  # タイムアウト (exit code 124)
  if [[ $EXIT_CODE -eq 124 ]]; then
    LAST_ERROR="TIMEOUT after ${TIMEOUT}s"
    log_error "タイムアウト (${TIMEOUT}秒超過)"
    log_to_file "$SESSION_LOG" "TIMEOUT"
    continue
  fi

  # その他のエラー
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

  # 構造化エラー出力 (呼び出し元のエージェントが解析可能)
  cat <<EOF >&2
[CODEX_WRAPPER_FAILURE]
session_id: $SESSION_ID
project_dir: $PROJECT_DIR
attempts: $ATTEMPT
last_error: $LAST_ERROR
log_file: $SESSION_LOG
action_required: ESCALATE_OR_FALLBACK
EOF
  exit $EXIT_CODE
fi

# --- Post-execution: Git差分キャプチャ (execモードのみ) ---
if [[ "$MODE" == "exec" && -n "$PRE_GIT_SHA" ]] && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
  POST_GIT_SHA=$(git -C "$PROJECT_DIR" rev-parse HEAD 2>/dev/null || echo "none")
  POST_GIT_STATUS=$(git -C "$PROJECT_DIR" status --short 2>/dev/null || echo "")

  log_to_file "$SESSION_LOG" "Post-execution Git SHA: $POST_GIT_SHA"
  log_to_file "$SESSION_LOG" "Post-execution Git Status:"
  log_to_file "$SESSION_LOG" "$POST_GIT_STATUS"

  # 変更されたファイル一覧
  CHANGED_FILES=$(git -C "$PROJECT_DIR" diff --name-only "$PRE_GIT_SHA" HEAD 2>/dev/null || echo "")
  UNSTAGED_CHANGES=$(git -C "$PROJECT_DIR" diff --name-only 2>/dev/null || echo "")
  ALL_CHANGES=$(echo -e "${CHANGED_FILES}\n${UNSTAGED_CHANGES}" | sort -u | grep -v '^$' || true)

  if [[ -n "$ALL_CHANGES" ]]; then
    log_to_file "$SESSION_LOG" "Changed files:"
    log_to_file "$SESSION_LOG" "$ALL_CHANGES"
    log_info "変更ファイル数: $(echo "$ALL_CHANGES" | wc -l | tr -d ' ')"
  fi

  # 差分をログに保存
  DIFF_OUTPUT=$(git -C "$PROJECT_DIR" diff "$PRE_GIT_SHA" HEAD 2>/dev/null || echo "")
  UNSTAGED_DIFF=$(git -C "$PROJECT_DIR" diff 2>/dev/null || echo "")
  if [[ -n "$DIFF_OUTPUT" || -n "$UNSTAGED_DIFF" ]]; then
    DIFF_FILE="${LOG_DIR}/${SESSION_ID}-diff.patch"
    {
      echo "=== Committed Changes ==="
      echo "$DIFF_OUTPUT"
      echo ""
      echo "=== Unstaged Changes ==="
      echo "$UNSTAGED_DIFF"
    } > "$DIFF_FILE"
    log_info "差分保存: $DIFF_FILE"
  fi
fi

# --- Post-execution: 品質検証 (execモードのみ) ---
if [[ "$MODE" == "exec" && "$SKIP_QUALITY" != "true" && -n "$ALL_CHANGES" ]]; then
  log_info "品質検証を実行中..."
  QUALITY_ISSUES=0

  # Python ファイルの検証
  PY_FILES=$(echo "$ALL_CHANGES" | grep '\.py$' || true)
  if [[ -n "$PY_FILES" ]]; then
    # ruff check
    if command -v uv &>/dev/null; then
      set +e
      RUFF_OUTPUT=$(cd "$PROJECT_DIR" && uv run ruff check $PY_FILES 2>&1)
      RUFF_EXIT=$?
      set -e
      if [[ $RUFF_EXIT -ne 0 ]]; then
        log_info "[Quality] ruff check: issues found"
        log_to_file "$SESSION_LOG" "Ruff issues: $RUFF_OUTPUT"
        QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
      fi
    fi
  fi

  # mypy による型チェック (Python)
  if [[ -n "$PY_FILES" ]]; then
    if command -v uv &>/dev/null && [[ -f "${PROJECT_DIR}/pyproject.toml" ]]; then
      # mypy がプロジェクトの依存に含まれている場合のみ実行
      set +e
      MYPY_OUTPUT=$(cd "$PROJECT_DIR" && uv run mypy --ignore-missing-imports $PY_FILES 2>&1)
      MYPY_EXIT=$?
      set -e
      if [[ $MYPY_EXIT -ne 0 ]]; then
        log_info "[Quality] mypy: type errors found"
        log_to_file "$SESSION_LOG" "Mypy issues: $MYPY_OUTPUT"
        QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
      fi
    fi
  fi

  # pytest 実行 (変更されたテストファイルがある場合)
  if [[ -n "$PY_FILES" ]]; then
    TEST_FILES=$(echo "$ALL_CHANGES" | grep -E 'test_.*\.py$|.*_test\.py$' || true)
    if [[ -n "$TEST_FILES" ]] && command -v uv &>/dev/null; then
      set +e
      PYTEST_OUTPUT=$(cd "$PROJECT_DIR" && uv run pytest --tb=short -q $TEST_FILES 2>&1 | tail -20)
      PYTEST_EXIT=$?
      set -e
      if [[ $PYTEST_EXIT -ne 0 ]]; then
        log_info "[Quality] pytest: test failures found"
        log_to_file "$SESSION_LOG" "Pytest issues: $PYTEST_OUTPUT"
        QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
      fi
    fi
  fi

  # TypeScript/JavaScript ファイルの検証
  TS_FILES=$(echo "$ALL_CHANGES" | grep -E '\.(ts|tsx|js|jsx)$' || true)
  if [[ -n "$TS_FILES" ]]; then
    if [[ -f "${PROJECT_DIR}/tsconfig.json" ]]; then
      set +e
      TSC_OUTPUT=$(cd "$PROJECT_DIR" && npx tsc --noEmit --pretty false 2>&1 | head -20)
      TSC_EXIT=$?
      set -e
      if [[ $TSC_EXIT -ne 0 ]]; then
        log_info "[Quality] tsc: type errors found"
        log_to_file "$SESSION_LOG" "TypeScript issues: $TSC_OUTPUT"
        QUALITY_ISSUES=$((QUALITY_ISSUES + 1))
      fi
    fi
  fi

  if [[ $QUALITY_ISSUES -gt 0 ]]; then
    log_info "[Quality] ${QUALITY_ISSUES} 件の品質問題を検出。セッションログを確認: $SESSION_LOG"
  else
    log_info "[Quality] 品質検証パス"
  fi
fi

# --- サマリー出力 ---
log_to_file "$SESSION_LOG" "=== Session Complete ==="
log_to_file "$SESSION_LOG" "Mode: $MODE"
log_to_file "$SESSION_LOG" "Duration: ${EXEC_DURATION}s"
log_to_file "$SESSION_LOG" "Status: SUCCESS"

if [[ "$MODE" == "exec" ]]; then
  cat <<EOF
[CODEX_WRAPPER_SUCCESS]
session_id: $SESSION_ID
mode: exec
project_dir: $PROJECT_DIR
duration: ${EXEC_DURATION}s
attempts: $ATTEMPT
output_file: $OUTPUT_FILE
log_file: $SESSION_LOG
changed_files: $(echo "$ALL_CHANGES" | wc -l | tr -d ' ')
EOF
else
  # reviewモード: レビュー結果をファイルに保存して出力
  echo "$CODEX_OUTPUT" > "$OUTPUT_FILE"
  log_to_file "$SESSION_LOG" "Review output saved to: $OUTPUT_FILE"

  cat <<EOF
[CODEX_REVIEW_SUCCESS]
session_id: $SESSION_ID
mode: review
project_dir: $PROJECT_DIR
duration: ${EXEC_DURATION}s
attempts: $ATTEMPT
output_file: $OUTPUT_FILE
log_file: $SESSION_LOG
EOF
  echo "---"
  echo "$CODEX_OUTPUT"
fi
