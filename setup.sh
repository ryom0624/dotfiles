#!/bin/bash

DOT_FILES=(.zshrc .bash_profile .bashrc .vim .vimrc .tmux.conf)

for file in ${DOT_FILES[@]}
do
	ln -fs $HOME/dotfiles/$file $HOME/$file
done

#####
## VS Codeの設定インポート
####

VSCODE_DOTFILES_DIR=$(pwd)/.vscode
VSCODE_SETTING_DIR=~/Library/Application\ Support/Code/User

rm "$VSCODE_SETTING_DIR/settings.json"
ln -s "$VSCODE_DOTFILES_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"

#rm "$VSCODE_SETTING_DIR/keybindings.json"
#ln -s "$SCRIPT_DIR/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"

# install extention
cat extensions | while read line
do
 code --install-extension $line
done

code --list-extensions > $VSCODE_DOTFILES_DIR/extensions

#####
## atomの設定インポート
#####

CWD=$(pwd)
SWD=$(cd $(dirname $0)/.atom && pwd)
LWD=$(cd $(dirname $0)/.atom && cd .. && pwd)

# trap
trap 'echo -e "\nabort!" ; exit 1' 1 2 3 15

# config {{{
PACKAGES_FILE="$SWD/packages.list"
# }}}

function apm_link() {
  cd $HOME/.atom
  ln -nfs $LWD/.atom/config.cson    config.cson
  ln -nfs $LWD/.atom/init.coffee    init.coffee
  ln -nfs $LWD/.atom/keymap.cson    keymap.cson
  ln -nfs $LWD/.atom/snippets.cson  snippets.cson
  ln -nfs $LWD/.atom/styles.less    styles.less
}

function apm_install() {
  apm install --packages-file $PACKAGES_FILE
}

function apm_dump() {
  [ -f $PACKAGES_FILE ] && rm $PACKAGES_FILE
  apm list --installed --bare > $PACKAGES_FILE
}

function apm_save() {
  git checkout master
  apm_dump
  git add $PACKAGES_FILE && git commit -m 'update apm installed list' && git push
}

case "$1" in
  link)    apm_link    ;;
  install) apm_install ;;
  dump)    apm_dump    ;;
  save)    apm_save    ;;
  *)       apm_install ;;
esac

exit 0



