{
  fetchFromGitHub,
  cmake,
  cargo,
  rustPlatform,

  kdePackages,
  fcitx5,
  pkg-config,
  libxkbcommon,
  llvmPackages,
}:
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "karukan";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "togatoga";
    repo = "karukan";
    rev = "9d3ebb1f6d88a1390b3cf0fd70789e37e58a8bad";
    hash = "sha256-3zE5Gr7kNTrGtls+aLL9KuuIsGJqCLN02Tq+s3V6zwY=";
  };

  cmakeDir = "../karukan-im/fcitx5/fcitx5-addon";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-16zjxf5BObxRhvFAVIPsm23wptCuKkx/8KbzmR5wgig=";
  };

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    kdePackages.extra-cmake-modules
    pkg-config
  ];
  buildInputs = [
    fcitx5
    libxkbcommon
    llvmPackages.libclang.lib
  ];
})
