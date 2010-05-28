inherit eutils

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://becquerel.org/"
SRC_URI="http://becquerel.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

DEPEND="dev-util/scons"

S=${WORKDIR}/${P}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/ library || die
}

src_test() {
	scons libdir=$(get_libdir) destdir=${D}/ || die
	./run-tests || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/ install || die
	dodoc AUTHORS COPYING CREDITS README
}
