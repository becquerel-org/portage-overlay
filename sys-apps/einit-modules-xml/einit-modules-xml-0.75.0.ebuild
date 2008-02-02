inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.org/"
SRC_URI="mirror://berlios/einit/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

IUSE=""

RDEPEND=">=sys-apps/einit-0.25.0
	doc? ( app-text/docbook-sgml app-doc/doxygen )"
DEPEND="${RDEPEND}"

src_compile() {
	:
}

src_install() {
	pushd "${S}/"
		CONFIGINSTALLMETHOD="ebuild" DESTDIR="${D}" ./install / $(get_libdir)

		dodoc AUTHORS ChangeLog COPYING
		if use doc ; then
			dohtml build/documentation/html/*
		fi
	popd
}

