{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          lean = import ./nix/lean.nix { inherit pkgs; };
        in
        {
          devShell = pkgs.stdenv.mkDerivation {
            buildInputs = [ lean ];
            shellHook = "";
          };
        }
      );
}
