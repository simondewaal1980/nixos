# nixos
Dit is mijn Nixos configuratie.

Download één van de Nixos iso's op www.nixos.org.

#gebruik van deze NIXOS configuratie 
Open daar een terminal en type:git clone https://github.com/simondewaal1980/nixos

Voer het script ./prepinstall.sh uit en kopieer configuration.nix naar /mnt/etc/nixos. De disk zal worden ingedeeld met twee partities, 1 UEFI boot partitie en 1 BTRFS partitie met compressie enabled. 

Doe aanpassingen aan configuration.nix, wijzig indien van toepassing uw gebruikersnaam.


# installeer NIXOS test

type nixos-install
