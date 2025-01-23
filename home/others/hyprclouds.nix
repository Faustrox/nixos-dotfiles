{ config, lib, pkgs, inputs, ... }: let

  hyprclouds = pkgs.fetchFromGitHub {
    owner = "arfan-on-clouds";
    repo = "hyprclouds";
    rev = "main";
    sha256 = "7TQZ0YivAIbi2w5GdrfDyosx7tGzlCdVPI+gK1jn5SM=";
  };

in {

  options = {
    hyprclouds.enable = 
      lib.mkEnableOption "Enable hyprclouds for nix.";
  };

  config = lib.mkIf config.hyprclouds.enable {

    home.packages = with pkgs; [
      # matugen
      # rofi
      gtk3
      socat
      ripgrep
      pulseaudio
    ];

    programs = {
      ags = {
        enable = true;

        configDir = ../config/ags;

        extraPackages = with pkgs; [
          bun
          gtksourceview
          webkitgtk
          accountsservice
          inputs.ags.packages.${pkgs.system}.hyprland
        ];
      };
      wofi.enable = false;
      eww = {
        enable = true;
        configDir = ../config/eww;
      };
      zsh.shellAliases = {
        eww-start = "$HOME/.dotfiles/home/others/scripts/eww-start.sh";
        ags-start = "$HOME/.scripts/start.sh";
      };
    };

    home.file = {

      ".scripts/start.sh".source = ./scripts/ags-start.sh;

    };

  };

}