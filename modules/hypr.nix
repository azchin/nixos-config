{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myHypr.enable = lib.mkEnableOption "myHypr";
  };
  
  config = lib.mkIf config.myHypr.enable {
    myMinimal.enable = true;
    myGraphical.enable = true;

    # TODO use hyprland github in flakes?
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;

    myPackages = with pkgs; [
      wl-clipboard
      rofi-wayland
      emacs30-pgtk
      waybar
      slurp
      grim
      hyprcursor
      hyprpaper
      hypridle
      nwg-look
    ];
  };
}
