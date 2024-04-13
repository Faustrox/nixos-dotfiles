{ config, lib, pkgs, inputs, ... }:

{

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
  };

  config = lib.mkIf config.gaming.setup {

    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

    # Enable low latency for pipewire
    services.pipewire.lowLatency.enable = true;

    # Enable Xbox controllers
    hardware.xone.enable = true;

    # Setup Steam, Gamescope, gamemode and java
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      };
      
      gamemode.enable = true;

      java = {
        enable = true;
        package = pkgs.jdk17;
      };
    };

    programs.steam.platformOptimizations.enable = true;

    environment.sessionVariables = {
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      VKBASALT_CONFIG_FILE = "/mnt/games/Reshade/vkBasalt.conf";
      ENABLE_VKBASALT = "1";
      WINEFSYNC = "1";
      WINEESYNC = "1";
      DXVK_ENABLE_NVAPI = "1";
      DXVK_ASYNC = "1";
      DXVK_HUD = "compiler";
      PULSE_LATENCY_MSEC = "60";
      PROTON_ENABLE_NGX_UPDATER = "1";
      PROTON_FORCE_LARGE_ADDRESS_AWARE = "1";
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

  };

}
