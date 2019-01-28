{ config, ... } :
{
  config.packageOverrides = pkgs: {
    miraclecast = pkgs.miraclecast.override { mesonFlags = [
    "-Drely-udev=true"
    "-Dbuild-tests=true"
      ]; 
    };
  };
}
