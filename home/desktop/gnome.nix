{ config, lib, pkgs, ... }:

{

  options = {
    dconf.setup =
      lib.mkEnableOption "Enables and configure dconf";
    dconf.colorScheme = 
      lib.mkOption {
        default = "prefer-dark";
        description = "Color scheme";
      };
  };

  config = lib.mkIf config.dconf.setup {

    home.packages = with pkgs.gnomeExtensions; [
      appindicator
      burn-my-windows
      compiz-windows-effect
      clipboard-indicator
      gnome-40-ui-improvements
      tiling-assistant
    ];

    home.sessionVariables.GTK_THEME = "Catppuccin-Mocha-Standard-Sapphire-Dark";

    dconf = {
      settings = {

        # Window Managment preferences
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,close";
          num-workspaces = 3;
          resize-with-right-button = true;
        };

        # Wallpaper
        "org/gnome/desktop/screensaver" = {
          picture-uri = "file:///home/faustrox/.dotfiles/assets/wallpapers/nix-black-4k.png";
        };
        "org/gnome/desktop/background" = {
          picture-uri = "file:///home/faustrox/.dotfiles/assets/wallpapers/nix-black-4k.png";
          picture-uri-dark = "file:///home/faustrox/.dotfiles/assets/wallpapers/nix-black-4k.png";
        };

        # Mutter, extensions and apps on dock
        "org/gnome/mutter" = {
          attach-modal-dialogs = false;
          dynamic-workspaces = false;
          workspaces-only-on-primary = false;
          experimental-features = [ "variable-refresh-rate" "kms-modifier" ];
        };
        "org/gnome/shell" = {
          enabled-extensions = [
            "burn-my-windows@schneegans.github.com"
            "compiz-windows-effect@hermes83.github.com"
            "clipboard-indicator@tudmotu.com"
            "gnome-ui-tune@itstime.tech"
            "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
            "native-window-placement@gnome-shell-extensions.gcampax.github.com"
            "drive-menu@gnome-shell-extensions.gcampax.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "user-theme-x@tuberry.github.io"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            "tiling-assistant@leleat-on-github"
          ];
          favorite-apps = [ 
            "google-chrome.desktop"
            "org.gnome.Nautilus.desktop"
            "kitty.desktop" 
          ];
        };

        # Extensions settings
        "org/gnome/shell/extensions/appindicator" = {
          icon-size = 17;
          
        };
        "org/gnome/shell/extensions/clipboard-indicator" = {
          toggle-menu = [ "<Super>v" ];
        };
        "org/gnome/shell/extensions/user-theme" = {
          name = "Catppuccin-Mocha-Standard-Sapphire-Dark";
        };
        "org/gnome/shell/extensions/burn-my-windows" = {
          active-profile = "/home/faustrox/.dotfiles/home/config/gnome/burn-my-windows.conf";
        };
        "org/gnome/shell/extensions/com/github/hermes83/compiz-windows-effect" = {
          resize-effect = true;
          speedup-factor-divider = 4.9;
        };
        "org/gnome/shell/extensions/tiling-assistant" = {
          enable-tiling-popup = false;
          single-screen-gap = 12;
          window-gap = 8;
        };

        # Keybindings
        "org/gnome/desktop/wm/keybindings" = {
          close = [ "<Super>q" ];
          switch-to-workspace-left = [ "<Control><Super>Left" ];
          switch-to-workspace-right = [ "<Control><Super>Right" ];
          switch-input-source = [];
          switch-input-source-backward = [];
          move-to-workspace-down = [];
          move-to-workspace-up = [];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
          calculator = [ "<Super>c" ];
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          name = "Terminal";
          binding = "<Super>space";
          command = "kitty";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          name = "Chrome";
          binding = "<Super>b";
          command = "env PULSE_LATENCY_MSEC=30 google-chrome-stable  --audio-buffer-size=2048";
        };

        # Power
        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = "interactive";
          sleep-inactive-ac-type = "nothing";
        };

        # Miscs
        "org/gnome/desktop/input-sources" = {
          xkb-options = [ "terminate:ctrl_alt_bksp" ];
        };
        "org/gnome/desktop/applications/terminal" = {
          exec = "kitty";
          exec-arg = "";
        };
        "org/gnome/desktop/interface" = {
          clock-format = "12h";
          color-scheme = config.dconf.colorScheme;
          enable-hot-corners = false;
        };
        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
          speed = 0;
        };
        "org/gnome/desktop/privacy" = {
          old-files-age = 0;
        };
      };

    };

  };

}
