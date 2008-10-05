DESCRIPTION="udev/devfs workalike, based on Duat"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="doc"

RDEPEND=">=sys-libs/curie-3
         >=sys-libs/duat-3"

DEPEND="${RDEPEND}
        dev-util/scons"

src_compile() {
	scons destdir=${D}/${ROOT}/ programme || die
}

src_install() {
	scons destdir=${D}/${ROOT}/ install || die
	dodoc AUTHORS COPYING CREDITS README
}

