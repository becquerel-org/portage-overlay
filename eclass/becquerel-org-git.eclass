inherit git

EGIT_REPO_URI="git://git.becquerel.org/${PN}.git"
HOMEPAGE="http://becquerel.org/"

LICENSE="MIT"
KEYWORDS=""
S=${WORKDIR}/${PN}

EXPORT_FUNCTIONS pkg_setup src_unpack

becquerel-org-git_pkg_setup() {
	ewarn
	ewarn "WARNING: This is a live GIT build"
	ewarn
}

becquerel-org-git_src_unpack() {
	git_src_unpack || die
}
