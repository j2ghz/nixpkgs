{ callPackage
, fetchgit
, lib
, stdenv
, fetchurl
, nixos
, testers
, git
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luvi";
  version = "2.14.0";

  src = fetchgit {
    url = "https://github.com/luvit/luvi.git";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-Qa4Hoa8+y7PAxK4DkHPH7mNRECTKLMjhqf+EHfncbKM=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };
  
  configureScript = "make regular";
  nativeBuildInputs = [ git cmake ];
  
  doCheck = true;
  checkPhase = ''
    pushd ..
    make test
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -p luvi $out/bin/luvi
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/luvi --help";  

  meta = with lib; {
    description = "A project in-between luv and luvit";
    longDescription = ''
      A project in-between luv and luvit.

      The goal of this is to make building luvit and derivatives much easier.
    '';
    homepage = "https://github.com/luvit/luvi";
    changelog = "https://github.com/luvit/luvi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.all;
  };
})
