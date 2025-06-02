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
    realtek-r8152-linux = {
      url = "github:wget/realtek-r8152-linux/v2.20.1";
      flake = false;  # This is just source code, not a flake
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, pwndbg, nixos-hardware, disko, home-manager, nur, realtek-r8152-linux }@inputs:
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
                overlays = [ 
                  nur.overlays.default 
                  (self: super: {
                    # add mpris controls to mpv
                    mpv = super.mpv.override {
                      scripts = [ self.mpvScripts.mpris ];
                    };
                    # r8152 kernel module
                    linuxPackages_latest = super.linuxPackages_latest // {
                      realtek-r8152-driver = super.callPackage ./modules/r8152.nix {
                        kernel = super.linuxPackages_latest.kernel;
                        inherit realtek-r8152-linux;
                      };
                    };
                  })
                ];
              };
              pkgs-stable = import nixpkgs-stable {
                inherit system;
                config.allowUnfree = true;
              };
              pkgs-pwndbg = pwndbg.packages.${system};
            in
              {
                inherit inputs pkgs-unstable pkgs-stable pkgs-pwndbg nixos-hardware home-manager realtek-r8152-linux; 
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
          nixfour = nixpkgs.lib.nixosSystem {
            specialArgs = provideArgs favourite // { inherit disko; };
            modules = [ ./hosts/nixfour ] ++ extraModules;
          };
        };
    };
}
