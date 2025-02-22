{nixpkgs_flake}: {
  nixpkgs.flake = nixpkgs_flake;
  "flox".to = builtins.parseFlakeRef "github:flox/flox";
}
