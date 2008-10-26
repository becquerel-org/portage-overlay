inherit git eutils

EGIT_REPO_URI="git://git.kyuba.org/curie.git"

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc debug valgrind"

DEPEND="${RDEPEND}
	dev-util/scons
        doc? ( app-doc/doxygen )
	valgrind? ( dev-util/valgrind )"

S=${WORKDIR}/${PN}

pkg_setup() {
	ewarn
	ewarn "WARNING: This is a live GIT build"
	ewarn
}

scons_flags() {
	scons_params=""

	if use debug; then
		scons_params="${scons_params} debug=yes"
	fi

	if use valgrind; then
		scons_params="${scons_params} debugMemory=yes"
	fi
}

src_unpack() {
	git_src_unpack || die
}

src_compile() {
	scons_flags

	scons libdir=$(get_libdir) destdir=${D}/ ${scons_params} library || die
        scons libdir=$(get_libdir) destdir=${D}/ ${scons_params} library++ || die

	if use doc; then
		doxygen
	fi
}

src_test() {
	scons_flags

	scons libdir=$(get_libdir) destdir=${D}/ ${scons_params} || die
	./run-tests || die
}

src_install() {
	scons_flags

	scons libdir=$(get_libdir) destdir=${D}/ ${scons_params} install || die
        scons libdir=$(get_libdir) hosted=yes destdir=${D}/ ${scons_params} install || die

	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man3c/*; do
			doman ${i}
		done
	fi
}
