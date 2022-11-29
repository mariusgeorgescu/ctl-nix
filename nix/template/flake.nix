{
  description = "la-ctl";

  inputs = {
    la-ctl.url = path:../../.;
    nixpkgs.follows = "la-ctl/nixpkgs";
    purs-nix.url = "github:purs-nix/purs-nix";
    utils.url = "github:ursi/flake-utils";
  };

  outputs = { self, utils, ... }@inputs:
    utils.apply-systems { inherit inputs; } ({ pkgs, system, ... }:
      let
        purs-nix = inputs.purs-nix {
          inherit system;
          overlays = inputs.la-ctl.overlays.purs-nix;
        };
        ps = purs-nix.purs
          {
            # Project dir (src, test)
            dir = ./.;
            # Dependencies
            dependencies =
              with purs-nix.ps-pkgs.la-ctl;
              [
                cardano-transaction-lib
              ];
            # FFI dependencies
            # foreign.Main.node_modules = [];
          };
      in
      {
        packages.default = ps.modules.Main.output { };
        checks.default = self.packages.default;
      });

}
