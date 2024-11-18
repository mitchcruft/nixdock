## Arch standalone installation:

```shell
mkdir -p ~/.config
git clone http://github.com/mitchcruft/nixdock ~/.config/home-manager
home-manager switch
```

## nix-darwin installation:

```shell
mkdir -p ~/.config
git clone http://github.com/mitchcruft/nixdock ~/.config/nix-darwin
darwin-rebuild switch
```

## Arch docker container:

```shell
ad pull
ad
```

## Arch WSL installation:
```shell
wsl/archinstall.bat
```
