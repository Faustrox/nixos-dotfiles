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
      networkmanager = {
        enable = true;
        dns = "dnsmasq";
      };
      wireless.enable = config.network.wifi; 
      enableIPv6  = false;
      firewall = {
        enable = true;
        allowPing = true;
        allowedTCPPorts = [ 51413 8080 11470 12470 80 ]; # 51413 ---> Fragments
        allowedUDPPorts = [ 51413 8080 ];
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

    # services.resolved = {
    #   enable = true;
    #   dnssec = "true";
    #   domains = [ "~." ];
    #   fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
    #   dnsovertls = "true";
    # };

    # services.nginx = {
    #   enable = true;
    #   recommendedProxySettings = true;
    #   recommendedOptimisation = true;
    #   virtualHosts."${config.network.host}.local" = {
    #     listen = [ { addr = "0.0.0.0"; port = 80; } ];
    #     locations."/ai" = {
    #       proxyPass = "http://localhost:8080";
    #       extraConfig = ''
    #         proxy_set_header Host $host;
    #         proxy_set_header X-Real-IP $remote_addr;
    #         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #         proxy_set_header X-Forwarded-Proto $scheme;
    #         rewrite ^/ai(/.*)$ $1 break;
    #       '';
    #     };
    #     locations."/stremio" = {
    #       proxyPass = "http://localhost:11470";
    #       extraConfig = ''
    #         proxy_set_header Host $host;
    #         proxy_set_header X-Real-IP $remote_addr;
    #         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #         proxy_set_header X-Forwarded-Proto $scheme;
    #         rewrite ^/stremio(/.*)$ $1 break;

    #             # Habilitar CORS en nginx
    #         add_header Access-Control-Allow-Origin "http://the-hope.local";
    #         add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE";
    #         add_header Access-Control-Allow-Headers "Content-Type, Authorization";

    #         # Asegurarse de que la respuesta preflight CORS sea permitida
    #         if ($request_method = 'OPTIONS') {
    #           add_header Access-Control-Allow-Origin "http://the-hope.local";
    #           add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE";
    #           add_header Access-Control-Allow-Headers "Content-Type, Authorization";
    #           return 204;
    #         }
    #       '';
    #     };
    #   };
    # };


  };

}
