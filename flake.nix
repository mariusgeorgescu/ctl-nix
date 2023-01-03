{
  description = "Cardano transaction lib backed by nix";

  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      utils.url = "github:ursi/flake-utils";
      getflake.url = "github:ursi/get-flake";

      # TODO remove pinned to match github:LovelaceAcademy/purs-nix
      ctl.url = "github:Plutonomicon/cardano-transaction-lib/30a410d1d80941e843f7f238e2b2b12c8114876d";
      # TODO find a way to get package-set-repo from ctl
      #  package-set-repo now is pinned to follow ctl /packages.dhall
      #  we need a way to extract this information from there
      package-set-repo.url = "github:purescript/package-sets/dffcbcfe9b35a3a826e4389fade3e2b28fb0c614";
      package-set-repo.flake = false;

      npmlock2nix.url = "github:nix-community/npmlock2nix";
      npmlock2nix.flake = false;
    };

  outputs = { self, nixpkgs, utils, package-set-repo, ctl, npmlock2nix, ... }@inputs:
    let
      # this export a lib with the override
      __functor = _: { system }:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          npmlock2nix' = import npmlock2nix { inherit pkgs; };
        in
        import ./nix/purs-nix
          package-set-repo
          ctl
          pkgs
          npmlock2nix';
    in
    { inherit __functor; } // utils.apply-systems
      {
        inherit inputs;
        # TODO remove systems limited by the test
        systems = [ "x86_64-linux" ];
      }
      ({ system, ... }@ctx:
        let
          package-set = import ./nix/package-set/generate.nix package-set-repo ctx.pkgs;
        in
        {
          packages.package-set = package-set;
          checks = (inputs.getflake ./test).checks.${system};
        });
}
