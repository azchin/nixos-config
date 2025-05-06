{ config, lib, ... }:

{
  imports = [
    ./packages.nix
    ./x11.nix
    ./display-manager.nix
    ./kwallet.nix
    ./awesomewm.nix
    ./minimal.nix
    ./wayland.nix
    ./hypr.nix
    ./river.nix
    ./dwm
    ./programs.nix
    ./amdgpu.nix
    ./intelgpu.nix
    ./ollama.nix
    ./efi.nix
    ./grub.nix
    ./users.nix
    ./logind.nix
    ./network.nix
    ./home-manager
  ];
}
