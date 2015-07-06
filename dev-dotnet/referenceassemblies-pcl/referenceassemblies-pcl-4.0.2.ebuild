# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Microsoft .NET Portable Library Reference Assemblies for mono ${PV}"
HOMEPAGE="http://www.microsoft.com/en-us/download/details.aspx?id=40727"
SRC_URI="http://download.mono-project.com/archive/4.0.2/macos-10-x86/MonoFramework-MDK-4.0.2.5.macos10.xamarin.x86.pkg"

LICENSE="MS-EULA"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="
	app-arch/xar
	app-arch/gzip
	app-arch/cpio
"
RDEPEND="${DEPEND}
	=dev-lang/mono-4.0.2"

src_unpack()
{
	xar -xf "${DISTDIR}/MonoFramework-MDK-4.0.2.5.macos10.xamarin.x86.pkg" || die
	mv "${WORKDIR}/mono.pkg" "${S}" || die
	cd "${S}" || die
	cat Payload | gunzip -dc | cpio -i || die
}

src_install()
{
	mkdir -p "${ED}/${EROOT}/usr/$(get_libdir)/mono/xbuild-frameworks" || die
	mv "${S}/Library/Frameworks/Mono.framework/Versions/4.0.2/lib/mono/xbuild-frameworks/.NETPortable" \
		"${ED}/${EROOT}/usr/$(get_libdir)/mono/xbuild-frameworks" || die
}
