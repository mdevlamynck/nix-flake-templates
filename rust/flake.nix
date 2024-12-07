{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import rust-overlay) ];
      };
      system = "x86_64-linux";
      app = "app";

      rust = pkgs.rust-bin.nightly.latest.default.override {
        extensions = [
          "rust-src"
          "rust-analyzer"
        ];
      };
      rustPlatform = pkgs.makeRustPlatform {
        cargo = rust;
        rustc = rust;
      };

      nativeBuildInputs = with pkgs; [
        clang
        mold
      ];
      buildInputs = with pkgs; [ cargo-nextest ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ self.packages.${system}.default ];
        packages = [ ];

        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}"
          ln -fsT ${rust} ./.direnv/rust
        '';
      };

      packages.${system} = {
        default = self.packages.${system}.${app};
        ${app} = rustPlatform.buildRustPackage {
          pname = app;
          version = "0.1.0";

          src = ./.;
          cargoSha256 = "";

          inherit nativeBuildInputs buildInputs;

          postFixup = ''
            patchelf $out/bin/${app} --add-rpath ${pkgs.lib.makeLibraryPath buildInputs}
          '';
        };
      };

      apps.${system} = {
        default = self.apps.${system}.${app};
        ${app} = {
          type = "app";
          program = "${self.packages.${system}.${app}}/bin/${app}";
        };
      };

      checks.${system}.build = self.packages.${system}.${app};
    };
}
