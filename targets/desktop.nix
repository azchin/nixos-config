{ config, lib, pkgs-unstable, pkgs-stable, pkgs-pwndbg, ... }:

{
  options = {
    myDesktop.enable = lib.mkEnableOption "myDesktop";
  };
  
  config = lib.mkIf config.myDesktop.enable {
    services.logind.settings.Login.HandlePowerKey = "ignore";
    myPackages = with pkgs-unstable; [
      furmark
      unigine-superposition
      pkgs-pwndbg.default
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

    services.pipewire.extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };

    systemd.services.ollama.environment = {
      OLLAMA_GPU_OVERHEAD = "1073741824";
    };
  };
}
