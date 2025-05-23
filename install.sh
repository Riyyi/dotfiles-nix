#!/bin/sh

echo "Installing.."

DOT="$HOME/dotfiles"
PROFILES="$DOT/profiles"

# Clone dotfiles
rm -rf "$DOT"
nix-shell -p git --command "git clone https://github.com/riyyi/dotfiles-nix $DOT"

# Get profile
echo
echo "Profiles:"
for DIR in "$PROFILES"/*; do
    [ -d "$DIR" ] || continue
	echo "- ${DIR##*/}"
done
printf "\nPick a profile: "
read -r PROFILE
if [ ! -d "$PROFILES/$PROFILE" ]; then
    echo "Error: Profile '${PROFILES##*/}/$PROFILE' not found." >&2
    exit 1
fi

# Run disko from profile
sudo nix --experimental-features "nix-command flakes" run \
	 github:nix-community/disko/latest -- --mode destroy,format,mount "$PROFILES/$PROFILE/disko.nix"

# Run extra disko from profile
if [ -f "$PROFILES/$PROFILE/disko-mount.nix" ]; then
	sudo nix --experimental-features "nix-command flakes" run \
		github:nix-community/disko/latest -- --mode mount "$PROFILES/$PROFILE/disko-mount.nix"
fi

# Generate hardware config
nixos-generate-config --show-hardware-config --no-filesystems --root /mnt > "$PROFILES/$PROFILE/hardware-configuration.nix"

# Move dotfiles dir into /mnt/etc/nixos
sudo mkdir /mnt/etc
sudo mv "$DOT" /mnt/etc/nixos
sudo chown -R root:root /mnt/etc/nixos

# Install system
sudo nixos-install --root /mnt --flake "/mnt/etc/nixos#$PROFILE"

# Message user
ip a
echo "Copy over SSH key, then press <Ctrl-D>"
cat

# Install sops key
sudo mkdir -p /mnt/etc/nixos/sops/age
sudo nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i /mnt/root/.ssh/id_ed25519 > /mnt/etc/nixos/sops/age/keys.txt"
sudo nix-shell -p age        --run "age-keygen -y /mnt/etc/nixos/sops/age/keys.txt"
sudo chmod 0600 /mnt/etc/nixos/sops/age/keys.txt

if [ -f "$PROFILES/$PROFILE/disko-mount.nix" ]; then
	echo "Don't forget to unmount ZFS pools!"
fi
