{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "girl_technology";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "p0lyw0lf";
    repo = "girl.technology";
    rev = "632efc130d0c3e90c06d6c397e72c9a841d8f046";
    hash = "sha256-13MI9J5LaJloQy+8YhyB8w1cZpMZKNfS3eTc1oKs9uw=";
  };

  cargoHash = "sha256-nTwt21s059C/SV1hAzHkC5HVTDakBJ3fn8RcTvxYYdw=";
}
