{ config, lib, pkgs, inputs, ... }:

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
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.kernelParams = [ "nvidia_drm.fbdev=1" "nvidia-drm.modeset=1" "video=2560x1440" ];

    # Enable Gsync Compatible on displays that has it 
    services.xserver.screenSection = ''
      Option "metamodes" "DP-1: 2560x1440_165 +1920+0 {AllowGSYNCCompatible=On} DP-2: 1920x1080_144 +0+360 {AllowGSYNCCompatible=On}"
    '';

    hardware.nvidia = let
      nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "565.77";
        sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
        sha256_aarch64 = "";
        openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
        settingsSha256 = "";
        persistencedSha256 = "";
      };
    in {
      # Modesetting is required.
      modesetting.enable = true;

      open = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = true;

      # Nvidia fine grainder power management, super experimental.
      powerManagement.finegrained = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc nvidiaPkg);
    };

    boot.extraModprobeConfig =
      "options nvidia "
      + lib.concatStringsSep " " [
        # nvidia assume that by default your CPU does not support PAT,
        # but this is effectively never the case in 2023
        "NVreg_UsePageAttributeTable=1"
        # This may be a noop, but it's somewhat uncertain
        "NVreg_EnablePCIeGen3=1"
        # This is sometimes needed for ddc/ci support, see
        # Current monitor does not support it, but this is useful for
        # the future
        "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
        # Message Signaled Interrupts
        "NVreg_EnableMSI=1"
        "NVreg_EnableResizableBar=1"
        "NVreg_EnableStreamMemOPs=1"
      ];

    nixpkgs.config.nvidia.acceptLicense = true;
    nixpkgs.config.cudaSupport = true;
    hardware.nvidia-container-toolkit.enable = true;

    environment.systemPackages = with pkgs; [
      egl-wayland
      vulkan-tools
      vulkan-headers
      vulkan-loader
    ];

    environment.variables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";

      __GL_SHADER_DISK_CACHE = 1;
      __GL_SHADER_DISK_CACHE_PATH = "/home/${config.main-user.username}/.cache/nvidia";
      __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
      __GL_THREADED_OPTIMIZATION = 1;
      __GL_SYNC_TO_VBLANK = 0;
      __GL_GSYNC_ALLOWED = 1;
    };
  
  };
  
}
