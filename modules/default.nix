{ config, lib, ... }:

{
  imports = [
    ./packages.nix
    ./x11.nix
    ./display-manager.nix
    ./kwallet.nix
    ./awesomewm.nix
    ./minimal.nix
    ./hypr.nix
    ./dwm
    ./programs.nix
    ./amdgpu.nix
    ./intelgpu.nix
    ./efi.nix
    ./users.nix
    ./logind.nix
    ./network.nix
  ];
}
