{ config, lib, ... }:

{

  options = {
    nvidia.enable = 
      lib.mkEnableOption "Nvidia drivers setup";
  };

  config = lib.mkIf config.nvidia.enable {

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    # boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    # Enable Gsync Compatible on displays that has it 
    services.xserver = {
      videoDrivers = [ "nvidia" ];
      # screenSection = ''
      #   Option "metamodes" "DP-1: 2560x1440_165 +1920+0 {AllowGSYNCCompatible=Off}, DP-2: 1920x1080_144 +0+360 {AllowGSYNCCompatible=Off}"
      # '';
    };

    hardware.nvidia = let
      nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "570.86.16";
        sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
        sha256_aarch64 = "";
        openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
        settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
        persistencedSha256 = "sha256-3mp9X/oV8o2TH9720NnoXROxQ4g98nNee+DucXpQy3w=";
      };
    in {
      # Modesetting is required.
      modesetting.enable = true;

      open = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      # Nvidia fine grainder power management, super experimental.
      powerManagement.finegrained = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = true;

      nvidiaPersistenced = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = nvidiaPkg;
    };

          
    boot.extraModprobeConfig = ''
      options nvidia_drm modeset=1 fbdev=1
      
      options nvidia '' + lib.concatStringsSep " " [
        "NVreg_UsePageAttributeTable=1"
        "NVreg_InitializeSystemMemoryAllocations=0"
        "NVreg_EnableStreamMemOPs=1"
        "NVreg_EnablePCIeGen3=1"
        "NVreg_EnableResizableBar=1"
      ];

    nixpkgs.config.nvidia.acceptLicense = true;
    # nixpkgs.config.cudaSupport = true;
    # hardware.nvidia-container-toolkit.enable = true;

    systemd.tmpfiles.rules = [
        "d /home/${config.main-user.username}/.cache/nvidia 0770 ${config.main-user.username} users -"
    ];

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";

      __GL_SHADER_DISK_CACHE = 1;
      __GL_SHADER_DISK_CACHE_PATH = "/home/${config.main-user.username}/.cache/nvidia";
      __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
      __GL_GSYNC_ALLOWED = 1;
    };
  };
}
