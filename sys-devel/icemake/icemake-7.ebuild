inherit eutils

DESCRIPTION="Build tool based on curie and intended for curie programmes"
HOMEPAGE="http://becquerel.org/"
SRC_URI="http://becquerel.org/files/curie-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm ~ppc ~x86 ~amd64"
IUSE=""

S=${WORKDIR}/curie-${PV}

src_compile() {
	./build-icemake.sh -Lod ${D}/usr||die
	./build/b-icemake -Lod ${D}/usr icemake||die
}

src_install() {
	./build/b-icemake -Lodif ${D}/usr icemake||die

	dodoc AUTHORS COPYING CREDITS README
}
