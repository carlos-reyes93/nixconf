{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences.monitors = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          width = lib.mkOption {
            type = lib.types.int;
            example = 2560;
          };
          height = lib.mkOption {
            type = lib.types.int;
            example = 1440;
          };
          refreshRate = lib.mkOption {
            type = lib.types.float;
            default = 144;
          };
          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      });
      default = {};
    };
  };
}
