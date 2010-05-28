inherit git eutils

EGIT_REPO_URI="git://git.becquerel.org/kyuba/curie.git"

DESCRIPTION="Build tool based on curie and intended for curie programmes"
HOMEPAGE="http://becquerel.org/"

LICENSE="MIT"
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
	./build/b-icemake -Lod ${D}/usr icemake ice||die
}

src_install() {
	./build/b-icemake -Lodif ${D}/usr icemake ice||die

	dodoc AUTHORS COPYING CREDITS README
}
