#!/bin/sh
set -eu
dir=$(dirname $(realpath $0))
cmd="${1:-switch}"

restore_git() {
    git restore --staged private
}

restore_git_exit() {
    restore_git || :
    exit 1
}

cd $dir

git add private

case $cmd in
    upgrade)
        echo "Upgrading!"
        nix flake update
        sudo nixos-rebuild switch --upgrade --flake . || restore_git_exit
        restore_git
        git add flake.lock
        git commit -m "x nix flake" || echo "flake.lock not updated"
        ;;
    switch|boot|test|build)
        sudo nixos-rebuild $cmd --flake . || restore_git_exit
        restore_git
        ;;
    bootloader)
        sudo nixos-rebuild switch --install-bootloader --flake . || restore_git_exit
        restore_git
        ;;
esac
