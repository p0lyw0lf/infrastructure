#!/usr/bin/env bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

UNIT_FOLDER="$(nix build --file "${DIR}/../default.nix" "$(hostname).systemd-user" --print-out-paths)"

for unit in "${UNIT_FOLDER}"/*.service; do

	ln -sf "$unit" "${HOME}/.config/systemd/user/$(basenamne "$unit")"
done

systemctl --user daemon-reload


for unit in "${UNIT_FOLDER}"/*.service; do

	systemctl --user restart "$(basenamne "$unit")"
done
