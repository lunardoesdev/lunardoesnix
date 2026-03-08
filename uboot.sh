nix --extra-experimental-features "nix-command flakes" flake update
sudo nixos-rebuild boot --verbose --impure --flake .#main
