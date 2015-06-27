# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the WFTPL version 2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="NES emulator for Windows by Jabo"
HOMEPAGE="http://www.jabosoft.com/categories/1"
SRC_URI="http://www.jabosoft.com/downloads/files/jnes_1_1_1.zip"

LICENSE="jnes"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

src_unpack()
{
	mkdir -p "${S}"
	unzip -x "/usr/portage/distfiles/${A}" -d "${S}"
}

src_install()
{
	# install Jnes
	#
	mkdir -p ${D}/usr/lib/jnes
	cp -R "${S}/Jnes.chm" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/Jnes.cht" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/Jnes.exe" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/kailleraclient.dll" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/languages" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/palettes" "${D}/usr/lib/jnes" || die "Install failed!"

	# extract windows ico from executable
	#
	wrestool -x -t 14 "${D}/usr/lib/jnes/Jnes.exe" > "${D}/usr/lib/jnes/Jnes.ico"

	# create desktop menu entry
	#
	mkdir -p "${D}/usr/share/applications"
	echo "[Desktop Entry]" > "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Name=Jnes" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Comment=NES Emulator for Windows" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Exec=wine ${D}/lib/jnes/Jnes.exe" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Icon=${D}/lib/jnes/Jnes.ico" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Terminal=false" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Type=Application" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
	echo "Categories=Game;Emulator;" >> "${D}/usr/share/applications/jnes-ebuild.desktop"
}
