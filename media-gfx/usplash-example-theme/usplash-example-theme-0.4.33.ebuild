DESCRIPTION="An example theme for usplash"
HOMEPAGE="https://launchpad.net/usplash"
SRC_URI="http://launchpadlibrarian.net/4903370/usplash_0.4-33.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

S=${WORKDIR}/usplash/example-theme

src_compile() {
	make
}

src_install() {
	mkdir -p ${D}/lib/usplash
	cp -a *.so ${D}/lib/usplash

	dodoc README
}

