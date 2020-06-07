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

if [ -f "$VSCODE_SETTING_DIR= ]; then
    echo "$FILE exists."
    rm "$VSCODE_SETTING_DIR/settings.json"
    ln -s "$VSCODE_DOTFILES_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
else 
    echo "$FILE does not exist."
    ln -s "$VSCODE_DOTFILES_DIR/settings.json" "${VSCODE_SETTING_DIR}/settings.json"
fi


#rm "$VSCODE_SETTING_DIR/keybindings.json"
#ln -s "$SCRIPT_DIR/keybindings.json" "${VSCODE_SETTING_DIR}/keybindings.json"

# install extention
cat $VSCODE_DOTFILES_DIR/extensions | while read line
do
    code --install-extension $line
done

code --list-extensions > $VSCODE_DOTFILES_DIR/extensions

exit 0



