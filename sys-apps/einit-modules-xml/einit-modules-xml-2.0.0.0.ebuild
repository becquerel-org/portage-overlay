# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

SRC_URI="http://einit.org/files/einit-modules-xml-2.0.0.0.tar.bz2"

DESCRIPTION=".xml modules for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

RDEPEND=">=sys-apps/einit-0.40.0"
DEPEND="${RDEPEND}
		dev-util/scons"

src_unpack() {
	unpack ${A} || die
	python_version || die
}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die
	dodoc AUTHORS COPYING ChangeLog README || die
}
