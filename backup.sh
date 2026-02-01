#!/usr/bin/env bash

# This script backs up folders on my cloud VPS to a hard drive on a server I run locally.
# It is meant to be run as root, because that is the best way I can see to read from these folders.
# (The other option would be to provide SSH login as root over the tailscale network, but that seems
# much too complex.)

folders=(
	/pds                    # Backs up pds.service
	/var/lib/docker/volumes # Backs up freshrss.service
	/var/lib/postgresql     # Backs up girl.technology.service
	# crossposter.service & rc.wolfgirl.dev.service are backed up by syncthing
)

for folder in "${folders[@]}"; do
	rsync -av -e ssh "$folder" "me@mammal:/mnt/seagate/devbox-backup"
done
