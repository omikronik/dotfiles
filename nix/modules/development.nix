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

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      openssl
      curl
      wget
      SDL2
      sdl3
    ];
  };

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
    pciutils
    # JS
    nodejs_24
    bun
    eslint
    prettierd
    # Lua
    lua
    lua-language-server
    # Rust
    cargo
    rust-analyzer
    rustc
    rustfmt
    # Odin
    odin
    ols
  ];
}
