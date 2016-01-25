# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Tor Profile for Firefox"
HOMEPAGE="https://torproject.org"
RESTRICT="strip"
SRC_URI=""

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND="
	www-client/firefox
	net-misc/tor"
RDEPEND="${DEPEND}"
S="${WORKDIR}"

src_prepare()
{
	tar -xf "${FILESDIR}/tor-browser-profile-amd64.tar.xz" || die
}

src_install()
{
	dodir /usr/bin
	insinto /usr/bin
	insopts --mode 0755 --owner root --group root
	doins "${FILESDIR}/start-tor-browser"

	dodir /usr/share/applications
	insinto /usr/share/applications
	doins "${FILESDIR}/start-tor-browser.desktop"
	dodir /usr/share/not-tor-browser
	find "${S}" -mindepth 1 -maxdepth 1 \
		-exec mv '{}' "${ED}/usr/share/not-tor-browser" \;
	find "${ED}/usr/share/not-tor-browser" -type f \
		-exec chmod o+r '{}' \;
	find "${ED}/usr/share/not-tor-browser" -type d \
		-exec chmod o+rx '{}' \;
}
