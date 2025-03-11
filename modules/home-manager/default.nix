{ config, lib, home-manager, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${config.myUser.primary} = import ./home.nix;
      };
    }
  ];
}
