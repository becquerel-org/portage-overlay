inherit git

EGIT_REPO_URI="git://git.kyuba.org/dev9.git"

DESCRIPTION="udev/devfs workalike, based on Duat"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="doc"

RDEPEND=">=sys-libs/curie-3
         >=sys-libs/duat-3"

DEPEND="${RDEPEND}
	dev-util/scons"

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
	scons destdir=${D}/${ROOT}/ programme || die
}

src_install() {
	scons destdir=${D}/${ROOT}/ install || die
	dodoc AUTHORS COPYING CREDITS README
}
