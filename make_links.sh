#!/bin/bash

ln -s ${HOME}/dotfiles/.vimrc ${HOME}/.vimrc
ln -s ${HOME}/dotfiles/.gvimrc ${HOME}/.gvimrc
ln -s ${HOME}/dotfiles/.latexmkrc ${HOME}/.latexmkrc
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf
mkdir ${HOME}/.matplotlib
ln -s ${HOME}/dotfiles/matplotlibrc ${HOME}/.matplotlib/matplotlibrc
mkdir ${HOME}/.vim
ln -s ${HOME}/dotfiles/.vim/skeleton.py ${HOME}/.vim/skeleton.py
ln -s ${HOME}/dotfiles/.vim/after ${HOME}/.vim/after

