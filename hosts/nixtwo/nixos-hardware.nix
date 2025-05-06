{ config, lib, nixos-hardware, ... }:

{
  imports = [
    nixos-hardware.nixosModules.framework-amd-ai-300-series
  ];
}
