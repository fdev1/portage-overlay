# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Skyhook Location SDK"
HOMEPAGE="http://developer.skyhookwireless.com/docs/precision-location-for-linux"
SRC_URI="https://my.skyhookwireless.com/downloadcenter/sdkdownload/precisionlocation/fedora_x86_64/4.9.3/wpsapi-4.9.3_01-linux-x86_64-fedora.zip"
RESTRICT="fetch"

LICENSE="WPSAPI"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND="net-wireless/wireless-tools"
RDEPEND="${DEPEND}"
S="${WORKDIR}/wpsapi-4.9.3_01-linux-x86_64-fedora"

pkg_nofetch()
{
	einfo "The driver package:"
	einfo ${A}
	einfo "needs to be downloaded manually from:"
	einfo "https://my.skyhookwireless.com"
}

src_install()
{
	dodir "/usr/$(get_libdir)"
	insinto "/usr/$(get_libdir)"
	doins "${S}/lib/libwpsapi.so"

	dodir /usr/include
	insinto /usr/include
	doins "${S}/include/wpsapi.h"

	dodir "/usr/share/doc/${PN}"
	find "${S}/documentation/" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}/usr/share/doc/${PN}" \;

}
