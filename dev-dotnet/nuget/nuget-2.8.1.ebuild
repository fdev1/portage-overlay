# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mono

DESCRIPTION="Nuget Addin for MonoDevelop"
HOMEPAGE=""
SRC_URI="http://download.mono-project.com/sources/nuget/nuget-2.8.1+md54+dhx1.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

src_compile()
{
	${S}/build-minimal.sh || die
}

src_install()
{
	dodir /usr/lib/mono/${P}
	insopts --mode=755
	insinto /usr/lib/mono/${P}
	doins "${S}/src/CommandLine/bin/Release/NuGet.exe"
	doins "${S}/src/Core/bin/Release/NuGet.Core.dll"
	doins "${S}/src/Core/bin/Release/Microsoft.Web.XmlTransform.dll"

	#egacinstall "${S}/src/Core/bin/Release/NuGet.Core.dll" "${P}"
	#egacinstall "${S}/src/Core/bin/Release/Microsoft.Web.XmlTransform.dll" "${P}"

	echo "#!/bin/sh" > nuget || die
	echo "${EROOT}/usr/bin/mono ${EROOT}/usr/lib/mono/${P}/NuGet.exe \$@" >> nuget || die
	insinto /usr/bin
	insopts --mode=755
	doins nuget
}
