# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Proprietary resources needed for Microchip's XC16 Compiler."
HOMEPAGE="http://www.microchip.com/pagehandler/en_us/devtools/mplabxc/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/xc16-v1.24-full-install-linux-installer.run"
RESTRICT="mirror userpriv strip"

LICENSE="MICROCHIP"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="
	usr/lib/xc16/lib/* 
	usr/lib/xc16/errata-lib/*"


pkg_pretend()
{
	mkdir -p /opt/microchip/xclm/license || die
}

pkg_nofetch()
{
	ewarn "This package is fetch restricted."
	ewarn "Please download xc16-v1.24-full-install-linux-installer.run"
	ewarn "from ${HOMEPAGE} and place it in ${DISTDIR}."
}

src_unpack()
{
	mkdir -p "${S}"
	cp "${DISTDIR}/xc16-v1.24-full-install-linux-installer.run" "${S}" || die
}

src_prepare()
{
	chmod +x "${S}/xc16-v1.24-full-install-linux-installer.run" || die
}

src_compile()
{
	addread /opt/microchip/xclm/license
	addwrite /opt/microchip
	addwrite /opt/microchip/xclm
	addwrite /opt/microchip/xclm/license
	einfo "Unpacking files..."
	${S}/xc16-v1.24-full-install-linux-installer.run \
		--prefix ${S}/install \
        --mode unattended \
        --netclient 0 \
        --netservername "" \
        --ModifyAll 0 || die
}

src_install()
{
	dodir "${EROOT}/usr/lib/xc16/"
	chmod -R 0755 "${S}/install" || die
	mv "${S}/install/examples" "${ED}/${EROOT}/usr/lib/xc16" || die
	mv "${S}/install/include" "${ED}/${EROOT}/usr/lib/xc16" || die
	mv "${S}/install/lib" "${ED}/${EROOT}/usr/lib/xc16" || die
	mv "${S}/install/support" "${ED}/${EROOT}/usr/lib/xc16" || die
	mv "${S}/install/src" "${ED}/${EROOT}/usr/lib/xc16" || die
	mv "${S}/install/errata-lib" "${ED}/${EROOT}/usr/lib/xc16" || die
	
	dodir "${EROOT}/usr/share/doc/xc16-1.24"
	find "${S}/install/docs/." \
		-exec cp -r '{}' "${ED}/${EROOT}/usr/share/doc/xc16-1.24/" \; || die
	cp -r "${S}/install/MPLAB_XC16_Compiler_License.txt" \
		"${ED}/${EROOT}/usr/share/doc/xc16-1.24/" || die
}

