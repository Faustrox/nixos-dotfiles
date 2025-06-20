{ config, lib, pkgs, ... }: let

  gamingEnv = {
    DXVK_STATE_CACHE_PATH = "/home/${config.main-user.username}/.cache/dxvk/";
    VKD3D_SHADER_CACHE_PATH = "/home/${config.main-user.username}/.cache/vkd3d/";
    PROTON_ENABLE_NGX_UPDATER = 1;
    PROTON_ENABLE_NVAPI = 1;
    PROTON_HIDE_NVIDIA_GPU = 0;
    DXVK_NVAPI_DRS_SETTINGS = "NGX_DLSS_RR_OVERRIDE=on,NGX_DLSS_SR_OVERRIDE=on,NGX_DLSS_RR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest,NGX_DLSS_SR_OVERRIDE_RENDER_PRESET_SELECTION=render_preset_latest";
    WINEDEBUG = "-all";
    DXVK_HUD = "compiler";
    DXVK_ASYNC = 1;
    VKD3D_CONFIG = "dxr";
  };

in {

  options = {
    gaming.setup = 
      lib.mkEnableOption "Configure some tweaks and programs for NixOs gaming";
  };

  config = lib.mkIf config.gaming.setup {

    users.users.${config.main-user.username}.extraGroups = [ "gamemode" ];

    # Kernel settings
    boot = {
      kernelPackages = pkgs.linuxPackages_cachyos-lto;
      kernelModules = [ "ntsync" ];
    };

    # SCX Scheduler
    services.scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_bpfland";
      extraArgs = [
        "--slice-us"
        "3000"
        "--primary-domain" 
        "performance"
        "--no-wake-sync"
      ];
    };
    
    # Xbox controllers dongle
    # hardware.xone.enable = true;
    hardware.xpadneo.enable = true;

    # Setup Steam, Gamescope, gamemode
    programs = {

      gpu-screen-recorder.enable = true;

      steam = {
        enable = true;
        protontricks.enable = true;
        # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

        package = pkgs.steam.override {
          extraEnv = gamingEnv // {};
        };

        extraCompatPackages = with pkgs; [ 
          proton-ge-custom
          
        ];
      };

      gamescope = {
        enable = true;
        package = pkgs.gamescope.overrideAttrs (old: {
          # version = "3.16.1_nvidia";

          # src = pkgs.fetchFromGitHub {
          #   owner = "sharkautarch";
          #   repo = "gamescope";
          #   rev = "bafa15766a3488c3c59ef2b558891ae1e26d6efa";
          #   fetchSubmodules = true;
          #   hash = "sha256-TL/3JkWbfgjd1sVbJw9ROpQtEUgIJVwcfxeQwrt9cCE=";
          # };

          NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
        });
        args = [
          # "-f"
          # "-e"
          "-H 1440"
          "-r 165"
          # "--force-grab-cursor"
          "--expose-wayland"
          # "-F nearest"
          # "--sharpness 10"
          # "--rt"
          "--adaptive-sync"
          "--immediate-flips"
        ];
        capSysNice = false;
      };

      gamemode = {
        enable = false;
        enableRenice = true;

        settings = {
          general = {
            renice = 10;
            softrealtime = "auto";
          };
          # custom = {
          #   start = "${agsPkg}/bin/ags request 'Toggle Gamemode' --instance astal";
          #   end = "${agsPkg}/bin/ags request 'Toggle Gamemode' --instance astal";
          # };
        };
      };
    };

    # services = {
    #   ananicy = {

    #     enable = if config.services.scx.enable then false else true;
    #     package = pkgs.ananicy-cpp;
    #     rulesProvider = pkgs.ananicy-rules-cachyos;

    #     settings = {
    #       check_freq = 15;
    #       cgroup_load = true;
    #       type_load = true;
    #       rule_load = true;

    #       apply_nice = true;
    #       apply_latnice = true;
    #       apply_ionice = true;
    #       apply_sched = true;
    #       apply_oom_score_adj = true;
    #       apply_cgroup = true;

    #       loglevel = "info";

    #       log_applied_rule = false;

    #       cgroup_realtime_workaround = lib.mkForce false;

    #     };

    #     extraRules = [
    #     ];
    #   };
    # };

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

    boot = { # Kernel changes for performance
      kernelParams = [
        "idle=nomwait"
        "mitigations=off"
        "retbleed=off"
        "pti=off"
        "amd_iommu=off"
        "intel_iommu=off"
        # "random.trust_cpu=off"
        # "random.trust_bootloader=off"
        "tsc=reliable"
        "clocksource=tsc"
        # "clearcpuid=514"
        "preempt=full"
        "threadirqs"
      ];
      kernel.sysctl = {
        
        # Cachyos Kernel only
        "kernel.sched_bore" = "1";

        "kernel.sched_rt_runtime_us" = 980000;
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        "kernel.sched_latency_ns" = 3000000;
        "kernel.sched_min_granularity_ns" = 300000;
        "kernel.sched_wakeup_granularity_ns" = 500000;
        "kernel.sched_migration_cost_ns" = 50000;
        "kernel.sched_nr_migrate" = 128;

        # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
        "kernel.unprivileged_userns_clone" = 1;

        # This action will speed up = yes;our boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
        # Disable NMI watchdog
        "kernel.nmi_watchdog" = 0;
        # To hide any kernel messages from the console
        "kernel.printk" = "3 3 3 3";
        # Restricting access to kernel pointers in the proc filesystem
        "kernel.kptr_restrict" = 2;

        # Disable Kexec, which allows replacing the current running kernel.
        "kernel.kexec_load_disabled" = 1;
        "kernel.split_lock_mitigate" = 0;
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

        "vm.min_free_kbytes" = 1048576;
        
        # Set size of file handles and inode cache
        "fs.file-max" = 2097152;

        # Increase writeback interval  for xfs
        "fs.xfs.xfssyncd_centisecs" = 10000;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        # Wine
        wineWowPackages.full
        winetricks
        gpu-screen-recorder-gtk
        gpu-screen-recorder
      ];
      sessionVariables = gamingEnv // {
        # STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-custom}/bin";
      };
    };

    systemd.tmpfiles.rules = [
      "d /home/${config.main-user.username}/.cache/dxvk 0770 ${config.main-user.username} users -"
      "d /home/${config.main-user.username}/.cache/vkd3d 0770 ${config.main-user.username} users -"
    ];
  };

}
