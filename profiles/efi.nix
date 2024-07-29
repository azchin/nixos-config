{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myEFI.enable = lib.mkEnableOption "myEFI";
  };
  
  config = lib.mkIf config.myEFI.enable {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
      efibootmgr
    ];
  };
}
