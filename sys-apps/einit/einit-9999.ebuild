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

IUSE="debug doc ( openrc ) +relaxng +scheme testing +xml"

RDEPEND="openrc? ( sys-apps/openrc )
		 !sys-apps/einit-modules-gentoo
		 scheme? ( >=dev-scheme/guile-1.8 )"
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

	if use scheme; then
		if ! built_with_use "dev-scheme/guile" 'threads' ; then
			die "you need to build guile with USE='threads'"
		fi
	fi

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

	if use testing; then
		if use scheme; then
			scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} || die
		else
			scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} scheme=none || die
		fi
	else

		local myconf

		filter-flags "-fomit-frame-pointer"
		filter-ldflags "-Wl,--enable-new-dtags"
		filter-ldflags "-Wl,-z,now"

		pushd ${WORKDIR}/expat-${EXPATVERSION}
			CFLAGS=-fPIC econf
			emake
		popd

		pushd "${S}/"

			myconf="--ebuild --git --prefix=/ --with-expat=${WORKDIR}/expat-${EXPATVERSION}/.libs/libexpat.a --libdir-name=$(get_libdir) --enable-tests"

			if use debug ; then
				local myconf="${myconf} --debug"
			fi
			if use openrc ; then
				myconf="${myconf} --distro-support=gentoo"
			fi
			if use scheme; then
				local myconf="${myconf} --enable-module-scheme-guile"
			fi

			echo ${myconf}
			econf ${myconf} || die
			emake || die

			if use doc ; then
				make documentation || die
			fi

		popd
	fi
}

src_install() {
	if use testing; then
		if use scheme; then
			scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} install || die
		else
			scons libdir=$(get_libdir) destdir=${D}/${ROOT}/ prefix=${ROOT} scheme=none install || die
		fi

		mkdir -p ${D}/${ROOT}/bin
		ln -s ../sbin/einit ${D}/${ROOT}/bin/einit
	else
		pushd "${S}/"
			emake -j1 install DESTDIR="${D}/${ROOT}" || die
			dodoc AUTHORS ChangeLog COPYING
			doman documentation/man/*.8
			keepdir /etc/einit/local
			keepdir /etc/einit/modules
			if use doc ; then
				dohtml build/documentation/html/*
			fi
		popd
	fi
}

src_test() {
	pushd "${S}/"
		emake -j1 test || die
	popd
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
