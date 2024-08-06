#!/bin/sh
set -eu
dir=$(dirname $(realpath $0))
cmd="${1:-switch}"
cd $dir
git add private
case $cmd in
    upgrade)
        echo "Upgrading!"
        sudo nixos-rebuild switch --upgrade --flake . || :
        ;;
    switch|boot|test|build)
        sudo nixos-rebuild $cmd --flake . || :
        ;;
esac
git restore --staged private
