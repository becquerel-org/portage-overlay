# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils python

SRC_URI="http://einit.org/files/einit-0.40.0.tar.bz2"

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"

IUSE="debug doc +relaxng"

RDEPEND="!sys-apps/einit-modules-gentoo"
DEPEND="${RDEPEND}
		doc? ( app-text/docbook-sgml app-doc/doxygen )
		dev-util/scons"
PDEPEND=">=sys-apps/einit-modules-xml-2.0.0.0
		 >=sys-apps/einit-modules-scheme-1.0.0.0
		 relaxng? ( app-text/rnv )"

pkg_setup() {
	enewgroup einit || die
	if [ $(getconf GNU_LIBPTHREAD_VERSION | cut -d " " -f 1) != "NPTL" ]; then
		break;
	fi
}

src_unpack() {
	unpack ${A} || die
	python_version || die
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

	doman documentation/man/*.8
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
