{
  description = "Formalization of Kechris's Classical Descriptive Set Theory in Lean.";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          vscode = (import ./nix/vscode.nix { inherit pkgs; }).vscode;
          lean = import ./nix/lean.nix { inherit pkgs; };
          name = "DescriptiveSetTheory";
        in
        {
          devShell = pkgs.stdenv.mkDerivation {
            buildInputs = [ lean vscode pkgs.mathlibtools ];
            shellHook = "";
          };
        }
      );
}
