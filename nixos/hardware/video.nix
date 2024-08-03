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
      extraPackages = with pkgs; [
        vaapiVdpau
        nvidia-vaapi-driver
      ];
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      blacklistedKernelModules = lib.mkDefault [ "nouveau" ];
      kernelParams = [ 
        "nvidia_drm.modeset=1"
        "nvidia_drm.fbdev=1"
      ];
    };

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      open = false;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      # Nvidia fine grainder power management, super experimental.
      powerManagement.finegrained = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = false;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "555.58.02";
          sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
          openSha256 = "";
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
      NIXOS_OZONE_WL = 1;
      MOZ_ENABLE_WAYLAND = 1;

      GBM_BACKEND = "nvidia-drm";
      NVD_BACKEND = "direct";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_MaxFramesAllowed = 1;
    };
  
  };
  
}
