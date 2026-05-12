{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.work = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.workConfiguration];
  };
}
