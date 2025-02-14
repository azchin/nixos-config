{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myEFI.enable = lib.mkEnableOption "myEFI";
  };
  
  config = lib.mkIf config.myEFI.enable {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 64;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs-unstable; [
      efibootmgr
    ];
  };
}
