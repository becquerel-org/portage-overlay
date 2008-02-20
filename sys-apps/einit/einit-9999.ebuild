# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

#
# eINIT GIT ebuild (v2)
#

inherit flag-o-matic git python

EXPATVERSION="2.0.1"

EGIT_REPO_URI="git://git.einit.org/core.git"
SRC_URI="mirror://sourceforge/expat/expat-${EXPATVERSION}.tar.gz"

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"

IUSE="debug doc openrc +relaxng +scheme testing +xml"

RDEPEND="openrc? ( sys-apps/openrc )
		 !sys-apps/einit-modules-gentoo"
DEPEND="${RDEPEND}
		doc? ( app-text/docbook-sgml app-doc/doxygen )
		testing? ( dev-util/scons )"
PDEPEND="xml? ( sys-apps/einit-modules-xml )
		 scheme? ( sys-apps/einit-modules-scheme )
		 relaxng? ( app-text/rnv )"

S=${WORKDIR}/${PN}

pkg_setup() {
	enewgroup einit
	ewarn
	ewarn "WARNING: This is a live GIT build!!!"
	ewarn "We're currently rewriting the build system in scons, so"
	ewarn "IF THINGS DON'T COMPILE, TELL US!"
	ewarn

	if use testing; then
		einfo "selected 'testing' GIT branch"
		EGIT_BRANCH='testing'
		EGIT_TREE='testing'
	fi

	if [ $(getconf GNU_LIBPTHREAD_VERSION | cut -d " " -f 1) != "NPTL" ]; then
		break;
	fi
	if use testing; then
		python_version
	fi
}

src_unpack() {
	unpack ${A}
	git_src_unpack
}

src_compile() {

	scons ${MAKEOPTS:--j2} libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
}

src_install() {
	scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die

	mkdir -p ${D}/${ROOT}/bin
	ln -s ../sbin/einit ${D}/${ROOT}/bin/einit
	ln -s ../$(get_libdir)/einit/bin/einit-log ${D}/${ROOT}/bin/einit-log
	ln -s ../$(get_libdir)/einit/bin/einit-feedback ${D}/${ROOT}/bin/einit-feedback
}

pkg_postinst() {
	einfo
	einfo "eINIT is now installed, but you will still need to configure it."
	einfo
	einfo "To use einit as a non-root user, add that user to the group 'einit'."
	einfo
	if use doc ; then
		einfo "Since you had the doc use-flag enabled, you should find the user's guide"
		einfo "in /usr/share/doc/einit-version/html/"
		einfo
	fi
	einfo "You can always find the latest documentation at"
	einfo "http://einit.org/"
	einfo
}
