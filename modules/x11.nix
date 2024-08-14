{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myX11.enable = lib.mkEnableOption "myX11";
    myX11.dpi = lib.mkOption {
      type = lib.types.int;
      default = 96;
      description = "X11 DPI";
    };
  };
  
  config = lib.mkIf config.myX11.enable {
    myMinimal.enable = true;
    
    myPackages = with pkgs; [
      emacs-gtk
      xorg.xrdb
      xorg.xset
      xorg.xsetroot
      xorg.xev
      xorg.xmodmap
      xorg.setxkbmap
      xorg.xdpyinfo
      lxde.lxrandr
      xclip
      dex # TODO add to autostart.sh, split across hosts
      rofi
      picom
      dmenu
      xss-lock
      xsecurelock
      maim
      arandr
    ];
  };
}
