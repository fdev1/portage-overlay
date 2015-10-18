# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Develop ASP.NET and Node applications at lightning speed"
HOMEPAGE="https://code.visualstudio.com/"
SRC_URI="
	x86? ( https://az764295.vo.msecnd.net/public/${PV}/VSCode-linux-ia32.zip -> VSCode-linux-ia32-${PV}.zip )
	amd64? ( https://az764295.vo.msecnd.net/public/${PV}/VSCode-linux-x64.zip -> VSCode-linux-x64-${PV}.zip )"
RESTRICT="mirror"

LICENSE="Microsoft-VS-Code"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="chromium-libs"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	chromium-libs? ( www-client/chromium )
	>=dev-libs/libgcrypt-1.5.4
	>=app-arch/bzip2-1.0.6
	>=app-crypt/mit-krb5-1.13.2
	>=dev-libs/atk-2.14.0
	>=dev-libs/dbus-glib-0.102
	>=dev-libs/expat-2.1.0
	>=dev-libs/glib-2.42.2
	>=dev-libs/gmp-5.1.3
	>=dev-libs/libffi-3.0.13
	>=dev-libs/libtasn1-4.5
	>=dev-libs/nettle-2.7.1
	>=gnome-base/gconf-3.2.6
	>=media-gfx/graphite2-1.2.4
	>=media-libs/alsa-lib-1.0.29
	>=media-libs/fontconfig-2.11.1
	>=media-libs/freetype-2.5.5
	>=media-libs/harfbuzz-0.9.38
	>=media-libs/libpng-1.6.17
	>=media-libs/mesa-10.3.7
	>=net-dns/avahi-0.6.31
	>=net-libs/gnutls-3.3.15
	>=net-print/cups-2.0.3
	>=sys-apps/dbus-1.8.16
	>=sys-apps/keyutils-1.5.9
	>=sys-libs/e2fsprogs-libs-1.42.13
	>=sys-libs/glibc-2.20
	>=sys-libs/zlib-1.2.8
	virtual/opengl
	>=x11-libs/cairo-1.14.2
	>=x11-libs/gdk-pixbuf-2.30.8
	x11-libs/gtk+:2
	>=x11-libs/libdrm-2.4.59
	>=x11-libs/libnotify-0.7.6
	>=x11-libs/libX11-1.6.2
	>=x11-libs/libXau-1.0.8
	>=x11-libs/libxcb-1.11
	>=x11-libs/libXcomposite-0.4.4
	>=x11-libs/libXcursor-1.1.14
	>=x11-libs/libXdamage-1.1.4
	>=x11-libs/libXdmcp-1.1.1
	>=x11-libs/libXext-1.3.3
	>=x11-libs/libXfixes-5.0.1
	>=x11-libs/libXi-1.7.4
	>=x11-libs/libXinerama-1.1.3
	>=x11-libs/libXrandr-1.4.2
	>=x11-libs/libXrender-0.9.8
	>=x11-libs/libXtst-1.2.2
	>=x11-libs/pango-1.36.8
	>=x11-libs/pixman-0.32.6"

QA_PREBUILT="opt/${P}/*"

src_unpack()
{
	mkdir -p "${S}" || die
	unzip -q "${DISTDIR}"/${A} -d "${S}" || die
	mv "${S}"/${A%%-$PV.zip} "${S}"/files || die
}

src_install()
{
	mkdir -p "${ED}"/opt || die
	mkdir -p "${ED}"/usr/bin || die
	find "${S}"/files -type f -exec chmod 0644 '{}' \; || die
	find "${S}"/files -type d -exec chmod 0755 '{}' \; || die
	chmod 0755 "${S}"/files/Code || die

	# unbundle libs
	rm "${S}"/files/libnotify.so.4 || die
	rm "${S}"/files/libgcrypt.so.11 || die
	ln -s ../../usr/$(get_libdir)/libgcrypt.so "${S}"/files/libgcrypt.so.11 || die

	# unbundle chromium files
	if use chromium-libs; then
		rm "${S}"/files/libffmpegsumo.so || die
		rm "${S}"/files/natives_blob.bin || die
		rm "${S}"/files/snapshot_blob.bin || die
		ln -s "${EROOT}"/usr/$(get_libdir)/chromium-browser/libffmpegsumo.so "${S}"/files/libffmpegsumo.so || die
		ln -s "${EROOT}"/usr/$(get_libdir)/chromium-browser/natives_blob.bin "${S}"/files/natives_blob.bin || die
		ln -s "${EROOT}"/usr/$(get_libdir)/chromium-browser/snapshot_blob.bin "${S}"/files/snapshot_blob.bin || die
	fi

	mv "${S}"/files "${ED}"/opt/"${P}" || die
	dosym /opt/"${P}"/Code /usr/bin/VSCode

	echo "[Desktop Entry]" > vscode.desktop || die
	echo "Name=Visual Studio Code" >> vscode.desktop || die
	echo "GenericName=Develop ASP.NET and Node applications" >> vscode.desktop || die
	echo "Comment=Develop ASP.NET and Node applications" >> vscode.desktop || die
	echo "Icon=${EROOT}/opt/${P}/resources/app/vso.png" >> vscode.desktop || die
	echo "Exec=${EROOT}/opt/${P}/Code" >> vscode.desktop || die
	echo "StartupNotify=true" >> vscode.desktop || die
	echo "Terminal=false" >> vscode.desktop || die
	echo "Type=Application" >> vscode.desktop || die
	echo "Categories=Development;IDE;" >> vscode.desktop || die
	sed -ie "s://:/:g" vscode.desktop || die
	domenu vscode.desktop
}
