{
  description = "Optioned Cardano Transaction Lib backed by nix";

  inputs =
    {
      #ctl.url = "github:Plutonomicon/cardano-transaction-lib";
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      #purs-nix.url = "github:purs-nix/purs-nix";
      utils.url = "github:ursi/flake-utils";
      get-flake.url = "github:ursi/get-flake";
      package-set-repo.url = "github:purescript/package-sets";
      package-set-repo.flake = false;
    };

  outputs = { utils, ... }@inputs:
    utils.apply-systems
      { inherit inputs; }
      ({ pkgs, ... }: { });
}
