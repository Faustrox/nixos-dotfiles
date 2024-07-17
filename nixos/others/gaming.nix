{ config, lib, pkgs, inputs, ... }:

{

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
  };

  config = lib.mkIf config.gaming.setup {

    # Enable Xbox controllers
    hardware.xone.enable = true;

    # Setup Steam, Gamescope, gamemode and java
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        protontricks.enable = true;
      };

      alvr = {
        enable = true;
        openFirewall = true;
      };
      
      gamescope.enable = true;
      gamemode.enable = true;
    };

    # Open source OpenXR for VR

    services.monado = {
      enable = true;
      defaultRuntime = true;
    };

    systemd.user.services.monado.environment = {
      XRT_COMPOSITOR_COMPUTE = "1";
    };

    # NixOS configuration for Star Citizen
    boot.kernel.sysctl = {
      "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

  };

}
