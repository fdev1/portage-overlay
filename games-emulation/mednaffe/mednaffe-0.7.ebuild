# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="A front-end (GUI) for mednafen emulator"
HOMEPAGE="https://github.com/AmatCoder/mednaffe"
SRC_URI="https://github.com/AmatCoder/mednaffe/archive/v0.7.tar.gz -> mednaffe-0.7.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=x11-libs/gtk+-2.0
	games-emulation/mednafen"

src_install()
{
	default
	mv "${ED}/usr/share/games/applications" "${ED}/usr/share" || die
	mv "${ED}/usr/share/games/icons" "${ED}/usr/share/icons" || die
}

