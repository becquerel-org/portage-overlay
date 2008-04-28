# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

#
# eINIT GIT ebuild (v2)
#

inherit eutils git python flag-o-matic

EGIT_REPO_URI="git://git.jyujin.de/einit/core.git"

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.jyujin.de/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"

IUSE="debug +relaxng testing scheme"

DEPEND="${RDEPEND}
		dev-util/scons"
PDEPEND="=sys-apps/einit-modules-simple-9999
		 relaxng? ( app-text/rnv )
		 scheme? ( =sys-apps/einit-modules-scheme-9999 )"

S=${WORKDIR}/${PN}

pkg_setup() {
	strip-flags
	filter-ldflags -Wl,--*dtags* -Wl,*-z*

	enewgroup einit
	ewarn
	ewarn "WARNING: This is a live GIT build!!!"
	ewarn

	if use testing; then
		einfo "selected 'testing' GIT branch"
		EGIT_BRANCH='testing'
		EGIT_TREE='testing'
	fi

	if ! use testing && \
		[[ $(getconf GNU_LIBPTHREAD_VERSION | cut -d " " -f 1) != "NPTL" ]]; then
		die "eINIT needs NPTL threading."
	fi

	if use debug; then
		CFLAGS="${CFLAGS} -g"
	fi
}

src_unpack() {
	git_src_unpack || die
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
	einfo "You can always find the latest documentation at"
	einfo "http://einit.jyujin.de/"
	einfo
}
