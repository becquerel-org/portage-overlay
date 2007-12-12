DESCRIPTION="Slick and simple bootsplash daemon"
HOMEPAGE="http://labs.o-hand.com/psplash/"
SRC_URI="http://labs.o-hand.com/sources/psplash/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

src_compile() {
	econf \
		--prefix=/ \
		 || die

	emake || die
}

src_install() {
	emake install DESTDIR=${D} || die

	dodoc AUTHORS
}

