{ config, lib, ... }:

{
  imports = [
    ./packages.nix
    ./x11.nix
    ./programs.nix
    ./amdgpu.nix
    ./intelgpu.nix
    ./efi.nix
    ./users.nix
    ./logind.nix
  ];
}
