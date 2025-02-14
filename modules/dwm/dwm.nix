{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myDwm.enable = lib.mkEnableOption "myDwm";
  };
  
  config = lib.mkIf config.myDwm.enable {
    myX11.enable = true;

    services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs-unstable.dwm.override {
        conf = ./config.h;
      };
    };
  };
}
