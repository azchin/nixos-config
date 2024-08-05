{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLaptop.enable = lib.mkEnableOption "myLaptop";
  };
  
  config = lib.mkIf config.myLaptop.enable {
    andrew.enable = true;
    # TODO make extra packages a config option in andrew
    users.users.andrew.packages = with pkgs; [
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
