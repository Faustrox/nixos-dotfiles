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

    boot.initrd.network.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
      dnsovertls = "true";
    };

    networking = {
      enableIPv6 = false;
      hostName = config.network.host;
      useDHCP = lib.mkDefault true;
      dhcpcd.enable = true;
      wireless.enable = config.network.wifi;
      nftables.enable = true;
      nameservers = [ "1.1.1.1" "1.0.0.1" ];
      
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };

      firewall = {
        enable = true; 
        # allowedTCPPorts = [ 80 443 ];
        # allowedUDPPorts = [ 80 443 ];
      }; 
    };

  };

}
