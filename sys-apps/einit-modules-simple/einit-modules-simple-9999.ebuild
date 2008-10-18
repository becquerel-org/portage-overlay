# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git python flag-o-matic

EGIT_REPO_URI="git://git.jyujin.de/einit/modules/simple.git"

DESCRIPTION="Simple modules for eINIT"
HOMEPAGE="http://einit.jyujin.de/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="testing"

RDEPEND=">=sys-apps/einit-0.40.0"
DEPEND="${RDEPEND}
		dev-util/scons"

S=${WORKDIR}/${PN}

pkg_setup() {
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
	dodoc AUTHORS COPYING ChangeLog README
}
