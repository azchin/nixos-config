{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myDwm.enable = lib.mkEnableOption "myDwm";
  };
  
  config = lib.mkIf config.myDwm.enable {
    myX11.enable = true;

    services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.override {
        conf = ./config.h;
      };
    };
  };
}
