{ buildFHSEnv, stdenv, glibc, homeDir }:

buildFHSEnv {
  name = "copilot";
  targetPkgs = pkgs: [ pkgs.stdenv.cc.cc.lib pkgs.glibc ];
  runScript = "${homeDir}/.local/bin/copilot";
}
