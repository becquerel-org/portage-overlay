# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python

SRC_URI="http://einit.org/files/einit-modules-scheme-1.0.0.1.tar.bz2"

DESCRIPTION="Scheme modules for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

RDEPEND=">=sys-apps/einit-0.40.0
		 >=dev-scheme/guile-1.8"
DEPEND="${RDEPEND}
		dev-util/scons"

pkg_setup() {
	if ! built_with_use "dev-scheme/guile" 'threads' ; then
		die "you need to build guile with USE='threads'"
	fi
}

src_unpack() {
	unpack ${A} || die
	python_version || die
}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die
	dodoc README || die
}
