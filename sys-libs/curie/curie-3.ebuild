inherit eutils

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://becquerel.org/"
SRC_URI="http://becquerel.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

DEPEND="${RDEPEND}
	dev-util/scons
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/ library || die
	scons libdir=$(get_libdir) destdir=${D}/ library++ || die

	if use doc; then
		doxygen
	fi
}

src_test() {
	scons libdir=$(get_libdir) destdir=${D}/ || die
	./run-tests || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/ install || die
	scons libdir=$(get_libdir) hosted=yes destdir=${D}/ install || die

	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man3c/*; do
			doman ${i}
		done
	fi
}
