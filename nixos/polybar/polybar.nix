{ pkgs }:
let 
  colors = import ../colors.nix;
  
  polybar-config = 
    import ./polybar-conf.nix{ inherit colors; };

  polybar-config-file =
    pkgs.writeTextFile {
      name="polybar-confs"; 
      text=polybar-config;
    };

in

  pkgs.writeScript
  "svarog-polybar"
''${pkgs.polybar}/bin/polybar -c ${polybar-config-file} mybar $@''
