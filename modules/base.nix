{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bash
    fish
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  system.stateVersion = "25.05";
}
