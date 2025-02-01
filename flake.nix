{
  description = "DevOps";

  inputs = {
    flake-parts.url = github:hercules-ci/flake-parts;
    nixpkgs-lib.url = github:nix-community/nixpkgs.lib/master;
    nixpkgs.url = github:NixOS/nixpkgs/master;

    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
  };


  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { config, lib, self', inputs', system, ... }:
        let
          overlays = [];
          pkgs = import nixpkgs {
            inherit system overlays;
          };

          # utils
          utilsPkgs = with pkgs; [
            kubectl
            kustomize
            (wrapHelm kubernetes-helm {
              plugins = with pkgs.kubernetes-helmPlugins; [
                helm-secrets
                helm-diff
                helm-git
              ];
            })
            yamllint
            yamlfix
            yq-go
          ];

          buildDevShell = extraPackages: pkgs.mkShell {
            packages = utilsPkgs ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.autoPatchelfHook ];
            shellHook = ''
            '';
          };
          defaultDevShell = buildDevShell [ ];
        in
        {
          devShells.default = defaultDevShell;
        };
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      flake = { };
    };
}
