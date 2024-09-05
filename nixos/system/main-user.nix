{ config, lib, pkgs, ... }:

{
  
  options = {
    main-user.enable =
      lib.mkEnableOption "Enables main user";
    main-user.userName = lib.mkOption {
      default = "faustrox";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf config.main-user.enable {

    hardware.i2c.enable = true;

    # Set up user
    users.users.${config.main-user.userName} = {
      isNormalUser = true;
      description = config.main-user.userName;
      extraGroups = [ "networkmanager" "wheel" "audio" "i2c" "kvm" "adbusers" "gamemode" ];
      shell = pkgs.zsh;
    };

    # Enable automatic login for the user.
    services.displayManager.autoLogin = {
      enable = true;
      user = config.main-user.userName;
    };

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
    };

    environment.systemPackages = with pkgs; [
      proton-pass
    ];

    nix.settings.trusted-users = [ config.main-user.userName ];

    overlays.proton-pass.update = true;

  };

}