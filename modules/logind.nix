{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myLogind.enable = lib.mkEnableOption "myLogind";
  };
  
  config = lib.mkIf config.myLogind.enable {
    services.logind.settings.Login = {
      HandlePowerKey = "suspend-then-hibernate";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "suspend-then-hibernate";
    };
    systemd.sleep.extraConfig = "HibernateDelaySec=20m";
  };
}
