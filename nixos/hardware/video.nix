{ config, pkgs, lib, ... }:

{

  options = {
    nvidia.enable = 
      lib.mkEnableOption "Nvidia stable drivers";

    nvidia.open = 
      lib.mkEnableOption "Nvidia stable Open drivers";
  };

  config = lib.mkMerge [
    (lib.mkIf config.nvidia.enable {

      # Enable OpenGL
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        powerManagement.enable = false;

        # Nvidia fine grainder power management, super experimental.
        powerManagement.finegrained = false;

        # Enable the Nvidia settings menu,
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;
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
          # https://www.ddcutil.com/nvidia/
          #
          # Current monitor does not support it, but this is useful for
          # the future
          "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
          # When (if!) I get another nvidia GPU, check for resizeable bar
          # settings
        ];

      environment.variables = {
        # Required to run the correct GBM backend for nvidia GPUs on wayland
        GBM_BACKEND = "nvidia-drm";
        # Apparently, without this nouveau may attempt to be used instead
        # (despite it being blacklisted)
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # Hardware cursors are currently broken on nvidia
        WLR_NO_HARDWARE_CURSORS = "1";
      };

    })
    (lib.mkIf config.nvidia.open {

      hardware.nvidia.open = true;
      
    })
  ];

  

}
