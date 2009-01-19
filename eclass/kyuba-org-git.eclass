inherit git

EGIT_REPO_URI="git://git.kyuba.org/${PN}.git"
HOMEPAGE="http://kyuba.org/"

LICENSE="BSD"
KEYWORDS=""
S=${WORKDIR}/${PN}

EXPORT_FUNCTIONS pkg_setup src_unpack

kyuba-org-git_pkg_setup() {
    ewarn
    ewarn "WARNING: This is a live GIT build"
    ewarn
}

kyuba-org-git_src_unpack() {
    git_src_unpack || die
}
