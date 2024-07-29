{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    nixone.enable = lib.mkEnableOption "nixone host";
  };
  
  config = lib.mkIf config.nixone.enable {
    nixoneHardware.enable = true;
    myDesktop.enable = true;
    
    # Custom modules
    myX11 = {
      enable = true;
      dpi = 144;
      cursorSize = 36;
    };
    myVPN = {
      enable = true;
      dnsOnly = false;
    };
    myGaming.enable = true;
    
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixone"; # Define your hostname.

    # Set your time zone.
    time.timeZone = "America/New_York";

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      efibootmgr
      btrfs-progs
      ntfs3g
    ];

  };
}
