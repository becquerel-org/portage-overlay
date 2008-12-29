inherit git

EGIT_REPO_URI="git://git.kyuba.org/core.git"

DESCRIPTION="The Kyuba Init Daemons"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc debug"

RDEPEND=">=sys-libs/curie-6
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
	icemake ${icemake_flags} -Ld ${D}||die
}

src_install() {
	icemake ${icemake_flags} -Ldib ${D} kyu||die

	dodoc AUTHORS COPYING CREDITS README
}
