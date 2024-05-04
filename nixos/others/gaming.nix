{ config, lib, pkgs, inputs, ... }:

{

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
    gaming.steamRoot = 
      lib.mkOption {
        default = "/mnt/games/Libreries/Steam";
        description = "Where steam libreary is located";
      };
  };

  config = lib.mkIf config.gaming.setup {

    environment.sessionVariables = {
      STEAM_ROOT = config.gaming.steamRoot;
      __GL_SHADER_DISK_CACHE_PATH = "/home/faustrox/.shaders";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      VKBASALT_CONFIG_FILE = "/mnt/games/Reshade/vkBasalt.conf";
      VKD3D_CONFIG = "dxr11,dxr";
      PROTON_ENABLE_NVAPI = "1";
      PROTON_ENABLE_NGX_UPDATER = "1";
      DXVK_ASYNC = "1";
      DXVK_HUD = "compiler";
      WEBKIT_DISABLE_COMPOSITING_MODE = "1"; # Fixes problems for logins in Lutris and other apps
      # PULSE_LATENCY_MSEC = "60";
    };

    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

    # Enable Xbox controllers
    hardware.xone.enable = true;

    # Setup Steam, Gamescope, gamemode and java
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        gamescopeSession.enable = true;
        platformOptimizations.enable = true;
      };
      
      gamemode.enable = true;

      java = {
        enable = true;
        package = pkgs.jdk17;
      };
    };

    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # NixOS configuration for Star Citizen requirements
    boot.kernel.sysctl = {
      # "vm.max_map_count" = 16777216;
      "fs.file-max" = 524288;
    };

  };

}
