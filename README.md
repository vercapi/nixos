# nixos

Flake-based NixOS-WSL configuration.

## Usage

- Regenerate Nix files from the Org source: `./scripts/tangle-config.sh`
- Evaluate the flake: `nix --extra-experimental-features 'nix-command flakes' flake show path:$PWD`
- Build the system without switching: `nix --extra-experimental-features 'nix-command flakes' build --no-link path:$PWD#nixosConfigurations.nixos.config.system.build.toplevel`
- Test-activate it: `sudo nixos-rebuild test --flake .#nixos`
- Apply it: `sudo nixos-rebuild switch --flake .#nixos`

Edit flow: update `config.org`, run `./scripts/tangle-config.sh`, then run the Nix validation/build/rebuild commands.

## Layout

- `config.org` is the canonical literate source for all generated Nix files
- `scripts/tangle-config.sh` tangles `config.org` into repository files
- `flake.nix` pins inputs and defines `nixosConfigurations.nixos`
- `hosts/nixos/default.nix` is the host entrypoint
- `modules/base.nix` contains shared system defaults like Nix settings, unfree allowance, shell defaults, and `system.stateVersion`
- `modules/wsl.nix` contains WSL-specific behavior
- `modules/development.nix` contains general development tooling
- `modules/copilot.nix` contains Copilot-specific tooling and its Node.js runtime
- `modules/emacs.nix` contains the Emacs-centric toolchain, including the native dependencies needed for Emacs-managed `vterm`, dictionaries, Python, and fonts
