{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "jitsi-meet";
  version = "1.0.4938";

  src = fetchurl {
    url = "https://download.jitsi.org/jitsi-meet/src/jitsi-meet-${version}.tar.bz2";
    sha256 = "1rk56l5wc3nfrigh096ldnb2ysfhvd3jyx2y4czcznk84nyr5w71";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv * $out/
    runHook postInstall
  '';

  passthru.tests = {
    single-host-smoke-test = nixosTests.jitsi-meet;
  };

  meta = with lib; {
    description = "Secure, Simple and Scalable Video Conferences";
    longDescription = ''
      Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge
      to provide high quality, secure and scalable video conferences.
    '';
    homepage = "https://github.com/jitsi/jitsi-meet";
    license = licenses.asl20;
    maintainers = teams.jitsi.members;
    platforms = platforms.all;
  };
}
