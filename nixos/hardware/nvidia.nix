{ config, lib, pkgs, ... }:

{

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
      "nvidia_drm"
    ];

    # Blacklist nouveau to avoid conflicts
    boot.blacklistedKernelModules = [ "nouveau" ];

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
        mesa
        egl-wayland
        vulkan-loader
        vulkan-validation-layers
        libva
      ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    services.lact.enable = true;
    # boot.initrd.availableKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    
    hardware.nvidia = let

      nvidiaPkg = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "575.64";
        sha256_64bit = "sha256-6wG8/nOwbH0ktgg8J+ZBT2l5VC8G5lYBQhtkzMCtaLE=";
        sha256_aarch64 = "";
        openSha256 = "sha256-y93FdR5TZuurDlxc/p5D5+a7OH93qU4hwQqMXorcs/g=";
        settingsSha256 = "sha256-3BvryH7p0ioweNN4S8oLDCTSS47fQPWVYwNq4AuWQgQ=";
        persistencedSha256 = "sha256-QkDNQKwCsakZOLcSie1NBiFCM5e5NFGiIKtPSFeWdXs=";
      };
    in {
      open = true;
      nvidiaSettings = true;
      nvidiaPersistenced = true;
      package = nvidiaPkg;

      gsp.enable = config.hardware.nvidia.open;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      # dynamicBoost.enable = true;
      
    };

    environment.etc."nvidia/nvidia-application-profiles-rc.d/limit-vram-usage".text = ''
      {
        "rules": [
          {
            "pattern": {
              "feature": "procname",
              "matches": "vesktop"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "spotify"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "discord"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "chromium"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "chrome"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "ghostty"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "webcord"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "brave"
            },
            "profile": "No VidMem Reuse"
          },
          {
            "pattern": {
              "feature": "procname",
              "matches": "wezterm"
            },
            "profile": "No VidMem Reuse"
          }
        ],
        "profiles": [
          {
            "name": "No VidMem Reuse",
            "settings": [
              {
                "key": "GLVidHeapReuseRatio",
                "value": 1
              }
            ]
          }
        ]
      }
    '';
    
    boot.extraModprobeConfig = ''
      options nvidia \
        NVreg_EnablePCIeGen3=1 \
        NVreg_EnableStreamMemOPs=1 \
        NVreg_UsePageAttributeTable=1 \
        NVreg_InitializeSystemMemoryAllocations=0 \
        NVreg_PreserveVideoMemoryAllocations=0 \
        NVreg_EnableResizableBar=1 \
        NVreg_RegistryDwords="RMIntrLockingMode=1"
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

    environment.variables = {
      # GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";

      __GL_MaxFramesAllowed = 1;
      __GL_YIELD = "USLEEP";
      # __GL_SHADER_DISK_CACHE = 1;
      # __GL_SHADER_DISK_CACHE_PATH = "/home/${config.main-user.username}/.cache/nvidia/";
      __GL_SHADER_DISK_CACHE_SIZE = "100000000000";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = 1;
    };
  };
}
