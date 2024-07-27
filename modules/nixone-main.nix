{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    nixoneMain.enable = lib.mkEnableOption "nixoneMain";
  };
  
  config = lib.mkIf config.nixoneMain.enable {
    networking.hostName = "nixone"; # Define your hostname.

    # Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        dpi = 144;
        upscaleDefaultCursor = true;
        autoRepeatInterval = 25;
        autoRepeatDelay = 400;
    };

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
        size = 36;
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
      extraConfig = "xft-dpi=144\n";
    };

    services.xserver = {
     windowManager.awesome = {
       enable = true;
       package = pkgs.awesome.overrideAttrs (old: {      
         src = pkgs.fetchFromGitHub {
           owner = "awesomeWM";
           repo = "awesome";
           rev = "ad0290bc1aac3ec2391aa14784146a53ebf9d1f0";
           sha256 = "sha256-uaskBbnX8NgxrprI4UbPfb5cRqdRsJZv0YXXshfsxFU=";
         }; 
         patches = [];
         postPatch = ''
           patchShebangs tests/examples/_postprocess.lua
         '';
         });    
         luaModules = with pkgs.luaPackages; [
           luarocks # is the package manager for Lua modules
           luadbi-mysql # Database abstraction layer
         ];
       };
     };

    services.gvfs.enable = true;

    users.users.andrew = {
      packages = with pkgs; [
        emacs-gtk
        xorg.xrdb
        xorg.xset
        xorg.xsetroot
        xclip
        dunst
        picom
        networkmanagerapplet
        xss-lock
        xsecurelock
        playerctl
        pamixer
        maim
        arc-theme
        papirus-icon-theme
        capitaine-cursors
        kdePackages.breeze
        libsForQt5.breeze-qt5
        kdePackages.okular
        kdePackages.oxygen-icons
        pcmanfm
        lxmenu-data
        shared-mime-info
      ];
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };
    # qtct settings: DejaVu Sans (Mono) 10
    #                Breeze icons

    # NOTE still need to set up .xprofile and xrdb
    environment.variables = {
      XCURSOR_THEME = "capitaine-cursors-white";
      XCURSOR_SIZE = "36";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      MOZ_ENABLE_WAYLAND = 0;
    };
  };
}
