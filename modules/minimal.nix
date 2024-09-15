{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myMinimal.enable = lib.mkEnableOption "myMinimal";
    myCursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size";
    };
  };
  
  config = lib.mkIf config.myMinimal.enable {
    myPackages = with pkgs; [
      arc-theme
      papirus-icon-theme
      capitaine-cursors
      kdePackages.breeze
      libsForQt5.breeze-qt5
      kdePackages.oxygen-icons
      pcmanfm
      lxmenu-data
      shared-mime-info
      playerctl
      pamixer
      networkmanagerapplet
      dunst
    ];

    services.gvfs.enable = true;

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };
    # qtct settings: DejaVu Sans (Mono) 10
    #                Breeze icons

    # NOTE still need to set up .xprofile and xrdb
    environment.variables = {
      XCURSOR_THEME = "capitaine-cursors-white";
      XCURSOR_SIZE = "${toString config.myCursorSize}";
      # MOZ_ENABLE_WAYLAND = 0;
    };
  };
}
