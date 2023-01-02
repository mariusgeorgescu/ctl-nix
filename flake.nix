{
  description = "Cardano transaction lib backed by nix";

  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      utils.url = "github:ursi/flake-utils";
      getflake.url = "github:ursi/get-flake";

      # TODO remove pinned to match github:LovelaceAcademy/purs-nix
      ctl.url = "github:LovelaceAcademy/cardano-transaction-lib/790bd5963a5b3e4c231b83288c91f632a2d6101e";
      # TODO remove pinned because of cardano-transaction-lib
      package-set-repo.url = "github:purescript/package-sets/dffcbcfe9b35a3a826e4389fade3e2b28fb0c614";
      package-set-repo.flake = false;
    };

  outputs = { utils, ... }@inputs:
    let
      # this export a lib with the override
      __functor = _: { system }: import ./nix/purs-nix
        inputs.package-set-repo
        inputs.ctl.legacyPackages.${system}
        inputs.nixpkgs.legacyPackages.${system};
    in
    { inherit __functor; } // utils.apply-systems
      {
        inherit inputs;
        # TODO remove systems limited by test
        systems = [ "x86_64-linux" "x86_64-darwin" ];
      }
      ({ system, ... }: {
        checks = (inputs.getflake ./test).checks.${system};
      });
}
