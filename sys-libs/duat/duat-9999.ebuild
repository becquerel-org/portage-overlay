inherit git eutils

EGIT_REPO_URI="git://git.kyuba.org/duat.git"

DESCRIPTION="Communications library (9P2000, etc) based on Curie"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=sys-libs/curie-5"

DEPEND="${RDEPEND}
	sys-devel/icemake
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${PN}

pkg_setup() {
	ewarn
	ewarn "WARNING: This is a live GIT build"
	ewarn
}

src_unpack() {
	git_src_unpack || die
}

src_compile() {
	icemake ${icemake_flags} -Ld ${D}/usr ||die

	if use doc; then
		doxygen
	fi
}

src_install() {
	icemake ${icemake_flags} -Ldif ${D}/usr ||die

	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man5/*; do
			doman ${i}
		done
	fi
}
