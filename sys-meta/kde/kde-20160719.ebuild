# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A lightweight install of KDE"
HOMEPAGE="https://nourl.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+kdm +multimedia +kdepim +bluetooth screensaver konqueror +wallpapers admintools bogus"

DEPEND="
	kdepim? ( kde-apps/kdepim-meta )
	kde-base/kdeplasma-addons
	kdm? (
		x11-misc/sddm
		kde-plasma/sddm-kcm
	)
	kde-base/plasma-workspace
	kde-base/powerdevil
	kde-apps/ark:5
	kde-apps/audiocd-kio
	kde-apps/ffmpegthumbs:5
	kde-apps/gwenview:5
	kde-apps/kamera:5
	kde-apps/kcharselect:5
	kde-apps/kdebase-kioslaves
	kde-apps/kdegraphics-mobipocket
	kde-apps/kdenetwork-filesharing:5
	kde-apps/kgamma
	kde-apps/kget
	kde-apps/kmix:*[alsa]
	kde-apps/kmplot:5
	kde-apps/kppp
	kde-apps/krdc:5
	kde-apps/krfb:5
	kde-apps/spectacle
	kde-apps/kwalletmanager:4
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
	kde-base/krunner
	kde-base/kcminit
	kde-base/kdebase-startkde
	kde-base/kdebase-cursors
	kde-base/kcheckpass
	kde-apps/kdepasswd
	kde-base/khotkeys
	kde-base/klipper
	kde-base/kmenuedit
	kde-base/ksmserver
	kde-base/ksplash
	kde-base/kstartupconfig
	kde-base/kstyles
	kde-base/ksystraycmd
	kde-base/kwin
	kde-base/kwrited
	kde-base/libkworkspace
	kde-base/liboxygenstyle
	kde-base/libplasmaclock
	kde-base/libplasmagenericshell
	kde-base/libtaskmanager
	kde-apps/plasma-apps
	kde-base/plasma-workspace
	kde-base/powerdevil
	kde-base/qguiplatformplugin_kde
	kde-base/solid-actions-kcm
	kde-base/systemsettings
	bogus? (
		kde-base/kephal
		kde-base/freespacenotifier
	)

	admintools? (
		kde-base/ksysguard
		kde-base/kinfocenter
		kde-apps/kuser
	)
	wallpapers? ( kde-apps/kde-wallpapers:4 )
	konqueror? (
		kde-apps/konq-plugins
		kde-apps/konqueror
		kde-apps/libkonq
		kde-apps/nsplugins
	)

	kde-apps/kdeartwork-colorschemes
	kde-apps/kdeartwork-desktopthemes
	kde-apps/kdeartwork-emoticons
	kde-apps/kdeartwork-iconthemes
	kde-apps/kdeartwork-wallpapers:4
	kde-apps/kdeartwork-weatherwallpapers:4
	kde-apps/kdeartwork-styles
	screensaver? (
		kde-apps/kdeartwork-kscreensaver
		kde-base/kscreensaver
	)

	multimedia? (
		media-sound/clementine[skydrive,googledrive,dropbox,ipod,lastfm,moodbar,ubuntu-one]
		media-sound/clementine[mtp,wiimote,box,mms]
		media-video/cheese
		>=media-video/ffmpeg-2.8[theora,jpeg2k,vaapi,vdpau,amr,vpx,threads,openssl]
		>=media-video/ffmpeg-2.8[celt,schroedinger,bs2b,amrenc,fontconfig,gme,libass,libv4l,lzma]
		>=media-video/ffmpeg-2.8[wavpack,zvbi,x265,speex,quvi,opus,ladspa,gsm,aacplus]
		>=media-video/ffmpeg-2.8[modplug,webp,snappy,fribidi,frei0r]
		media-video/vlc[alsa,faad,mtp,ncurses,rtsp,samba,schroedinger,taglib]
		media-video/vlc[theora,vdpau,vaapi,libsamplerate,postproc]
		media-video/vlc[musepack,vlm,vpx,zvbi,vcdx,speex,shout,omxil]
		media-video/vlc[libass,aalib,libsamplerate,directfb,x265,sid,fontconfig]
		kde-apps/kdenlive:*
	)
"
RDEPEND="${DEPEND}"
