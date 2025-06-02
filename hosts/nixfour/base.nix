{ config, lib, pkgs-unstable, pkgs-stable, disko, ... }:

{
  imports = [
    disko.nixosModules.disko
    ../../configuration.nix
    ../../private/disko-nixthree.nix # same disk format, TODO export
    ../../private/hardware-nixfour.nix
  ];

  # Define your hostname.
  networking.hostName = "nixfour";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure custom modules
  nixtwoNetwork.enable = true;
  myWireguard.enable = true;
  myWireguard.mode = "everything";
  mySSH.enable = true;
  myHypr.enable = true;
  myX11.dpi = 96;
  myCursorSize = 36;
  myGaming.enable = true;
  
  # Bootloader
  myEFI.enable = true;

  # Ethernet module
  boot.kernelModules = [ "r8152" ];
  boot.extraModprobeConfig = ''
    options r8152 autosuspend=0
  '';

  # Graphics
  myIntelgpu.enable = true;

  services.power-profiles-daemon.enable = true;
  
  # Install programs specific for this host
  environment.systemPackages = with pkgs-unstable; [
    btrfs-progs
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
