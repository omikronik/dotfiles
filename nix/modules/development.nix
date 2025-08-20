# Dev related stuff in here
{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;

    config = {
      user = {
        name = "omikronik";
        email = "yasirceltik9@gmail.com";
      };
      init.defaultBranch = "main";
      credential.helper = "store";
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  programs.fish.enable = true;
  users.users.yasir.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    # THE all time classics
    vim
    neovim
    ripgrep
    fzf
    tmux
    lazygit
    git-credential-manager

    # Compilers and whatnot
    gcc
    gnumake
    cmake
    pkg-config
    autoconf
    automake
    libtool
    binutils
    gdb
    linuxHeaders
    nodejs_24
    bun
    lua
    cargo
    rust-analyzer
    rustc
    rustfmt
    pciutils
  ];
}
