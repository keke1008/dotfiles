# dotfiles

![installation test](https://github.com/keke1008/dotfiles/actions/workflows/installation.yaml/badge.svg)

## Installation

```sh
git clone https://github.com/keke1008/dotfiles.git
cd ./dotfiles
./dot install
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
