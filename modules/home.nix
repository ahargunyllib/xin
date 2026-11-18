{ user, ... }:
{
  home = {
    username = user;
    homeDirectory = "/Users/${user}";
    file.".config/ghostty".source = ./home-manager/ghostty;
    stateVersion = "26.05";
  };

  programs = {
    # atuin owns Ctrl-R, so fzf's history widget is turned off below.
    atuin = {
      enable = true;
      enableZshIntegration = true;
    };
    btop.enable = true;
    bun.enable = true;
    claude-code.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    fastfetch.enable = true;
    fd.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
      historyWidget.command = "";
    };
    gh.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          email = "ahargunyllib@gmail.com";
          name = user;
        };
        init.defaultBranch = "main";
      };
    };
    home-manager.enable = true;
    lazygit.enable = true;
    neovim = {
      enable = true;
      withNodeJs = true;
    };
    ripgrep.enable = true;
    tmux.enable = true;
    vscode.enable = true;
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        dr = "sudo darwin-rebuild switch --flake ~/xin#main";
        ssh = "TERM=xterm-256color ssh";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "1password"
          "aws"
          "docker"
          "docker-compose"
          "gh"
          "git"
          "sudo"
        ];
        theme = "robbyrussell";
      };
    };
  };
}
