{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myFirefox.enable = lib.mkEnableOption "myFirefox";
    myGaming.enable = lib.mkEnableOption "myGaming";
    myFcitx.enable = lib.mkEnableOption "myFcitx";
    myDocker.enable = lib.mkEnableOption "myDocker";
    myVirtualbox.enable = lib.mkEnableOption "myVirtualbox";
  };
  
  config = lib.mkMerge [
    (lib.mkIf config.myFirefox.enable {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin; # FIXME https://github.com/NixOS/nixpkgs/issues/332540
        preferences = {
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.tabs.insertAfterCurrent" = true;
          "browser.tabs.hoverPreview.showThumbnails" = false;
          "findbar.highlightAll" = true;
          "browser.sessionstore.interval" = 60000;
          "extensions.pocket.enabled" = false;
          "media.ffmpeg.vaapi.enabled" = true;
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        };
        preferencesStatus = "default";
      };
    })
    (lib.mkIf config.myVirtualbox.enable {
      virtualisation.virtualbox.host.enable = true;
      users.users.${config.myUser.primary}.extraGroups = [ "vboxusers" ];
    })
    (lib.mkIf config.myGaming.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
      hardware.graphics.enable32Bit = true;
      environment.systemPackages = with pkgs; [
        (lutris.override {
          extraPkgs = pkgs: [
            wineWowPackages.stable
          ];
        })
        wineWowPackages.stable
      ];
    })
    (lib.mkIf config.myFcitx.enable {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          plasma6Support = true;
          addons = with pkgs; [
            fcitx5-mozc
            kdePackages.fcitx5-chinese-addons
          ];
        };
      };
      environment.variables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
      };
    })
    (lib.mkIf config.myDocker.enable {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
        storageDriver = "btrfs";
      };
      myUser.extraGroups = [ "docker" ];
    })
  ];
}
