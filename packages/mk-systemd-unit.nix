{
  # The nane of the service you want to generate
  pname,
  # The package you want to generate the service for.
  package,
  # The template file that create the service. Every instance of `@pname@` will be replace with the directory of `package`.
  serviceTemplateFile,
  # Any extra substitutions to be applied to the file
  subst ? { },
  # Any extra environment variables. These will be appended to the end of the file.
  environment ? { },
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

    mkdir $out
    substitute ${serviceTemplateFile} $out/${pname}.service \
      --subst-var-by "${pname}" "${package}" \
      ${builtins.concatStringsSep "\n" (
        map (var: "--subst-var-by \"${var}\" \"${subst.${var}}\" \\") (builtins.attrNames subst)
      )}

    cat <<EOF >> $out/${pname}.service
    ${builtins.concatStringsSep "\n" (
      map (var: "Environment=\"${var}=${environment.${var}}\"") (builtins.attrNames environment)
    )}
    EOF

    runHook postInstall
  '';
}
