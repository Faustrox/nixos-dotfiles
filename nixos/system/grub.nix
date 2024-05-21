{ config, lib, pkgs, ... }:

{

  options = {
    grub.enable = 
      lib.mkEnableOption "Use grub as bootloader";
  };

  config = lib.mkIf config.grub.enable {
    # Boot settings (loader, pymouth and more)
    boot = {
      plymouth = {
        enable = true;
        catppuccin.enable = true;
      };

      # Silent boot
      consoleLogLevel = 0;
      kernelParams = [
        "quiet"
        "splash"
        "vga=current"
        "udev.log_level=3"
        "udev.log_priority=3"
      ];
      initrd.verbose = false;
      
      # Nvidia drivers at boot
      initrd.kernelModules = [ "nvidia" ];
      # extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

      # Bootloader config
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 2;
        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = true;
          timeoutStyle = "menu";
          default = "0";
          catppuccin.enable = true;
        };
      };
      
    };
  };
  
}