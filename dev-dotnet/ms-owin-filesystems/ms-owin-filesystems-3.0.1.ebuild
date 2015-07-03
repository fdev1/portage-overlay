# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mono

DESCRIPTION="Microsoft.Owin.FileSystems package"
HOMEPAGE=""
SRC_URI="https://www.nuget.org/api/v2/package/Microsoft.Owin.FileSystems/3.0.1 -> ms-owin-filesystems-3.0.1.zip"

LICENSE="ms-net-library-eula"
SLOT="${PV}"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

src_unpack()
{
	unzip -x "${DISTDIR}/ms-owin-filesystems-3.0.1" -d "${S}" || die
}

src_install()
{
	dodir "${ROOT}/usr/lib/mono/${P}"
	insinto "${ROOT}/usr/lib/mono/${P}"
	doins "${S}/lib/net45/Microsoft.Owin.FileSystems.dll"
	#egacinstall "${S}/lib/net45/Microsoft.Owin.FileSystems.dll" "${P}"	
}
