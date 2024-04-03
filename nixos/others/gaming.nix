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

    services.pipewire = {
      lowLatency = {
        # enable this module
        enable = true;
        # defaults (no need to be set unless modified)
        quantum = 64;
        rate = 48000;
      };
    };

    # Enable Xbox controllers
    hardware.xone.enable = true;

    # Setup Steam, Gamescope and gamemode
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };

    programs.java = {
      enable = true;
      package = pkgs.jdk17;
    };

    programs.steam.platformOptimizations.enable = true;

    boot.kernel.sysctl = {
      "fs.file-max" = 524288;
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

  };

}
