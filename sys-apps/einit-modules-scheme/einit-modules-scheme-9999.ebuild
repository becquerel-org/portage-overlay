# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git python

EGIT_REPO_URI="git://git.einit.org/modules/scheme.git"
SRC_URI=""

DESCRIPTION="Scheme modules for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND=">=sys-apps/einit-0.40.0
	scheme? ( >=dev-scheme/guile-1.8 )"
DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use "dev-scheme/guile" 'threads' ; then
		die "you need to build guile with USE='threads'"
	fi
}

src_unpack() {
	git_src_unpack
	python_version
}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die
	dodoc README
}
