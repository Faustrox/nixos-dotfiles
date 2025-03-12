{ config, lib, pkgs, ... }:

{
  options = {
    podman.enable = lib.mkEnableOption "Enable and configure podman";
  };

  config = lib.mkIf config.podman.enable {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";

      podman = {
        enable = true;
        autoPrune.enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;

      };

      # containers.storage.settings = {
      #   storage = {
      #     driver = "btrfs";
      #     runroot = "/run/containers/storage";
      #     graphroot = "/var/lib/containers/storage";
      #     options.overlay.mountopt = "nodev,metacopy=on";
      #   }; # storage
      # };
    };
    users.users.${config.main-user.username}.extraGroups = [ "oci" "podman" "docker" ];

    environment.systemPackages = with pkgs; [
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      # docker-compose # start group of containers for dev
      podman-compose # start group of containers for dev
      passt    # For Pasta rootless networking

    ];

    # Add 'newuidmap' and 'sh' to the PATH for users' Systemd units. 
    # Required for Rootless podman.
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [ pkgs.bash ]}"
    '';
  };
}
