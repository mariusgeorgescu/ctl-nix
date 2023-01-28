# this is a purs-nix overlay (not nixpkgs overlay)
package-set-repo: inputs: pkgs: npmlock2nix: self: super: with self; {

  cardano-transaction-lib = {
    # TODO find a way to reuse ctl to build cardano-transaction-lib overlay
    #  it seems that we'll need a purs-nix api change for that
    #  also applies to other inputs
    #src = ctl;
    src.git = {
      inherit (inputs.ctl.sourceInfo) rev;
      repo = "https://github.com/Plutonomicon/cardano-transaction-lib.git";
    };
    info = {
      version = "4.0.2";
      dependencies = [
        aeson
        argonaut-codecs
        aff
        aff-promise
        aff-retry
        affjax
        argonaut
        arraybuffer-types
        arrays
        avar
        bifunctors
        bigints
        checked-exceptions
        console
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
        functions
        gen
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
        noble-secp256k1
        node-buffer
        node-child-process
        node-fs
        node-fs-aff
        node-path
        node-process
        node-readline
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
        purescript-toppokki
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
      #  command used `grep -rl --include "*.js" require src/ | xargs -I _ sh -c "S=_; grep module \${S/js/purs} | cut -d ' ' -f2"`
      #  command used for nested dependencies `spago install && grep -rl --include "*.js" require .spago/ | xargs -I _ sh -c "S=_; grep -H module \${S/js/purs}"`
      foreign =
        let
          ffi = [
            "Ctl.Internal.BalanceTx.UtxoMinAda"
            "Ctl.Internal.Base64"
            "Ctl.Internal.Deserialization.FromBytes"
            "Ctl.Internal.Deserialization.Keys"
            "Ctl.Internal.Deserialization.Language"
            "Ctl.Internal.Deserialization.Transaction"
            "Ctl.Internal.Deserialization.UnspentOutput"
            "Ctl.Internal.Deserialization.WitnessSet"
            "Ctl.Internal.JsWebSocket"
            "Ctl.Internal.Plutip.PortCheck"
            "Ctl.Internal.Plutip.Spawn"
            "Ctl.Internal.Plutip.Utils"
            "Ctl.Internal.QueryM.UniqueId"
            "Ctl.Internal.Serialization.Address"
            "Ctl.Internal.Serialization.AuxiliaryData"
            "Ctl.Internal.Serialization.BigInt"
            "Ctl.Internal.Serialization.Hash"
            "Ctl.Internal.Serialization.MinFee"
            "Ctl.Internal.Serialization.NativeScript"
            "Ctl.Internal.Serialization.PlutusData"
            "Ctl.Internal.Serialization.PlutusScript"
            "Ctl.Internal.Serialization.WitnessSet"
            "Ctl.Internal.Types.TokenName"
            "Ctl.Internal.Types.BigNum"
            "Ctl.Internal.Types.Int"
            "Ctl.Internal.Wallet.Cip30.SignData"
            "Ctl.Internal.ApplyArgs"
            "Ctl.Internal.Hashing"
            "Ctl.Internal.Serialization"
          ];
          node_modules = npmlock2nix.v1.node_modules { src = inputs.ctl; } + /node_modules;
        in
        pkgs.lib.attrsets.genAttrs ffi (_: { inherit node_modules; });
    };
  };

  # additional packages for CTL
  # TODO: automate the set generation using CTL input
  # pinned to match ctl arg
  aeson = {
    src.git = {
      repo = "https://github.com/mlabs-haskell/purescript-aeson.git";
      inherit (inputs.aeson) rev;
    };
    info = {
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
          node_modules = npmlock2nix.v1.node_modules
            {
              pname = "aeson-node_modules-" + inputs.aeson.shortRev;
              src = inputs.aeson;
            } + /node_modules;
        in
        pkgs.lib.attrsets.genAttrs ffi (_: { inherit node_modules; });
    };
  };

  bignumber = {
    src.git = {
      repo = "https://github.com/mlabs-haskell/purescript-bignumber.git";
      inherit (inputs.bignumber) rev;
    };
    info = {
      dependencies = [
        console
        effect
        either
        exceptions
        functions
        integers
        partial
        prelude
        tuples
        # FIXME remove missing Data.UInt workaround
        uint
        # /endworkaround
      ];
      foreign =
        let
          ffi = [
            #"Data.BigNumber"
          ];
          node_modules = npmlock2nix.v1.node_modules { src = inputs.bignumber; } + /node_modules;
        in
        pkgs.lib.attrsets.genAttrs ffi (_: { inherit node_modules; });
    };
  };

  sequences = {
    src.git = {
      repo = "https://github.com/hdgarrood/purescript-sequences";
      rev = "1f1d828ef30070569c812d0af23eb7253bb1e990";
    };
    info = {
      dependencies =
        [
          arrays
          self."assert"
          console
          effect
          lazy
          maybe
          newtype
          nonempty
          partial
          prelude
          profunctor
          psci-support
          quickcheck
          quickcheck-laws
          tuples
          unfoldable
          unsafe-coerce
        ];
    };
  };

  properties = {
    src.git = {
      repo = "https://github.com/Risto-Stevcev/purescript-properties.git";
      rev = "ddcad0f6043cc665037538467a2e2e4173ef276a";
    };
    info = {
      dependencies = [ prelude console ];
    };
  };

  lattice = {
    src.git = {
      repo = "https://github.com/Risto-Stevcev/purescript-lattice.git";
      rev = "aebe3686eba30f199d17964bfa892f0176c1742d";
    };
    info = {
      dependencies = [ prelude console properties ];
    };
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
      repo = "https://github.com/juspay/medea-ps.git";
      rev = "8b215851959aa8bbf33e6708df6bd683c89d1a5a";
    };
    info = {
      dependencies =
        [
          aff
          argonaut
          arrays
          bifunctors
          control
          effect
          either
          enums
          exceptions
          foldable-traversable
          foreign-object
          free
          integers
          lists
          maybe
          mote
          naturals
          newtype
          node-buffer
          node-fs-aff
          node-path
          nonempty
          ordered-collections
          parsing
          partial
          prelude
          psci-support
          quickcheck
          quickcheck-combinators
          safely
          spec
          strings
          these
          transformers
          typelevel
          tuples
          unicode
          unordered-collections
          unsafe-coerce
        ];
    };
  };

  purescript-toppokki = {
    src.git = {
      repo = "https://github.com/firefrorefiddle/purescript-toppokki";
      ref = "mike/browserpages";
      inherit (inputs.toppokki) rev;
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

      foreign =
        let
          p = pkgs.mkYarnModules {
            pname = "purescript-toppokki-node_modules";
            version = inputs.toppokki.shortRev;
            yarnLock = inputs.toppokki + /yarn.lock;
            packageJSON = inputs.toppokki + /package.json;
          };
          ffi = [
            "Toppokki"
          ];
          node_modules = p + /node_modules;
        in
        pkgs.lib.attrsets.genAttrs ffi (_: { inherit node_modules; });
    };
  };

  noble-secp256k1 = {
    src.git = {
      repo = "https://github.com/mlabs-haskell/purescript-noble-secp256k1.git";
      inherit (inputs.noble-secp256k1) rev;
    };
    info = {
      dependencies =
        [
          aff
          aff-promise
          effect
          prelude
          spec
          tuples
          unsafe-coerce
          # FIXME remove missing Data.ArrayBuffer.Types workaround
          arraybuffer-types
          # /endworkaround
          # FIXME remove missing Data.UInt workaround
          uint
          # /endworkaround
        ];

      foreign =
        let
          ffi = [
            "Noble.Secp256k1.ECDSA"
            "Noble.Secp256k1.Schnorr"
            "Noble.Secp256k1.Utils"
          ];
          node_modules = npmlock2nix.v1.node_modules { src = inputs.noble-secp256k1; } + /node_modules;
        in
        pkgs.lib.attrsets.genAttrs ffi (_: { inherit node_modules; });
    };
  };
}
