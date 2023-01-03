{
  description = "Cardano transaction lib backed by nix";

  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      utils.url = "github:ursi/flake-utils";
      getflake.url = "github:ursi/get-flake";

      # TODO remove pinned to match github:LovelaceAcademy/purs-nix
      ctl.url = "github:LovelaceAcademy/cardano-transaction-lib/790bd5963a5b3e4c231b83288c91f632a2d6101e";
      # TODO find a way to get package-set-repo from ctl
      #  package-set-repo now is pinned to follow ctl /packages.dhall
      #  we need a way to extract this information from there
      package-set-repo.url = "github:purescript/package-sets/dffcbcfe9b35a3a826e4389fade3e2b28fb0c614";
      package-set-repo.flake = false;
    };

  outputs = { self, nixpkgs, utils, package-set-repo, ctl, ... }@inputs:
    let
      # this export a lib with the override
      __functor = _: { system }: import ./nix/purs-nix
        package-set-repo
        ctl
        nixpkgs.legacyPackages.${system};
    in
    { inherit __functor; } // utils.apply-systems
      {
        inherit inputs;
        # TODO remove systems limited by test
        systems = [ "x86_64-linux" "x86_64-darwin" ];
      }
      ({ system, pkgs, ... }:
        let
          package-set = import ./nix/package-set/generate.nix package-set-repo pkgs;
        in
        {
          packages.package-set = package-set;
          checks = (inputs.getflake ./test).checks.${system};
        });
}
