# nixos

Flake-based NixOS-WSL configuration.

## Usage

- Evaluate the flake: `nix --extra-experimental-features 'nix-command flakes' flake show path:$PWD`
- Build the system without switching: `nix --extra-experimental-features 'nix-command flakes' build --no-link path:$PWD#nixosConfigurations.nixos.config.system.build.toplevel`
- Test-activate it: `sudo nixos-rebuild test --flake .#nixos`
- Apply it: `sudo nixos-rebuild switch --flake .#nixos`

## Layout

- `flake.nix` pins inputs and defines `nixosConfigurations.nixos`
- `hosts/nixos/default.nix` is the host entrypoint
- `modules/base.nix` contains shared system defaults like Nix settings, unfree allowance, shell defaults, and `system.stateVersion`
- `modules/wsl.nix` contains WSL-specific behavior
- `modules/development.nix` contains general development tooling
- `modules/copilot.nix` contains Copilot-specific tooling and its Node.js runtime
- `modules/emacs.nix` contains the Emacs-centric toolchain, dictionaries, Python, and fonts
