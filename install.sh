#!/bin/bash

DIRS=".vim .config/i3 .config/matplotlib .ipython/profile_default/startup"
for dn in $DIRS; do
    if [ ! -e $HOME/$dn ]; then
        mkdir -p $HOME/$dn
        echo "Made directory ~/${dn}."
    else
        echo "Directory ~/${dn} exists."
    fi
done

FILES=".vimrc .gvimrc .latexmkrc .tmux.conf .ctags .gitignore_global .agignore .vim/after .vim/plugin .vim/indent .vim/skeleton.py .config/i3/config .config/matplotlib/matplotlibrc .ipython/profile_default/startup/ipython_startup.py"
for fn in $FILES; do
    if [ ! -e $HOME/$fn ]; then
        ln -s $HOME/dotfiles/$fn $HOME/$fn
        echo "Made link ~/${fn}."
    else
        echo "File ~/${fn} exists."
    fi
done

if [ ! -e ~/.tmux/plugins/tmux-resurrect ]; then
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
else
    echo "Directory ~/.tmux/plugins/tmux-resurrect exists."
fi

if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
else
    echo "Directory ~/.vim/bundle/Vundle.vim exists."
fi

if [ ! -e ~/dotfiles/.vimrc.local ]; then
    cp ~/dotfiles/.vimrc.local.example ~/dotfiles/.vimrc.local
    echo "Made file ~/dotfiles/.vimrc.local."
    echo "Don't forget to edit this later."
else
    echo "Directory ~/dotfiles/.vimrc.local exists."
fi

if ! grep "source \$HOME/dotfiles/.bashrc" $HOME/.bashrc > /dev/null; then
    echo "source \$HOME/dotfiles/.bashrc" >> ${HOME}/.bashrc
else
    echo "~/.bashrc is already setup to source \$HOME/dotfiles/.bashrc"
fi

git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor vim
git config --global user.name "Kosuke Tahara"
git config --global user.email "ksk.tahara@gmail.com"
git config --global push.default simple

