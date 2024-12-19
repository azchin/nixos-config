{ config, lib, pkgs, pkgs-stable, nixos-hardware, disko, ... }:

{
  imports = [
    # FIXME temp default to server
    ./server.nix
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
