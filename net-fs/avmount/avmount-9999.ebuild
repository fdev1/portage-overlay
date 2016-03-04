# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == 9999* ]]; then
	inherit eutils autotools git-r3
	EGIT_REPO_URI=(
		"https://github.com/fernando-rodriguez/avmount.git"
		"git://github.com/fernando-rodriguez/avmount.git" )
	KEYWORDS=""
else
	inherit eutils autotools
	SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> avmount-${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

DESCRIPTION="Mount uPnP AV devices as FUSE filesystem"
HOMEPAGE="https://sourceforge.net/projects/djmount/"

LICENSE="GPL-2"
SLOT="0"
IUSE="charset +curl debug +networkmanager systemd"

DEPEND="
	sys-fs/fuse
	sys-libs/talloc
	net-libs/libupnp
	curl? ( >=net-misc/curl-7.45.0 )"
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
	eautoreconf
}

src_configure()
{
	econf \
		$(use_with curl) \
		$(use_enable charset) \
		$(use_enable debug)
}

src_install()
{
	default

	if use systemd; then
		dodir /usr/lib/systemd/system
		insinto /usr/lib/systemd/system
		insopts --mode=644
		doins "${FILESDIR}/avmount.service"

		if use debug; then
			sed -i -e "s:@ARGS@:-d -l /var/log/avmount.log:g" \
				"${ED}/usr/lib/systemd/system/avmount.service" || die
		else
			sed -i -e "s:@ARGS@::g" \
				"${ED}/usr/lib/systemd/system/avmount.service" || die
		fi

		if use networkmanager; then
			dodir /etc/NetworkManager/dispatcher.d
			insinto /etc/NetworkManager/dispatcher.d
			insopts --mode=755
			doins "${FILESDIR}/40-avmount"
		fi
	fi
}
