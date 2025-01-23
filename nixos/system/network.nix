{ config, lib, ... }:

{
  
  options = {
    network.enable =
      lib.mkEnableOption "Enables and configure network";
    network.wifi = 
      lib.mkEnableOption "Enables wireless";
    network.host = lib.mkOption {
      default = "the-hope";
      description = ''
        Network hostname
      '';
    };
  };

  config = lib.mkIf config.network.enable {

    networking = {
      hostName = config.network.host;
      enableIPv6  = false;
      wireless.enable = config.network.wifi; 
      firewall.enable = true;
      networkmanager = {
        enable = true;
        dns = "dnsmasq";
      };
      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      hosts = {
        "127.0.0.1" = [ "${config.network.host}.local" ];
      };
    };

    services.dnsmasq.enable = true;

  };

}
