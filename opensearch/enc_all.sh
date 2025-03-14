#!/usr/bin/env bash

for f in *.pem; do
  sops encrypt $f > $f.enc
done
