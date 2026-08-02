# .zprofile — login shell initialization
# PATH の重複を zsh の typeset -U で除去する
typeset -U path PATH

# Homebrew のセットアップ（Apple Silicon 優先、Intel Mac にも対応）
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ユーザーローカルのバイナリを優先する
path=("$HOME/.local/bin" "$HOME/bin" $path)
export PATH
