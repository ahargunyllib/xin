{
  description = "ahargunyllib's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, home-manager }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages =
        [
          pkgs.brave

          pkgs.infisical

          pkgs.nodejs
          pkgs.pnpm
        ];

      homebrew = {
        enable = true;
        brews = [
          "mas"
        ];
        casks = [
          "ghostty"
          "spotify"
          "raycast"
          "arc"
          "steam"
          "orbstack"
          "beekeeper-studio"
          "zoom"
          "bruno"
        ];
        masApps = {
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
	      pkgs.nerd-fonts.jetbrains-mono
      ];

      nix.settings.experimental-features = "nix-command flakes";

      # Auto garbage-collect generasi lama tiap Minggu 03:00, simpan yang < 30 hari.
      nix.gc = {
        automatic = true;
        interval = { Weekday = 0; Hour = 3; Minute = 0; };
        options = "--delete-older-than 30d";
      };

      # Auto hardlink file identik di /nix/store (dedup, hemat ruang).
      nix.optimise.automatic = true;

      nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = "aarch64-darwin";
      };

      programs = {
      };

      system = {
        # https://github.com/nix-darwin/nix-darwin/issues/786
        activationScripts.extraActivation.text = ''
          softwareupdate --install-rosetta --agree-to-license
        '';

        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;

        defaults = {
          controlcenter = {
            AirDrop = false;
            BatteryShowPercentage = true;
            Bluetooth = false;
            Display = false;
            FocusModes = false;
            NowPlaying = true;
            Sound = false;
          };
          dock = {
            autohide = true;
            mru-spaces = false;
            persistent-apps = [
              "/Applications/Arc.app"
              "/Applications/WhatsApp.app"
              "/Applications/Spotify.app"
              "/Applications/Ghostty.app"
            ];
            showhidden = true;
            wvous-br-corner = 4;
            wvous-bl-corner = 13;
          };
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXEnableExtensionChangeWarning = false;
            FXPreferredViewStyle = "Nlsv";
            NewWindowTarget = "Other";
            NewWindowTargetPath = "~";
            QuitMenuItem = true;
          };
          loginwindow.GuestEnabled = false;
          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            NSAutomaticCapitalizationEnabled = false;
          };
          screencapture = {
            target = "clipboard";
          };
          trackpad = {
            ActuationStrength = 0;
            Clicking = true;
            TrackpadRightClick = true;
          };
        };

        primaryUser = "ahargunyllib";

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 6;
      };

      users.users.ahargunyllib = {
        name = "ahargunyllib";
        home = "/Users/ahargunyllib";
      };
    };
    home-configuration = { pkgs, ... }: {
      home = {
        username = "ahargunyllib";
        homeDirectory = "/Users/ahargunyllib";
        file = {
          ".config/ghostty".source = ./modules/home-manager/ghostty;
        };
        sessionVariables = { };
        stateVersion = "26.05";
      };

      programs = {
        atuin = {
          enable = true;
          enableZshIntegration = true;
        };
        btop = {
          enable = true;
        };
        bun = {
          enable = true;
        };
        claude-code = {
          enable = true;
        };
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
        eza = {
          enable = true;
          enableZshIntegration = true;
        };
        fastfetch = {
          enable = true;
        };
        fd = {
            enable = true;
        };
        gh = {
          enable = true;
        };
        git = {
          enable = true;
          settings = {
            user = {
              email = "billy.bpm03@gmail.com";
              name = "ahargunyllib";
            };
            init.defaultBranch = "main";
          };
        };
        fzf = {
          enable = true;
          enableZshIntegration = true;
          historyWidget.command = "";
        };
        home-manager = {
          enable = true;
        };
        lazygit = {
          enable = true;
        };
        neovim = {
          enable = true;
          withNodeJs = true;
        };
        ripgrep = {
          enable = true;
        };
        tmux = {
          enable = true;
        };
        vscode = {
          enable = true;
        };
        yazi = {
          enable = true;
          enableZshIntegration = true;
        };
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
        zsh = {
          autosuggestion = {
            enable = true;
          };
          enable = true;
          shellAliases = {
            dr = "sudo darwin-rebuild switch --flake ~/xin#main";
            ssh = "TERM=xterm-256color ssh";
            cd = "z";
          };
          syntaxHighlighting = {
            enable = true;
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
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#main
    darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
      modules = [
      	configuration
	      nix-homebrew.darwinModules.nix-homebrew
	      {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = "ahargunyllib";

	                # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
	      # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ahargunyllib = home-configuration;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
