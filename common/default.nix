{nixpkgs}: {
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations impure-derivations
      keep-outputs = true
      keep-derivations = true
    '';
    registry = {
      "nixpkgs".flake = nixpkgs;
    };
  };
  nixpkgs.config.allowUnfree = true;
}
