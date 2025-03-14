#!/usr/bin/env bash

for f in *.pem.enc; do
  sops decrypt $f > ${f%.enc}
done
