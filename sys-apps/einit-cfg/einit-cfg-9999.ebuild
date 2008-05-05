# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit flag-o-matic git python

EGIT_REPO_URI="git://git.jyujin.de/einit/cfg.git"

DESCRIPTION="eINIT-cfg - the eINIT configuration tool."
HOMEPAGE="http://einit.jyujin.de/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"

IUSE=""

RDEPEND="
	dev-util/scons
	sys-apps/einit
"
DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack || die
	python_version || die
}

src_compile() {
	scons -f buildscript ${MAKEOPTS:--j2} release=1 || die
}

src_install() {
	scons -f buildscript release=1 destdir=${D}/${ROOT}/ libdir=$(get_libdir) install || die

	mkdir -p ${D}/${ROOT}/bin
	ln -s ../$(get_libdir)/einit-cfg/einit-cfg ${D}/${ROOT}/bin/einit-cfg
}

pkg_postinst() {
	einfo
	einfo "Warning: This is highly experimental alpha quality software."
	einfo "Please backup your /etc/einit/modes.xml before using it"
	einfo "and review changes it makes."
	einfo
	einfo "Currently only CLI interface is built."
	einfo "See einit-cfg help for further information."
	einfo
	einfo "Blame & support: squeaky_pl #einit@freenode"
	einfo
}
