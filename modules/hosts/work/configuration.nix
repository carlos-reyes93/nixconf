{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.workConfiguration = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      inputs.nixos-wsl.nixosModules.default
    ];

    wsl.enable = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    wsl.defaultUser = "charly";
    wsl.wslConf.user.default = lib.mkDefault "charly";
    networking.hostName = "work";

    system.stateVersion = "25.05";
    environment.systemPackages = [
      self.packages.${pkgs.system}.environment
    ];
  };
}
