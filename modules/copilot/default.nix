{ lib, stdenv, fetchurl, buildFHSEnv, glibc, writeShellScript }:

let
  version = "0.0.406";
  sha256 = "0n0346k7kmf5a71kkys9nv0s33vcxj7x82z1zcpx60rr8h8yvw4k";

  copilot-unwrapped = stdenv.mkDerivation {
    pname = "copilot-cli-unwrapped";
    inherit version;
    src = fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/copilot-linux-x64.tar.gz";
      inherit sha256;
    };
    sourceRoot = ".";
    dontBuild = true;
    dontStrip = true;    # strip corrupts this binary
    dontPatchELF = true;
    installPhase = ''
      install -Dm755 copilot $out/bin/copilot
    '';
  };
in
buildFHSEnv {
  name = "copilot";
  targetPkgs = pkgs: with pkgs; [
    stdenv.cc.cc.lib
    glibc
  ];
  runScript = writeShellScript "copilot-wrapper" ''
    exec ${copilot-unwrapped}/bin/copilot --no-auto-update "$@"
  '';
  meta = with lib; {
    description = "GitHub Copilot CLI";
    homepage = "https://github.com/github/copilot-cli";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
