{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLaptop.enable = lib.mkEnableOption "myLaptop";
  };
  
  config = lib.mkIf config.myLaptop.enable {
    myUser.enable = true;
    myUser.primary.extraPackages = with pkgs; [
      cbatticon
    ];
    powerManagement.powertop.enable = true;
    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
      };
    };
  };
}
