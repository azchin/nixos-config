{ config, lib, pkgs-unstable, pkgs-stable, ... }:

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
      waybar
      slurp
      grim
      nwg-look
    ];
  };
}
