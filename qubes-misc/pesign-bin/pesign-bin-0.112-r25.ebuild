# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs rhel

MY_PR=${PVR##*r}
MY_PF=pesign-${PV}-${MY_PR}
SRC_URI="http://mirror.centos.org/centos/8-stream/AppStream/x86_64/os/Packages/${MY_PF}.el8.x86_64.rpm"
DESCRIPTION="Tools for manipulating signed PE-COFF binaries"
HOMEPAGE="https://github.com/rhboot/pesign"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-libs/nspr
	dev-libs/nss
	dev-libs/openssl:0=
	dev-libs/popt
	sys-apps/util-linux
	sys-libs/efivar
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig
"
src_unpack() {
	rpm_unpack ${A} && mkdir $S
}

src_install() {
	rm -rf $D $S
	ln -s ${WORKDIR} ${PORTAGE_BUILDDIR}/image
	rm -rf $D/usr/lib/.build-id
}

pkg_preinst() {
	getent group pesign >/dev/null || groupadd -r pesign
	getent passwd pesign >/dev/null || \
		useradd -r -g pesign -d /run/pesign -s /sbin/nologin \
			-c "Group for the pesign signing daemon" pesign
}
pkg_postinst() {
	certutil -d /etc/pki/pesign/ -X -L > /dev/null
	systemctl enable pesign.service
}

pkg_prerm() {
	systemctl disable pesign.service
}

pkg_postrm() {
	systemctl restart pesign.service
}
