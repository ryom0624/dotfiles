#!/bin/bash
# macOS Bash 3.2 互換

_FAILED=0

# スクリプト自身の実体ディレクトリを DOTFILES_DIR として解決
# シンボリックリンク越しでも正しく解決するため readlink -f を使用
# macOS (Bash 3.2) では readlink -f が使えないため代替手段を用いる
_resolve_dir() {
  local src="$1"
  local previous_src
  while [ -L "$src" ]; do
    previous_src="$src"
    src="$(readlink "$src")"
    # 相対パスの場合はディレクトリを補完
    case "$src" in
      /*) ;;
      *) src="$(dirname "$previous_src")/$src" ;;
    esac
  done
  echo "$(cd "$(dirname "$src")" && pwd)"
}
DOTFILES_DIR="$(_resolve_dir "${BASH_SOURCE[0]}")"

# --- 安全なシンボリックリンク作成関数 ---
# 使い方: _safe_link <リンク元の実体ファイル> <リンク先パス>
# ・リンク元が存在しない場合はスキップ（警告）
# ・正しいリンクが既に存在する場合はスキップ（正常）
# ・別ターゲットを指すリンクが既に存在する場合は警告してスキップ
# ・通常ファイル/ディレクトリが存在する場合はバックアップ後にリンク作成
_safe_link() {
  local target="$1"
  local link="$2"
  local link_dir
  link_dir="$(dirname "$link")"

  if [ ! -e "$target" ]; then
    echo "Warning: link source not found: $target. Skipping." >&2
    _FAILED=1
    return 1
  fi

  if [ -L "$link" ]; then
    local current_target
    current_target="$(readlink "$link")"
    if [ "$current_target" = "$target" ]; then
      echo "Symlink already correct: $link -> $target"
    else
      echo "Warning: $link already points to '$current_target', not '$target'. Skipping." >&2
      _FAILED=1
      return 1
    fi
    return 0
  fi

  if [ -e "$link" ]; then
    local backup
    backup="${link}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing $link to $backup"
    if ! mv "$link" "$backup"; then
      echo "Warning: failed to back up $link. Skipping." >&2
      _FAILED=1
      return 1
    fi
  fi

  if ! mkdir -p "$link_dir"; then
    echo "Warning: failed to create parent directory: $link_dir. Skipping." >&2
    _FAILED=1
    return 1
  fi

  if ! ln -s "$target" "$link"; then
    echo "Warning: failed to create symlink: $link -> $target" >&2
    _FAILED=1
    return 1
  fi
  echo "Created symlink: $link -> $target"
}

# --- Git submodule の初期化・更新 ---
if ! command -v git >/dev/null 2>&1; then
  echo "Warning: git not found. Skipping submodule initialization." >&2
  _FAILED=1
else
  echo "Initializing submodules in $DOTFILES_DIR..."
  if ! git -C "$DOTFILES_DIR" submodule update --init --recursive; then
    echo "Warning: submodule update failed." >&2
    _FAILED=1
  else
    # fzf バイナリのビルド・シンボリックリンク作成
    FZF_DIR="$DOTFILES_DIR/tools/fzf"
    if [ -f "$FZF_DIR/install" ]; then
      echo "Installing fzf binary..."
      if ! "$FZF_DIR/install" --bin; then
        echo "Warning: fzf install --bin failed" >&2
        _FAILED=1
      else
        mkdir -p "$HOME/.local/bin"
        FZF_LINK="$HOME/.local/bin/fzf"
        FZF_TARGET="$FZF_DIR/bin/fzf"
        if [ ! -x "$FZF_TARGET" ]; then
          echo "Warning: fzf binary not found at $FZF_TARGET" >&2
          _FAILED=1
        elif [ -L "$FZF_LINK" ]; then
          if [ "$(readlink "$FZF_LINK")" = "$FZF_TARGET" ]; then
            echo "Symlink already exists: $FZF_LINK -> $FZF_TARGET"
          else
            echo "Warning: $FZF_LINK points elsewhere. Skipping." >&2
            _FAILED=1
          fi
        elif [ -e "$FZF_LINK" ]; then
          echo "Warning: $FZF_LINK exists and is not a symlink. Skipping." >&2
          _FAILED=1
        else
          ln -s "$FZF_TARGET" "$FZF_LINK"
          echo "Created symlink: $FZF_LINK -> $FZF_TARGET"
        fi
      fi
    else
      echo "Warning: fzf install script not found at $FZF_DIR/install" >&2
      _FAILED=1
    fi
  fi
fi

# --- dotfiles のシンボリックリンク作成（常に実行）---
DOT_FILES=(.zshrc .zprofile .vim .vimrc .tmux.conf)

for file in "${DOT_FILES[@]}"; do
  _safe_link "$DOTFILES_DIR/$file" "$HOME/$file"
done

# --- Herdr 設定のシンボリックリンク作成 ---
HERDR_CONFIG_DIR="$HOME/.config/herdr"
mkdir -p "$HERDR_CONFIG_DIR"
_safe_link "$DOTFILES_DIR/config/herdr/config.toml" "$HERDR_CONFIG_DIR/config.toml"

# --- Git 設定のシンボリックリンク作成 ---
_safe_link "$DOTFILES_DIR/config/git/config" "$HOME/.gitconfig"

# --- Cursor 設定のシンボリックリンク作成 ---
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
mkdir -p "$CURSOR_USER_DIR"
_safe_link "$DOTFILES_DIR/config/cursor/settings.json" "$CURSOR_USER_DIR/settings.json"
_safe_link "$DOTFILES_DIR/config/cursor/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"

# --- Karabiner 設定のシンボリックリンク作成 ---
KARABINER_CONFIG_DIR="$HOME/.config/karabiner"
mkdir -p "$KARABINER_CONFIG_DIR"
_safe_link "$DOTFILES_DIR/config/karabiner/karabiner.json" "$KARABINER_CONFIG_DIR/karabiner.json"

exit $_FAILED
