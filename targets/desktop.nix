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

    services.ollama.enable = true; # acceleration is in amdgpu
    systemd.services.ollama.environment = {
      OLLAMA_GPU_OVERHEAD = "1073741824";
    };
  };
}
