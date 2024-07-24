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
        "udev.log_level=3"
      ];
      initrd.verbose = false;

      # Bootloader config
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 2;
        grub = {
          enable = true;
          devices = [ "nodev" ];
          efiSupport = true;
          useOSProber = false;
          timeoutStyle = "menu";
          default = 0;
          catppuccin.enable = true;
        };
      };
      
    };
  };
  
}