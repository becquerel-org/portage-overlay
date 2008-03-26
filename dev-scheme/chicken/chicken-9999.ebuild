# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion multilib elisp-common

DESCRIPTION="Chicken is a Scheme interpreter and native Scheme to C compiler"
HOMEPAGE="http://www.call-with-current-continuation.org/"

ESVN_REPO_URI="http://galinha.ucpel.tche.br/svn/chicken-eggs/chicken/trunk"
ESVN_OPTIONS="--username=anonymous --password= --non-interactive"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="emacs"

DEPEND=">=dev-libs/libpcre-7.6
		sys-apps/texinfo
		emacs? ( virtual/emacs )"

SITEFILE=50hen-gentoo.el

pkg_setup() {
	einfo "This is a modified version of the live chicken ebuild"
	einfo "to use in eINIT development, which installs in /$(get_libdir)/einit/chicken"
	einfo "Do not report bugs with this ebuild to b.g.o. !"
}

src_unpack() {
	subversion_fetch || die
	cd "${S}"
	#sed -i -e "s:/lib:/$(get_libdir):g" defaults.make
}

src_compile() {
	unset A

	set > /tmp/envvars

	OPTIONS="PLATFORM=linux PREFIX=/$(get_libdir)/einit/chicken"

	# all this is necessary for bootstrapping from svn. yes, I asked :P
	emake ${OPTIONS} confclean || die
	emake ${OPTIONS} spotless  || die
	emake ${OPTIONS} bootstrap || die
	emake ${OPTIONS} confclean || die
	emake ${OPTIONS} C_COMPILER_OPTIMIZATION_OPTIONS="${CFLAGS}" CHICKEN=./chicken-boot || die

	use emacs && elisp-comp hen.el
}

RESTRICT=test

src_install() {
	# just in case..
	unset A

	emake ${OPTIONS} DESTDIR="${D}" install || die
	dodoc ChangeLog* NEWS
	dohtml -r html/
	rm -rf "${D}"/$(get_libdir)/einit/chicken/share/doc

	keepdir /$(get_libdir)/einit/chicken/lib/chicken/3

	cat > 50chicken <<- EOF
PATH="/$(get_libdir)/einit/chicken/bin"
ROOTPATH="/$(get_libdir)/einit/chicken/bin"
LDPATH="/$(get_libdir)/einit/chicken/lib"
EOF

	doenvd 50chicken

	if use emacs; then
		elisp-install ${PN} *.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi
}

pkg_postinst() {
	ewarn "This ebuild installs /etc/env.d/50chicken to setup its paths."
	ewarn "Remember to remove if you switch to the normal chicken ebuilds!"
	ewarn "If you used the default egg repository path, you will have to"
	ewarn "uninstall and reinstall all eggs. Sorry."
	use emacs && elisp-site-regen
}

pkg_postrm() {
	ewarn "This ebuild installs /etc/env.d/50chicken to setup its paths."
	ewarn "Remember to remove if you switch to the normal chicken ebuilds!"
	ewarn "If you used the default egg repository path, you will have to"
	ewarn "uninstall and reinstall all eggs. Sorry."
	use emacs && elisp-site-regen
}
