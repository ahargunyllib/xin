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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
      git-hooks,
      ...
    }:
    let
      system = "aarch64-darwin";
      user = "ahargunyllib";
      pkgs = nixpkgs.legacyPackages.${system};

      # statix, deadnix and nixfmt: run on `git commit` and by `nix flake check`.
      pre-commit = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          deadnix.enable = true;
          nixfmt.enable = true;
          statix.enable = true;
        };
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      checks.${system}.pre-commit = pre-commit;

      # `nix develop` installs the git hooks and provides the tools.
      devShells.${system}.default = pkgs.mkShell {
        inherit (pre-commit) shellHook;
        packages = pre-commit.enabledPackages;
      };

      # Build: darwin-rebuild build --flake .#main
      darwinConfigurations.main = nix-darwin.lib.darwinSystem {
        specialArgs = inputs // {
          inherit user;
        };
        modules = [
          ./modules/darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/homebrew.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit user; };
              users.${user} = ./modules/home.nix;
            };
          }
        ];
      };
    };
}
