{ config, lib, pkgs-unstable, pkgs-stable, nixos-hardware, ... }:

{
  imports = [
    ./base.nix
    ./nixos-hardware.nix
  ];

  specialisation = {
    safe = {
      inheritParentConfig = false;
      configuration = {
        imports = [
          ./base.nix
        ];
        boot.kernelPackages = lib.mkForce pkgs-unstable.linuxPackages;
        myGaming.enable = lib.mkForce false;
        services.auto-cpufreq.enable = lib.mkForce false;
      };
    };
    gaming.configuration = {
      myGaming.enable = lib.mkForce true;
    };
  };
}
