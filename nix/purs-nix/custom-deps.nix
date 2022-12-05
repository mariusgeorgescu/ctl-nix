# this is a purs-nix overlay (not nixpkgs overlay)
package-set-repo: ctl: pkgs: self: super: with self; {
  # additional packages for CTL
  # TODO: automate the set generation using CTL input
  # pinned to match ctl arg
  aeson = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-aeson.git";
      rev = "ff1afd366aaab257063320a4acdbd594072f9037";
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
      rev = "391231db9e278fcb87c82245e6da22f776c1783a";
    };
    info = /package.nix;
  };

  properties = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-properties.git";
      rev = "4d8de7ffe18bd3997d05a19f3fbeef90aba9c81f";
    };
    info = /package.nix;
  };

  lattice = {
    src.git = {
      repo = "https://github.com/LovelaceAcademy/purescript-lattice.git";
      rev = "086c2f05fdbcc60c2e7b2927147b8518cdbe0e69";
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
      rev = "18dc4b42ddd0b2caf5f8c24c258b16f8bb15d3ce";
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

  bigints.src.flake.url = "github:LovelaceAcademy/purescript-bigints/eb0349d2f8153b3d103e902064cc55316c0b8967";

  affjax.src.flake.url = "github:LovelaceAcademy/purescript-affjax/1dd6aa0a0e47b83197a46eed4c35fe9cd6b3e59d";
}
