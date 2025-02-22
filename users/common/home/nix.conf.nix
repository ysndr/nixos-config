secrets @ {gh_token ? false, ...}: ''
  experimental-features = nix-command flakes
  keep-outputs = true
  keep-derivations = true

  # ssh-ng://nixbld@build-proxy.floxdev.com

  substituters = https://cache.nixos.org https://ysndr.cachix.org
  trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ysndr.cachix.org-1:Yc/8iRx8QdQ7e2uZbeWJnX5S1vwyzhzj76bL/Z/Hl2g=

  access-tokens = ${
    if secrets ? gh_token
    then "github.com=${secrets.gh_token}"
    else ""
  }
''
