#!/bin/bash

	DOT_FILES=(.zshrc .bash_profile .bashrc .vim .vimrc .tmux.conf .atom .vscode)

	for file in ${DOT_FILES[@]}
	do
		ln -fs $HOME/dotfiles/$file $HOME/$file
	done
