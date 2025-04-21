{
  stdenvNoCC,
  bash,
  nodejs,
  diesel-cli,
  girl-technology,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "girl_technology_server";
  version = girl-technology.version;
  src = girl-technology.src;

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    cd static
    npm install
    npm run build
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/static/dist
    cp -R static/dist/* $out/static/dist

    mkdir -p $out/migrations
    cp -R migrations/* $out/migrations

    mkdir -p $out/bin
    cat <<EOF > $out/bin/girl_technology_server
    #!${bash}/bin/bash
    ${diesel-cli}/bin/diesel setup
    ${girl-technology}/bin/girl_technology \$GIRL_TECHNOLOGY_HOST \$GIRL_TECHNOLOGY_PORT
    EOF
    chmod +x $out/bin/girl_technology_server
  '';
})
