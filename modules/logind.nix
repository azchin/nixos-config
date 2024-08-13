{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myLogind.enable = lib.mkEnableOption "myLogind";
  };
  
  config = lib.mkIf config.myLogind.enable {
    services.logind = {
      powerKey = "suspend-then-hibernate";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend";
    };
    systemd.sleep.extraConfig = "HibernateDelaySec=2h";
  };
}
