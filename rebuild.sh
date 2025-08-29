#!/bin/sh
set -eu
NH="${NH:-}"
dir=$(dirname $(realpath $0))
cmd="${1:-switch}"
if [ $# -ge 1 ]; then
    shift 1
fi

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
        nh os switch . \
            || (echo "nixos-rebuild failed, continue? [y/N]"; read answer; [ "$answer" = "y" ]) \
            || restore_git_exit
        restore_git
        git add flake.lock
        git commit -m "x nix flake update" || echo "flake.lock not updated"
        ;;
    switch|boot|test|build)
        echo "sudo nixos-rebuild $cmd $@ --flake . || restore_git_exit"
        # nh os $cmd $@ . || restore_git_exit
        sudo nixos-rebuild $cmd $@ --flake . || restore_git_exit
        restore_git
        ;;
    bootloader)
        sudo nixos-rebuild switch --install-bootloader --flake . || restore_git_exit
        restore_git
        ;;
esac
