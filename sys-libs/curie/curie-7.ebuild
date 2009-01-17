inherit eutils

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://kyuba.org/"
SRC_URI="http://kyuba.org/files/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="doc"

DEPEND="${RDEPEND}
	>=sys-devel/icemake-6
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${P}

src_compile() {
        icemake curie curie++ syscall -Ld ${D}/usr ||die

        if use doc; then
                doxygen
        fi
}

src_test() {
        icemake curie curie++ syscall -Ldr ${D}/usr ||die
}

src_install() {
        icemake curie curie++ syscall -Ldif ${D}/usr ||die

        dodoc AUTHORS COPYING CREDITS README

        if use doc; then
                for i in documentation/doxygen/man/*/*; do
                        doman ${i}
                done
        fi
}

