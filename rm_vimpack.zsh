#!/bin/zsh

git submodule deinit vim/pack/my/start/$1
git rm vim/pack/my/start/$1
