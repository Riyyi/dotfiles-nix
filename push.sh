#!/bin/sh

echo "Enter IP address: "
read -r IP

if [ -z "$IP" ]; then
    echo "Error: please provide an IP." >&2
    exit 1
fi

ssh "nixos@$IP" "
  sudo mkdir -p /mnt/root/.ssh && \
  echo '$(cat ~/.ssh/id_ed25519)'     | sudo tee /mnt/root/.ssh/id_ed25519 > /dev/null && \
  echo '$(cat ~/.ssh/id_ed25519.pub)' | sudo tee /mnt/root/.ssh/id_ed25519.pub > /dev/null && \
  sudo chmod 600 /mnt/root/.ssh/id_ed25519 /mnt/root/.ssh/id_ed25519.pub
"
