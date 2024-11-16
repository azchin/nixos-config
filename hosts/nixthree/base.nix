{ config, lib, pkgs, pkgs-stable, disko, ... }:

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
  myWireguard.dnsOnly = true;
  myDesktop.enable = true;
  myHypr.enable = true;
  myX11.dpi = 96;
  myCursorSize = 36;

  # TODO clean this up into multihead target or module
  services.xserver.xrandrHeads = [ 
    {
      output = "DP-2";
      # DisplaySize 338 190\n
      monitorConfig = ''
        Option "LeftOf DP-1
      '';
    }
    {
      output = "DP-1";
      primary = true;
    }
  ];

  myGaming.enable = true;
  
  # Bootloader
  myEFI.enable = true;

  # Graphics
  myAmdgpu.enable = true;
  
  # Install programs specific for this host
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
