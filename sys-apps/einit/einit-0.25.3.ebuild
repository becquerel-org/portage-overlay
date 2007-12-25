inherit flag-o-matic

EXPATVERSION="2.0.1"

EGIT_REPO_URI="git://git.einit.org/core.git"
SRC_URI="mirror://sourceforge/expat/expat-${EXPATVERSION}.tar.gz
 mirror://berlios/${PN}/${P}.tar.bz2"

DESCRIPTION="eINIT - an alternate /sbin/init"
HOMEPAGE="http://einit.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
# RESTRICT="strip"

IUSE="doc static debug nowtf externalise aural dbus noxml baselayout2 scheme"

#>=dev-libs/libnl-1.0_pre6

RDEPEND="sys-apps/iproute2
	dbus? ( >=sys-apps/dbus-1.0.2-r2 )
	baselayout2? ( >=sys-apps/baselayout-2.0.0_rc2-r1 )
	scheme? ( >=dev-scheme/guile-1.8 )"
DEPEND="${RDEPEND}
	doc? ( app-text/docbook-sgml app-doc/doxygen )"
PDEPEND="!noxml? ( >=sys-apps/einit-modules-xml-0.75.0 )"

pkg_setup() {
	enewgroup einit
}

src_unpack() {
	unpack ${A}
}

src_compile() {
	local myconf

	filter-ldflags "-Wl,--enable-new-dtags"
	filter-ldflags "-Wl,-z,now"

	pushd ${WORKDIR}/expat-${EXPATVERSION}
		CFLAGS=-fPIC econf
		emake
	popd

	pushd "${S}/"

		myconf="--ebuild --prefix=/ --with-expat=${WORKDIR}/expat-${EXPATVERSION}/.libs/libexpat.a --libdir-name=$(get_libdir) --enable-tests"

		if use static ; then
			local myconf="${myconf} --static"
		fi
		if use debug ; then
			local myconf="${myconf} --debug"
		fi
		if use nowtf ; then
			local myconf="${myconf} --nowtf"
		fi
		if use dbus ; then
			myconf="${myconf} --enable-ipc-dbus"
		fi
		if use baselayout2 ; then
			myconf="${myconf} --distro-support=gentoo"
		fi
		if use externalise ; then
			local myconf="${myconf} --externalise"
		fi
		if ! use aural ; then
			local myconf="${myconf} --no-feedback-aural --no-feedback-aural-festival"
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
}

src_install() {
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
