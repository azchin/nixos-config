{
  description = "NixOS configuration wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, disko }@inputs:
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
  in {
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    nixosConfigurations = {
      nixone = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable nixos-hardware; };
        modules = [ ./hosts/nixone ];
      };
      nixtwo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable nixos-hardware; };
        modules = [ ./hosts/nixtwo ];
      };
      nixthree = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable nixos-hardware disko; };
        modules = [ ./hosts/nixthree ];
      };
    };
  };
}
