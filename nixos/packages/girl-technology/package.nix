{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "girl_technology";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "p0lyw0lf";
    repo = "girl.technology";
    rev = "47d11d678f1fb2817d95bf5ca0854034dc05b35e";
    hash = "sha256-cbSGAhp9mpIKtD1XQ8/jyPDvWa615jgX/yTNC2AqV5M=";
  };

  cargoHash = "sha256-90dbFYXdPQxP07Z0aZ5++1KgUIkPxTVPyi255cyo2nA=";
}
