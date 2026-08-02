######################################
##
## 基本設定
##
#####################################

# 文字コードの指定
export LANG=ja_JP.UTF-8

# 補完機能
autoload -U compinit
compinit

# viのキーバインド
# bindkey -v

# cdとタイプしなくても、移動
setopt AUTO_CD

# cdの履歴を保持（同一のディレクトリは重複排除）
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# 色を使用出来るようにする
autoload -Uz colors
colors

# 日本語ファイル名を表示可能にする
setopt print_eight_bit


# ビープ音の停止
setopt no_beep

# ビープ音の停止(補完時)
setopt nolistbeep

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# 高機能なワイルドカード展開を使用する
# setopt extended_glob

# コマンドのスペルを訂正する
setopt correct

# 補完候補を一覧表示にする
setopt auto_list

# TAB で順に補完候補を切り替える
setopt auto_menu

# 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1

# LS_COLORSを設定しておく
export LS_COLORS='di=01;36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LSCOLORS=GxFxcxdxbxegedabagacad

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# git-prompt
setopt PROMPT_SUBST

# less
export LESS='-R'

################################################
##
## 履歴関連の設定
##
###############################################

HISTFILE=~/.z_history #履歴ファイルの設定
HISTSIZE=1000000 # メモリに保存される履歴の件数。(保存数だけ履歴を検索できる)
SAVEHIST=1000000 # ファイルに何件保存するか
setopt extended_history # 実行時間とかも保存する
setopt share_history # 別のターミナルでも履歴を参照できるようにする
# setopt inc_append_history # 履歴をインクリメンタルに追加
setopt hist_ignore_all_dups # 過去に同じ履歴が存在する場合、古い履歴を削除し重複しない
setopt hist_ignore_space # コマンド先頭スペースの場合保存しない
setopt hist_verify # ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_reduce_blanks #余分なスペースを削除してヒストリに記録する
setopt hist_save_no_dups # histryコマンドは残さない
setopt hist_expire_dups_first # 古い履歴を削除する必要がある場合、まず重複しているものから削除
setopt hist_expand # 補完時にヒストリを自動的に展開する


#################################################
##
## aliases
##
###############################################

alias rmi='rm -i'
alias ls='ls -FG'
alias la='ls -lahFG'
alias ll='ls -lhFG'
alias ..='cd ..'
alias hosts='sudo vi /etc/hosts'
alias reload='source ~/.zshrc'
alias zshrc='${EDITOR:-vi} ~/.zshrc'

# Git関連
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gclone="git clone"


################################################
##
## promptの設定
##
###############################################

# Git情報
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:git:*' formats '%F{magenta}git:(%b)%f'
add-zsh-hook precmd vcs_info

setopt PROMPT_SUBST

PROMPT='
%F{blue}╭─%f %F{yellow}%~%f ${vcs_info_msg_0_}
%F{blue}╰─%f %# '

RPROMPT='%(?..%F{red}✘ %?%f )%F{white}%D{%H:%M}%f'


##############################################
##
##  direnv
##
##############################################
# eval "$(direnv hook bash)"

##############################################
##
## herdr
##
##############################################

if (( $+commands[herdr] )); then
  source <(herdr completion zsh)
fi

alias h='herdr'

# 対話型ターミナルの起動時に Herdr へ接続する
# Herdr 管理ペイン内（HERDR_ENV=1）からの再起動は防止する
if [[ -o interactive && -t 0 && -t 1 && ${HERDR_ENV:-} != 1 ]] \
  && (( $+commands[herdr] )); then
  herdr
fi

##############################################
##
## plugins
##
##############################################

# プラグイン設定を最後に読み込む
_zshrc_dir="${${(%):-%N}:A:h}"
if [[ -f "${_zshrc_dir}/zsh/plugins.zsh" ]]; then
  source "${_zshrc_dir}/zsh/plugins.zsh"
fi
unset _zshrc_dir
