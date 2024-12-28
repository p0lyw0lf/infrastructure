#!/usr/bin/env bash

# Usage: ./link.sh <target.service> {system}

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TARGET="${DIR}/${1}"

if [[ ! -f "${TARGET}" ]]; then
	echo "${TARGET} not found"
	exit 1
fi

if [[ "x${2}x" = "xsystemx" ]]; then
	sudo ln -s "${TARGET}" "/etc/systemd/system/${1}"
else
	ln -s "${TARGET}" "${HOME}/.config/systemd/user/${1}"
fi
