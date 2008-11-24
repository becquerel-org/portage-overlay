inherit eutils

DESCRIPTION="Communications library (9P2000, etc) based on Curie"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

DEPEND="${RDEPEND}
	>=sys-libs/curie-4
	sys-devel/icemake
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
        icemake -Ld ${D}/usr ||die

        if use doc; then
                doxygen
        fi
}

src_test() {
        icemake -Ldr ${D}/usr ||die
}

src_install() {
        icemake -Ldif ${D}/usr ||die

        dodoc AUTHORS COPYING CREDITS README

        if use doc; then
                for i in documentation/doxygen/man/man5/*; do
                        doman ${i}
                done
        fi
}

