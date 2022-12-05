{
  description = "la-ctl";

  inputs = {
    #TODO: copy this to template at CI/release and change the path
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
          overlays = inputs.la-ctl.lib;
        };
        ps = purs-nix.purs
          {
            # Project dir (src, test)
            dir = ./.;
            # Dependencies
            dependencies =
              with purs-nix.ps-pkgs;
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
