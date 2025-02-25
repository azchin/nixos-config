{ config, lib, pkgs-unstable, pkgs-stable, disko, ... }:

{
  imports = [
    disko.nixosModules.disko
    ../../configuration.nix
    ../../private/disko-nixthree.nix
    ../../private/hardware-nixthree.nix
  ];

  # Define your hostname.
  networking.hostName = "nixthree";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure custom modules
  nixoneNetwork.enable = true;
  myWireguard.enable = true;
  myWireguard.mode = "devices";
  # myWireguard.mode = "everything";
  mySSH.enable = true;
  myDesktop.enable = true;
  myHypr.enable = true;
  myRiver.enable = true;
  myX11.dpi = 96;
  myCursorSize = 36;
  myGaming.enable = true;
  
  # Bootloader
  myEFI.enable = true;

  # Graphics
  myAmdgpu.enable = true;
  
  # Install programs specific for this host
  environment.systemPackages = with pkgs-unstable; [
    btrfs-progs
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
