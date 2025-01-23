{ config, lib, pkgs, ... }:

{
  
  options = {
    main-user.enable =
      lib.mkEnableOption "Enables main user";
    main-user.username = lib.mkOption {
      default = "faustrox";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf config.main-user.enable {

    hardware.i2c.enable = true;

    security.sudo.extraRules = [
      { 
        users = [ config.main-user.username ];
        commands = [
          {
            command = "/root/scripts/*";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    # Set up user
    users.users.${config.main-user.username} = {
      isNormalUser = true;
      description = config.main-user.username;
      extraGroups = [ "networkmanager" "wheel" "audio" "i2c" "kvm" "adbusers" "firejail" ];
      shell = pkgs.zsh;
    };

    services.getty.autologinUser = config.main-user.username;

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
    };

    console.earlySetup = true;
    catppuccin.tty = {
      enable = false;
      flavor = "mocha";
    };

    nix.settings.trusted-users = [ config.main-user.username ];

  };

}
