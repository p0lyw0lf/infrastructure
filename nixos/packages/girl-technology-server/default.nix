{
  pkgs,
  perSystem,
  ...
}:
pkgs.callPackage (import ./package.nix) {
  diesel-cli = pkgs.diesel-cli.override {
    sqliteSupport = false;
    postgresqlSupport = true;
    mysqlSupport = false;
  };
  girl-technology = perSystem.self.girl-technology;
  girl-technology-static = perSystem.self.girl-technology-static;
}
