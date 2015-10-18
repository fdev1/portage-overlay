# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Popcorn Time - Watch Movies and TV Shows instantly"
HOMEPAGE="http://popcorntime.io"
SRC_URI="
	x86?   ( https://get.popcorntime.io/build/Popcorn-Time-0.3.8-3-Linux-32.tar.xz )
	amd64? ( https://get.popcorntime.io/build/Popcorn-Time-0.3.8-3-Linux-64.tar.xz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="chromium-ffmpeg"
RESTRICT="primaryuri strip"
MERGEDIR="/usr/lib/Popcorn-Time-${PV}"

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
	chromium-ffmpeg? ( www-client/chromium )
"

src_unpack()
{
	mkdir -p "${S}" || die
	pkg="${DISTDIR}/Popcorn-Time-0.3.8-3-Linux-$(use x86 && printf "32" || printf "64").tar.xz"
	tar -xf "${pkg}" -C "${S}" || die
}

src_install()
{
	# install main components
	diropts --owner=root --group=root
	dodir "${MERGEDIR}"
	insinto "${MERGEDIR}"
	insopts --owner=root --group=root --mode=755
	doins "${S}/Popcorn-Time"
	dosym "${MERGEDIR}"/Popcorn-Time "${EROOT}"/usr/bin/Popcorn-Time
	insopts --owner=root --group=root --mode=664
	doins "${S}"/nw.pak
	doins "${S}"/icudtl.dat
	doins "${S}"/package.json

	if use chromium-ffmpeg; then
		dosym /usr/$(get_libdir)/chromium-browser/libffmpegsumo.so "${MERGEDIR}/libffmpegsumo.so"
	else
		doins "${S}/libffmpegsumo.so"
	fi

	mv "${S}/node_modules" "${ED}/${MERGEDIR}/" || die
	mv "${S}/src" "${ED}/${MERGEDIR}/" || die

	dodir "${MERGEDIR}/locales"
	insinto "${MERGEDIR}/locales"
	find "${S}/locales" -mindepth 1 -maxdepth 1 \
		-exec mv '{}' "${ED}/${MERGEDIR}/locales" \; || die

	# install docs
	dodoc LICENSE.txt
	dodoc README.md
	dodoc CHANGELOG.md

	# install icon
	insopts --owner=root --group=root --mode=644
	insinto "/usr/share/icons"
	doins "${S}/popcorntime.png"

	# install menu item
	echo "[Desktop Entry]" > Popcorn-Time.desktop || die
	echo "Name=Popcorn Time" >> Popcorn-Time.desktop || die
	echo "GenericName=Watch Movies and TV Shows instantly" >> Popcorn-Time.desktop || die
	echo "Comment=Watch Movies and TV Shows instantly" >> Popcorn-Time.desktop || die
	echo "Exec=/usr/bin/Popcorn-Time" >> Popcorn-Time.desktop || die
	echo "Icon=popcorntime" >> Popcorn-Time.desktop || die
	echo "Terminal=false" >> Popcorn-Time.desktop || die
	echo "Type=Application" >> Popcorn-Time.desktop || die
	echo "Categories=AudioVideo;Player;Recorder;" >> Popcorn-Time.desktop || die
	domenu Popcorn-Time.desktop || die
}
