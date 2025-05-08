{ config, lib, pkgs-unstable, pkgs-stable, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    services.logind.powerKey = "ignore";
    myPackages = with pkgs-unstable; [
      geekbench
      furmark
      unigine-superposition
    ];

    # Overclock
    boot.extraModprobeConfig = ''
      options amdgpu ppfeaturemask=0xfffd7fff
    '';
    
    # https://github.com/ollama/ollama/blob/main/docs/gpu.md#amd-radeon
    # rocminfo | grep gfx
    services.ollama = {
      enable = true;
      acceleration = "rocm"; 
      rocmOverrideGfx = "11.0.0";
    };

    systemd.services.ollama.environment = {
      OLLAMA_GPU_OVERHEAD = "1073741824";
    };
  };
}
