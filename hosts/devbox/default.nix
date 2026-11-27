inp: {
  systemd-user = import ../mk-systemd-unit-collection.nix [
    ../../packages/crossposter
    ../../packages/freshrss
    ../../packages/girl-technology
    ../../packages/pds
    ../../packages/syncthing
  ] inp;
}
