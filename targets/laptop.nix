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
    services.fprintd.enable = true;
    security.pam.services = {
      # The ly module ships a pam stack that just substacks/includes `login`,
      # so ly.fprintAuth is ignored and ly inherits login's pam_fprintd.
      # Force ly onto its own default stack so fprintAuth = false actually applies.
      ly = {
        useDefaultRules = lib.mkForce true;
        unixAuth = true;
        startSession = true;
        fprintAuth = false; # unfortunately breaks kwallet unlock
        rules.auth.login.enable = false;
        rules.account.login.enable = false;
        rules.password.login.enable = false;
        rules.session.login.enable = false;
      };
      login.fprintAuth = true;
    };

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
