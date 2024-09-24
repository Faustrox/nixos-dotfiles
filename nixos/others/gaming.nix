{ config, lib, pkgs, inputs, ... }:

{

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
  };

  config = lib.mkIf config.gaming.setup {

    # Xbox controllers dongle
    overlays.xone.fixes = true;
    hardware.xone.enable = true;

    # Setup Steam, Gamescope, gamemode 
    programs = {

      gamescope.enable = true;

      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 0;
            disable_splitlock = 1;
          };

          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'Gamemode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'Gamemode ended'";
          };
        };
      };
      
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
        "vm.page_lock_unfairness" = 1;

        "fs.file-max" = 524288;
      };
    };
  };

}
