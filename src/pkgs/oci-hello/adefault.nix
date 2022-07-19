{ pkgs ? import <nixpkgs> { } }:
let
  hello-output = pkgs.runCommand "my-hello" {
    buildInputs = [ pkgs.hello ];
  }
  ''
    mkdir $out
    hello > $out/hello
  '';

in
pkgs.dockerTools.buildImage {
  name = "hello-world-output";
  tag = "0.0.1";

  contents = [ hello-output ];

}
