{ config, lib, ... }:

{
  imports = [
    ./x11.nix
    ./programs.nix
    ./amdgpu.nix
    ./efi.nix
    ./andrew.nix
  ];
}
