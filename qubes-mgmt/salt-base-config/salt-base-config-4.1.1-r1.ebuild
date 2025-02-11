EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit eutils multilib python-single-r1 qubes

KEYWORDS="amd64"
HOMEPAGE="http://www.qubes-os.org"
LICENSE="GPLv2"

SLOT="0"
IUSE="pandoc-bin"

DEPEND=""
        
RDEPEND="qubes-mgmt/salt
	qubes-mgmt/salt-base-topd
	"

PDEPEND=""

src_compile() {
	export PYTHONDONTWRITEBYTECODE=
	emake DESTDIR="${D}" LIBDIR=/usr/$(get_libdir) BINDIR=/usr/bin SBINDIR=/usr/sbin SYSCONFDIR=/etc PYTHON="/usr/bin/python3"
}

src_install() {
	emake install DESTDIR="${D}" LIBDIR=/usr/$(get_libdir) BINDIR=/usr/bin SBINDIR=/usr/sbin SYSCONFDIR=/etc PYTHON="/usr/bin/python3"
	fowners root:root /srv/salt/qubes && fperms 750 /srv/salt/qubes
}

pkg_postinst() {
	# disable formula which used to be in this package
	rm -f /srv/salt/_tops/base/config.top
	rm -f /srv/pillar/_tops/base/config.top
	rm -f /srv/pillar/_tops/base/config.modules.top
	rm -f /srv/pillar/_tops/dom0/config.top
	rm -f /srv/pillar/_tops/dom0/config.modules.top
}
