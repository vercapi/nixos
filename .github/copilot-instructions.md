# Copilot instructions for this repository

## Validation commands

- `nix --extra-experimental-features 'nix-command flakes' flake show path:$PWD` — confirm the flake evaluates and exposes the expected outputs.
- `nix --extra-experimental-features 'nix-command flakes' build --dry-run path:$PWD#nixosConfigurations.nixos.config.system.build.toplevel` — resolve the full system build without producing a result symlink.
- `nix --extra-experimental-features 'nix-command flakes' build --no-link path:$PWD#nixosConfigurations.nixos.config.system.build.toplevel` — build the configured system without switching to it.
- `sudo nixos-rebuild test --flake .#nixos` — build and activate temporarily for end-to-end validation.
- `sudo nixos-rebuild switch --flake .#nixos` — apply the configuration after review.
- There is no repo-local lint script or unit/integration test runner. There is also no single-test entry point; validation is whole-system, so use `nix flake show` for fast evaluation and `nix build`/`nixos-rebuild` for full verification.

## High-level architecture

- `flake.nix` is the repo entrypoint. It pins `nixpkgs`, `nixos-wsl`, and `copilot-cli`, then exposes a single host at `nixosConfigurations.nixos`.
- The flake builds the system with `nixpkgs.lib.nixosSystem` and imports the upstream WSL module from `nixos-wsl.nixosModules.default`.
- `hosts/nixos/default.nix` is the host entrypoint. It assembles the system from focused modules instead of defining everything inline.
- The reusable settings live under `modules/` and are grouped by function: `base.nix`, `wsl.nix`, `development.nix`, `copilot.nix`, and `emacs.nix`.
- `modules/copilot.nix` consumes the Copilot CLI from the flake input via `copilot-cli.packages.${pkgs.system}.default` rather than rebuilding it from an inline fetch.
- `modules/emacs.nix` is intentionally broader than just the editor package: it also carries the native dependencies needed for Emacs-managed `vterm`, plus Python, dictionaries, and fonts used for that workflow.

## Key conventions

- Keep the repo flake-first: new system wiring belongs in `flake.nix`, while option definitions belong in host/modules under `hosts/` and `modules/`.
- Group modules by user-facing function rather than by option type. Extend `development.nix`, `copilot.nix`, or `emacs.nix` before creating technical slices like `packages.nix` or `fonts.nix`.
- Add packages to the functional module they support. Prefer consuming flake inputs directly from `packages.${pkgs.system}` when an upstream flake already exposes the package.
- Emacs packages themselves are expected to be managed inside Emacs; `modules/emacs.nix` should provide editor support tooling and native dependencies rather than Nix-managed Emacs extensions unless explicitly requested.
- Keep WSL-specific behavior in `modules/wsl.nix` rather than mixing it into package or shell modules.
- Keep host composition in `hosts/nixos/default.nix`; add new focused modules instead of growing one large host file.
- Preserve `system.stateVersion` unless the task is explicitly about a NixOS release migration.
- This config already sets `nixpkgs.config.allowUnfree = true`; prefer normal package references over ad hoc workarounds for unfree packages.
