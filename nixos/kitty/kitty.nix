{pkgs}:
let 
  colors = import ../colors.nix;
  
  kitty-config = 
    import ./kitty-conf.nix{ inherit pkgs colors; };

  kitty-config-file =
    pkgs.writeTextFile {
      name="kitty-conf"; 
      text=kitty-config;
    };

in

  pkgs.writeScript
  "nixos-kitty"
''${pkgs.kitty}/bin/kitty -c ${kitty-config-file} $@''
