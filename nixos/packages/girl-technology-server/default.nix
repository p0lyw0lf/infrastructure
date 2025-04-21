{
  pkgs,
  perSystem,
  ...
}:
pkgs.callPackage (import ./package.nix) {
  girl-technology = perSystem.self.girl-technology;
  diesel-cli = pkgs.diesel-cli.override {
    sqliteSupport = false;
    postgresqlSupport = true;
    mysqlSupport = false;
  };
}
