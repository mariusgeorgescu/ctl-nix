# this is a purs-nix overlay (not nixpkgs overlay)
package-set-repo: ctl: pkgs: npmlock2nix: self: super: with self; {

  cardano-transaction-lib = {
    # TODO find a way to reuse ctl to build cardano-transaction-lib overlay
    #  it seems that we'll need a purs-nix api change for that
    #src = ctl;
    src.git = {
      inherit (ctl.sourceInfo) rev;
      repo = "https://github.com/Plutonomicon/cardano-transaction-lib.git";
    };
    info = {
      version = "2.0.0";
      dependencies = [
        aeson
        aeson-helpers
        aff
        aff-promise
        aff-retry
        affjax
        arraybuffer-types
        arrays
        bifunctors
        bigints
        checked-exceptions
        console
        const
        contravariant
        control
        datetime
        debug
        effect
        either
        encoding
        enums
        exceptions
        foldable-traversable
        foreign
        foreign-object
        heterogeneous
        http-methods
        identity
        integers
        js-date
        lattice
        lists
        math
        maybe
        medea
        media-types
        monad-logger
        mote
        newtype
        node-buffer
        node-child-process
        node-fs
        node-fs-aff
        node-path
        node-process
        node-streams
        nonempty
        now
        numbers
        optparse
        ordered-collections
        orders
        parallel
        partial
        posix-types
        prelude
        profunctor
        profunctor-lenses
        toppokki
        quickcheck
        quickcheck-combinators
        quickcheck-laws
        rationals
        record
        refs
        safe-coerce
        spec
        spec-quickcheck
        strings
        stringutils
        tailrec
        text-encoding
        these
        transformers
        tuples
        typelevel
        typelevel-prelude
        uint
        undefined
        unfoldable
        untagged-union
        variant
      ];
      # TODO compare the bundle produced by purs-nix
      #  using embeded w/o embeded runtime deps to test if there
      #  are dups and decide if we keep the deps embeded
      # TODO get all .js files and use their paths to generate foreigns
      #  command used `grep -rl require src/{**/*,*}.js | xargs -I _ sh -c "S=_; grep module \${S/js/purs} | cut -d ' ' -f2"`
      foreign =
        let
          ffi = [
            "BalanceTx.UtxoMinAda"
            "Deserialization.FromBytes"
            "Deserialization.Language"
            "Deserialization.Transaction"
            "Deserialization.UnspentOutput"
            "Deserialization.WitnessSet"
            "Plutip.PortCheck"
            "Plutip.Utils"
            "QueryM.UniqueId"
            "Serialization.Address"
            "Serialization.AuxiliaryData"
            "Serialization.BigInt"
            "Serialization.Hash"
            "Serialization.MinFee"
            "Serialization.NativeScript"
            "Serialization.PlutusData"
            "Serialization.PlutusScript"
            "Serialization.WitnessSet"
            "Types.BigNum"
            "Types.Int"
            "Types.TokenName"
            "Base64"
            "Hashing"
            "JsWebSocket"
            "Serialization"
          ];
          node_modules = npmlock2nix.v1.node_modules { src = ctl; } + /node_modules;
        in
        pkgs.lib.attrsets.genAttrs ffi (_: { inherit node_modules; });
    };
  };

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
        aeson
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
      rev = "b9bc34b92c450bc7d38349062abe0b16b90d592d";
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
