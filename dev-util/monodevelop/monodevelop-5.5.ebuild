# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop/monodevelop-3.0.2-r1.ebuild,v 1.5 2013/10/12 12:09:05 pacho Exp $

EAPI=4
inherit fdo-mime gnome2-utils mono versionator eutils

DESCRIPTION="Integrated Development Environment for .NET"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.0.227.tar.bz2
https://launchpadlibrarian.net/68057829/NUnit-2.5.10.11092.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+subversion +git"

RDEPEND="
	>=dev-lang/mono-2.10.9
	dev-dotnet/nuget:2.8.1
	dev-dotnet/nunit
	dev-dotnet/NUnit-NuGet:2.6.3
	dev-dotnet/NUnit-Runners-NuGet:2.6.3
	dev-dotnet/System-Web-Mvc-Extensions-Mvc-4-NuGet:1.0.9
	dev-dotnet/Microsoft-AspNet-Mvc-NuGet:5.2.2
	dev-dotnet/Microsoft-AspNet-Razor-NuGet:3.2.2
	dev-dotnet/Microsoft-AspNet-WebPages-NuGet:3.2.2
	dev-dotnet/Microsoft-Web-Infrastructure-NuGet:1.0.0.0
	>=dev-dotnet/gconf-sharp-2.24.0
	>=dev-dotnet/glade-sharp-2.12.9
	>=dev-dotnet/gnome-sharp-2.24.0
	>=dev-dotnet/gnomevfs-sharp-2.24.0
	>=dev-dotnet/gtk-sharp-2.12.9
	>=dev-dotnet/mono-addins-0.6[gtk]
	>=dev-dotnet/xsp-2
	dev-util/ctags
	sys-apps/dbus[X]
	|| (
		www-client/firefox
		www-client/firefox-bin
		www-client/seamonkey
		)
	subversion? ( dev-vcs/subversion )
	!<dev-util/monodevelop-boo-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-java-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-database-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-gdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-debugger-mdb-$(get_version_component_range 1-2)
	!<dev-util/monodevelop-vala-$(get_version_component_range 1-2)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	x11-misc/shared-mime-info"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare()
{

	mkdir "${S}/packages" || die
	ln -s "${ROOT}/usr/lib/mono/NuGet-Packages/NUnit-2.6.3" "${S}/packages/NUnit.2.6.3"
	ln -s "${ROOT}/usr/lib/mono/NuGet-Packages/NUnit.Runners-2.6.3" "${S}/packages/NUnit.Runners.2.6.3"
	ln -s "${ROOT}/usr/lib/mono/NuGet-Packages/Microsoft.AspNet.Mvc-5.2.2" "${S}/packages/Microsoft.AspNet.Mvc.5.2.2"
	ln -s "${ROOT}/usr/lib/mono/NuGet-Packages/Microsoft.AspNet.Razor-3.2.2" "${S}/packages/Microsoft.AspNet.Razor.3.2.2"
	ln -s "${ROOT}/usr/lib/mono/NuGet-Packages/Microsoft.AspNet.WebPages-3.2.2" "${S}/packages/Microsoft.AspNet.WebPages.3.2.2"
	ln -s "${ROOT}/usr/lib/mono/NuGet-Packages/Microsoft.Web.Infrastructure-1.0.0.0" "${S}/packages/Microsoft.Web.Infrastructure.1.0.0.0"

	sed -i '/<Exec.*rev-parse/ d' "${S}/src/core/MonoDevelop.Core/MonoDevelop.Core.csproj" || die
	cp -fR "${WORKDIR}"/NUnit-2.5.10.11092/bin/net-2.0/framework/* "${S}"/external/cecil/Test/libs/nunit-2.5.10/ || die
	cp "${ROOT}/usr/lib/mono/nuget-2.8.1/NuGet.Core.dll" "${S}/external/nuget-binary/" || die

	mv "${S}/external/ikvm/reflect/IKVM.Reflection.csproj" \
		"${S}/external/ikvm/reflect/IKVM.Reflection.csproj.orig" || die
	sed -e "s/<Project ToolsVersion=\"3.5\"/<Project ToolsVersion=\"4.0\"/g" \
		"${S}/external/ikvm/reflect/IKVM.Reflection.csproj.orig" | \
	sed -e "s/<TargetFrameworkVersion>v2.0/<TargetFrameworkVersion>v4.5/g" > \
		"${S}/external/ikvm/reflect/IKVM.Reflection.csproj"
		
	epatch "${FILESDIR}/disable-tests-${PV}.patch"
	return
}

src_configure() {
	econf \
		--disable-update-mimedb \
		--disable-update-desktopdb \
		--enable-monoextensions \
		--enable-gnomeplatform \
		$(use_enable subversion) \
		$(use_enable git)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}