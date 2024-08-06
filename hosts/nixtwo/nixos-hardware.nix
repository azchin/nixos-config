{ config, lib, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.framework-11th-gen-intel
  ];
}
