##############################################
##
## プラグイン設定
## このファイルの実体パスから zsh/plugins を解決するため
## リポジトリが $HOME/dotfiles 以外でも動作する
##
##############################################

# このファイル自身の実体ディレクトリを取得（シンボリックリンク対応）
_plugins_dir="${${(%):-%N}:A:h}/plugins"

# 1. fzf-tab（compinit 後・他プラグインより前）
if [[ -z ${_FZF_TAB_LOADED:-} ]]; then
  if [[ -f "${_plugins_dir}/fzf-tab/fzf-tab.plugin.zsh" ]]; then
    if source "${_plugins_dir}/fzf-tab/fzf-tab.plugin.zsh"; then
      typeset -g _FZF_TAB_LOADED=1
      # fzf-tab 使用時は menu select=1 と競合しないよう menu no に変更
      zstyle ':completion:*:default' menu no
    fi
  fi
fi

# 2. zsh-autosuggestions
if [[ -z ${_ZSH_AUTOSUGGESTIONS_LOADED:-} ]]; then
  if [[ -f "${_plugins_dir}/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    if source "${_plugins_dir}/zsh-autosuggestions/zsh-autosuggestions.zsh"; then
      typeset -g _ZSH_AUTOSUGGESTIONS_LOADED=1
    fi
  fi
fi

# 3. zsh-syntax-highlighting
if [[ -z ${_ZSH_SYNTAX_HIGHLIGHTING_LOADED:-} ]]; then
  if [[ -f "${_plugins_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    if source "${_plugins_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"; then
      typeset -g _ZSH_SYNTAX_HIGHLIGHTING_LOADED=1
    fi
  fi
fi

unset _plugins_dir

# syntax-highlighting スタイル: 既知コマンド=緑、未知トークン=赤
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
  ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
fi
