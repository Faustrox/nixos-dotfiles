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

    # Enable Gsync Compatible on displays that has it 
    services.xserver.screenSection = ''
      Option "metamodes" "DP-1: 2560x1440_165 +1920+0 {AllowGSYNCCompatible=On} DP-2: 1920x1080_144 +0+360 {AllowGSYNCCompatible=On}"
    '';

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      open = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      # Nvidia fine grainder power management, super experimental.
      powerManagement.finegrained = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "560.35.03";
          sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
          openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
          settingsSha256 = "";
          persistencedSha256 = "";
        };
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
      # Disable GSP Firmware.
      # Nvidia 555 beta enables it by default
      # This can't be change in open nvidia drivers
      # "NVreg_EnableGpuFirmware=0"
    ];

    nixpkgs.config.nvidia.acceptLicense = true;

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      NVD_BACKEND = "direct";
      
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_SYNC_DISPLAY_DEVICE = "DP-1";
      __GL_GSYNC_ALLOWED = 1;
      __GL_MaxFramesAllowed = 1;
    };
  
  };
  
}
