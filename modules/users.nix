{ config, lib, pkgs, pkgs-stable, ... }:

with lib; {
  options = with types; {
    myUser.enable = mkEnableOption "myUser";
    myUser.primary = mkOption {
      type = str;
      description = "Name of the primary user";  
      default = "andrew";
    };
  };
  
  config = mkIf config.myUser.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${config.myUser.primary} = {
      isNormalUser = true;
      uid = 1000;
      group = config.myUser.primary;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.zsh;
      packages = config.myPackages;
    };

    users.groups.${config.myUser.primary}.gid = 1000;
  
    security.sudo.wheelNeedsPassword = false;
  };
}
