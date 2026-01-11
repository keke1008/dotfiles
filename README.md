# dotfiles

![installation test](https://github.com/keke1008/dotfiles/actions/workflows/installation.yaml/badge.svg)

![desktop image](https://github.com/user-attachments/assets/f84328a0-183c-4cdb-bd47-ac541a555f4c)

## Installation

```sh
git clone https://github.com/keke1008/dotfiles.git
cd ./dotfiles
./dot install
./dot init
```

## Uninstallation

```sh
./dot restore
```

## Testings

```sh
docker build . -t dotfiles-test
docker run -t --rm --user "$(id -u):$(id -g)" -v .:/dotfiles dotfiles-test
```
