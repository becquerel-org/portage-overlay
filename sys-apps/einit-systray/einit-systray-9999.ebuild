# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git

EGIT_REPO_URI="git://git.einit.org/extras/systray.git"
SRC_URI=""

DESCRIPTION="Libnotify based feedback daemon for eINIT"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND=">=sys-apps/einit-9999
	x11-libs/libnotify
	x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
		dev-util/scons"

S=${WORKDIR}/${PN}

src_unpack() {
	git_src_unpack
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
