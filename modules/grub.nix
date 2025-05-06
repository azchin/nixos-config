{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myGrub.enable = lib.mkEnableOption "myGrub";
  };
  
  config = lib.mkIf config.myGrub.enable {
    boot.loader.grub = {
      enable = true;
      efiInstallAsRemovable = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs-unstable; [
      efibootmgr
    ];
  };
}
