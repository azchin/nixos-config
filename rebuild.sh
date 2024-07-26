#!/bin/sh
set -eu
dir=$(dirname $(realpath $0))
cmd="${1:-switch}"
cd $dir
git add private
case $cmd in
    boot)
        sudo nixos-rebuild boot --flake . || :
        ;;
    upgrade)
        sudo nixos-rebuild switch --upgrade --flake . || :
        ;;
    switch)
        sudo nixos-rebuild switch --flake . || :
        ;;
esac
git restore --staged private
