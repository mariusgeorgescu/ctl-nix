# this is a purs-nix overlay (not nixpkgs overlay)
package-set-repo: ctl: pkgs:
let
  b = builtins;
  p = pkgs;
  l = p.lib;
  package-set = import ./package-set.nix package-set-repo ctl p;
  custom-deps = import ./custom-deps.nix package-set-repo ctl p;
in
l.composeExtensions package-set custom-deps
