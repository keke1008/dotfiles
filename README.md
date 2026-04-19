# dotfiles

![installation test](https://github.com/keke1008/dotfiles/actions/workflows/installation.yaml/badge.svg)

![desktop image](https://github.com/user-attachments/assets/8a3412b1-0862-45a2-bfc2-9622e7635c05)

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
