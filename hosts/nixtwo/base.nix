{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports = [
    ../../configuration.nix
  ];

  # Define your hostname.
  networking.hostName = "nixtwo";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure custom modules
  myLaptop.enable = true;
  nixtwoNetwork = {
    enable = true;
    dnsOnly = false;
  };
  myX11 = {
    enable = true;
    dpi = 138; # TODO sync Xresources? home manager?
    cursorSize = 36;
  };
  myGaming.enable = false;
  
  # Hardware configuration
  nixtwoHardware.enable = true;

  # Bootloader
  myEFI.enable = true;

  # Graphics
  myIntelgpu.enable = true;

  # Install programs specific for this host
  # environment.systemPackages = with pkgs; [
  # ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
