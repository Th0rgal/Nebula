with import <nixpkgs> {};

let
  nebulapy = python3.withPackages (python-packages: with python-packages; [
    pkg-config (callPackage ./binancepy.nix { }) aioconsole aiohttp cython toml
  ]);
in
    stdenv.mkDerivation {
        name = "nebula-dev-environment";
        buildInputs = [ nebulapy ];
    }