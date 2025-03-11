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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, pwndbg, nixos-hardware, disko, home-manager, nur }@inputs:
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    # https://nix.dev/manual/nix/2.18/language/constructs
    # TODO https://flake.parts/
    {
      nixosConfigurations = 
        let
          favourite = "x86_64-linux";
          extraModules = [];
          provideArgs = system:
            let
              pkgs-unstable = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
                overlays = [ nur.overlays.default ];
              };
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
              pkgs-pwndbg = pwndbg.packages.${system};
            in
              {
                inherit inputs pkgs-unstable pkgs-stable pkgs-pwndbg nixos-hardware home-manager; 
              };
        in {
          nixone = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite;
            modules = [ ./hosts/nixone ] ++ extraModules;
          };
          nixtwo = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite;
            modules = [ ./hosts/nixtwo ] ++ extraModules;
          };
          nixthree = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite // { inherit disko; };
            modules = [ ./hosts/nixthree ] ++ extraModules;
          };
        };
    };
}
