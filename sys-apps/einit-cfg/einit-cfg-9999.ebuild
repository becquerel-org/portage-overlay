# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit git python

EGIT_REPO_URI="git://git.einit.org/cfg.git"

DESCRIPTION="eINIT-cfg - the eINIT configuration tool."
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"

IUSE=""

DEPEND="dev-libs/expat"
RDEPEND="${DEPEND}
		 =sys-apps/einit-9999"

src_unpack() {
	git_src_unpack
	python_version
}

src_compile() {
	scons destdir=${D}/${ROOT}/ || die
}

src_install() {
	scons destdir=${D}/${ROOT}/ install || die
}
