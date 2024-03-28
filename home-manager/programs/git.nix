{ config, lib, pkgs, ... }:

{
  
  options = {
    git.enable = 
      lib.mkEnableOption "Enables and configure git";
    git.userName = 
      lib.mkOption {
        description = ''
          git username
        '';
      };
    git.userEmail = 
      lib.mkOption {
        description = ''
          git email
        '';
      };
  };

  config = lib.mkIf config.git.enable {

    programs.git = {
      enable = true;
      userName  = "Fausto Jáquez";
      userEmail = "Faustojr03@gmail.com";
      aliases = {
        a = "add";
        ci = "commit";
        co = "checkout";
        l = "log --oneline";  
        s = "status";
        st = "stash";
      };
    };

  };

}