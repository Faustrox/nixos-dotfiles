{ config, lib, pkgs, inputs, ... }:

{

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
  };

  config = lib.mkIf config.gaming.setup {

    users.users.${config.main-user.username}.extraGroups = [ "gamemode" ];

    # Kernel zen version
    boot.kernelPackages = pkgs.linuxPackages_cachyos;

    # SCX Scheduler
    services.scx = {
      enable = true;
      package = pkgs.scx_git.full;
      scheduler = "scx_lavd";
      extraArgs = [
        "--performance"
        "--no-core-compaction"
      ];
    };
    
    # Xbox controllers dongle
    hardware.xone.enable = true;

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

        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        # Internet
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_low_latency" = 1;
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fin_timeout" = 5;

        # Kernel delay task accounting
        "kernel.task_delayacct" = 1;

        # Increase the compaction activity slightly
        "vm.compaction_proactiveness" = 0;

        "vm.max_map_count" = 2147483642;
        "fs.file-max" = 524288;
      };
    };
  };

}
