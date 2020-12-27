{ stdenv, lib, buildGoPackage, fetchFromGitHub, go, systemd, makeWrapper }:

buildGoPackage rec {
  pname = "exim_exporter";
  version = "1.1.0";
  rev = "c8212ea687bcf4444ff000f8868691c23d6be366";

  goPackagePath = "github.com/gvengel/exim_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "pkern";
    repo = "exim_exporter";
    sha256 = "09i8lmbx1s415x5rhihi5am4j2q1zsvnl9ds02gcn31mxfdmsmrx";
  };

  buildFlagsArray = ''
    -ldflags=
        -X github.com/prometheus/common/version.Version=${version}
        -X github.com/prometheus/common/version.Revision=${rev}
        -X github.com/prometheus/common/version.Branch=${rev}
        -X main.goVersion=${lib.getVersion go}
  '';


  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ systemd ];

  goDeps = ./exim-exporter-deps.nix;

  postInstall = ''
    wrapProgram $out/bin/exim_exporter \
      --prefix LD_LIBRARY_PATH : "${lib.getLib systemd}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Export Exim metrics to Prometheus";
    homepage = "https://github.com/gvengel/exim_exporter";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
