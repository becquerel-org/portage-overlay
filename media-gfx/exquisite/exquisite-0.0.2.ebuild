inherit eutils

DESCRIPTION="Slick and simple bootsplash daemon"
HOMEPAGE="http://www.enlightenment.org"
SRC_URI="http://www.rasterman.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="x11-libs/evas
         x11-libs/ecore
	 dev-libs/eet
	 dev-libs/embryo
	 media-libs/edje"
DEPEND="${RDEPEND}"

src_compile() {
	if ! built_with_use x11-libs/evas fbcon; then die "need to build evas with support for framebuffer consoles! USE=fbcon"; fi
	if ! built_with_use x11-libs/ecore fbcon; then die "need to build evas with support for framebuffer consoles! USE=fbcon"; fi

	econf \
		--prefix=/ \
		 || die

	emake || die
}

src_install() {
	emake install DESTDIR=${D} || die

	dodoc AUTHORS README NEWS
}

