{ stdenv, fetchurl, dovecot, openssl }:

stdenv.mkDerivation rec {
  name = "dovecot-pigeonhole-${version}";
  version = "0.5.3";

  src = fetchurl {
    url = "https://pigeonhole.dovecot.org/releases/2.3/dovecot-2.3-pigeonhole-${version}.tar.gz";
    sha256 = "08i6vw6k2v906s4sc6wl9ffpz6blzdga6vglqpqjm7jzq10jfbz0";
  };

  buildInputs = [ dovecot openssl ];

  preConfigure = ''
    substituteInPlace src/managesieve/managesieve-settings.c --replace \
      ".executable = \"managesieve\"" \
      ".executable = \"$out/libexec/dovecot/managesieve\""
    substituteInPlace src/managesieve-login/managesieve-login-settings.c --replace \
      ".executable = \"managesieve-login\"" \
      ".executable = \"$out/libexec/dovecot/managesieve-login\""
  '';

  configureFlags = [
    "--with-dovecot=${dovecot}/lib/dovecot"
    "--without-dovecot-install-dirs"
    "--with-moduledir=$(out)/lib/dovecot"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://pigeonhole.dovecot.org/;
    description = "A sieve plugin for the Dovecot IMAP server";
    license = licenses.lgpl21;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.unix;
  };
}
