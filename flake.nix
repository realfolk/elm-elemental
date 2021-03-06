{
  description = "Packages and shells for developing Real Folk's Elemental project.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flakeUtils.url = "github:numtide/flake-utils";
    neovim.url = "github:realfolk/nix?dir=lib/packages/neovim";
    ranger.url = "github:realfolk/nix?dir=lib/packages/ranger";
    rnixLsp.url = "github:nix-community/rnix-lsp";
    elmPackages.url = "github:realfolk/nix?dir=lib/projects/elm/packages/elm-0.19";
    nodeInterpreter.url = "github:realfolk/nix?dir=lib/projects/node/interpreter/node-17";
    elmLibSrc = {
      url = "github:realfolk/elm-lib/83a65a2b9c8cd95aa4c5ef4d9532ec44bf0b0be3";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , flakeUtils
    , neovim
    , ranger
    , rnixLsp
    , elmPackages
    , nodeInterpreter
    , elmLibSrc
    , ...
    }:
    flakeUtils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages = {
        neovim = neovim.packages.${system}.default;
        ranger = ranger.packages.${system}.default;
        node = nodeInterpreter.packages.${system}.default;
        rnixLsp = rnixLsp.defaultPackage.${system};
        elm = elmPackages.packages.${system}.elm;
        elmTest = elmPackages.packages.${system}.elm-test;
        elmFormat = elmPackages.packages.${system}.elm-format;
        elmLanguageServer = elmPackages.packages.${system}.elm-language-server;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = builtins.concatLists [
          (builtins.attrValues self.packages.${system})
          [
            pkgs.silver-searcher # ag
            pkgs.fzf
            pkgs.openssl
            pkgs.inotifyTools
          ]
        ];
        shellHook = ''
          # Load ~/.bashrc if it exists
          test -f ~/.bashrc && source ~/.bashrc

          # Source .env file if present
          test -f "$PROJECT/.env" && source .env

          # Ignore files specified in .gitignore when using fzf
          # -t only searches text files and includes empty files
          export FZF_DEFAULT_COMMAND="ag -tl"

          # Initialize $PROJECT environment variable
          export PROJECT="$PWD"

          # Symlink GitHub elm dependencies
          function symlink_dependency {
            src="$1"
            dest="$2"
            mkdir -p "$(dirname $dest)"
            ln -sfT "$src" "$dest"
          }
          symlink_dependency "${elmLibSrc}" "$PROJECT/lib/realfolk/elm-lib"
        '';
      };
    });
}
