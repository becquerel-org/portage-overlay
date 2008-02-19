# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

<<<<<<< HEAD:sys-apps/einit-cfg/einit-cfg-9999.ebuild
inherit flag-o-matic git python
=======
inherit git python
>>>>>>> d61f0e0db98c2834869f311dc77f6da3064ef356:sys-apps/einit-cfg/einit-cfg-9999.ebuild

EGIT_REPO_URI="git://git.einit.org/cfg.git"

DESCRIPTION="eINIT-cfg - the eINIT configuration tool."
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"

IUSE=""

<<<<<<< HEAD:sys-apps/einit-cfg/einit-cfg-9999.ebuild
RDEPEND="=sys-apps/einit-9999
	 app-text/xmlstarlet"
DEPEND="${RDEPEND}"
=======
DEPEND="dev-libs/expat"
RDEPEND="${DEPEND}
		 =sys-apps/einit-9999"
>>>>>>> d61f0e0db98c2834869f311dc77f6da3064ef356:sys-apps/einit-cfg/einit-cfg-9999.ebuild

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
