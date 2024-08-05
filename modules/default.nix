{ config, lib, ... }:

{
  imports = [
    ./x11.nix
    ./programs.nix
    ./amdgpu.nix
    ./intelgpu.nix
    ./efi.nix
    ./andrew.nix
  ];
}
