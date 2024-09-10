{ config, lib, pkgs, pkgs-stable, ... }:

with lib; {
  options = with types; {
    myDisplayManager = mkOption {
      type = nullOr (enum [ "ly" "lightdm" ]);
      default = null;
    };
  };

  config = mkMerge [
    (mkIf (config.myDisplayManager == "ly") {
      services.displayManager.ly = {
        enable = true;
        settings = {
          clear_password = true;
        };
      };
    })
    (mkIf (config.myDisplayManager == "lightdm") {
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
    })
  ];
}
