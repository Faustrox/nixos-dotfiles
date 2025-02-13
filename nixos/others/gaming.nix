{ config, lib, pkgs, ... }:

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
        package = pkgs.gamescope;
        args = [
          "-f"
          "-H 1440"
          "-h 1440"
          "-r 165"
          "-F nearest"
          "--sharpness 10"
          "--rt"
          "--force-grab-cursor"
          "--expose-wayland"
        ];
        capSysNice = false;
      };

      gamemode = {
        enable = false;
        enableRenice = false;
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
        # extest.enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-custom ];
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        protontricks.enable = true;
      };

      alvr = {
        enable = true;
        openFirewall = true;
      };
      
    };

    services = {
      udev.extraRules = ''
        KERNEL=="ntsync", MODE="0644"
      '';
      ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos.overrideAttrs {
          src = pkgs.fetchFromGitHub {
            owner = "CachyOS";
            repo = "ananicy-rules";
            rev = "03cc642f7b8e38d3d3c4e9bb8754659c8c64fd38";
            hash = "sha256-OoyQKuEzxNmrbNX5d3tzofH2Xvxi/T8bbe03So5CiuI=";
          };
        };

        settings = {
          check_freq = 15;
          cgroup_load = true;
          type_load = true;
          rule_load = true;

          apply_nice = true;
          apply_latnice = true;
          apply_ionice = true;
          apply_sched = true;
          apply_oom_score_adj = true;
          apply_cgroup = true;

          loglevel = "info";

          log_applied_rule = false;

          cgroup_realtime_workaround = lib.mkForce false;

        };

        extraRules = [
          {
            name = "Marvel.exe";
            type = "Game";
          }
          {
            name = "isaac-ng.exe";
            type = "Game";
          }
          {
            name = "Sifu.exe";
            type = "Game";
          }
          {
            name = "TheGreatCircle.exe";
            type = "Game";
          }
          {
            name = "Spider-Man2.exe";
            type = "Game";
          }
          {
            name = "mgsvtpp.exe";
            type = "Game";
          }
          {                       
            name = "KingdomCome.exe";
            type = "Game";
          }
        ];
      };
    };

    systemd.services."pci-latency" = {
      description = "Adjust latency timers for PCI peripherals";
      wantedBy = [ "multi-user.target" ];
      script = ''
        # This script is designed to improve the performance and reduce audio latency
        # for sound cards by setting the PCI latency timer to an optimal value of 80
        # cycles. It also resets the default value of the latency timer for other PCI
        # devices, which can help prevent devices with high default latency timers from
        # causing gaps in sound.

        # Check if the script is run with root privileges
        if [ "$(${pkgs.coreutils}/bin/id -u)" -ne 0 ]; then
          echo "Error: This script must be run with root privileges." >&2
          exit 1
        fi

        # Reset the latency timer for all PCI devices
        ${pkgs.pciutils}/bin/setpci -v -s '*:*' latency_timer=20
        ${pkgs.pciutils}/bin/setpci -v -s '0:0' latency_timer=0

        # Set latency timer for all sound cards
        ${pkgs.pciutils}/bin/setpci -v -d "*:*:04xx" latency_timer=80
      '';
      serviceConfig = {
        Type = "oneshot";
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

        # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
        # Disable NMI watchdog
        "kernel.nmi_watchdog" = 0;
        # To hide any kernel messages from the console
        "kernel.printk" = "3 3 3 3";
        # Restricting access to kernel pointers in the proc filesystem
        "kernel.kptr_restrict" = 2;

        # Disable Kexec, which allows replacing the current running kernel.
        "kernel.kexec_load_disabled" = 1;
        "kernel.split_lock_mitigate" = 0;
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        # Internet
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_low_latency" = 1;
        "net.ipv4.tcp_ecn" = 1;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fin_timeout" = 5;
        # Disable TCP slow start after idle
        # Helps kill persistent single connection performance
        "net.ipv4.tcp_slow_start_after_idle" = 0;
        # Protect against tcp time-wait assassination hazards, drop RST packets for sockets in the time-wait state. Not widely supported outside of Linux, but conforms to RFC:
        "net.ipv4.tcp_rfc1337" = 1;
        # Increase netdev receive queue
        # May help prevent losing packets
        "net.core.netdev_max_backlog" = 4096;
        # Kernel delay task accounting
        "kernel.task_delayacct" = 1;

        # Increase the compaction activity slightly
        "vm.compaction_proactiveness" = 0;

        "vm.max_map_count" = 2147483642;
        "fs.file-max" = 524288;
        # Increase writeback interval  for xfs
        "fs.xfs.xfssyncd_centisecs" = 10000;
      };
    };


    environment.sessionVariables = {
      # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-custom}/bin";
      DXVK_STATE_CACHE_PATH = "/home/${config.main-user.username}/.cache/dxvk";
      PROTON_HIDE_NVIDIA_GPU = 0;
      DXVK_HUD = "compiler";
      DXVK_ASYNC = 1;
      WINEESYNC = 1;
      WINEFSYNC = 1;
      PROTON_ENABLE_NVAPI = 1;
      # PROTON_ENABLE_NGX_UPDATER = 1;
    };
  };

}
