# xin

My macOS config: nix-darwin + nix-homebrew + home-manager in one flake.

```bash
sudo darwin-rebuild switch --flake ~/xin#main   # apply (alias: dr)
nix fmt                                         # format
nix flake check                                 # lint (statix, deadnix) + format check
nix develop                                     # install the same checks as git commit hooks
```

Config lives in `modules/`: `darwin.nix` (system), `homebrew.nix` (apps), `home.nix` (dotfiles).

Homebrew cleanup is `zap`: removing a cask deletes the app and its data on the next rebuild.
