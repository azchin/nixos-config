{ config, lib, pkgs-unstable, pkgs-stable, ... }:

with lib; {
  options = with types; {
    myUser.enable = mkOption {
        type = bool;
        description = "Enable non-root user";
        default = true;
    };
    myUser.primary = mkOption {
      type = str;
      description = "Name of the primary user";  
      default = "andrew";
    };
    myUser.extraGroups = mkOption {
      type = listOf str;
      description = "Extra groups for the user";  
      default = [];
    };
  };
  
  config = mkIf config.myUser.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.myUser.primary} = {
      isNormalUser = true;
      uid = 1000;
      group = config.myUser.primary;
      extraGroups = [ "wheel" ] ++ config.myUser.extraGroups; # Enable ‘sudo’ for the user.
      shell = pkgs-unstable.zsh;
      packages = config.myPackages;
    };

    users.groups.${config.myUser.primary}.gid = 1000;

    programs.zsh.enable = true;
  
    security.sudo.wheelNeedsPassword = false;
  };
}
