# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Mount uPnP AV devices as FUSE filesystem"
HOMEPAGE="https://sourceforge.net/projects/djmount/"
SRC_URI="http://downloads.sourceforge.net/project/djmount/djmount/0.71/djmount-0.71.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}"

src_install()
{
	default
	dodir /usr/lib/systemd/system
	insinto /usr/lib/systemd/system
	insopts --mode=644
	doins "${FILESDIR}/djmount.service"
}
