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
  ln -fhs "$DOTFILES_DIR/$file" "$HOME/$file"
done

# --- Herdr 設定のシンボリックリンク作成 ---
HERDR_CONFIG_DIR="$HOME/.config/herdr"
HERDR_CONFIG_LINK="$HERDR_CONFIG_DIR/config.toml"
HERDR_CONFIG_TARGET="$DOTFILES_DIR/config/herdr/config.toml"

mkdir -p "$HERDR_CONFIG_DIR"

if [ -L "$HERDR_CONFIG_LINK" ]; then
  current_target="$(readlink "$HERDR_CONFIG_LINK")"
  if [ "$current_target" = "$HERDR_CONFIG_TARGET" ]; then
    echo "Symlink already correct: $HERDR_CONFIG_LINK -> $HERDR_CONFIG_TARGET"
  else
    echo "Warning: $HERDR_CONFIG_LINK points to '$current_target', not '$HERDR_CONFIG_TARGET'. Skipping." >&2
    _FAILED=1
  fi
elif [ -e "$HERDR_CONFIG_LINK" ]; then
  BACKUP="$HERDR_CONFIG_LINK.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing $HERDR_CONFIG_LINK to $BACKUP"
  mv "$HERDR_CONFIG_LINK" "$BACKUP"
  ln -s "$HERDR_CONFIG_TARGET" "$HERDR_CONFIG_LINK"
  echo "Created symlink: $HERDR_CONFIG_LINK -> $HERDR_CONFIG_TARGET"
else
  ln -s "$HERDR_CONFIG_TARGET" "$HERDR_CONFIG_LINK"
  echo "Created symlink: $HERDR_CONFIG_LINK -> $HERDR_CONFIG_TARGET"
fi

exit $_FAILED
