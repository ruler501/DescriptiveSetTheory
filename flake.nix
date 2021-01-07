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
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          vscode = import ./nix/vscode.nix { inherit pkgs; };
          lean = import ./nix/lean.nix { inherit pkgs; };
          name = "DescriptiveSetTheory";
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = [ lean vscode pkgs.mathlibtools ];
            shellHook = "";
          };
        }
      );
}
