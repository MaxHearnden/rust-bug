{ lib, mdbook-linkcheck, openssl, pkg-config, rust, rustPlatform, stdenv }:

rustPlatform.buildRustPackage {
  pname = "mdbook-linkcheck-dump";
  version = "0.7.7";

  src = mdbook-linkcheck.src;

  cargoHash = "sha256-Ntrb0jkhz8zl39l7DRQe54WsaDfRK5yBGetS5ltVtJk=";

  buildPhase = ''
    cargoBuildHook
    mkdir -p $out
    for output in mir llvm-ir asm; do
      (
      set -x
      cargo rustc --frozen -p tokio --target \
        ${rust.toRustTargetSpec stdenv.hostPlatform} --release -- --emit \
        $output=$out/tokio.$output
      )
    done
    cargoInstallPostBuildHook
  '';

  installPhase = ''
    cp $bins $out
  '';

  dontCargoInstall = true;

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  OPENSSL_NO_VENDOR = 1;

  doCheck = false;
}
