{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      purs-nix.url = "github:LovelaceAcademy/purs-nix";
      utils.url = "github:ursi/flake-utils";
      npmlock2nix.url = "github:nix-community/npmlock2nix";
      npmlock2nix.flake = false;
      # pinned to follow ctl-nix
      aeson.url = "github:mlabs-haskell/purescript-aeson/9fd6e8241881d4b8ed9dcb6a80b166d3683f87b5";
      aeson.flake = false;
    };

  outputs = { utils, npmlock2nix, ... }@inputs:
    utils.apply-systems
      {
        inherit inputs;
        # restricted by npmlock2nix, see nix-community/npmlock2nix#159
        systems = [ "x86_64-linux" ];
        overlays = [
          (final: prev:
            { npmlock2nix = import npmlock2nix { pkgs = prev; }; }
          )
        ];
      }
      ({ purs-nix, pkgs, ... }:
        let
          name = "aeson";
          src = inputs.aeson;
          pname = "${name}-node_modules";
          node_modules = pkgs.npmlock2nix.v1.node_modules
            {
              inherit src pname;
            };
          info = with purs-nix.ps-pkgs;
            {
              dependencies = [
                aff
                argonaut
                argonaut-codecs
                argonaut-core
                arrays
                bifunctors
                bigints
                bignumber
                const
                control
                effect
                either
                exceptions
                foldable-traversable
                foreign-object
                integers
                lists
                maybe
                mote
                numbers
                ordered-collections
                partial
                prelude
                quickcheck
                record
                sequences
                spec
                strings
                tuples
                typelevel
                typelevel-prelude
                uint
                untagged-union
              ];
              foreign =
                let
                  ffi = [
                    "Aeson"
                  ];
                in
                pkgs.lib.attrsets.genAttrs ffi (_: { node_modules = node_modules + /node_modules; });
            };
        in
        {
          packages.default =
            purs-nix.build
              {
                inherit name info;
                src.path = src;
              };
          packages.node_modules = node_modules;
        }
      );
}
