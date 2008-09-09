inherit git eutils

EGIT_REPO_URI="git://git.kyuba.org/curie.git"

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="doc"

DEPEND="${RDEPEND}
	dev-util/scons
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
	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man3/*; do
			doman ${i}
		done
	fi
}
