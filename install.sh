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

# Message user
ip a
echo "Copy over SSH key, then press <Ctrl-D>"
cat

# Move SSH key to the main user of the profile
USER="$(sed -nE 's/.*user.*=.*"(.*)";.*/\1/p' \
    "$PROFILES/$PROFILE/settings.nix")"
mkdir -p "/mnt/home/$USER"
mv "/mnt/root/.ssh" "/mnt/home/$USER"
chown -R $USER:users "/home/$USER/.ssh"

# Install system
sudo nixos-install --root /mnt --flake "/mnt/etc/nixos#$PROFILE"

if [ -f "$PROFILES/$PROFILE/disko-mount.nix" ]; then
	echo "Don't forget to unmount ZFS pools!"
fi
