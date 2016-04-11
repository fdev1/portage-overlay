# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == 9999* ]]; then
	inherit eutils autotools git-r3 linux-info
	EGIT_REPO_URI=(
		"https://github.com/fernando-rodriguez/avmount.git"
		"git://github.com/fernando-rodriguez/avmount.git" )
	KEYWORDS=""
else
	inherit eutils autotools check-reqs linux-info
	SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> avmount-${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

DESCRIPTION="Mount uPnP AV devices as FUSE filesystem"
HOMEPAGE="https://sourceforge.net/projects/djmount/"

LICENSE="GPL-2"
SLOT="0"
IUSE="charset debug systemd"

RDEPEND="
	sys-fs/fuse
	sys-libs/talloc
	net-libs/libupnp
	>=net-misc/curl-7.45.0"
DEPEND="${RDEPEND}
	dev-lang/perl"

pkg_pretend()
{
	CONFIG_CHECK="~FUSE_FS"
	ERROR_FUSE="You must enable CONFIG_FUSE_FS in your kernel to use avmount"
	check_extra_config
}

pkg_setup()
{
	if [ ! -d /media/upnp ]; then
		mkdir -p /media/upnp
		chattr +i /media/upnp
	fi
}

src_prepare()
{
	eautoreconf
}

src_configure()
{
	econf \
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
	fi
}
