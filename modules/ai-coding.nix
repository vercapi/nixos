{ pkgs, copilot-cli, ... }:

{
  environment.systemPackages = [
    pkgs.nodejs_24
    copilot-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.copilot-language-server
    pkgs.claude-code
    (let
      version = "0.33.0";
      assets = {
        x86_64-linux = {
          file = "microsoft-azd-waza-linux-amd64.tar.gz";
          hash = "sha256-KAYS1N6stW8QjFi8BlEDzONbD30RdZh+B+6hjtoo/+U=";
          binary = "microsoft-azd-waza-linux-amd64";
        };
        aarch64-linux = {
          file = "microsoft-azd-waza-linux-arm64.tar.gz";
          hash = "sha256-V56UW6wH9SkqSdZ6/4Cw89Tt8/n9Ij4g5U9QGn/f1lQ=";
          binary = "microsoft-azd-waza-linux-arm64";
        };
      };
      asset =
        assets.${pkgs.stdenv.hostPlatform.system}
          or (throw "waza is only packaged for x86_64-linux and aarch64-linux");
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "waza";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://github.com/microsoft/waza/releases/download/azd-ext-microsoft-azd-waza_${version}/${asset.file}";
        hash = asset.hash;
      };
      sourceRoot = ".";
      installPhase = ''
        runHook preInstall
        install -Dm755 "${asset.binary}" "$out/bin/waza"
        runHook postInstall
      '';
      meta = with pkgs.lib; {
        description = "CLI for evaluating AI agent skills";
        homepage = "https://github.com/microsoft/waza";
        license = licenses.mit;
        mainProgram = "waza";
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };
    })
  ];
}
