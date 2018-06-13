# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A lightweight install of KDE"
HOMEPAGE="https://nourl.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+display-manager +multimedia +bluetooth konqueror admintools x11-apps"

DEPEND="
	display-manager? (
		x11-misc/sddm
		kde-plasma/sddm-kcm
	)
	x11-apps? (
		x11-apps/xmodmap
		x11-apps/xinput
		x11-apps/xrandr
		x11-apps/xdpyinfo
	)
	x11-terms/xterm
	kde-apps/ark:5
	kde-apps/audiocd-kio
	kde-apps/ffmpegthumbs:5
	kde-apps/gwenview:5
	kde-apps/kamera:5
	kde-apps/kcharselect:5
	kde-apps/kdegraphics-mobipocket
	kde-apps/kdenetwork-filesharing:5
	kde-apps/spectacle
	kde-apps/kwalletmanager:5
	kde-apps/libkcddb
	kde-apps/libkcompactdisc
	kde-apps/libkdcraw:5
	kde-apps/libkexiv2:5
	kde-apps/libkipi:5
	kde-apps/okular
	kde-apps/print-manager:5
	kde-apps/svgpart
	kde-apps/sweeper
	kde-apps/thumbnailers:5
	kde-apps/zeroconf-ioslave
	kde-apps/kaccounts-integration
	kde-apps/kaccounts-providers

	kde-apps/dolphin:5
	kde-apps/kdialog
	kde-apps/keditbookmarks
	kde-apps/kfind
	kde-apps/konsole:5
	kde-apps/kwrite:5

	kde-plasma/plasma-meta
	bluetooth? ( kde-plasma/plasma-meta[bluetooth] )
	konqueror? (
		kde-apps/konqueror
	)
	multimedia? (
		sys-meta/base-system[multimedia]
		media-sound/clementine
		media-video/smplayer
	)
"
RDEPEND="${DEPEND}"

src_unpack()
{
	mkdir -p "${S}"
}

src_install()
{
	dodir /usr/share/xsessions/
	insinto /usr/share/xsessions
	doins "${FILESDIR}/terminal.desktop"
	dodir /etc/X11/Sessions
	insopts --mode=755
	insinto /etc/X11/Sessions
	doins "${FILESDIR}/terminal"
}
