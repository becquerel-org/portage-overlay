# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# eINIT GIT ebuild (v2)
#

inherit flag-o-matic git

EXPATVERSION="2.0.1"

EGIT_REPO_URI="git://git.einit.org/core.git"
SRC_URI="mirror://sourceforge/expat/expat-${EXPATVERSION}.tar.gz"

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
# RESTRICT="strip"

IUSE="doc static debug nowtf externalise fbsplash aural noxml baselayout2 noscheme testing stable"

#>=dev-libs/libnl-1.0_pre6

RDEPEND="app-text/rnv
	baselayout2? ( >=sys-apps/baselayout-2.0.0_rc2-r1 )
	!sys-apps/einit-modules-gentoo
	!noscheme? ( >=dev-scheme/guile-1.8 )
        testing? ( dev-util/scons )"
DEPEND="${RDEPEND}
	doc? ( app-text/docbook-sgml app-doc/doxygen )"
PDEPEND="!noxml? ( sys-apps/einit-modules-xml )
         !noscheme? ( sys-apps/einit-modules-scheme )"

S=${WORKDIR}/${PN}

pkg_setup() {
	enewgroup einit
	ewarn
	ewarn "WARNING: This is a live GIT build!!!"
	ewarn "We're currently rewriting the build system in scons, so"
	ewarn "IF THINGS DON'T COMPILE, TELL US!"
	ewarn

	if ! use noscheme; then
		if ! built_with_use "dev-scheme/guile" 'threads' ; then
			die "you need to build guile with USE='threads'"
		fi
	fi


	if use stable; then
		einfo "selected 'stable' GIT branch"
		EGIT_BRANCH='stable'
		EGIT_TREE='stable'
	elif use testing; then
		einfo "selected 'testing' GIT branch"
		EGIT_BRANCH='testing' 
		EGIT_TREE='testing'
	fi

	if [ $(getconf GNU_LIBPTHREAD_VERSION | cut -d " " -f 1) != "NPTL" ]; then
		break;
	fi
}

src_unpack() {
	unpack ${A}
	git_src_unpack
}

src_compile() {

	if use testing; then
		if ! use noscheme; then
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

			if use static ; then
				local myconf="${myconf} --static"
			fi
			if use debug ; then
				local myconf="${myconf} --debug"
			fi
			if use nowtf ; then
				local myconf="${myconf} --nowtf"
			fi
			if use baselayout2 ; then
				myconf="${myconf} --distro-support=gentoo"
			fi
			if use externalise ; then
				local myconf="${myconf} --externalise"
			fi
			if ! use fbsplash ; then
				local myconf="${myconf} --no-feedback-visual-fbsplash"
			fi
			if ! use aural ; then
				local myconf="${myconf} --no-feedback-aural --no-feedback-aural-festival"
			fi

			if ! use noscheme; then
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
		if ! use noscheme; then
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
		einfo
		einfo "Since you had the doc use-flag enabled, you should find the user's guide"
		einfo "in /usr/share/doc/einit-version/html/"
	fi
	einfo
	einfo "You can always find the latest documentation at"
	einfo "http://einit.org/"
	einfo
	if ! use nowtf; then
		einfo "I'm going to run 'einit --wtf' now, to see if there's anything you'll need"
		einfo "to set up."
		einfo
		chroot ${ROOT} /sbin/einit --wtf
		einfo
		einfo "Done; make sure you follow any advice given in the output of the command that"
		einfo "just ran. If you wish to have einit re-evaluate the current state, just run"
		einfo "'/sbin/einit --wtf' in a root-shell near you."
		einfo
	fi
}
