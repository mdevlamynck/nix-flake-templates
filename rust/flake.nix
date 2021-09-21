{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust deps
            (rust-bin.nightly.latest.default.override { extensions = [ "rust-src" ]; })

            # Fast Compile deps
            clang
          ];

          APPEND_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          ];

          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$APPEND_LIBRARY_PATH"
          '';
        };
      }
    );
}
