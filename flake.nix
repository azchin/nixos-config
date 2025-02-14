{
  description = "NixOS configuration wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    pwndbg = {
      url = "github:pwndbg/pwndbg"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, pwndbg, nixos-hardware, disko }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-pwndbg = pwndbg.packages.${system};
    baseSpecialArgs = {
      inherit pkgs pkgs-stable pkgs-pwndbg nixos-hardware; 
    };
    baseModules = [
      nixpkgs.nixosModules.readOnlyPkgs
      {
        nixpkgs.pkgs = pkgs;
        nixpkgs.config = { };
        nixpkgs.overlays = [ ];
      }
    ];
  in {
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    nixosConfigurations = {
      nixone = nixpkgs.lib.nixosSystem {
        inherit (baseSpecialArgs) specialArgs;
        modules = baseModules ++ [ ./hosts/nixone ];
      };
      nixtwo = nixpkgs.lib.nixosSystem {
        inherit (baseSpecialArgs) specialArgs;
        modules = baseModules ++ [ ./hosts/nixtwo ];
      };
      nixthree = nixpkgs.lib.nixosSystem {
        specialArgs = baseSpecialArgs // { inherit disko; };
        modules = baseModules ++ [ ./hosts/nixthree ];
      };
    };
  };
}
