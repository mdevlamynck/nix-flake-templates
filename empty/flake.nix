{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        inherit system;
      };

      system = "x86_64-linux";
      app = "app";

      shellInputs = with pkgs; [
      ];
      appNativeBuildInputs = with pkgs; [
      ];
      appBuildInputs = appRuntimeInputs ++ (with pkgs; [
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
    };
}
