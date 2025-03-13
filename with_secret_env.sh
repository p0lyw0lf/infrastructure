#!/usr/bin/env bash
# Usage: ./with_secret_env.sh one.env two.env -- command with args
# WARNING: all inputs (secret files and command) are trusted

while (( "$#" )); do
	# If the argument is --, break from the loop
	if [[ "$1" == "--" ]]; then
		break
	fi
	# Otherwise, load all variables from the file
	source <(sops decrypt "$1")
	shift
done

# Consume the "--" and execute the remaining command
shift
"$@"
