{
  pkgs,
  self,
  user,
  ...
}:
{
  environment.systemPackages = [
    pkgs.brave
    pkgs.infisical
    pkgs.nodejs
    pkgs.pnpm
  ];

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@admin" ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # Keep build inputs of live outputs so GC doesn't wipe direnv shells.
      keep-outputs = true;
      keep-derivations = true;
    };

    # Garbage-collect old generations every Sunday at 03:00, keeping the last 30 days.
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 3;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    # Hard-link identical files in /nix/store to save space.
    optimise.automatic = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

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
        # Tab moves focus between all controls in dialogs.
        AppleKeyboardUIMode = 3;
        NSAutomaticCapitalizationEnabled = false;
      };
      screencapture.target = "clipboard";
      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
        TrackpadRightClick = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    primaryUser = user;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };
}
