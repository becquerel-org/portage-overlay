inherit git eutils

EGIT_REPO_URI="git://git.jyujin.de/curie.git"

DESCRIPTION="A minimalistic, sexpr-based, non-posix(!) libc"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${PN}

pkg_setup() {
	ewarn
	ewarn "WARNING: This is a live GIT build"
	ewarn
}

src_unpack() {
	git_src_unpack || die
}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ library || die
}

src_test() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ || die
	./run-tests || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ install || die
	dodoc AUTHORS COPYING CREDITS README
}
