inherit git

EGIT_REPO_URI="git://git.kyuba.org/core.git"

DESCRIPTION="The Kyuba Init Daemons"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc debug"

RDEPEND=">=sys-libs/curie-4
         >=sys-libs/duat-4"

DEPEND="${RDEPEND}
	dev-util/scons"

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

	scons destdir=${D}/ ${scons_params} programme || die
}

src_install() {
	scons_flags

	scons destdir=${D}/ ${scons_params} install || die
	dodoc AUTHORS COPYING CREDITS README
}
