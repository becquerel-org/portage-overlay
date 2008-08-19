inherit eutils

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://hamiltonshells.ca/~jyujin/kyuba/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${P}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ library || die
}

src_test() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ || die
	./run-tests || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ install || die
	dodoc AUTHORS COPYING CREDITS README
}
