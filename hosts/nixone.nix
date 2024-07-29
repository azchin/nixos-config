{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    nixone.enable = lib.mkEnableOption "nixone host";
  };
  
  config = lib.mkIf config.nixone.enable {
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

    # Bootloader
    myEFI.enable = true;

    # Graphics
    myAmdgpu.enable = true;
    
    # Install programs specific for this host
    environment.systemPackages = with pkgs; [
      btrfs-progs
      ntfs3g
    ];
  };
}