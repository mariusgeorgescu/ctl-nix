{
  description = "Optioned Cardano Transaction Lib backed by nix";

  inputs =
    {
      # pinned to match github:LovelaceAcademy/purs-nix
      ctl.url = "github:LovelaceAcademy/cardano-transaction-lib/790bd5963a5b3e4c231b83288c91f632a2d6101e";
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      #purs-nix.url = "github:purs-nix/purs-nix";
      utils.url = "github:ursi/flake-utils";
      # pinned because of CTL
      package-set-repo.url = "github:purescript/package-sets/dffcbcfe9b35a3a826e4389fade3e2b28fb0c614";
      package-set-repo.flake = false;
      get-flake.url = "github:ursi/get-flake";
    };

  outputs = { self, utils, ... }@inputs:
    let
      templates.default.path = ./nix/template;
      templates.default.description = "la-ctl template";
    in
    { inherit templates; } // utils.apply-systems
      { inherit inputs; }
      ({ pkgs, system, ... }:
        let
        in
        {
          # warning: unknown flake output 'lib' is a know issue
          # it will be eventually standard on nix
          lib = import ./nix/overlay.nix
            inputs.package-set-repo
            inputs.ctl
            pkgs;
          #checks.template = (inputs.get-flake ./nix/template).checks.${system};
        });
}
