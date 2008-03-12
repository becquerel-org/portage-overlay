# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git python

EGIT_REPO_URI="git://git.einit.org/event-servers.git"
SRC_URI=""

DESCRIPTION="External binary based services for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND=">=sys-apps/einit-9999"
DEPEND="${RDEPEND}
		dev-util/scons"

S=${WORKDIR}/${PN}

src_unpack() {
	git_src_unpack
	python_version
}

src_compile() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die
	#dodoc AUTHORS COPYING ChangeLog README
}
