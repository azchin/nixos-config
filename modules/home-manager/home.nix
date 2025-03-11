{ lib, pkgs, osConfig, ... }: {
  home = {
    stateVersion = "25.05";
    username = osConfig.myUser.primary;
    homeDirectory = "/home/${osConfig.myUser.primary}";
  };

  # TODO gtk
  # TODO vscode

  # https://foo-dogsquared.github.io/nixos-config/03-project-specific-setup/04-custom-firefox-addons/
  # https://nur.nix-community.org/repos/rycee/
  # https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
  # https://github.com/llakala/nixos/blob/3ae839c3b3d5fd4db2b78fa2dbb5ea1080a903cd/apps/programs/firefox/policies.nix
  programs.librewolf = {
    enable = true;
    profiles.${osConfig.myUser.primary} = {
      containers = {
        "Spook" = {
          color = "red";
          icon = "circle";
        };
      };
      # TODO install extensions in system level?
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          multi-account-containers
        ];
        # force = true;
        # settings = {
        #   "multi-account-containers".force = true;
        # };
      };
    };
  };
}
