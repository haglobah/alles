{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
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
        devshells.default = {
          env = [
            { name = "YDOTOOL_SOCKET"; value = "/tmp/.ydotool_socket"; } 
          ];
          packages = [
            pkgs.racket
            pkgs.ydotool
            pkgs.fontconfig.lib
          ];
          devshell.startup = {
            setup-langserver.text = ''raco pkg install --auto --skip-installed racket-langserver'';
          };
          commands = [
            { name = "ra"; command = "racket src/alles.rkt"; help = "Runs the 'alles.rkt' program."; }
          ];
        };
      };
      flake = 
      let 
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.x86_64-linux.default = (import ./alles.nix { inherit pkgs; });
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
