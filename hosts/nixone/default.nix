{ config, lib, pkgs, pkgs-stable, nixos-hardware, ... }:

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
        boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
        nixoneHardwareExtra.enable = lib.mkForce false;
        myGaming.enable = lib.mkForce false;
        myAmdgpu.enable = lib.mkForce false;
      };
    };
  };
}
