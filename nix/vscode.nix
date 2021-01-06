{ pkgs }:
let
  extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "lean";
      publisher = "jroesch";
      version = "0.16.20";
      sha256 = "1gad16aa097zzdyvvy8sr07bvqlgjnl0bq96s973im3fvpav58w2";
    }
  ];
in
{
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
}
