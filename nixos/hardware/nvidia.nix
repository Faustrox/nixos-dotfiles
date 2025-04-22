{ config, lib, pkgs, ... }:

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

    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };

    hardware.nvidia = let
      nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "575.51.02";
        sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
        sha256_aarch64 = "";
        openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
        settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
        persistencedSha256 = "";
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

      nvidiaPersistenced = false;

      # dynamicBoost.enable = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = nvidiaPkg;
    };
    
    boot.extraModprobeConfig = ''
      options nvidia_drm modeset=1 fbdev=1
      
      options nvidia 
    '' + lib.concatStringsSep " " [
      "NVreg_UsePageAttributeTable=1"
      "NVreg_InitializeSystemMemoryAllocations=1"
      "NVreg_EnableStreamMemOPs=1"
      "NVreg_EnablePCIeGen3=1"
      "NVreg_EnableResizableBar=1"
      "NVreg_RegistryDwords=RMIntrLockingMode=1"
    ];

    services.udev.extraRules = ''
      # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
      ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
          ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
          TEST=="power/control", ATTR{power/control}="auto"

      # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
      ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
          ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
          TEST=="power/control", ATTR{power/control}="on"
    '';

    nixpkgs.config.nvidia.acceptLicense = true;
    # nixpkgs.config.cudaSupport = true;
    # hardware.nvidia-container-toolkit.enable = true;

    systemd.tmpfiles.settings = {
      "10-nvidia-glcache" = {
        "/home/${config.main-user.username}/.cache/nvidia" = {
          d = {
            group = "users";
            mode = "0770";
            user = "${config.main-user.username}";
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      libva-utils
      vdpauinfo
      vulkan-tools
      vulkan-validation-layers
      libvdpau-va-gl
      egl-wayland
      wgpu-utils
      libglvnd
      nvtopPackages.full
      nvitop
      libGL
      gl-gsync-demo
    ];

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";

      # __GL_SHADER_DISK_CACHE = 1;
      # __GL_SHADER_DISK_CACHE_PATH = "/home/${config.main-user.username}/.cache/nvidia/";
      __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;

      # __GL_MaxFramesAllowed = 1;
    };
  };
}
