# mynixconfiguration

```
cd ~
git clone https://github.com/GrumpyMeow/mynixconfiguration.git
```

```
nixos-rebuild -I nixos-config=/root/mynixconfiguration/machines/nixserver.nix dry-run

nixos-rebuild -I nixos-config=/root/mynixconfiguration/machines/nixdesktop.nix dry-run
```
