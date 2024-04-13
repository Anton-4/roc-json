{
  description = "json package devShell flake";

  inputs = {
    roc.url = "github:faldor20/roc/3fef8b9f82acb70c7fb8b142e886ac5dd4495fe6";
    nixpkgs.follows = "roc/nixpkgs";

    # to easily make configs for multiple architectures
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, roc }:
    let supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    in flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        rocPkgs = roc.packages.${system};

        linuxInputs = with pkgs;
          lib.optionals stdenv.isLinux [
          ];

        darwinInputs = with pkgs;
          lib.optionals stdenv.isDarwin
          (with pkgs.darwin.apple_sdk.frameworks; [
          ]);

        sharedInputs = (with pkgs; [
          expect
          rocPkgs.cli
        ]);
      in {

        devShell = pkgs.mkShell {
          buildInputs = sharedInputs ++ darwinInputs ++ linuxInputs;
        };

        formatter = pkgs.nixpkgs-fmt;
      });
}
