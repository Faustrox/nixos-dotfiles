{ config, lib, pkgs, ... }:

{
  options = {
    docker.enable =
      lib.mkEnableOption "Enable and configure docker for nixos";
    
    docker.userName = lib.mkOption {
      default = "faustrox";
        description = ''
          Adding users to the docker group will provide them access to the socket
        '';
    };
  };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.users.${config.docker.userName}.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      lazydocker
    ];
  };
}
