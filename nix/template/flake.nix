{
  description = "la-ctl";

  inputs = {
    la-ctl.url = "github:LovelaceAcademy/la-ctl";
    nixpkgs.follows = "la-ctl/nixpkgs";
    purs-nix.url = "github:purs-nix/purs-nix";
    utils.url = "github:ursi/flake-utils";
  };

  outputs = { self, utils, ... }@inputs:
    # systems limited by LovelaceAcademy/purescript-affjax
    let systems = [ "x86_64-linux" ]; in
    utils.apply-systems
      { inherit inputs; inherit systems; }
      ({ pkgs, system, ... }:
        let
          la-ctl = inputs.la-ctl { inherit system; };
          purs-nix = inputs.purs-nix {
            inherit system;
            overlays = [ la-ctl ];
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
                ];
              # FFI dependencies
              # foreign.Main.node_modules = [];
            };
        in
        {
          packages.default = ps.modules.Main.output { };
        });

}
