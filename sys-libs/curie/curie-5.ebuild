inherit eutils

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://becquerel.org/"
SRC_URI="http://becquerel.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

DEPEND="${RDEPEND}
	sys-devel/icemake
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
        icemake curie curie++ -Ld ${D}/usr ||die

        if use doc; then
                doxygen
        fi
}

src_test() {
        icemake curie curie++ -Ldr ${D}/usr ||die
}

src_install() {
        icemake curie curie++ -Ldif ${D}/usr ||die

        dodoc AUTHORS COPYING CREDITS README

        if use doc; then
                for i in documentation/doxygen/man/man3c/*; do
                        doman ${i}
                done
        fi
}

