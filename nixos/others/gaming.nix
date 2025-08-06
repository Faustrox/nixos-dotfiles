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
      kernelPackages = pkgs.linuxPackages_cachyos;
      kernelModules = [ "ntsync" ];
    };

    # SCX Scheduler
    services.scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_lavd";
      extraArgs = [
        "--performance"
      ];
    };

    services.lsfg-vk = {
      enable = true;
      ui.enable = true; # installs gui for configuring lsfg-vk
    };
    
    # Xbox controllers dongle
    # hardware.xpadneo.enable = true;
    hardware.xone.enable = true;

    # Setup Steam, Gamescope, gamemode
    programs = {

      gpu-screen-recorder.enable = true;

      steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

        package = pkgs.steam.override {
          extraEnv = gamingEnv // {};
        };

        extraCompatPackages = with pkgs; [ 
          proton-ge-custom
          proton-cachyos_x86_64_v3
          proton-em-custom
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
          "-f"
          "-w 2560"
          "-h 1440"
          "-r 165"
          # "-o 165"
          # "-F nis"
          # "--backend"
          # "sdl"
          # "--expose-wayland"
          "--adaptive-sync"
          "--force-grab-cursor"
        ];
      };

      gamemode = {
        enable = true;
        enableRenice = true;

        settings = {
          general = {
            renice = 0;
            softrealtime = "auto";
          };
        };
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

        ${pkgs.coreutils}/bin/echo 3072 > /sys/class/rtc/rtc0/max_user_freq
        ${pkgs.coreutils}/bin/echo 3072 > /proc/sys/dev/hpet/max-user-freq

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
        "vdso=off"
        "retbleed=off"
        "pti=off"
        "split_lock_detect=off"
        "split_lock_mitigate=0"
        "sched_migration_cost=512"
        "amd_iommu=pgtbl_v2"
        "iommu=pt"
        # "random.trust_cpu=off"
        # "random.trust_bootloader=off"
        "tsc=reliable"
        "clocksource=tsc"
        "clearcpuid=514"
        "preempt=full"
        "processor.max_cstate=5"
        "nokaslr"
        "threadirqs"
        "ignore_rlimit_data"

        "nohz=on"
        "nohz_full=4-5"
        "rcu_nocb_poll"
        "rcu_nocbs=4-5"
        "irqaffinity=0-3"
      ];
      kernel.sysctl = {
        
        "kernel.sched_bore" = 1;

        "vm.compaction_proactiveness" = 0;
        "vm.watermark_boost_factor" = 1;
        "vm.watermark_scale_factor" = 500;
        "vm.min_free_kbytes" = 1024;
        "vm.zone_reclaim_mode" = 0;
        "vm.page_lock_unfairness" = 1;
        "kernel.sched_autogroup_enabled" = 1;
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;

        # The sysctl swappiness parameter determines the kernel's preference for pushing anonymous pages or page cache to disk in memory-starved situations.
        # A low value causes the kernel to prefer freeing up open files (page cache), a high value causes the kernel to try to use swap space,
        # and a value of 100 means IO cost is assumed to be equal.
        "vm.swappiness" = 10;

        # The value controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects (VFS cache).
        # Lowering it from the default value of 100 makes the kernel less inclined to reclaim VFS cache (do not set it to 0, this may produce out-of-memory conditions)
        "vm.vfs_cache_pressure" = 50;

        # Contains, as bytes, the number of pages at which a process which is
        # generating disk writes will itself start writing out dirty data.
        "vm.dirty_bytes" = 268435456;

        # page-cluster controls the number of pages up to which consecutive pages are read in from swap in a single attempt.
        # This is the swap counterpart to page cache readahead. The mentioned consecutivity is not in terms of virtual/physical addresses,
        # but consecutive on swap space - that means they were swapped out together. (Default is 3)
        # increase this value to 1 or 2 if you are using physical swap (1 if ssd, 2 if hdd)
        "vm.page-cluster" = 0;

        # Contains, as bytes, the number of pages at which the background kernel
        # flusher threads will start writing out dirty data.
        "vm.dirty_background_bytes" = 67108864;

        # The kernel flusher threads will periodically wake up and write old data out to disk.  This
        # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
        "vm.dirty_writeback_centisecs" = 1500;

        # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
        # Disable NMI watchdog
        "kernel.nmi_watchdog" = 0;

        # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
        "kernel.unprivileged_userns_clone" = 1;

        # To hide any kernel messages from the console
        "kernel.printk" = "3 3 3 3";

        # Restricting access to kernel pointers in the proc filesystem
        "kernel.kptr_restrict" = 2;

        # Disable Kexec, which allows replacing the current running kernel.
        "kernel.kexec_load_disabled" = 1;

        # Increase netdev receive queue
        # May help prevent losing packets
        "net.core.netdev_max_backlog" = 4096;

        # Set size of file handles and inode cache
        "fs.file-max" = 2097152;

        "vm.max_map_count" = 2147483642;
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

      "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
      "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
      "w /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - never"
      "w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000"
      "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
      "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
      "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
    ];
  };

}
