{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.default = pkgs.stdenv.mkDerivation {
          name = "alles";
          src = ./src;

          buildInputs = [
            pkgs.racket
          ];

          nativeBuildInputs = [
            pkgs.makeWrapper
            pkgs.autoPatchelfHook
            pkgs.ncurses
            pkgs.zlib
            pkgs.libgcc
          ];

          buildPhase = ''
            raco exe --gui alles.rkt
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp ./alles $out/bin
          '';

          postFixup = ''
            wrapProgram $out/bin/alles \
              --prefix LD_LIBRARY_PATH : ${with pkgs; lib.makeLibraryPath [
                  cairo
                  fontconfig
                  glib
                  gmp
                  gtk3
                  gsettings-desktop-schemas
                  libedit
                  libjpeg
                  libpng
                  mpfr
                  ncurses
                  openssl
                  pango
                  poppler
                  readline
                  sqlite
                ]}
          '';
        };
        # devshells.default = {
        #   env = [
        #     { name = "YDOTOOL_SOCKET"; value = "/tmp/.ydotool_socket"; } 
        #   ];
        #   packages = [
        #     pkgs.racket
        #     pkgs.ydotool
        #     pkgs.fontconfig.lib
        #   ];
        #   commands = [];
        # };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
