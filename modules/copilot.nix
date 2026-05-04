{ pkgs, copilot-cli, ... }:

{
  environment.systemPackages = [
    pkgs.nodejs_24
    copilot-cli.packages.${pkgs.system}.default
  ];
}
