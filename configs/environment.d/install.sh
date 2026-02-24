#!/bin/sh -eu

ENV_FILE_NAME="99-keke-nix-compatible-path.conf"
declare_xdg_config_link "${ENV_FILE_NAME}" "environment.d/${ENV_FILE_NAME}"
