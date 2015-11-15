# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A Lean and Mean install of KDE"
HOMEPAGE="https://google.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+kdm +multimedia"

DEPEND="
	kde-base/kdepim-meta
	kde-base/kdeplasma-addons
	kdm? ( kde-base/kdm )
	kde-base/plasma-workspace
	kde-base/powerdevil
	kde-apps/ark
	kde-apps/audiocd-kio
	kde-apps/ffmpegthumbs
	kde-apps/gwenview
	kde-apps/kamera
	kde-apps/kcharselect
	kde-apps/kdeartwork-meta
	kde-apps/kdebase-kioslaves
	kde-apps/kdebase-meta
	kde-apps/kdegraphics-mobipocket
	kde-apps/kdenetwork-filesharing
	kde-apps/kgamma
	kde-apps/kget
	kde-apps/kmix:*
	kde-apps/kmplot
	kde-apps/kppp
	kde-apps/krdc
	kde-apps/krfb
	kde-apps/ksnapshot
	kde-apps/kturtle
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

	multimedia? (
		media-video/cheese
		media-video/ffmpeg
		media-video/vlc
		kde-apps/kdenlive:*
	)
"
RDEPEND="${DEPEND}"
