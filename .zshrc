#################################################
##
## zplug
##
################################################

# zplugが無ければgitからclone
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

# zplugを使う
source ~/.zplug/init.zsh

# ここに使いたいプラグインを書いておく
# zplug "ユーザー名/リポジトリ名", タグ

# zshの候補選択を拡張するプラグイン
zplug zsh-users/zsh-completions

# 入力途中に候補をうっすら表示
zplug "zsh-users/zsh-autosuggestions"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# コマンドを種類ごとに色付け
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# ヒストリの補完を強化する
zplug "zsh-users/zsh-history-substring-search", defer:3

# 自分自身をプラグインとして管理
zplug "zplug/zplug", hook-build:'zplug --self-manage'

# インストールしてないプラグインはインストール
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
#zplug load --verbose
zplug load


######################################
##
## 基本設定
##
#####################################



if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
fi


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


# less
export LESS='-R'


#################################################
##
## aliases
##
###############################################

alias ls='ls -FG'
alias la='ls -laFG'
alias ll='ls -lFG'
alias ..='cd ..'
alias hosts='sudo vi /etc/hosts'

alias vu='vagrant up'
alias vh='vagrant halt'
alias vr='vagrant reload'
alias vs='vagrant global-status'
alias sv='ssh 192.168.33.10'



################################################
##
## promptの設定
##
###############################################

PROMPT="
  %{${fg[green]}%}%~%{${reset_color}%} 
$ "

PROMPT2='> '
RPROMPT="%{${fg[green]}%}[%m @ %n]%{${reset_color}%}"



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
setopt hist_ignore_all_dups # 過去に同じ履歴が存在する場合、古い履歴を削除し重複しない
setopt hist_ignore_space # コマンド先頭スペースの場合保存しない
setopt hist_verify # ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_reduce_blanks #余分なスペースを削除してヒストリに記録する
setopt hist_save_no_dups # histryコマンドは残さない
setopt hist_expire_dups_first # 古い履歴を削除する必要がある場合、まず重複しているものから削除
setopt hist_expand # 補完時にヒストリを自動的に展開する
setopt inc_append_history # 履歴をインクリメンタルに追加





