# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mono

DESCRIPTION="Nunit"
HOMEPAGE="http://nunit.org"
SRC_URI="http://github.com/nunit/nunitv2/releases/download/2.6.4/NUnit-2.6.4-net-1.1.zip"

LICENSE=""
SLOT="${PV}"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

src_unpack()
{
	default	
	mv "${WORKDIR}/NUnit-2.6.4" "${WORKDIR}/nunit-2.6.4"
}

src_install()
{
	dodir /usr/lib/mono/${P}/bin
	insinto /usr/lib/mono/${P}/bin
	for f in $(ls "${S}/bin"); do
		[ -f "${S}/bin/${f}" ] && doins "${S}/bin/${f}"	
	done
	dodir /usr/lib/mono/${P}/bin/lib
	insinto /usr/lib/mono/${P}/bin/lib
	for f in $(ls "${S}/bin/lib"); do
		doins "${S}/bin/lib/${f}"
	done
	dodir /usr/lib/mono/${P}/bin/framework
	insinto /usr/lib/mono/${P}/bin/framework
	for f in $(ls "${S}/bin/framework"); do
		doins "${S}/bin/framework/${f}"
	done
	egacinstall "${S}/bin/framework/nunit.framework.dll" "${P}"
	egacinstall "${S}/bin/framework/nunit.mocks.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.core.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit-console-runner.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.core.interfaces.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.util.dll" "${P}"
	egacinstall "${S}/bin/lib/Rhino.Mocks.dll" "${P}"
	egacinstall "${S}/bin/lib/log4net.dll" "${P}"

	dodir /usr/lib/mono/${P}/bin/tests
	insinto /usr/lib/mono/${P}/bin/tests
	for f in $(ls "${S}/bin/tests"); do
		doins "${S}/bin/tests/${f}"
	done
}

