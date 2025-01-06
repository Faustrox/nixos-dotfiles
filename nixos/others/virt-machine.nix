{ config, lib, pkgs, inputs, ... }: let

  cfg = config.virt-machine;

in {

  options = {
    virt-machine = {
      enable = 
        lib.mkEnableOption "Enable and configure virtual machine in nixos";
      fileSharing = {
        enable = 
          lib.mkEnableOption "Enable file sharing";
        settings = lib.mkOption {
          description = "Samba settings";
          default = {
            "public" = {
              "path" = "/home/${config.main-user.username}/Public";
              "browseable" = "yes";
              "read only" = "no";
              "guest ok" = "yes";
              "create mask" = "0644";
              "directory mask" = "0755";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.${config.main-user.username}.extraGroups = [ "qemu-libvirtd" "libvirtd" ];

    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf = {
            enable = true;
            packages = [ (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd ];
          };
        };
      };
      spiceUSBRedirection.enable = true;
    };

    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
      samba-wsdd = lib.mkIf cfg.fileSharing.enable {
        enable = true;
        openFirewall = true;
      };
    };


    # Public folder default file sharing
    services.samba = lib.mkIf cfg.fileSharing.enable {
      enable = true;
      securityType = "user";
      openFirewall = true;
      settings = cfg.fileSharing.settings;
    };

  };

}
