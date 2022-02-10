{ nixpkgs }:
{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    registry."nixpkgs".flake = nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;
}
