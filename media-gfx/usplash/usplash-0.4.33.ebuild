DESCRIPTION="Slick and simple bootsplash daemon"
HOMEPAGE="https://launchpad.net/usplash"
SRC_URI="http://launchpadlibrarian.net/4903370/usplash_0.4-33.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

S=${WORKDIR}/${PN}

src_compile() {
	make
}

src_install() {
	emake install DESTDIR=${D} || die

	mkdir ${D}/var/lib/usplash
	mkfifo ${D}/var/lib/usplash/usplash_fifo

	dodoc AUTHORS
}

