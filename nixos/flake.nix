{
  description = "Remote server images";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    girl-technology.url = "github:p0lyw0lf/girl.technology";
    girl-technology.inputs.nixpkgs.follows = "nixpkgs";
    rc-wolfgirl-dev.url = "github:p0lyw0lf/crossposter";
    rc-wolfgirl-dev.inputs.nixpkgs.follows = "nixpkgs";
    dotl-bud.url = "github:p0lyw0lf/DotL-Bud?ref=discordpy-v2";
    dotl-bud.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Load the blueprint
  outputs = inputs: inputs.blueprint { inherit inputs; };
}
