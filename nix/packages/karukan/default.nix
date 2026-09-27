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
    rev = "53775de1b9561269697112f0f3fc8b79783c368c";
    hash = "sha256-AeM60B38BHnNO5VPdqKG4YONVUJ6v8AH0mlsdbPCpJI=";
  };

  cmakeDir = "../karukan-im/fcitx5/fcitx5-addon";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-2PKvzTYMenF8NtsKhP6qt/mMo0E6AgfD6WrZ1tfhQz4=";
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
