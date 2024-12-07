{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { inherit system; };
      system = "x86_64-linux";
      app = "app";

      nativeBuildInputs = with pkgs; [ ];
      buildInputs = with pkgs; [ ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ ];
        packages = [ pkgs.zig ];

        shellHook = ''
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}"
        '';
      };

      packages.${system} = {
        default = self.packages.${system}.${app};
        ${app} = pkgs.stdenv.mkDerivation {
          pname = app;
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = [ pkgs.zig.hook ] ++ nativeBuildInputs;
          inherit buildInputs;

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
