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
        # TODO remove systems limited by purs-nix/ps-tools
        systems = [ "x86_64-linux" "x86_64-darwin" ];
      }
      ({ system, ctl, ... }@ctx:
        let
          purs-nix = inputs.purs-nix {
            inherit system;
            overlays = [ ctl ];
          };
          ps = purs-nix.purs
            {
              # Project dir (src, test)
              dir = ./.;
              # Dependencies
              dependencies =
                with purs-nix.ps-pkgs;
                [
                  #cardano-transaction-lib
                  affjax
                  bigints
                  #toppokki
                  #medea
                  #mote
                  #lattice 
                  #properties 
                  #sequences 
                  #aeson-helpers
                  #aeson
                  either
                ];
              # FFI dependencies
              # foreign.Main.node_modules = [];
            };
        in
        {
          # TODO add ctl rev == self rev
          checks.default = ps.output { };
        });
}
