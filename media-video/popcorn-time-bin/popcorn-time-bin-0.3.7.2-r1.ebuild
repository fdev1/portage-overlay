# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Popcorn Time - Watch Movies and TV Shows instantly"
HOMEPAGE="http://popcorntime.io"
SRC_URI="https://ci.popcorntime.io/job/Popcorn-Experimental/lastSuccessfulBuild/artifact/build/releases/Popcorn-Time/linux64/Popcorn-Time-0.3.7-2-c6781e09d-Linux64.tar.xz"

LICENSE="gpl"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RESTRICT="mirror"

DEPEND="
	app-arch/xz-utils
"
RDEPEND="${DEPEND}
	sys-libs/glibc
	virtual/udev
	>=x11-libs/libX11-1.6.2
	>=x11-libs/libXrender-0.9.8
	>=dev-libs/glib-2.42.2
	>=x11-libs/libXtst-1.2.2
	>=x11-libs/gtk+-2.24.28
	>=dev-libs/atk-2.14.0
	>=x11-libs/pango-1.36.8
	>=x11-libs/gdk-pixbuf-2.30.8
	>=x11-libs/cairo-1.14.2
	>=x11-libs/pango-1.36.8
	>=media-libs/freetype-2.5.5
	>=media-libs/fontconfig-2.11.1
	>=x11-libs/libXi-1.7.4 
	>=x11-libs/libXcomposite-0.4.4
	>=dev-libs/nss-3.19
	>=dev-libs/nspr-4.10.8
	>=gnome-base/gconf-3.2.6
	>=x11-libs/libXext-1.3.3
	>=x11-libs/libXfixes-5.0.1
	>=media-libs/alsa-lib-1.0.29
	>=x11-libs/libXdamage-1.1.4
	>=dev-libs/expat-2.1.0
	>=sys-apps/dbus-1.8.16
"

src_unpack()
{
	mkdir -p "${S}" || die "Unpack failed!"
	tar -xf "${DISTDIR}/Popcorn-Time-0.3.7-2-c6781e09d-Linux64.tar.xz" -C "${S}" || die "Unpack failed!"
}

src_install()
{
	MERGEDIR="/opt/Popcorn-Time"
	diropts --owner=root --group=root
	dodir "${MERGEDIR}"
	insinto "${MERGEDIR}"
	insopts --owner=root --group=root --mode=755
	doins "${S}/Popcorn-Time"
	insopts --owner=root --group=root --mode=664
	doins "${S}/package.nw"
	doins "${S}/nw.pak"
	doins "${S}/icudtl.dat"
	doins "${S}/libffmpegsumo.so"
	dosym "${MERGEDIR}/Popcorn-Time" /usr/bin/Popcorn-Time

	dodir "${MERGEDIR}/locales"
	insinto "${MERGEDIR}/locales"
	for f in $(ls ${S}/locales); do
		doins "${S}/locales/${f}"
	done

	insopts --owner=root --group=root --mode=644
	insinto "${MERGEDIR}"
	doins "${FILESDIR}/Popcorn-Time.png"
	echo "[Desktop Entry]" > Popcorn-Time.desktop || die "Install failed!"
	echo "Name=Popcorn Time" >> Popcorn-Time.desktop || die "Install failed!"
	echo "Comment=Watch Movies and TV Shows instantly" >> Popcorn-Time.desktop || die "Install failed!"
	echo "Exec=/usr/bin/Popcorn-Time" >> Popcorn-Time.desktop || die "Install failed!"
	echo "Icon=${MERGEDIR}/Popcorn-Time.png" >> Popcorn-Time.desktop || die "Install failed!"
	echo "Terminal=false" >> Popcorn-Time.desktop || die "Install failed!"
	echo "Type=Application" >> Popcorn-Time.desktop || die "Install failed!"
	echo "Categories=AudioVideo;Player;Recorder;" >> Popcorn-Time.desktop || die "Install failed!"
	domenu Popcorn-Time.desktop || die "Install failed!"


}

