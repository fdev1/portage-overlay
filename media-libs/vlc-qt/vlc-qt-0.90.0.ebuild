# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="VLC-Qt is a free library used to connect Qt and libvlc libraries."
HOMEPAGE="http://projects.tano.si/library"
RESTRICT="mirror"
SRC_URI="https://github.com/vlc-qt/vlc-qt/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
#EGIT_REPO_URI="git://github.com/ntadej/vlc-qt"
#EGIT_BRANCH="master"
#EGIT_COMMIT="$PV"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
#MAKEOPTS="-j1"

DEPEND="
	app-doc/doxygen
"
RDEPEND="
	dev-qt/qtcore:5
	media-video/vlc
"

S="${WORKDIR}/${P}"
