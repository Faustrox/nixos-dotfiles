{ config, lib, pkgs, ... }: let
  nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "580.65.06";
    sha256_64bit = "sha256-BLEIZ69YXnZc+/3POe1fS9ESN1vrqwFy6qGHxqpQJP8=";
    sha256_aarch64 = "";
    openSha256 = "sha256-BKe6LQ1ZSrHUOSoV6UCksUE0+TIa0WcCHZv4lagfIgA=";
    settingsSha256 = "sha256-9PWmj9qG/Ms8Ol5vLQD3Dlhuw4iaFtVHNC0hSyMCU24=";
    persistencedSha256 = "";
  };
in {

  options = {
    nvidia.enable = 
      lib.mkEnableOption "Nvidia drivers setup";
  };

  config = lib.mkIf config.nvidia.enable {

    # Enable early KMS for NVIDIA
    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];

    # Enable the NVIDIA kernel modules
    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
      "nvidia_uvm"
    ];
    boot.extraModulePackages = [ nvidiaPkg ];

    # Blacklist nouveau to avoid conflicts
    boot.blacklistedKernelModules = [ "nouveau" ];

    hardware = {
      graphics = {
        enable = true;
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau
          libvdpau-va-gl
        ];
      };
      nvidia = {
        open = true;
        nvidiaSettings = true;
        nvidiaPersistenced = false;
        package = nvidiaPkg;

        modesetting.enable = lib.mkDefault true;
        powerManagement.enable = true;
      };
    };
    
    services.xserver.videoDrivers = [ "nvidia" ];
    services.lact.enable = true;
    
    boot.extraModprobeConfig = ''
      options nvidia \
        NVreg_EnablePCIeGen3=1 \
        NVreg_EnableStreamMemOPs=1 \
        NVreg_UsePageAttributeTable=1 \
        NVreg_InitializeSystemMemoryAllocations=0 \
        NVreg_PreserveVideoMemoryAllocations=1 \
        NVreg_DynamicPowerManagement=0x02 \
        NVreg_EnableResizableBar=1 \
        NVreg_DmaRemapPeerMmio=0 \
        NVreg_TemporaryFilePath=/var/tmp \
        NVreg_RegistryDwords="RmEnableAggressiveVblank=1;RMIntrLockingMode=1;RMUseSwI2c=0x01;RMI2cSpeed=100"

      options nvidia_modeset \
        opportunistic_display_sync=1 \
        disable_vrr_memclk_switch=1

      options nvidia_uvm \
        uvm_page_table_location=vid \
        uvm_block_cpu_to_cpu_copy_with_ce=1 \
        uvm_exp_gpu_cache_sysmem=1
    '';

    services.udev.extraRules = ''
      # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
      ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", \
          ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="auto"

      # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
      ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", ATTR{vendor}=="0x10de", \
          ATTR{class}=="0x03[0-9]*", TEST=="power/control", ATTR{power/control}="on"
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
      vulkan-tools
    ];

    environment.sessionVariables = {
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      MESA_VK_WSI_PRESENT_MODE = "immediate";

      GSK_RENDERER = "gl";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";

      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # __GLX_VENDOR_LIBRARY_NAME = "mesa";
      # __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"; 
      # MESA_LOADER_DRIVER_OVERRIDE = "zink";
      # GALLIUM_DRIVER = "zink";

      # __GL_GSYNC_ALLOWED = 1;
      # __GL_SHADER_DISK_CACHE = 1;
      # __GL_SHADER_DISK_CACHE_PATH = "/home/${config.main-user.username}/.cache/nvidia/";
      __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
    };
  };
}
