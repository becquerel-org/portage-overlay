inherit git

EGIT_REPO_URI="git://git.kyuba.org/${PN}.git"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
KEYWORDS=""
S=${WORKDIR}/${PN}

kyuba_org_git_pkg_setup() {
    ewarn
    ewarn "WARNING: This is a live GIT build"
    ewarn
}

pkg_setup() {
    kyuba_org_git_pkg_setup
}

src_unpack() {
    git_src_unpack || die
}
