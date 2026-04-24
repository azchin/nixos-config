{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myLaptop.enable = lib.mkEnableOption "myLaptop";
  };
  
  config = lib.mkIf config.myLaptop.enable {
    myPackages = with pkgs-unstable; [
      cbatticon
      brightnessctl
    ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true; # for Solaar GUI

    myLogind.enable = true;
    services.upower.enable = true;
    services.auto-cpufreq = {
      enable = false; # disable due to conflicts with power-profiles-daemon
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "balanced";
          turbo = "auto";
        };
      };
    };
  };
}
