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
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    # https://nix.dev/manual/nix/2.18/language/constructs
    {
      nixosConfigurations = 
        let
          favourite = "x86_64-linux";
          provideArgs = system:
            let
              pkgs-unstable = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
              pkgs-pwndbg = pwndbg.packages.${system};
            in
              {
                inherit inputs pkgs-unstable pkgs-stable pkgs-pwndbg nixos-hardware; 
              };
        in {
          nixone = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite;
            modules = [ ./hosts/nixone ];
          };
          nixtwo = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite;
            modules = [ ./hosts/nixtwo ];
          };
          nixthree = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite // { inherit disko; };
            modules = [ ./hosts/nixthree ];
          };
        };
    };
}
