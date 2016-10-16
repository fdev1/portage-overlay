# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Allows management and user-mode mounting of encrypted filesystems."
HOMEPAGE="http://sourceforge.net/projects/cryptmount/"
SRC_URI="http://downloads.sourceforge.net/project/${PN}/${PN}/${P%.*}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	>=sys-fs/cryptsetup-1.6.5
	virtual/udev"

RDEPEND="${DEPEND}"
