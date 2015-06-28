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
KEYWORDS="x86 amd64"
IUSE="nls"

DEPEND="
	app-arch/unzip
	media-gfx/icoutils
"
RDEPEND="${DEPEND}
	app-emulation/wine[abi_x86_32]
"

src_unpack()
{
	mkdir -p "${S}" || die "Unpack failed!"
	unzip -x "${DISTDIR}/${A}" -d "${S}" >/dev/null || die "Unpack failed!"
}

src_install()
{
	# install Jnes
	#
	mkdir -p "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/Jnes.chm" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/Jnes.cht" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/Jnes.exe" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/kailleraclient.dll" "${D}/usr/lib/jnes" || die "Install failed!"
	cp -R "${S}/palettes" "${D}/usr/lib/jnes" || die "Install failed!"
	
	# install language files
	#
	use nls && ( cp -R "${S}/languages" "${D}/usr/lib/jnes" || die "Install failed!" )

	# create config file
	#
	echo "[Jnes]" > "${D}/usr/lib/jnes/Jnes.ini" || die "Install failed!"
	echo "options=7052114013" >> "${D}/usr/lib/jnes/Jnes.ini" || die "Install failed!"
	chown root:games "${D}/usr/lib/jnes/Jnes.ini" || die "Install failed!"
	chmod 664 "${D}/usr/lib/jnes/Jnes.ini" || die "Install failed"
	chmod 754 "${D}/usr/lib/jnes/Jnes.exe" || die "Install failed"

	# extract windows ico from executable
	#
	wrestool -x -t 14 "${D}/usr/lib/jnes/Jnes.exe" > "${D}/usr/lib/jnes/Jnes.ico" || die "Install failed!"

	# create executable script in /usr/bin
	#
	mkdir -p "${D}/usr/bin" || die "Install failed!"
	echo "#!/bin/sh" > "${D}/usr/bin/jnes" || die "Install failed!"
	echo "wine /usr/lib/jnes/Jnes.exe" >> "${D}/usr/bin/jnes" || die "Install failed!"
	chown root:games "${D}/usr/bin/jnes" || die "Install failed!"
	chmod 754 "${D}/usr/bin/jnes" || die "Install failed!"

	# create desktop menu entry
	#
	echo "[Desktop Entry]" > jnes.desktop || die "Install failed!"
	echo "Name=Jnes" >> jnes.desktop || die "Install failed!"
	echo "Comment=NES Emulator for Windows" >> jnes.desktop || die "Install failed!"
	echo "Exec=wine /usr/lib/jnes/Jnes.exe" >> jnes.desktop || die "Install failed!"
	echo "Icon=/usr/lib/jnes/Jnes.ico" >> jnes.desktop || die "Install failed!"
	echo "Terminal=false" >> jnes.desktop || die "Install failed!"
	echo "Type=Application" >> jnes.desktop || die "Install failed!"
	echo "Categories=Game;Emulator;" >> jnes.desktop || die "Install failed!"
	domenu jnes.desktop || die "Install failed!"

}

