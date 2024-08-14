{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myHypr.enable = lib.mkEnableOption "myHypr";
  };
  
  config = lib.mkIf config.myHypr.enable {
    myMinimal.enable = true;

    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    programs.waybar.enable = true;

    myPackages = with pkgs; [
      wl-clipboard
      rofi-wayland
      emacs29-pgtk
      waybar
      slurp
      grim
      hyprcursor
    ];
  };
}
