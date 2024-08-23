{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myHypr.enable = lib.mkEnableOption "myHypr";
  };
  
  config = lib.mkIf config.myHypr.enable {
    myMinimal.enable = true;

    # TODO use hyprland github in flakes?
    programs.hyprland.enable = true;
    programs.hyprland.package = pkgs.hyprland.override { legacyRenderer = true; };
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    myPackages = with pkgs; [
      wl-clipboard
      rofi-wayland
      emacs29-pgtk
      waybar
      slurp
      grim
      hyprcursor
      nwg-look
    ];
  };
}
