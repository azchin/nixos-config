{
  description = "NixOS configuration wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware }@inputs:
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
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    nixosConfigurations = {
      nixone = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable; };
        modules = [
          ./hosts/nixone.nix
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          nixos-hardware.nixosModules.common-hidpi
        ];
      };
      nixtwo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit pkgs pkgs-stable; };
        modules = [
          ./hosts/nixtwo.nix
          nixos-hardware.nixosModules.framework-11th-gen-intel
        ];
      };
    };
  };
}
