{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myKwallet.enable = lib.mkEnableOption "myKwallet";
  };

  config = lib.mkIf (config.myKwallet.enable && (config.myDisplayManager != null)) {
    # kwallet https://github.com/NixOS/nixpkgs/issues/258296
    security.pam.services.${config.myDisplayManager}.kwallet = { 
      enable = true; 
      package = pkgs.kdePackages.kwallet-pam; 
      forceRun = true;
    };
    environment.etc."kwallet-pam-path".text = pkgs.kdePackages.kwallet-pam.outPath;

    myPackages = with pkgs; [
      kdePackages.kwallet
      kdePackages.kwalletmanager
    ];
  };
}
