{pkgs}:
let 
  colors = import ../colors.nix;
  
  dunst-config = 
    import ./dunst-conf.nix{ inherit pkgs colors; };

  dunst-config-file =
    pkgs.writeTextFile {
      name="dunstrc"; 
      text=dunst-config;
    };

in

  pkgs.writeScript
  "nixos-dunst"
''${pkgs.dunst}/bin/dunst -conf ${dunst-config-file} $@''
