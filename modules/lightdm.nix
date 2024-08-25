{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLightdm.enable = lib.mkEnableOption "myLightdm";
  };
  
  config = lib.mkIf config.myLightdm.enable {
    services.xserver.displayManager.lightdm.greeters.gtk = {
      enable = true;
      theme = {
        name = "Arc-Darker";
        package = pkgs.arc-theme;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "capitaine-cursors-white";
        package = pkgs.capitaine-cursors;
        size = config.myCursorSize;
      };
      indicators = [
        "~host"
        "~spacer"
        "~clock"
        "~spacer"
        "~session"
        "~a11y"
        "~power"
      ];
      clock-format = "%F %T %Z";
      extraConfig = "xft-dpi=${toString config.myX11.dpi}\n";
    };

  };
}
