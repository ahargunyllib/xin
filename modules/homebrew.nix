{
  config,
  homebrew-core,
  homebrew-cask,
  user,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    # Also install an Intel Homebrew under Rosetta 2.
    enableRosetta = true;
    inherit user;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
    # Taps come only from flake.lock; `brew tap` is disabled.
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [ "mas" ];
    casks = [
      "arc"
      "beekeeper-studio"
      "bruno"
      "ghostty"
      "orbstack"
      "raycast"
      "spotify"
      "steam"
      "zoom"
    ];
    onActivation = {
      # Removes (and zaps the data of) anything not listed above.
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
