# dotfiles

[![installation test](https://github.com/keke1008/dotfiles/actions/workflows/test.yaml/badge.svg)](https://github.com/keke1008/dotfiles/actions/workflows/test.yaml)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/keke1008/dotfiles)

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

## Testing

### Unit testing

```sh
bats -r scripts/test/
```

### Integration testing

```sh
docker build . -t dotfiles-integration-test
docker run -t --rm dotfiles-integration-test
```
