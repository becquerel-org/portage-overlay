# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git python flag-o-matic

EGIT_REPO_URI="git://git.jyujin.de/einit/modules/scheme.git"

DESCRIPTION="Scheme modules for eINIT"
HOMEPAGE="http://einit.jyujin.de/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="testing"

RDEPEND=">=sys-apps/einit-0.40.0
		!testing? ( >=dev-scheme/guile-1.8 )
		 testing? ( =dev-scheme/chicken-9999 )"
DEPEND="${RDEPEND}
		dev-util/scons"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use "dev-scheme/guile" 'threads' ; then
		die "you need to build guile with USE='threads'"
	fi
	ewarn
	ewarn "WARNING: This is a live GIT build!!!"
	ewarn
	if use testing; then
		einfo "selected 'testing' GIT branch"
		EGIT_BRANCH='testing'
		EGIT_TREE='testing'
	fi
	strip-flags
	filter-ldflags -Wl,--*dtags* -Wl,*-z*
	if use testing; then
		filter-flags -fomit-frame-pointer
	fi
}

src_unpack() {
	git_src_unpack || die
	python_version || die
}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die
	dodoc README
}
