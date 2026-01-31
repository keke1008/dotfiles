#!/bin/sh -eu

ENV_FILE_NAME="99-keke-nix-compatible-path.conf"
declare_config_link "${XDG_CONFIG_HOME}/environment.d/${ENV_FILE_NAME}" "${ENV_FILE_NAME}"
