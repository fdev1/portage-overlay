# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="On-screen capslock indicator for laptops"
HOMEPAGE="https://github.com/fernando-rodriguez/lock-keys"
SRC_URI="https://github.com/fernando-rodriguez/lock-keys/archive/${PV}.tar.gz -> lock-keys-${PV}.tar.gz"
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
	emake \
		PREFIX="${ROOT}/usr" \
		ENABLE_AUTOSTART=0 \
		CC="${CHOST}-gcc" \
		CFLAGS="${CFLAGS}" \
		DESTDIR="${D}"
}

src_install()
{
	dodir "${ROOT}/usr/bin"
	emake PREFIX="${ROOT}/usr" DESTDIR="${D}" install

	echo "[Desktop Entry]" > lock-keys.desktop || die
	echo "Type=Application" >> lock-keys.desktop || die
	echo "Exec=/usr/bin/lock-keys" >> lock-keys.desktop || die
	echo "Name=Lock Keys" >> lock-keys.desktop || die
	echo "Comment=On-screen Capslock Indicator" >> lock-keys.desktop || die
	echo "Terminal=false" >> lock-keys.desktop || die
	
	insinto "${EROOT}/etc/xdg/autostart"
	doins lock-keys.desktop
}
