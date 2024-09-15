{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLaptop.enable = lib.mkEnableOption "myLaptop";
  };
  
  config = lib.mkIf config.myLaptop.enable {
    myPackages = with pkgs; [
      cbatticon
      light
    ];
    myLogind.enable = true;
    powerManagement.powertop.enable = true;
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "balanced";
          turbo = "never";
        };
      };
    };
  };
}
