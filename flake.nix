{
  description = "NixOS configuration wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
  };

  outputs = { self, nixpkgs, nixpkgs-stable }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        (final: prev: {
          awesome = prev.awesome.override { gtk3Support = true; };
        })
      ];
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      nixone = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable; };
        modules = [ ./hosts/nixone.nix ];
      };
      nixtwo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable; };
        modules = [ ./hosts/nixtwo.nix ];
      };
    };
  };
}
