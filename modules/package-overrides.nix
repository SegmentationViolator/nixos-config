{...}:

let
  stremio-service = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/sparky3387/nixpkgs/5fee36f0a9aec7edbbf071246e9acf1d02f548b1/pkgs/by-name/st/stremio-service/package.nix";
    sha256 = "sha256:19h76c7wlqk58j057wz7cghbwhr7fk2rda9cikaihv0z0in1jvih";
  };
in
{
  nixpkgs.config.packageOverrides = pkgs: {
    stremio-service = pkgs.callPackage stremio-service {};
  };
}
