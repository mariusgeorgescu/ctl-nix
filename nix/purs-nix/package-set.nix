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
    (acc: { n, v }:
      let
        repo = b.fetchGit
          {
            url = v.repo;
            ref = "refs/tags/${v.version}";
          };
      in
      acc // {
        ${n} = {
          src.git = {
            repo = v.repo;
            rev = repo.rev;
          };
          info = {
            version = b.substring 1 (b.stringLength v.version) v.version;
            dependencies = [ ];
            #FIXME: missing dependencies
            #dependencies = b.foldl' (acc': d: acc' + d + " ") "" v.dependencies;
          };
        };
      })
    { }
  )
]
