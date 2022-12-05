# this is a purs-nix overlay (not nixpkgs overlay)
package-set-repo: ctl: pkgs: self: super:
let
  b = builtins;
  p = pkgs;
  l = p.lib;
  package-set = l.importJSON (package-set-repo + /packages.json);
in
l.pipe package-set [
  (l.mapAttrsToList (n: v: { inherit n v; }))
  (b.foldl'
    (acc: { n, v }: acc // {
      ${n} = {
        src.git = { inherit (v) repo rev; };
        info = {
          version = b.substring 1 (b.stringLength v.version) v.version;
          dependencies = b.foldl' (acc': d: acc' + d + " ") "" v.dependencies;
        };
      };
    })
    { }
  )
]
