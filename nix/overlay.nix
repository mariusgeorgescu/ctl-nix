# this is a purs-nix overlay (not nixpkgs overlay)
package-set-repo: ctl: pkgs: final: prev:
let
  b = builtins;
  p = pkgs;
  l = p.lib;
  package-set = l.importJSON (package-set-repo + /packages.json);
  packages = l.pipe package-set [
    (l.mapAttrsToList (n: v: { inherit n v; }))
    (b.foldl'
      (acc: { n, v }: acc // {
        ${n} = {
          src.git = { inherit (v) repo rev; };
          info = {
            version = b.substring 1 (b.stringLength v.version) v.version;
            dependencies = b.foldl' (acc': d: acc' + d + " ") "" v.dependencies;
          };
        };
      })
      { }
    )
  ];
in
with packages; packages // {
  # additional packages for CTL
  # TODO: automate the set generation using CTL input
  # pinned to match ctl arg
  aeson = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-aeson.git";
      rev = "85449440c264d5eedf1acbdf8649fc8eb035e50b";
    };
    info = /package.nix;
  };
  aeson-helpers = {
    src.git = {
      repo = "https://github.com/mlabs-haskell/purescript-bridge-aeson-helpers.git";
      rev = "44d0dae060cf78babd4534320192b58c16a6f45b";
    };
    info = {
      dependencies = [
        aff
        argonaut-codecs
        argonaut-core
        arrays
        bifunctors
        contravariant
        control
        effect
        either
        enums
        foldable-traversable
        foreign-object
        maybe
        newtype
        ordered-collections
        prelude
        profunctor
        psci-support
        quickcheck
        record
        spec
        spec-quickcheck
        transformers
        tuples
        typelevel-prelude
      ];
    };
  };

  sequences = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-sequences";
      rev = "e37a04e5b88e0cdc2bc92d32aaf281ed61f9fdb0";
    };
    info = /package.nix;
  };

  properties = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-properties.git";
      rev = "69c73d0eeeea79f7a73ec18976fda89e404d7760";
    };
    info = /package.nix;
  };

  lattice = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-lattice.git";
      rev = "80f7411d1f51d033a3a1b2d2a15bac3e06e81e5c";
    };
    info = /package.nix;
  };

  mote = {
    src.git = {
      repo = "https://github.com/garyb/purescript-mote.git";
      rev = "29aea4ad7b013d50b42629c87b01cf0202451abd";
    };
    info = {
      dependencies = [
        these
        transformers
        arrays
      ];
    };
  };

  medea = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/medea-ps.git";
      rev = "1c34dbeba9534aaecb874fd17ede8dfe62923a92";
    };
    info = /package.nix;
  };

  toppokki = {
    src.git = {
      repo = "https://github.com/firefrorefiddle/purescript-toppokki";
      ref = "mike/browserpages";
      rev = "6983e07bf0aa55ab779bcef12df3df339a2b5bd9";
    };
    info = {
      dependencies = [
        prelude
        record
        functions
        node-http
        aff-promise
        node-buffer
        node-fs-aff
      ];
    };
  };

  bigints.src.flake.url = "github:LovelaceAcademy/purescript-bigints/1e7e8a260b3283307fa887be26300fb29604799a";

  affjax.src.flake.url = "github:LovelaceAcademy/purescript-affjax/c24e75155cf2b243472b6f163a7772290a603ed1";
}
