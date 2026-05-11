{
  flake.nixosModules.anki = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.anki
    ];

    # persistance.cache.directories = [
    #   ".config/GIMP"
    # ];
  };
}
