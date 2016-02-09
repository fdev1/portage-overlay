# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A Lean and Mean install of KDE"
HOMEPAGE="https://google.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+kdm +multimedia +kdepim screensaver"

DEPEND="
	kdepim? ( kde-apps/kdepim-meta )
	kde-base/kdeplasma-addons
	kdm? ( kde-base/kdm )
	!kdm? ( !kde-apps/kdebase-meta[display-manager] )
	kde-base/plasma-workspace
	kde-base/powerdevil
	kde-apps/ark
	kde-apps/audiocd-kio
	kde-apps/ffmpegthumbs
	kde-apps/gwenview
	kde-apps/kamera
	kde-apps/kcharselect
	kde-apps/kdebase-kioslaves
	kde-apps/kdebase-meta
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
	kde-apps/kuser
	kde-apps/kwalletmanager
	kde-apps/libkcddb
	kde-apps/libkcompactdisc
	kde-apps/libkdcraw
	kde-apps/libkexiv2
	kde-apps/libkipi
	kde-apps/okular
	kde-apps/phonon-kde
	kde-apps/plasma-runtime
	kde-apps/print-manager
	kde-apps/svgpart
	kde-apps/sweeper
	kde-apps/thumbnailers
	kde-apps/zeroconf-ioslave

	kde-apps/kdeartwork-colorschemes
	kde-apps/kdeartwork-desktopthemes
	kde-apps/kdeartwork-emoticons
	kde-apps/kdeartwork-iconthemes
	kde-apps/kdeartwork-wallpapers
	kde-apps/kdeartwork-weatherwallpapers
	kde-apps/kdeartwork-styles
	screensaver? ( kde-apps/kdeartwork-kscreensaver )

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
