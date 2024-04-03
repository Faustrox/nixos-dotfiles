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

  config = lib.mkMerge [
    (lib.mkIf config.network.enable {

      networking.hostName = config.network.host; # Define your hostname.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Disable IPv6
      networking.enableIPv6  = false;

      # Enable DNSmasq
      services.dnsmasq.enable = true;

    })
    (lib.mkIf config.network.wifi {

      # Enables wireless support via wpa_supplicant.
      networking.wireless.enable = true;  

    })
  ];

}
