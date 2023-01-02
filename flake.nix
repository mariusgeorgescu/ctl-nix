{
  description = "Cardano transaction lib backed by nix";

  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

      # TODO remove pinned to match github:LovelaceAcademy/purs-nix
      ctl.url = "github:LovelaceAcademy/cardano-transaction-lib/790bd5963a5b3e4c231b83288c91f632a2d6101e";
      # TODO remove pinned because of cardano-transaction-lib
      package-set-repo.url = "github:purescript/package-sets/dffcbcfe9b35a3a826e4389fade3e2b28fb0c614";
      package-set-repo.flake = false;
    };

  outputs = { nixpkgs, package-set-repo, ctl, ... }:
    {
      # warning: unknown flake output 'lib' is a know issue
      # it will be eventually standard on nix
      __functor = _: { system }: import ./nix/purs-nix
        package-set-repo
        ctl
        nixpkgs.legacyPackages.${system};
    };
}
