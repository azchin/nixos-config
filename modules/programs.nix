{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myFirefox.enable = lib.mkEnableOption "myFirefox";
    myGaming.enable = lib.mkEnableOption "myGaming";
    myFcitx.enable = lib.mkEnableOption "myFcitx";
    myDocker.enable = lib.mkEnableOption "myDocker";
  };
  
  config = lib.mkMerge [
    (lib.mkIf config.myFirefox.enable {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin;
        preferences = {
          "browser.aboutConfig.showWarning" = false;
          "browser.compactmode.show" = true;
          "browser.tabs.insertAfterCurrent" = true;
          "findbar.highlightAll" = true;
          "browser.sessionstore.interval" = 600000;
          "extensions.pocket.enabled" = false;
        };
      };
    })
    (lib.mkIf config.myGaming.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
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
