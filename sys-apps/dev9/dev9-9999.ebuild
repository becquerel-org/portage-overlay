inherit git

EGIT_REPO_URI="git://git.kyuba.org/dev9.git"

DESCRIPTION="udev/devfs workalike, based on Duat"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc debug"

RDEPEND=">=sys-libs/curie-3
         >=sys-libs/duat-4"

DEPEND="${RDEPEND}
	sys-devel/icemake"

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
}

src_install() {
	icemake ${icemake_flags} -Ldif ${D}/usr ||die

	dodoc AUTHORS COPYING CREDITS README
}
