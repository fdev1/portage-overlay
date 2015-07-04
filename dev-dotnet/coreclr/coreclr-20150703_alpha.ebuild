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
IUSE=""

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
	CFLAGS="" CXXFLAGS="" ${S}/build.sh
}

src_install()
{
	dodir "${ROOT}/usr/lib"
	mv "${S}/bin/Product/Linux.x64.Debug" "${D}/${ROOT}/usr/lib/${P}" || die
	dosym "${ROOT}/usr/lib/${P}/bin/corerun" "${ROOT}/usr/bin/corerun"
}
