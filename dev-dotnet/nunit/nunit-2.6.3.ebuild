# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mono

DESCRIPTION="Nunit"
HOMEPAGE="http://nunit.org"
SRC_URI="http://launchpad.net/nunitv2/trunk/2.6.3/+download/NUnit-2.6.3.zip"
LICENSE="nunit"
SLOT="${PV}"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

src_unpack()
{
	default	
	mv "${WORKDIR}/NUnit-${PV}" "${WORKDIR}/nunit-${PV}"
}

src_install()
{
	dodir "${ROOT}/usr/lib/mono/${P}"
	cp -R "${S}/bin" "${D}/${ROOT}/usr/lib/mono/${P}"

	#insinto "${ROOT}/usr/lib/mono/${P}/bin"
	#for f in $(ls "${S}/bin"); do
	#	[ -f "${S}/bin/${f}" ] && doins "${S}/bin/${f}"	
	#done
	#dodir "${ROOT}/usr/lib/mono/${P}/bin/lib"
	#insinto "${ROOT}/usr/lib/mono/${P}/bin/lib"
	#for f in $(ls "${S}/bin/lib"); do
	#	[ -f "${S}/lib/${f}" ] && doins "${S}/bin/lib/${f}"
	#done

	#dodir "${ROOT}/usr/lib/mono/${P}/bin/lib/Images"

	#dodir "${ROOT}/usr/lib/mono/${P}/bin/framework"
	#insinto "${ROOT}/usr/lib/mono/${P}/bin/framework"
	#for f in $(ls "${S}/bin/framework"); do
	#	doins "${S}/bin/framework/${f}"
	#done
	egacinstall "${S}/bin/framework/nunit.framework.dll" "${P}"
	egacinstall "${S}/bin/framework/nunit.mocks.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.core.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit-console-runner.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.core.interfaces.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.util.dll" "${P}"
	#egacinstall "${S}/bin/lib/Rhino.Mocks.dll" "${P}"
	#egacinstall "${S}/bin/lib/log4net.dll" "${P}"
	egacinstall "${S}/bin/lib/NSubstitute.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit-gui-runner.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.uiexception.dll" "${P}"
	egacinstall "${S}/bin/lib/nunit.uikit.dll" "${P}"

	#dodir "${ROOT}/usr/lib/mono/${P}/bin/tests"
	#insinto "${ROOT}/usr/lib/mono/${P}/bin/tests"
	#for f in $(ls "${S}/bin/tests"); do
	#	doins "${S}/bin/tests/${f}"
	#done
}

