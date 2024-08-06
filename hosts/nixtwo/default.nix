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
        myVPN.enable = lib.mkForce false;
        myGaming.enable = lib.mkForce false;
      };
    };
    gaming.configuration = {
      myVPN.enable = lib.mkForce true;
      myGaming.enable = lib.mkForce true;
    };
  };
}
