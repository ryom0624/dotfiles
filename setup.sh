#!/bin/bash

DOT_FILES=(.zshrc .zprofile .vim .vimrc .tmux.conf)

for file in ${DOT_FILES[@]}
do
	ln -fhs "$HOME/dotfiles/$file" "$HOME/$file"
done

exit 0



