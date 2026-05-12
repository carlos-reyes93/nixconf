{
  lib,
  inputs,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    # My whole desktop in one package, includes kityy terminal
    packages.desktop = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrappersModules.niri];
      terminal = lib.getExe self'.packages.terminal;
      env = {
        EDITOR = lib.getExe self'.packages.neovim;
      };
    };

    # My primary flake terminal
    packages.terminal =
      (inputs.wrappers.wrapperModules.kitty.apply {
        inherit pkgs;
        imports = [self.wrappersModules.kitty];
        shell = lib.getExe self'.packages.environment;
      }).wrapper;

    # My primary flake shell with all of it's packages
    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        # nix
        pkgs.nil
        pkgs.nixd
        pkgs.statix
        pkgs.alejandra
        pkgs.manix
        pkgs.nix-inspect
        self'.packages.nh

        # other
        pkgs.file
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.killall
        pkgs.sshfs
        pkgs.fzf
        pkgs.htop
        pkgs.btop
        pkgs.eza
        pkgs.fd
        pkgs.zoxide
        pkgs.dust
        pkgs.ripgrep
        pkgs.fastfetch
        pkgs.tree-sitter
        pkgs.imagemagick
        pkgs.imv
        pkgs.ffmpeg-full
        pkgs.yt-dlp
        pkgs.lazygit

        # go
        pkgs.go
        pkgs.gopls
        pkgs.golangci-lint
        pkgs.gosec
        pkgs.goreleaser

        # python
        pkgs.python3
        pkgs.python3Packages.python-lsp-server
        pkgs.python3Packages.python-lsp-ruff
        pkgs.uv

        # Rust
        pkgs.cargo
        pkgs.rustc
        pkgs.clippy
        pkgs.rustfmt
        pkgs.rust-analyzer

        pkgs.azure-cli

        #dev tools
        pkgs.devenv
        pkgs.httpie
        pkgs.pre-commit
        pkgs.just
        pkgs.bats
        pkgs.powershell
        pkgs.act
        pkgs.bun
        pkgs.jujutsu
        pkgs.jjui
        pkgs.nodejs_22
        (pkgs.pnpm.override { nodejs = pkgs.nodejs_22; })

        # wrapped
        self'.packages.tmux
        self'.packages.neovim
        self'.packages.lf
        self'.packages.git
        # self'.packages.jujutsu
        # self'.packages.jjui
        self'.packages.nix-check-bin
      ];
      # env = {
      #   EDITOR = lib.getExe self'.packages.neovimDynamic;
      # };
    };

    packages.nix-check-bin = pkgs.writeShellApplication {
      name = "nix-check-bin";
      text = ''
        $EDITOR "$(nix build "$1" --no-link --print-out-paths)/bin"
      '';
    };
  };
}
