{ pkgs, useLua ? true }:
let
  vimLib = import ./lib.nix { inherit pkgs; };
  tmpConfig = "-- yeet";


  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    customRC =
      if useLua
      then vimLib.wrapLua tmpConfig
      else tmpConfig;

    plugins = with pkgs.vimPlugins; with pkgs.vitalityVimPlugins; [
      barbar-nvim
      { plugin = gruvbox-community; config = "colorscheme gruvbox"; optional = false; }
    ];

  };

in
{
  plutovim = pkgs.wrapNeovimUnstable pkgs.neovim neovimConfig;
  init-vim = neovimConfig.neovimRcContent;
}
