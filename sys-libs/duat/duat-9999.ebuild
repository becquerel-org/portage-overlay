inherit git eutils

EGIT_REPO_URI="git://git.kyuba.org/duat.git"

DESCRIPTION="Communications library (9P2000, etc) based on Curie"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc debug"

RDEPEND=">=sys-libs/curie-2"

DEPEND="${RDEPEND}
	dev-util/scons
        doc? ( app-doc/doxygen )"

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
}

src_unpack() {
	git_src_unpack || die
}

src_compile() {
	scons_flags

	scons libdir=$(get_libdir) destdir=${D}/ ${scons_params} library || die

	if use doc; then
		doxygen
	fi
}

src_install() {
	scons_flags

	scons libdir=$(get_libdir) destdir=${D}/ ${scons_params} install || die
	dodoc AUTHORS COPYING CREDITS README

	if use doc; then
		for i in documentation/doxygen/man/man5/*; do
			doman ${i}
		done
	fi
}
