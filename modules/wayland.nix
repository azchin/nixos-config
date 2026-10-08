{ config, lib, pkgs-unstable, pkgs-stable, pkgs-waybar, ... }:

{
  options = {
    myWayland.enable = lib.mkEnableOption "myWayland";
  };
  
  config = lib.mkIf config.myWayland.enable {
    myMinimal.enable = true;
    myGraphical.enable = true;

    myPackages = with pkgs-unstable; [
      wl-clipboard
      rofi
      emacs-pgtk
      slurp
      grim
      nwg-look
      pkgs-waybar.waybar # FIXME once new release hits unstable
    ];
  };
}
