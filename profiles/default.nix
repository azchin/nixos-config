{ config, lib, ... }:

{
  imports = [
    ./desktop.nix
    ./efi.nix
    ./amdgpu.nix
  ];
}
