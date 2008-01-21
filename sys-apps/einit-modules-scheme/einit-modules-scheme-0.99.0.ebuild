inherit git

EGIT_REPO_URI="git://git.einit.org/modules/scheme.git"
SRC_URI=""

DESCRIPTION="Scheme modules for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="doc"

RDEPEND=">=sys-apps/einit-0.23.5"
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.1.2-r11"

S=${WORKDIR}/${PN}

src_unpack() {
	git_src_unpack
}

src_compile() {
	:
}

src_install() {
	pushd "${S}/"
		CONFIGINSTALLMETHOD="ebuild" DESTDIR="${D}" ./install / $(get_libdir)

		dodoc AUTHORS ChangeLog COPYING
	popd
}
