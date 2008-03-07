inherit eutils

RESTRICT="nomirror"

DESCRIPTION="acpi daemon with support for netlink and evdev events"
SRC_URI="http://dbservice.com/ftpdir/tom/acpid-ng.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="dev-lang/lua
	sys-apps/dbus
	!sys-power/acpid"
DEPEND="${RDEPEND}"

src_compile() {
	cd acpid
	epatch ${FILESDIR}/fix.patch
	make
}

src_install() {
	cd acpid
	dosbin acpid
	insinto /etc/acpid
	doins *.lua
	insinto /usr/include/acpid
	doins include/acpid/*
	insinto /usr/include/acpid/driver
	doins include/acpid/driver/*
}
