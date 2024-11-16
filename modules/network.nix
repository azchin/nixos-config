{ config, lib, pkgs, pkgs-stable, ... }:

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
    myWireguard.dnsOnly = mkOption {
      type = bool;
      default = false;
      description = "Only use VPN for DNS";
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
  };
  config = mkMerge [
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
        ${config.myWireguard.interface} = {
          autostart = config.myWireguard.autostart;
          listenPort = config.myWireguard.port;
          address = [
            "10.100.0.${toString config.myWireguard.index}/32"
            "fd08:4711::${toString config.myWireguard.index}/128"
          ];
          privateKey = config.myWireguard.privateKey;
          dns = [ config.myWireguard.endpoint ];
          peers = [
            {
              publicKey = config.myWireguard.publicKey;
              presharedKey = config.myWireguard.presharedKey;
              endpoint = "${config.myWireguard.endpoint}:${toString config.myWireguard.port}";
              allowedIPs = if !config.myWireguard.dnsOnly
              then [ "0.0.0.0/0" "::/0" ]
              else [ ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
    })
    (mkIf (config.mySSH.enable && config.myWireguard.enable && !config.myWireguard.dnsOnly) {
      services.openssh = {
        listenAddresses = [
          {
            addr = "10.100.0.${toString config.myWireguard.index}";
            port = config.mySSH.port;
          }
        ];
      };
      systemd.services.sshd = {
        after = [ "wg-quick-${config.myWireguard.interface}.service" ];
        wants = [ "wg-quick-${config.myWireguard.interface}.service" ];
      };
      networking.firewall.interfaces = {
        ${config.myWireguard.interface} = {
          allowedTCPPorts = [
            config.mySSH.port
          ];
        };
      };
    })
    (mkIf (config.mySSH.enable && (!config.myWireguard.enable || config.myWireguard.dnsOnly )) {
      networking.firewall.allowedTCPPorts = [ config.mySSH.port ];
    })
  ];
}
