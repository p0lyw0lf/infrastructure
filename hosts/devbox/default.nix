inp: {
  systemd-user = import ../mk-systemd-unit-collection.nix [
    ../../packages/crossposter
    ../../packages/girl-technology
    ../../packages/pds
  ] inp;
}
