# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

EGIT_REPO_URI="git://git.einit.org/modules/xml-sh.git"
SRC_URI=""

DESCRIPTION=".xml modules for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="doc"

RDEPEND=">=sys-apps/einit-0.23.5
	doc? ( app-text/docbook-sgml app-doc/doxygen )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	git_src_unpack
}

src_compile() {
	:
}

src_install() {
	pushd "${S}/"
		CONFIGINSTALLMETHOD="ebuild" DESTDIR="${D}" ./install / $(get_libdir)

		dodoc AUTHORS ChangeLog COPYING
		if use doc ; then
			dohtml build/documentation/html/*
		fi
	popd
}
