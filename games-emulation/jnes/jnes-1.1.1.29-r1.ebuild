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
	unzip -q -x "${DISTDIR}/${A}" -d "${S}" || die "Unpack failed!"
}

src_install()
{

	MERGEDIR="/opt/jnes"

	# install Jnes
	diropts --owner=root --group=games --mode=775
	dodir "${MERGEDIR}"
	insinto "${MERGEDIR}"
	insopts --owner=root --group=root --mode=755
	doins "${S}/Jnes.exe"
	insopts --owner=root --group=root --mode=644
	doins "${S}/Jnes.chm"
	doins "${S}/Jnes.cht"
	doins "${S}/kailleraclient.dll"
	dodir "${MERGEDIR}/palettes"
	insinto "${MERGEDIR}/palettes"
	doins "${S}/palettes/Accurate.pal"
	doins "${S}/palettes/BMFFINR3.PAL"
	doins "${S}/palettes/file_id.diz"
	doins "${S}/palettes/mattc.pal"

	if use nls; then
		dodir "${MERGEDIR}/languages"
		insinto "${MERGEDIR}/languages"
		doins "${S}/languages/chs.msg"
		doins "${S}/languages/cz.msg"
		doins "${S}/languages/de.msg"
		doins "${S}/languages/en.msg.example"
		doins "${S}/languages/es.msg"
		doins "${S}/languages/est.msg"
		doins "${S}/languages/fi.msg"
		doins "${S}/languages/fr.msg"
		doins "${S}/languages/gl.msg"
		doins "${S}/languages/hun.msg"
		doins "${S}/languages/ita.msg"
		doins "${S}/languages/lt.msg"
		doins "${S}/languages/nl.msg"
		doins "${S}/languages/pl.msg"
		doins "${S}/languages/pt-br.msg"
		doins "${S}/languages/pt-gz.msg"
		doins "${S}/languages/ro.msg"
		doins "${S}/languages/ru.msg"
		doins "${S}/languages/tr.msg"
		doins "${S}/languages/tt.msg"
		doins "${S}/languages/ukr.msg"
	fi

	# create config file
	echo "[Jnes]" > jnes.ini || die "Install failed!"
	echo "options=7052114013" >> jnes.ini || die "Install failed!"
	#touch jnes-browser.cache || die
	insopts --owner=root --group=games --mode=664
	insinto /etc
	doins jnes.ini
	dosym /etc/jnes.ini "${MERGEDIR}/Jnes.ini"
	#dosym /var/cache/jnes/browser.cache "${MERGEDIR}/browser.cache"

	#diropts --owner=root --group=games --mode=0775
	#dodir /var/cache/jnes

	# extract windows ico from executable
	wrestool -x -t 14 "${S}/Jnes.exe" > Jnes.ico || die "Install failed!"
	insopts --owner=root --group=root --mode=644
	insinto "${MERGEDIR}"
	doins Jnes.ico

	# create executable script in /usr/bin
	echo "#!/bin/sh" > jnes || die
	echo 'cd $HOME' >> jnes || die
	echo "wine \"${MERGEDIR}/Jnes.exe\"" >> jnes || die
	insopts --owner=root --group=root --mode=755
	doins jnes
	dosym "${MERGEDIR}/jnes" /usr/bin/jnes

	# create desktop menu entry
	echo "[Desktop Entry]" > jnes.desktop || die
	echo "Name=Jnes" >> jnes.desktop || die
	echo "Comment=NES Emulator for Windows" >> jnes.desktop || die
	echo "Exec=${EROOT}/usr/bin/jnes" >> jnes.desktop || die
	echo "Icon=${MERGEDIR}/Jnes.ico" >> jnes.desktop || die
	echo "Terminal=false" >> jnes.desktop || die
	echo "Type=Application" >> jnes.desktop || die
	echo "Categories=Game;Emulator;" >> jnes.desktop || die
	sed -ie "s://:/:g" jnes.desktop || die
	domenu jnes.desktop
}

