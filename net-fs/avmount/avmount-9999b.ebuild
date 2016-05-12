# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} == 9999* ]]; then
	inherit eutils autotools git-r3 linux-info
	EGIT_REPO_URI=(
		"https://github.com/fernando-rodriguez/avmount.git"
		"git://github.com/fernando-rodriguez/avmount.git" )
	if [[ ${PV} == 9999 ]]; then
		EGIT_BRANCH="staging"
	fi
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
IUSE="charset debug ipv6 systemd"

RDEPEND="
	sys-fs/fuse
	>=sys-libs/talloc-2.1.5
	net-libs/libupnp
	ipv6? ( net-libs/libupnp[ipv6] )
	>=net-misc/curl-7.45.0"
DEPEND="${RDEPEND}
	dev-lang/perl"

pkg_pretend()
{
	CONFIG_CHECK="~FUSE_FS"
	ERROR_FUSE="You must enable CONFIG_FUSE_FS in your kernel to use avmount"
	check_extra_config
}

src_prepare()
{
	eautoreconf
}

src_configure()
{
	econf \
		$(use_with systemd) \
		$(use_enable charset) \
		$(use_enable ipv6) \
		$(use_enable debug)
}
