# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Mount uPnP AV devices as FUSE filesystem"
HOMEPAGE="https://sourceforge.net/projects/djmount/"
SRC_URI="http://downloads.sourceforge.net/project/djmount/djmount/0.71/djmount-0.71.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+networkmanager -system-libupnp"

DEPEND="
	sys-fs/fuse
	system-libupnp? ( net-libs/libupnp )
	"
RDEPEND="${DEPEND}"

pkg_setup()
{
	if [ ! -d /upnp ]; then
		mkdir -p /upnp
		chattr +i /upnp
	fi
}

src_prepare()
{
	epatch "${FILESDIR}/djmount-0.71-hide-devices-file.patch"
	if use system-libupnp; then
		rm -rf libupnp/*/{src,inc} libupnp/configure
	fi
}

src_configure()
{
	econf $(with_use system-libupnp --with-external-libupnp)
}

src_install()
{
	default
	dodir /usr/lib/systemd/system
	insinto /usr/lib/systemd/system
	insopts --mode=644
	doins "${FILESDIR}/djmount.service"
	doins "${FILESDIR}/djmount-keep-alive.service"
	doins "${FILESDIR}/djmount-keep-alive.timer"

	if use networkmanager; then
		dodir /etc/NetworkManager/dispatcher.d
		insinto /etc/NetworkManager/dispatcher.d
		insopts --mode=755
		doins "${FILESDIR}/40-djmount"
	fi
}
