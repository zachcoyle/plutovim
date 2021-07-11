{
  description = "";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
    devshell.url = github:numtide/devshell;
    neovim.url = github:neovim/neovim?dir=contrib;
    vim-plugins-overlay.url = github:vi-tality/vim-plugins-overlay;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , devshell
    , neovim
    , vim-plugins-overlay
    }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlay
          neovim.overlay
          vim-plugins-overlay.overlay
        ];
      };

      plutovim = import ./default.nix { inherit pkgs; };

    in
    rec {
      packages = {
        neovim = pkgs.neovim;
        plutovim = plutovim.plutovim;
        init-vim = pkgs.writeText "init.vim" plutovim.init-vim;
      };

      defaultPackage = packages.plutovim;

      devShell = pkgs.devshell.mkShell {
        packages = with pkgs; [ ];
      };

    });
}
