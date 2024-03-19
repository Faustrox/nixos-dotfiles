{ config, pkgs, ... }:

{

  config.programs.git = {
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

}