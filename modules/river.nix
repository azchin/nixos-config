{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myRiver.enable = lib.mkEnableOption "myRiver";
  };
  
  config = lib.mkIf config.myRiver.enable {
    myMinimal.enable = true;
    myGraphical.enable = true;
    myWayland.enable = true;

    programs.river.enable = true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };
    
    myPackages = with pkgs-unstable; [
      kanshi
      wlr-randr
      swww
      lswt
      swaybg
      swaylock
      swayidle
    ];
  };
}
