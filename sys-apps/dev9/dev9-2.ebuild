inherit eutils

DESCRIPTION="udev/devfs workalike, based on Duat"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

DEPEND="${RDEPEND}
	>=sys-libs/curie-4
	>=sys-libs/duat-4
	sys-devel/icemake"

S=${WORKDIR}/${P}

src_compile() {
        icemake -Ld ${D} ||die
}

src_test() {
        icemake -Ldr ${D} ||die
}

src_install() {
        icemake -Ldif ${D} ||die

        dodoc AUTHORS COPYING CREDITS README
}

