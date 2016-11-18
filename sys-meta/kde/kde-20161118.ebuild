# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A lightweight install of KDE"
HOMEPAGE="https://nourl.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+kdm +multimedia kdepim +bluetooth +gtk screensaver konqueror +wallpapers admintools bogus x11-apps"

DEPEND="
	kdepim? ( kde-apps/kdepim-meta:5 )
	kdm? (
		x11-misc/sddm
		kde-plasma/sddm-kcm
	)
	x11-apps? (
		x11-apps/xmodmap
		x11-apps/xinput
	)
	kde-apps/ark:5
	kde-apps/audiocd-kio
	kde-apps/ffmpegthumbs:5
	kde-apps/gwenview:5
	kde-apps/kamera:5
	kde-apps/kcharselect:5
	kde-apps/kdebase-kioslaves
	kde-apps/kdegraphics-mobipocket
	kde-apps/kdenetwork-filesharing:5
	kde-apps/kget
	kde-apps/kmix:*[alsa]
	kde-apps/kmplot:5
	kde-apps/kppp
	kde-apps/krdc:5
	kde-apps/krfb:5
	kde-apps/spectacle
	kde-apps/kwalletmanager:5
	kde-apps/libkcddb
	kde-apps/libkcompactdisc
	kde-apps/libkdcraw:5
	kde-apps/libkexiv2:5
	kde-apps/libkipi:5
	kde-apps/okular
	kde-apps/phonon-kde
	kde-apps/plasma-runtime
	kde-apps/print-manager:5
	kde-apps/svgpart
	kde-apps/sweeper
	kde-apps/thumbnailers:5
	kde-apps/zeroconf-ioslave

	kde-apps/dolphin:5
	kde-apps/kdebase-runtime-meta:5
	kde-apps/kdialog
	kde-apps/keditbookmarks
	kde-apps/kfind
	kde-apps/kfmclient
	kde-apps/konsole:5
	kde-apps/kwrite:5
	kde-apps/phonon-kde
	kde-apps/plasma-apps

	kde-plasma/plasma-desktop
	kde-plasma/systemsettings:5
	kde-plasma/plasma-nm:5
	kde-plasma/powerdevil:5
	kde-plasma/khotkeys:5
	kde-plasma/kmenuedit:5
	kde-plasma/user-manager
	kde-plasma/kinfocenter:5
	bluetooth? ( kde-plasma/bluedevil:5 )
	gtk? (
		kde-plasma/breeze-gtk
		kde-plasma/kde-gtk-config:5
	)
	kde-base/qguiplatformplugin_kde
	bogus? (
		kde-base/kephal
		kde-base/freespacenotifier
	)

	admintools? (
		kde-apps/kuser
	)
	wallpapers? ( kde-plasma/plasma-workspace-wallpapers )
	konqueror? (
		kde-apps/konq-plugins
		kde-apps/konqueror
		kde-apps/libkonq
		kde-apps/nsplugins
	)

	screensaver? (
		kde-apps/kdeartwork-kscreensaver
		kde-base/kscreensaver
	)

	multimedia? (
		sys-meta/base-system[multimedia]
		media-sound/clementine[skydrive,googledrive,dropbox,ipod,lastfm,moodbar,ubuntu-one]
		media-sound/clementine[mtp,wiimote,box,mms]
		media-video/vlc
	)
"
RDEPEND="${DEPEND}"
