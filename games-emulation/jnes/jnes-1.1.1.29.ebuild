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

	MERGEDIR="/opt/jnes-${PV}"
	INSTALLDIR="${D}/${MERGEDIR}"

	# install Jnes
	#
	mkdir -p "${INSTALLDIR}" || die "Install failed!"
	cp -R "${S}/Jnes.chm" "${INSTALLDIR}" || die "Install failed!"
	cp -R "${S}/Jnes.cht" "${INSTALLDIR}" || die "Install failed!"
	cp -R "${S}/Jnes.exe" "${INSTALLDIR}" || die "Install failed!"
	cp -R "${S}/kailleraclient.dll" "${INSTALLDIR}" || die "Install failed!"
	cp -R "${S}/palettes" "${INSTALLDIR}" || die "Install failed!"
	
	# install language files
	#
	use nls && ( cp -R "${S}/languages" "${INSTALLDIR}" || die "Install failed!" )

	# create config file
	#
	echo "[Jnes]" > "${INSTALLDIR}/Jnes.ini" || die "Install failed!"
	echo "options=7052114013" >> "${INSTALLDIR}/Jnes.ini" || die "Install failed!"
	chown root:games "${INSTALLDIR}/Jnes.ini" || die "Install failed!"
	chmod 664 "${INSTALLDIR}/Jnes.ini" || die "Install failed"
	chmod 754 "${INSTALLDIR}/Jnes.exe" || die "Install failed"

	# extract windows ico from executable
	#
	wrestool -x -t 14 "${INSTALLDIR}/Jnes.exe" > "${INSTALLDIR}/Jnes.ico" || die "Install failed!"

	# create executable script in /usr/bin
	#
	mkdir -p "${D}/usr/bin" || die "Install failed!"
	echo "#!/bin/sh" > "${D}/usr/bin/jnes" || die "Install failed!"
	echo "wine \"${MERGEDIR}/Jnes.exe\"" >> "${D}/usr/bin/jnes" || die "Install failed!"
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

