{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    andrew.enable = true;
  };
}
