{
  flake.nixosModules.mpv = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.mpv
    ];

    # persistance.cache.directories = [
    #   ".config/GIMP"
    # ];
  };
}
