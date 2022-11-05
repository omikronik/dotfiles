#!/bin/bash


# Check if git is installed
GIT_INSTALLED="$(git --version)"
if [[ $GIT_INSTALLED == *"version"* ]]; then
    echo "Git is available"
else
    echo "Git is not available"
    exit 1
fi

# Copy dotfiles
cp $HOME/{.zshrc,.zshenv,.vimrc,.tmux.conf} .
cp $HOME/.config/{alacritty/alacritty.yml,nvim/init.vim} .


# Ceck git status
GIT_STATUS="$(git status | grep -i "modified")"

# If there is a new change
if [[ $GIT_STATUS == *"modified"* ]]; then
    echo "push"
fi

git add -u;
git commit -m "New backup `date +'%Y-%m-%d %H:%M:%S'`";
git push origin main
