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

  environment.localBinInPath = true;

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    randomizedDelaySec = "45min";
    flake = "/home/nixos/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
    ];
    allowReboot = false;
  };

  system.stateVersion = "25.05";
}
