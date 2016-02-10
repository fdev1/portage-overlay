# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A Lean and Mean install of KDE"
HOMEPAGE="https://google.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+kdm +multimedia +kdepim +bluetooth screensaver konqueror +wallpapers admintools bogus"

DEPEND="
	kdepim? ( kde-apps/kdepim-meta )
	kde-base/kdeplasma-addons
	kdm? ( kde-base/kdm )
	kde-base/plasma-workspace
	kde-base/powerdevil
	kde-apps/ark:4
	kde-apps/audiocd-kio
	kde-apps/ffmpegthumbs:4
	kde-apps/gwenview:4
	kde-apps/kamera:4
	kde-apps/kcharselect:4
	kde-apps/kdebase-kioslaves
	kde-apps/kdegraphics-mobipocket
	kde-apps/kdenetwork-filesharing
	kde-apps/kgamma
	kde-apps/kget
	kde-apps/kmix:*[alsa]
	kde-apps/kmplot
	kde-apps/kppp
	kde-apps/krdc
	kde-apps/krfb
	kde-apps/ksnapshot
	kde-apps/kwalletmanager:4
	kde-apps/libkcddb
	kde-apps/libkcompactdisc
	kde-apps/libkdcraw:4
	kde-apps/libkexiv2:4
	kde-apps/libkipi:4
	kde-apps/okular
	kde-apps/phonon-kde
	kde-apps/plasma-runtime
	kde-apps/print-manager:4
	kde-apps/svgpart
	kde-apps/sweeper
	kde-apps/thumbnailers:4
	kde-apps/zeroconf-ioslave

	kde-apps/dolphin:4
	kde-apps/kdebase-runtime-meta:4
	kde-apps/kdialog
	kde-apps/keditbookmarks
	kde-apps/kfind
	kde-apps/kfmclient
	kde-apps/konsole
	kde-apps/kwrite:4
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
	kde-base/ksysguard
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
		media-sound/clementine[mtp,system-sqlite,wiimote,box,mms]
		media-video/cheese
		>=media-video/ffmpeg-2.8[theora,jpeg2k,vaapi,vdpau,amr,vpx,threads,openssl]
		>=media-video/ffmpeg-2.8[celt,schroedinger,bs2b,amrenc,fontconfig,gme,libass,libv4l,lzma]
		>=media-video/ffmpeg-2.8[wavpack,zvbi,x265,speex,quvi,opus,ladspa,gsm,aacplus]
		>=media-video/ffmpeg-2.8[modplug,webp,snappy,fribidi,frei0r]
		media-video/vlc[alsa,faad,mtp,ncurses,rtsp,samba,schroedinger,taglib]
		media-video/vlc[theora,vdpau,vaapi,libsamplerate,postproc]
		media-video/vlc[upnp,musepack,vlm,vpx,zvbi,vcdx,speex,shout,omxil]
		media-video/vlc[libass,aalib,libsamplerate,directfb,x265,sid,fontconfig]
		kde-apps/kdenlive:*
	)
"
RDEPEND="${DEPEND}"
