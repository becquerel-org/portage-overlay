inherit git eutils

EGIT_REPO_URI="git://git.kyuba.org/curie.git"

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!), non-ansi(!) libc"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc debug valgrind"

DEPEND="${RDEPEND}
	>=sys-devel/icemake-6
	doc? ( app-doc/doxygen )
	valgrind? ( dev-util/valgrind )"

S=${WORKDIR}/${PN}

pkg_setup() {
	ewarn
	ewarn "WARNING: This is a live GIT build"
	ewarn
}

icemake_flags() {
	icemake_params=""

	if use debug; then
		icemake_params="${icemake_params} -D"
	fi

	if use valgrind; then
		icemake_params="${icemake_params} -V"
	fi
}

src_unpack() {
	git_src_unpack || die
}

src_compile() {
	icemake_flags

	icemake curie curie++ syscall ${icemake_flags}  -Ld ${D}/usr ||die

	if use doc; then
		doxygen
	fi
}

src_test() {
	icemake_flags

	icemake curie curie++ syscall ${icemake_flags} -Ldr ${D}/usr ||die
}

src_install() {
	icemake_flags

	icemake curie curie++ syscall ${icemake_flags} -Ldif ${D}/usr ||die

	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/*/*; do
			doman ${i}
		done
	fi
}
