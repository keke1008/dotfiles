#!/bin/sh -eu

ENV_FILE_NAME="99-keke-nix-compatible-path.conf"
declare_config_link "${ENV_FILE_NAME}" "${XDG_CONFIG_HOME}/environment.d/${ENV_FILE_NAME}"
