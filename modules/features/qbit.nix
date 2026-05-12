{
  flake.nixosModules.qbit = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.qbittorrent-enhanced
    ];

    # persistance.cache.directories = [
    #   ".config/GIMP"
    # ];
  };
}
