{ config, lib, pkgs-unstable, pkgs-stable, ... }:

let
  kwalletPam = "${pkgs-unstable.kdePackages.kwallet-pam}/lib/security/pam_kwallet5.so";
in
{
  options = {
    myKwallet.enable = lib.mkEnableOption "myKwallet";
  };

  config = lib.mkIf (config.myKwallet.enable && (config.myDisplayManager != null)) (lib.mkMerge [
    {
      environment.etc."kwallet-pam-path".text = pkgs-unstable.kdePackages.kwallet-pam.outPath;

      myPackages = with pkgs-unstable; [
        kdePackages.kwallet
        kdePackages.kwalletmanager
      ];
    }

    # nixpkgs' ly module builds its PAM stack with useDefaultRules = false, and
    # the security.pam.services.<name>.kwallet options only feed the default
    # rule set. Setting them for ly is a silent no-op, so spell the rules out.
    # They sort after ly's own login rules, since pam_kwallet needs the password
    # that the login substack has already collected.
    # If ly is forced back onto the default rules (targets/laptop.nix does this),
    # the login rules are disabled and the kwallet option takes over instead.
    # Gating on rule `enable` rather than mkIf avoids infinite recursion.
    # kwallet https://github.com/NixOS/nixpkgs/issues/258296
    (lib.mkIf (config.myDisplayManager == "ly") (let
      ly = config.security.pam.services.ly;
    in {
      security.pam.services.ly = {
        kwallet = {
          enable = true;
          package = pkgs-unstable.kdePackages.kwallet-pam;
          forceRun = true;
        };
        rules = {
          auth.kwallet-ly = {
            enable = !ly.useDefaultRules;
            order = ly.rules.auth.login.order + 10;
            control = "optional";
            modulePath = kwalletPam;
          };
          session.kwallet-ly = {
            enable = !ly.useDefaultRules;
            order = ly.rules.session.login.order + 10;
            control = "optional";
            modulePath = kwalletPam;
            settings.force_run = true;
          };
        };
      };
    }))

    (lib.mkIf (config.myDisplayManager != "ly") {
      security.pam.services.${config.myDisplayManager}.kwallet = {
        enable = true;
        package = pkgs-unstable.kdePackages.kwallet-pam;
        forceRun = true;
      };
    })
  ]);
}
