{
  # The nane of the service you want to generate
  pname,
  # The package you want to generate the service for.
  package,
  # The template file that create the service. Every instance of `@pname@` will be replace with the directory of `package`.
  serviceTemplateFile,
}:
{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "${pname}-systemd-unit";
  version = package.version;

  buildInputs = [ package ];

  src = null;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    ${pname}=${package}
    substitute ${serviceTemplateFile} $out/${pname}.service \
      --subst-var ${pname}

    runHook postInstall
  '';
}
