{ config, lib, pkgs, ... }:

{

  options = {
    bootloader = {
      enable = 
        lib.mkEnableOption "Configure settings for bootloader";
      grub.enable = 
        lib.mkEnableOption "Use grub as bootloader";
      systemd-boot.enable =
      lib.mkEnableOption "Use systemd as bootloader";
    };
  };

  config = lib.mkIf config.bootloader.enable {

    boot = {
      tmp.cleanOnBoot = true;
      consoleLogLevel = 0;

      plymouth = {
        enable = true;
      };

      kernelParams = [
        "quiet"
        "plymouth.use-simpledrm"
        "console=/dev/null"
        "boot.shell_on_fail"
        "loglevel=4"
        "systemd.show_status=0"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
        "bgrt_disable" # Disable OEM Logo on system startup loading screen
      ];
      initrd = {
        verbose = false;
        kernelModules = [];
        systemd.enable = true;
      };

      # Bootloader config
      loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;

        systemd-boot = lib.mkIf config.bootloader.systemd-boot.enable {
          enable = true;
          editor = false;
          consoleMode = "max";
          configurationLimit = 5;
        };
        grub = lib.mkIf config.bootloader.grub.enable {
          enable = true;
          timeoutStyle = "hidden";
          configurationLimit = 5;
          gfxmodeEfi = "2560x1440";
          efiSupport = true;
          efiInstallAsRemovable = false;
          useOSProber = false;
          default = 0;
        };
      };
    };

    catppuccin = {
      plymouth.enable = true;
      grub.enable = true;
      tty.enable = true;
    };

    stylix.targets = {
      grub.enable = false;
      plymouth.enable = false;
      console.enable = false;
    };

  };
  
}
