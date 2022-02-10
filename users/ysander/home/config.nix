{ pkgs, platform}:
{
  allowUnfree = true;
  joypixels.acceptLicense = true;


  # nix.registry.nixpkgs.flake = pkgs.path;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true;
    keep-derivations = true;
  '';

} // (if platform == "x86_64-linux" then {
  packageOverrides = super: rec { };

  android_sdk.accept_license = true;

} else { })
