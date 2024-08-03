{ config, pkgs, lib, inputs, ... }: 

{

  options = {
    hyprland.enable = 
      lib.mkEnableOption "Enable Hyprland and configure";
  };

  config = lib.mkIf config.hyprland.enable {

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.x86_64-linux.hyprland;
    };

    nixpkgs.overlays = [
      (final: prev: {
        xwayland = prev.xwayland.overrideAttrs ({
          patches = [
            (prev.fetchpatch {
              url = "https://raw.githubusercontent.com/Nobara-Project/rpm-sources/main/baseos/xorg-x11-server-Xwayland/xwayland-pointer-warp-fix.patch";
              hash = "sha256-Qfee2M7Js0tnqR417BIJ3sa+gnARsF8UBx6ynPGOYAw=";
            })
          ];
        });
      })
    ];

    services = {
      displayManager = { 
        sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          wayland.enable = true;
          catppuccin.enable = true;
        };
      };
      gvfs.enable = true;
    };

    xdg.mime = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
      removedAssociations = {
        "inode/directory" = "code.desktop";
      };
    };

    environment.systemPackages = with pkgs; [
      
      wlr-randr
      wl-clipboard
      wl-clip-persist
      networkmanagerapplet
      
    ];

  };

}
