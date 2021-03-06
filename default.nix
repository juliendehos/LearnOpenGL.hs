with (builtins.fromJSON (builtins.readFile ./nixpkgs.json));
{
  pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  }) {}
}:
with pkgs.haskell.lib;
let
  app = pkgs.haskellPackages.callCabal2nix "opengl-exp" ./. {};
  buildDemo = name:
    let
      pkg = pkgs.haskellPackages.callCabal2nix name (./GettingStarted + ("/" + name)) {};
    in
      pkg.overrideAttrs (drv: {
        postInstall = ''
          mkdir -p $out/img
          if [ -f ${drv.src}/frag.glsl ]; then
            cp -v ${drv.src}/*.glsl $out
          fi
          if [ -d ${drv.src}/img ]; then
            cp -v ${drv.src}/img/* $out/img
          fi
        '';
      });
  myPkgs = {
     HelloWindow       = buildDemo "HelloWindow";
     HelloTriangle     = buildDemo "HelloTriangle";
     HelloTriangle-Ex1 = buildDemo "HelloTriangle-Ex1";
     HelloTriangle-Ex2 = buildDemo "HelloTriangle-Ex2";
     HelloTriangle-Ex3 = buildDemo "HelloTriangle-Ex3";
     HelloTriangle-Idx = buildDemo "HelloTriangle-Idx";
     ShadersEx1        = buildDemo "ShadersEx1";
     ShadersEx2        = buildDemo "ShadersEx2";
     ShadersEx3        = buildDemo "ShadersEx3";
     Textures          = buildDemo "Textures";
     Textures-Colored  = buildDemo "Textures-Colored";
     Textures-Happy    = buildDemo "Textures-Happy";
     Textures-Ex1      = buildDemo "Textures-Ex1";
     Textures-Ex2      = buildDemo "Textures-Ex2";
     Textures-Ex3      = buildDemo "Textures-Ex3";
     Textures-Ex4      = buildDemo "Textures-Ex4";
     Transformations   = buildDemo "Transformations";
     Transformations-Spin = buildDemo "Transformations-Spin";
     CoordinateSystems = buildDemo "CoordinateSystems";
     CoordinateSystems-Ex1 = buildDemo "CoordinateSystems-Ex1";
     Camera = buildDemo "Camera";
     Camera-Ex1 = buildDemo "Camera-Ex1";
     Camera-Ex2 = buildDemo "Camera-Ex2";
  };
in
  with myPkgs;
{
  inherit app pkgs;
  demo = pkgs.writeScriptBin "demo" ''
    cd ${HelloTriangle}      && ./bin/HelloTriangle
    cd ${HelloTriangle-Ex1}  && ./bin/HelloTriangle-Ex1
    cd ${HelloTriangle-Ex2}  && ./bin/HelloTriangle-Ex2
    cd ${HelloTriangle-Ex3}  && ./bin/HelloTriangle-Ex3
    cd ${HelloTriangle-Idx}  && ./bin/HelloTriangle-Idx
    cd ${ShadersEx1}         && ./bin/ShadersEx1
    cd ${ShadersEx2}         && ./bin/ShadersEx2
    cd ${ShadersEx3}         && ./bin/ShadersEx3
    cd ${Textures}           && ./bin/Textures
    cd ${Textures-Colored}   && ./bin/Textures-Colored
    cd ${Textures-Happy}     && ./bin/Textures-Happy
    cd ${Textures-Ex1}       && ./bin/Textures-Ex1
    cd ${Textures-Ex2}       && ./bin/Textures-Ex2
    cd ${Textures-Ex3}       && ./bin/Textures-Ex3
    cd ${Textures-Ex4}       && ./bin/Textures-Ex4
    cd ${Transformations}    && ./bin/Transformations
    cd ${Transformations-Spin} && ./bin/Transformations-Spin
    cd ${CoordinateSystems} && ./bin/CoordinateSystems
    cd ${CoordinateSystems-Ex1} && ./bin/CoordinateSystems-Ex1
    cd ${Camera} && ./bin/Camera
    cd ${Camera-Ex1} && ./bin/Camera-Ex1
    cd ${Camera-Ex2} && ./bin/Camera-Ex2
  '';
}
