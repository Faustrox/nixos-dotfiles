{ config, lib, pkgs, inputs, ... }:

{

  options = {
    nvidia.enable = 
      lib.mkEnableOption "Nvidia drivers setup";

    nvidia.open = 
      lib.mkEnableOption "Nvidia stable Open drivers";
  };

  config = lib.mkIf config.nvidia.enable {

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
      ];
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      blacklistedKernelModules = lib.mkDefault [ "nouveau" ];
      kernelModules = [ "nvidia" ];
      initrd.kernelModules = [ "nvidia" ];
    };

    services.xserver.screenSection = ''
      Option "metamodes" "DP-0: 2560x1440_165 +1920+0 {AllowGSYNCCompatible=On} DP-2: 1920x1080_144 +0+360 {AllowGSYNCCompatible=On}"
    '';

    hardware.nvidia = {

      # Modesetting is required.
      modesetting.enable = true;

      open = config.nvidia.open;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;

      # Nvidia fine grainder power management, super experimental.
      powerManagement.finegrained = false;

      # Enable the Nvidia settings menu,
      nvidiaSettings = true;

      nvidiaPersistenced = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.42.02";
        sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
        settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
      };
    };

    nixpkgs.config.nvidia.acceptLicense = true;

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      # NVD_BACKEND = "direct";
      # LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  
  };
  

}
