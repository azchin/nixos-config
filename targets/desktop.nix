{ config, lib, pkgs, pkgs-stable, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    services.logind.powerKey = "ignore";
    myPackages = with pkgs; [
      geekbench
      furmark
      unigine-superposition
    ];
  };
}
