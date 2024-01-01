 
#Home manager

home-manager.users.${user} = { pkgs, ... }: {
 home.stateVersion = "23.11";
nixpkgs.config.allowUnfree = true;
 home.packages = [ 
 pkgs.helix
 pkgs.tree
pkgs.nodePackages_latest.neovim
 pkgs.tree-sitter


   ];
  
programs.vscode = {
  enable = true;
  extensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    vscodevim.vim
jnoortheen.nix-ide
bbenoist.nix
    yzhang.markdown-all-in-one
  ];
};
};
programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set undofile
        set undodir=~/.vim/undodir
      '';
      packages.nix.start = with pkgs.vimPlugins; [  nvim-treesitter.withAllGrammars ];
    };

  };


 
