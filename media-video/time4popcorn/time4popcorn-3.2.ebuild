# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Popcorn Time - Watch Movies and TV Shows instantly"
HOMEPAGE="http://popcorntime.io"
SRC_URI="http://popcorn-time.se/source/PopcornTime_Desktop-src.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="primaryuri strip"
MERGEDIR="/opt/Popcorn-Time-${PV}"

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

	dev-libs/boost
	dev-util/boost-build
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebkit:5

	media-libs/vlc-qt
	dev-libs/quazip[qt5]
	>=net-libs/rb_libtorrent-1.0
	virtual/libiconv
"

src_unpack()
{
	mkdir -p "${S}" || die
	unzip -q "${DISTDIR}/PopcornTime_Desktop-src.zip" -d "${S}" || die
	#pkg="${DISTDIR}/Popcorn-Time-0.3.8-5-Linux-$(use x86 && printf "32" || printf "64").tar.xz"
	#tar -xf "${pkg}" -C "${S}" || die
}

src_prepare()
{
	chmod +x "${S}/Import/libtorrent/configure" || die
	mv "${S}/Common/md5.cpp" "${S}/Common/MD5.cpp" || die
	sed -i -e 's|http://beta.time4popcorn.eu/?version=0.4.4a&os=mac|http://app.popcorn-time.se|' \
		"${S}/gui/defaults.h" || die
	sed -i -e 's/QObject.h/QObject/' "${S}/gui/ResizeDragEventHandler.h" || die
	sed -i -e 's:QEvent.h:QEvent:' "${S}/gui/ResizeDragEventHandler.cpp" || die
	sed -i -e 's/QPoint.h/QPoint/' "${S}/gui/ResizeDragEventHandler.h" || die
	sed -i -e 's:"QGraphicsView.h":<QGraphicsView>:' "${S}/gui/GraphicsBrowser.h" || die
	sed -i -e 's:<QGraphicsWebView>:<QtWebKitWidgets/QGraphicsWebView>:' \
		"${S}/gui/GraphicsBrowser.h" || die
	sed -i \
		-e 's:<QNetworkAccessManager>:<QtNetwork/QNetworkAccessManager>:' \
		-e 's:<QNetworkReply>:<QtNetwork/QNetworkReply>:' \
		"${S}/gui/hostApp.h" || die
	sed -i -e 's:#ifdef WIN32:#if 1:' "${S}/gui/hostApp.cpp" || die
	sed -i -e 's:<QNetworkProxy>:<QtNetwork/QNetworkProxy>:' "${S}/gui/commontypes.h" || die
	sed -i \
		-e 's:<QHostAddress>:<QtNetwork/QHostAddress>:' \
		-e 's:<QNetworkAccessManager>:<QtNetwork/QNetworkAccessManager>:' \
		-e 's:<QNetworkReply>:<QtNetwork/QNetworkReply>:' \
		"${S}/gui/ChromeCast.h" || die
	sed -i -e 's:VLC.h:vlc.h:' "${S}/gui/ChromeCast.cpp" || die
	sed -i -e 's:#ifdef Q_OS_MAC:#if 1:' "${S}/gui/main.cpp" || die
	sed -i -e 's:vlc-qt/:VLCQtCore/:g' "${S}/gui/VMediaPlayer.cpp" || die
	sed -i -e 's:vlc-qt/:VLCQtCore/:g' "${S}/gui/VMediaPlayer.h" || die
	sed -i \
		-e 's:-lvlc-qt-widgets:-L../lib/bin/gcc-4.9.3/release/link-static/threading-multi:' \
		-e 's:-lvlc-qt:-lboost_filesystem-mt -lboost_system-mt -lboost_thread-mt -lboost_iostreams-mt -lstreamerok -ltorrent-rasterbar -lVLCQtWidgets -lVLCQtQml -lVLCQtCore -lc:' \
		"${S}/gui/gui.pro" || die
	#sed -i -e 's:libiconv:iconv:g' "${S}/gui/SubtitleDecoder.cpp" || die
	sed -i \
		-e 's:"iconv.h":<iconv.h>:' \
		-e 's:#ifdef Q_OS_MAC:#if 1:' \
		"${S}/gui/SubtitleDecoder.cpp" || die
}

#src_configure()
#{
#	cd "${S}/Import/libtorrent"
#	econf 
#}

src_compile()
{
	CFLAGS=""
	CXXFLAGS=""

	# Build libtorrent
	#cd "${S}/Import/libtorrent"
	#make || die

	cd "${S}/lib"
	bjam release || die
	cd "${S}/gui"
	/usr/lib/qt5/bin/qmake || die
	make release || die
}

src_install()
{
	dodir /opt/time4popcorn
	insinto /opt/time4popcorn
	insopts --mode=755
	doins "${S}/gui/debugU/PopcornTime"
	mv "${S}/Import/chromecast" "${ED}/opt/time4popcorn/" || die

	#insopts --owner=root --group=root --mode=644
	#insinto "/usr/share/icons"
	#doins "${S}/popcorntime.png"

	# install menu item
	echo "[Desktop Entry]" > PopcornTime.desktop || die
	echo "Name=Popcorn Time (se)" >> PopcornTime.desktop || die
	echo "GenericName=Watch Movies and TV Shows instantly" >> PopcornTime.desktop || die
	echo "Comment=Watch Movies and TV Shows instantly" >> PopcornTime.desktop || die
	echo "Exec=/opt/time4popcorn/PopcornTime" >> PopcornTime.desktop || die
	echo "Icon=popcorntime" >> PopcornTime.desktop || die
	echo "Terminal=false" >> PopcornTime.desktop || die
	echo "Type=Application" >> PopcornTime.desktop || die
	echo "Categories=AudioVideo;Player;Recorder;" >> PopcornTime.desktop || die
	domenu PopcornTime.desktop || die
}
