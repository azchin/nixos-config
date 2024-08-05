{ config, lib, ... }:

{
  imports = [
    ./desktop.nix
    ./laptop.nix
  ];
}
