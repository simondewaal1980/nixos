#!/usr/bin/env bash
lsblk

# Vraag de gebruiker om de disk te kiezen
echo "Kies de disk met voldoende vrije ruimte uit bovenstaande lijst waarop je NixOS wilt installeren,bestaande gegevens op gekozen disk gaan verloren!"
read DISK

# Controleer of de disk bestaat
if [ ! -b "$DISK" ]; then
  echo "Disk $DISK bestaat niet of is geen blokapparaat. Probeer het opnieuw."
  exit 1
fi

# Maak een GPT-partitietabel aan
parted "$DISK" -- mklabel gpt

# Maak een bootpartitie aan (512 MiB)
parted "$DISK" -- mkpart primary fat32 1MiB 512MiB
parted "$DISK" -- set 1 esp on

# Maak een BTRFS-partitie aan voor de rest van de disk
parted "$DISK" -- mkpart primary 512MiB 100%

# Formatteer de bootpartitie als FAT32
mkfs.fat -F 32 "${DISK}1"

# Formatteer de BTRFS-partitie met zstd-compressie
mkfs.btrfs -f  "${DISK}2"
# koppel disk aan en  maak BTRFS-volumes aan
# mkdir -p /mnt
mount "${DISK}2" /mnt

# Maak de subvolumes root, home en nix aan
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
#ontkoppel mnt
umount /mnt

# Koppel de subvolumes aan /mnt
mount -o subvol=root,compress-force=zstd "${DISK}2" /mnt
mkdir -p /mnt/{boot,home,nix}
mount -o subvol=home,compress-force=zstd "${DISK}2" /mnt/home
mount -o subvol=nix,compress-force=zstd "${DISK}2" /mnt/nix
mount "${DISK}1" /mnt/boot

# Genereer een nieuwe NixOS-configuratie
nixos-generate-config --root /mnt
