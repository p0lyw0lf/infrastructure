# Following the example at https://nixos.org/manual/nixpkgs/stable/#javascript-pnpm
{
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pds";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "p0lyw0lf";
    repo = "pds";
    rev = "c2a68af20e61caaa529b92ab471416b90737fcec";
    hash = "sha256-zen0+aHixCfJk7VpiFnHkKHaKH7cSto5UahLW0Mvx0w=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/service";
    hash = "sha256-KyHa7pZaCgyqzivI0Y7E6Y4yBRllYdYLnk1s0o0dyHY=";
  };

  pnpmRoot = "service";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    pwd
    ls
    cd service
    cp index.js $out
    cp -R node_modules $out

    runHook postInstall
  '';
})
