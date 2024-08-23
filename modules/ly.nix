{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLy.enable = lib.mkEnableOption "myLy";
  };

  config = lib.mkIf config.myLy.enable {
    services.displayManager.ly = {
      enable = true;
      settings = {
        clear_password = true;
      };
    };
  };
}
