{ config, lib, pkgs, inputs, ... }:

{

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
  };

  config = lib.mkIf config.gaming.setup {

    users.users.${config.main-user.username}.extraGroups = [ "gamemode" ];

    # Xbox controllers dongle
    hardware.xone.enable = true;

    # New games for ananicy rules
    services.ananicy.extraRules = let
      defaultType = "Game";
      gamesToImport = [ "isaac-ng.exe" "bms.exe" "project8.exe" "valheim.exe" "Marvel.exe" "TheGreatCircle.exe" "dontstarve_steam_x64.exe" ];
    in map (gameName: {
      type = defaultType;
      name = gameName;
    }) gamesToImport;

    # SCX Scheduler
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [
        "--performance"
        "--no-core-compaction"
      ];
    };

    # Setup Steam, Gamescope, gamemode
    programs = {

      gpu-screen-recorder.enable = true;

      gamescope = {
        enable = true;
        args = [
          "-b"
          "--rt"
          "--expose-wayland"
          "--immediate-flips"
        ];
        capSysNice = false;
      };

      gamemode = {
        enable = true;
        # enableRenice = false;
        settings = {
          # general = {
          #   ioprio = "off"; # Ananicy handles this
          # };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
      
      steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamemode
          gamescope
        ];
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        protontricks.enable = true;
      };

      alvr = {
        enable = true;
        openFirewall = true;
      };
      
    };

    boot = {
      kernelParams = [
        "retbleed=off"
        "mitigations=off"
        "tsc=reliable"
        "clocksource=tsc"
        "clearcpuid=514"
        "preempt=full"
      ];
      kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;

        "vm.max_map_count" = 2147483642;

        "fs.file-max" = 524288;
      };
    };
  };

}
