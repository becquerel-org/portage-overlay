# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

#
# eINIT GIT ebuild (v2)
#

inherit flag-o-matic git python

EGIT_REPO_URI="git://git.einit.org/cfg.git"

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"

IUSE=""

RDEPEND="=sys-apps/einit-9999
		 dev-libs/expat"
DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack
	python_version
}

src_compile() {
	scons destdir=${D}/${ROOT}/usr/ || die
}

src_install() {
	scons destdir=${D}/${ROOT}/usr/ install || die
}
