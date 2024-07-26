#!/bin/sh
set -eu
git add private
sudo nixos-rebuild switch --flake .
git restore --staged private
