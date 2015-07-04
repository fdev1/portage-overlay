# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="On-screen capslock indicator for laptops"
HOMEPAGE="https://github.com/fernando-rodriguez/lock-keys"
SRC_URI="https://github.com/fernando-rodriguez/lock-keys/archive/0.3.tar.gz -> lock-keys-0.3.tar.gz"
RESTRICT="mirror"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=x11-libs/gtk+-3.0
"

src_compile()
{
	emake PREFIX="${ROOT}/usr" CC="${CHOST}-gcc" DESTDIR="${D}"
}

src_install()
{
	dodir "${ROOT}/usr/bin"
	emake PREFIX="${ROOT}/usr" DESTDIR="${D}" install
}
