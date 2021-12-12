{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };

      system = "x86_64-linux";
      app = "app";

      shellInputs = with pkgs; [
        (rust-bin.nightly.latest.default.override { extensions = [ "rust-src" ]; })
        clang
      ];
      appNativeBuildInputs = with pkgs; [
        pkg-config
      ];
      appBuildInputs = appRuntimeInputs ++ (with pkgs; [
        cairo gdk-pixbuf glib graphene gtk4 libadwaita pango
      ]);
      appRuntimeInputs = with pkgs; [
      ];
    in
    {
      devShells.${system}.${app} = pkgs.mkShell {
        nativeBuildInputs = appNativeBuildInputs;
        buildInputs = shellInputs ++ appBuildInputs;

        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath appRuntimeInputs}"
        '';
      };
      devShell.${system} = self.devShells.${system}.${app};

      packages.${system}.${app} = pkgs.rustPlatform.buildRustPackage {
        pname = app;
        version = "0.1.0";

        src = ./.;
        cargoSha256 = pkgs.lib.fakeSha256;#"sha256-lzs+8qAsBJ/ms/OppxnKfJChV9+xM0W/QRZGPn+9uv4=";

        nativeBuildInputs = appNativeBuildInputs;
        buildInputs = appBuildInputs;
      };
      defaultPackage.${system} = self.packages.${system}.${app};

      apps.${system}.${app} = {
        type = "app";
        program = "${self.packages.${system}.${app}}/bin/${app}";
      };
      defaultApp.${system} = self.apps.${system}.${app};

      checks.${system}.build = self.packages.${system}.${app};
    };
}
