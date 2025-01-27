#!/bin/sh
nix --experimental-features "nix-command flakes" run nix-darwin -- switch --flake '.#simple'
