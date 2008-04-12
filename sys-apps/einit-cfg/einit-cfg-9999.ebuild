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

RDEPEND="=sys-apps/einit-9999
	 app-text/xmlstarlet"
DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack
	python_version
}

src_compile() {
	scons ${MAKEOPTS:--j2} destdir=${D}/${ROOT}/ || die
}

src_install() {
	scons destdir=${D}/${ROOT}/ install || die
}
