{ config, lib, pkgs-unstable, pkgs-stable, ... }:

# TODO experiment with multiple interfaces

with lib; {
  options = with types; {
    mySSH.enable = mkEnableOption "mySSH";
    mySSH.port = mkOption {
      type = int;
      default = 22;
      description = "SSH port";
    };
    myWireguard.enable = mkEnableOption "myWireguard";
    myWireguard.autostart = mkOption {
      type = bool;
      default = true;
      description = "Wireguard autostart";
    };
    myWireguard.index = mkOption {
      type = int;
      default = 1;
      description = "Wireguard client index";
    };
    myWireguard.privateKey = mkOption {
      type = str;
      default = "";
      description = "Wireguard private key";
    };
    myWireguard.presharedKey = mkOption {
      type = str;
      default = "";
      description = "Wireguard preshared key";
    };
    myWireguard.publicKey = mkOption {
      type = str;
      default = "";
      description = "Wireguard public key";
    };
    myWireguard.endpoint = mkOption {
      type = str;
      default = "";
      description = "Wireguard endpoint";
    };
    myWireguard.mode = mkOption {
      type = enum [ "devices" "dns" "everything" ];
      default = "devices";
      description = "Special mode for Wireguard. Options are to route DNS only, devices, or all traffic";
    };
    myWireguard.port = mkOption {
      type = int;
      default = 51820;
      description = "Wireguard port";
    };
    myWireguard.interface = mkOption {
      type = str;
      default = "wg0";
      description = "Wireguard interface";
    };
    myWireguard.additionalAllowedIPs = mkOption {
      type = listOf str;
      default = [];
      description = "Wireguard additional allowed IPs";
    };
  };
  config =
    let
      interfaceEverything = "${config.myWireguard.interface}-everything";
      interfaceDNS = "${config.myWireguard.interface}-dns";
      remoteOverVPN = config.myWireguard.enable && config.myWireguard.mode == "everything";
      declareWgInterface = modeStr: allowedIPs: {
        autostart = config.myWireguard.autostart && config.myWireguard.mode == modeStr;
        listenPort = config.myWireguard.port;
        address = [
          "10.100.0.${toString config.myWireguard.index}/32"
          "fd08:4711::${toString config.myWireguard.index}/128"
        ];
        privateKey = config.myWireguard.privateKey;
        dns = [ "9.9.9.9" ];
        peers = [
          {
            publicKey = config.myWireguard.publicKey;
            presharedKey = config.myWireguard.presharedKey;
            endpoint = "${config.myWireguard.endpoint}:${toString config.myWireguard.port}";
            allowedIPs = allowedIPs ++ config.myWireguard.additionalAllowedIPs;
            persistentKeepalive = 25;
          }
        ];
      };
    in
      mkMerge [
        (mkIf config.mySSH.enable {
          # by default sets up sshd jail
          # by default sets up services.openssh.logLevel to verbose
          services.fail2ban.enable = true;
          services.openssh = {
            enable = true;
            settings = {
              PasswordAuthentication = false; 
              PermitRootLogin = "no";
              AllowUsers = [ config.myUser.primary ];
            };
            ports = [ config.mySSH.port ];
          };
        })
        (mkIf config.myWireguard.enable {
          networking.firewall.allowedUDPPorts = [ config.myWireguard.port ];
          networking.wg-quick.interfaces = {
            ${config.myWireguard.interface} =
              declareWgInterface "devices" [ "10.100.0.0/24" "fd08:4711::/64" ];
            ${interfaceEverything} =
              declareWgInterface "everything" [ "0.0.0.0/0" "::/0" ];
            ${interfaceDNS} =
              declareWgInterface "dns" [ ];
          };
        })
        (mkIf (config.mySSH.enable && remoteOverVPN) {
          services.openssh = {
            listenAddresses = [
              {
                addr = "10.100.0.${toString config.myWireguard.index}";
                port = config.mySSH.port;
              }
            ];
          };
          systemd.services.sshd = {
            after = [ "wg-quick-${interfaceEverything}.service" ];
            wants = [ "wg-quick-${interfaceEverything}.service" ];
          };
          networking.firewall.interfaces = {
            ${config.myWireguard.interface} = {
              allowedTCPPorts = [
                config.mySSH.port
              ];
            };
          };
        })
        (mkIf (config.mySSH.enable && !remoteOverVPN) {
          networking.firewall.allowedTCPPorts = [ config.mySSH.port ];
        })
        (mkIf (!config.myWireguard.enable) {
          networking.nameservers = ["9.9.9.9"];
        })
      ];
}
