#!/usr/bin/env bash

# Usage: ./link.sh <target.nginx>

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TARGET="${DIR}/${1}"

if [[ ! -f "${TARGET}" ]]; then
	echo "${TARGET} not found"
	exit 1
fi

sudo ln -s "${TARGET}" "/etc/nginx/sites-enabled/${1}"
