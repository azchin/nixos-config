{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myHypr.enable = lib.mkEnableOption "myHypr";
  };
  
  config = lib.mkIf config.myHypr.enable {
    myMinimal.enable = true;
    myGraphical.enable = true;
    myWayland.enable = true;

    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;

    myPackages = with pkgs-unstable; [
      hyprcursor
      hyprpaper
      hypridle
    ];
  };
}
