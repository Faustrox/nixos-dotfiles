{ pkgs, ... }:
let
  nvibrantAutostart = pkgs.writeText "nvibrant.desktop" ''
    [Desktop Entry]
    Type=Application
    Name=nVibrant
    Exec=nvibrant 256 256 256 256 256 256 256
    NoDisplay=true
  '';
in
{
  xdg.enable = true;
  # Autostart desktop files
  xdg.autostart = {
    enable = true;
    entries = [ nvibrantAutostart ];
  };

  # Systemd user services
  systemd.user.services = {
    swww-daemon = {
      Unit = {
        Description = "SWWW Daemon";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    clipse = {
      Unit = {
        Description = "Clipse Clipboard Manager";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.clipse}/bin/clipse -listen";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wl-clip-persist = {
      Unit = {
        Description = "Wayland Clipboard Persistence";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    udiskie = {
      Unit = {
        Description = "UDiskie Daemon";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.udiskie}/bin/udiskie";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

}