{
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
  in {
    packages.neovim = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = inputs.nix-nvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim;
    };
  };
}
