{ inputs, lib, self, ... }: {
  # Wrapped neovim definition, reusable across NixOS and home-manager.
  # Lua config stays in ~/.config/nvim (managed by chezmoi).
  # This replaces mason for tool management — LSPs and formatters are on PATH via nix.
  flake.nvimWrapper = {
    config,
    wlib,
    pkgs,
    ...
  }: {
    imports = [ wlib.wrapperModules.neovim ];

    # Use standard ~/.config/nvim — not managed by nix
    settings.config_directory = lib.generators.mkLuaInline "vim.fn.stdpath('config')";
    settings.block_normal_config = false;

    # LSPs, formatters, and tools on PATH for the wrapped neovim
    extraPackages = with pkgs; [
      # lua
      lua-language-server
      stylua

      # nix
      nil
      nixd
      alejandra

      # bash
      bash-language-server
      shellcheck

      # c/c++
      clang-tools

      # go
      gopls

      # python
      pyright

      # markdown
      marksman
      markdownlint-cli

      # misc
      tree-sitter
    ];

    # Treesitter grammars provided by nix
    specs.treesitter = {
      data = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
    };
  };

  perSystem = { pkgs, ... }: {
    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [ self.nvimWrapper ];
    };
  };
}
