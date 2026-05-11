{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.mainConfiguration = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.mainHardware
      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.discord
      self.nixosModules.gimp
      self.nixosModules.anki
      self.nixosModules.telegram

      self.nixosModules.gaming
    ];

    programs.corectrl.enable = true;

    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      supportedFilesystems.ntfs = true;

      # kernelParams = ["quiet" "amd_pstate=guided" "processor.max_cstate=1"];
      kernelModules = ["mt7921e" "coretemp" "cpuid" "v4l2loopback"];

      binfmt.emulatedSystems = ["aarch64-linux"];
    };

    networking = {
      hostName = "main";
      networkmanager.enable = true;
    };

    virtualisation.libvirtd.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    hardware.cpu.amd.updateMicrocode = true;

    services = {
      hardware.openrgb.enable = true;
      flatpak.enable = true;
      udisks2.enable = true;
      printing.enable = true;
    };

    programs.alvr.enable = true;
    programs.alvr.openFirewall = true;

    environment.systemPackages = with pkgs; [
      winetricks
      glib

      inputs.nix-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim
      ntfs3g
    ];

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdg.portal.enable = true;

    programs.niri.enable = true;

    networking.firewall.enable = false;
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-move-transition
      ];
    };
    # persistance.cache.directories = [
    #   ".config/obs-studio"
    # ];

    networking.firewall.allowedUDPPorts = [34585];

    system.stateVersion = "25.11";

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.kernelModules = [
      "nvidia"
      "i915"
      "nvidia_modeset"
      "nvidia_drm"
    ];
    boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    boot.kernelParams = [
      "quiet"
      "ibt=off"
    ];
    hardware.graphics = {
      enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = false;

      powerManagement.finegrained = false;

      open = true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    fileSystems."/home/charly/Media" = {
      device = "/dev/disk/by-uuid/F200BF5C00BF270F";
      fsType = "ntfs-3g";
      options = [
        "rw"
        "uid=1000" # Maps ownership to your primary user
        "gid=100" # Maps to the 'users' group
        "umask=0022" # Standard folder/file permissions
        "nofail" # Prevents boot hang if the drive is disconnected
      ];
    };
  };
}
