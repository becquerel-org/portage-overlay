inherit eutils

DESCRIPTION="Communications library (9P2000, etc) based on Curie"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

RDEPEND=">=sys-libs/curie-3"

DEPEND="${RDEPEND}
	dev-util/scons
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ library || die

	if use doc; then
		doxygen
	fi
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ install || die
	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man5/*; do
			doman ${i}
		done
	fi
}
