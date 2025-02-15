{ config, lib, pkgs-unstable, pkgs-stable, nixos-hardware, disko, ... }:

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
          ./server.nix
        ];
      };
    };
  };
}
