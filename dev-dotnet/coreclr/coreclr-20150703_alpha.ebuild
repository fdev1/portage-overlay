# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION=".NET Core Runtime"
HOMEPAGE="http://dotnet.github.io/core/"
SRC_URI="https://github.com/fernando-rodriguez/coreclr/archive/20150703_alpha.tar.gz -> coreclr-20150703_alpha.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="debug"

DEPEND="
	sys-devel/clang
	dev-util/cmake
	>=sys-libs/libunwind-1.1
"
RDEPEND="${DEPEND}"

src_prepare()
{
	mv "${S}/CMakeLists.txt" "${S}/CMakeLists.txt.orig" || die
	sed -e "s/add_subdirectory(src\/ToolBox\/SOS\/lldbplugin)//g" \
		"${S}/CMakeLists.txt.orig" > "${S}/CMakeLists.txt" || die
}

src_compile()
{
	CFLAGS="" CXXFLAGS="" ${S}/build.sh \
		$(use amd64 && printf "x64" || printf "x86") \
		$(use debug && printf "Debug" || printf "Release")
}

src_install()
{
	BLDT=$(use debug && printf "Debug" || printf "Release")
	ARCH=$(use amd64 && printf "x64" || printf "x86")
	dodir /usr/lib
	mv "${S}/bin/Product/Linux.${ARCH}.${BLDT}" "${D}/${ROOT}/usr/lib/${PN}" || die
	dosym /usr/lib/${PN}/corerun /usr/bin/corerun
	dosym /usr/lib/${PN}/coreconsole /usr/bin/coreconsole
	dosym /usr/lib/${PN}/crossgen /usr/bin/crossgen
}
