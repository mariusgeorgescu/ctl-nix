{
  inputs = {
    purs-nix.url = "github:purs-nix/purs-nix";

    # TODO re-use root deps (even solvable?)
    utils.url = "github:ursi/flake-utils";
    getflake.url = "github:ursi/get-flake";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };


  outputs = { utils, getflake, ... }@inputs:
    let
      ctl-flake = getflake ../.;
    in
    utils.apply-systems
      {
        inputs = inputs // { ctl = ctl-flake; };
        # TODO remove systems limited by purs-nix
        systems = [ "x86_64-linux" ];
        overlays = [
          # override purescript compiler by CTL version
          ctl-flake.inputs.ctl.overlays.purescript
        ];
      }
      ({ system, pkgs, ctl, ... }@ctx:
        let
          purs-nix = inputs.purs-nix {
            inherit system;
            overlays = [ ctl ];
          };
          ps = purs-nix.purs
            {
              # TODO find a way to define purescript compiler globally
              #  so we don't need to bump this on each compiler update
              purescript = pkgs.easy-ps.purs-0_14_5;
              # Project dir (src, test)
              dir = ./.;
              # Dependencies
              dependencies =
                with purs-nix.ps-pkgs;
                [
                  #cardano-transaction-lib
                  affjax
                  bigints
                  toppokki
                  medea
                  mote
                  lattice
                  properties
                  sequences
                  aeson-helpers
                  aeson
                  either
                ];
              # FFI dependencies
              # foreign.Main.node_modules = [];
            };
        in
        {
          # TODO add ctl rev == self rev
          packages.default = ps.output { };
        });
}
