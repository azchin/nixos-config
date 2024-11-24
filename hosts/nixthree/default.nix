{ config, lib, pkgs, pkgs-stable, nixos-hardware, disko, ... }:

{
  imports = [
    ./base.nix
    ./nixos-hardware.nix
  ];

  specialisation = {
    server = {
      inheritParentConfig = false;
      configuration = {
        imports = [
          ./base.nix
        ];
        myGaming.enable = lib.mkForce false;
        myX11.enable = lib.mkForce false;
        myHypr.enable = lib.mkForce false;
        nixoneNetwork.enable = lib.mkForce true;
        mySSH.enable = lib.mkForce true;
        myWireguard.enable = lib.mkForce true;
        myWireguard.mode = lib.mkForce "everything";
      };
    };
  };
}
