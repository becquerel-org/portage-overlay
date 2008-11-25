inherit eutils

DESCRIPTION="Build tool based on curie and intended for curie programmes"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/curie-${PV}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

S=${WORKDIR}/curie-${PV}

src_compile() {
        ./build.sh curie icemake -Ld ${D}/usr ||die
}

src_test() {
        ./build.sh icemake -Ldr ${D}/usr ||die
}

src_install() {
        ./build.sh icemake -Ldif ${D}/usr ||die

        dodoc AUTHORS COPYING CREDITS README
}

