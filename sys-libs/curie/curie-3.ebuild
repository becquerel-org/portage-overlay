inherit eutils

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

DEPEND="${RDEPEND}
	dev-util/scons
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ library || die
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ library++ || die

	if use doc; then
		doxygen
	fi
}

src_test() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ || die
	./run-tests || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ install || die
	scons libdir=$(get_libdir) hosted=yes destdir=${D}/${ROOT}/ install || die

	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man3c/*; do
			doman ${i}
		done
	fi
}
