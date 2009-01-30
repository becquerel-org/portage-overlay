inherit git eutils

EGIT_REPO_URI="git://git.kyuba.org/curie.git"

DESCRIPTION="Build tool based on curie and intended for curie programmes"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

S=${WORKDIR}/${PN}

pkg_setup() {
    ewarn
    ewarn "WARNING: This is a live GIT build"
    ewarn
}

src_compile() {
    ./build-icemake.sh -Lod ${D}/usr||die
    ./build/b-icemake -Lod ${D}/usr icemake||die
}

src_install() {
    ./build/b-icemake -Lodif ${D}/usr icemake||die

    dodoc AUTHORS COPYING CREDITS README
}
