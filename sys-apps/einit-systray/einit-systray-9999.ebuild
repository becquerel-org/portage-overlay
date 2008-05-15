# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git

EGIT_REPO_URI="git://git.jyujin.de/einit/extras/systray.git"

DESCRIPTION="Systray-based DM agonstic core manipulation daemon for eINIT"
HOMEPAGE="http://einit.jyujin.de/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=sys-apps/einit-9999
		 x11-libs/libnotify
		 x11-themes/gnome-icon-theme"
DEPEND="${RDEPEND}
		dev-util/scons"

S="${WORKDIR}"/${PN}

src_install() {
	emake DESTDIR="${D}" install
	dosym /usr/bin/einit-systray /lib/einit/bin/einit-systray
}
