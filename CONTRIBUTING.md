# Contributing to ctl-nix

Any contribution is welcome.

## Conventional Commits

We follow conventional commit [specification](https://www.conventionalcommits.org/en/v1.0.0/#summary).

## How to upgrade CTL in ctl-nix

- pin CTL and peer deps on `flake.nix`
- `nix flake lock`
- pin `package-set-repo` flake input to corresponding CTL `packages.dhall` upstream rev
- `nix build .#package-set --impure`
- `cp result nix/package-set/default.nix`
- update `nix/purs-nix/custom-deps.nix` according CTL `{spago/packages}.dhall`
- `cd test && nix flake check && nix build`

## Commit format