{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLogind.enable = lib.mkEnableOption "myLogind";
  };
  
  config = lib.mkIf config.myLogind.enable {
    services.logind = {
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend-then-hibernate";
    };
    systemd.sleep.extraConfig = "HibernateDelaySec=20m";
  };
}
