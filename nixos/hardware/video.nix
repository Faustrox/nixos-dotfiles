{ config, lib, pkgs, ... }:

{

  options = {
    nvidia.enable = 
      lib.mkEnableOption "Nvidia drivers setup";

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
        extraPackages = with pkgs; [
          libva-utils
          vaapiVdpau 
          libvdpau-va-gl
          nvidia-vaapi-driver
          vulkan-loader
          vulkan-validation-layers
          vulkan-tools
        ];
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
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "535.154.05";
          sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
          sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
          openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
          settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
          persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
        };
      };
      nixpkgs.config.nvidia.acceptLicense = true;

      # Load nvidia-settings config on startup
      # systemd.services.nvidia-setup = {
      #   wantedBy = [ "multi-user.target" ];
      #   description = "Apply the nvidia-settings config.";
      #   serviceConfig = {
      #     Type = "oneshot";
      #     ExecStart = ''${config.hardware.nvidia.package.settings}/bin/nvidia-settings --load-config-only'';
      #   };
      # };

      environment.variables = {
        GBM_BACKEND = "nvidia-drm";
        NVD_BACKEND = "direct";
        LIBVA_DRIVER_NAME = "nvidia";
        VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE = "DP-2";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };

    })
    (lib.mkIf config.nvidia.open {

      hardware.nvidia.open = true;
      
    })
  ];

  

}
