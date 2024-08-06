{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  # Define your hostname.
  networking.hostName = "nixone";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure custom modules
  myDesktop.enable = true;
  myVPN = {
    enable = true;
    dnsOnly = false;
  };
  myX11 = {
    enable = true;
    dpi = 144;
    cursorSize = 36;
  };
  myGaming.enable = true;
  
  # Hardware configuration
  nixoneHardware.enable = true;
  nixoneHardwareExtra.enable = true;

  # Bootloader
  myEFI.enable = true;

  # Graphics
  myAmdgpu.enable = true;
  
  # Install programs specific for this host
  environment.systemPackages = with pkgs; [
    btrfs-progs
    ntfs3g
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
