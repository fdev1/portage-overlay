# Copyright 1999-2015 Gentoo Foundation
# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit chroot-jail

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

XC16_RESOURCES_DIR=usr/lib/xc16

QA_PREBUILT="
	usr/lib/xc16/lib/* 
	usr/lib/xc16/errata-lib/*"

src_unpack()
{
	mkdir -p "${S}"
	cp "${DISTDIR}/xc16-v1.24-full-install-linux-installer.run" "${S}" || die
}

src_prepare()
{
	chmod 0755 "${S}/xc16-v1.24-full-install-linux-installer.run" || die
}

src_install()
{
	chroot_create_jail
	chroot_add_bins bash ln tar gzip ls find
	chroot_add_libs libc.so.6 libdl.so.2 libm.so.6 libnsl.so.1 \
		libreadline.so.6 libncurses.so.5 libacl.so.1 libattr.so.1 \
		libpthread.so.0 libnss_compat.so.2 librt.so.1
	chroot_mv xc16-v1.24-full-install-linux-installer.run /tmp
	chroot_exec "/tmp/xc16-v1.24-full-install-linux-installer.run \
		--mode unattended --netservername '' --installdir /${XC16_RESOURCES_DIR}"
	chroot_cleanup

	chroot_rm "${XC16_RESOURCES_DIR}/MPLAB_XC16_Compiler_License.txt"
	chroot_rm "${XC16_RESOURCES_DIR}/Uninstall MPLAB XC16 C Compiler.desktop"
	chroot_rm "${XC16_RESOURCES_DIR}/Uninstall-xc16-v1.dat"
	chroot_rm "${XC16_RESOURCES_DIR}/Uninstall-xc16-v1.24"
	chroot_rm -R "${XC16_RESOURCES_DIR}/etc"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-ar"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-as"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-bin2hex"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-cc1"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-gcc"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-ld"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-nm"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-objdump"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-pa"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-ranlib"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-readelf"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-strings"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xc16-strip"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/xclm"
	chroot_rm -f "${XC16_RESOURCES_DIR}/bin/roam.lic"
	chroot_rm -R "${XC16_RESOURCES_DIR}/bin/bin"
	chroot_rm -R /opt

	find chroot -type f -exec chmod 0644 {} \;
	find chroot -type d -exec chmod 0755 {} \;
	chmod 0755 "chroot/${XC16_RESOURCES_DIR}/bin"
	chmod 0755 "chroot/${XC16_RESOURCES_DIR}/bin/sim30"

	chroot_install
	return
	die


	dodir /usr/lib/xc16/
	chmod -R 0755 "${S}/install" || die
	mv "${S}/install/examples" "${ED}/usr/lib/xc16" || die
	mv "${S}/install/include" "${ED}/usr/lib/xc16" || die
	mv "${S}/install/lib" "${ED}/usr/lib/xc16" || die
	mv "${S}/install/support" "${ED}/usr/lib/xc16" || die
	mv "${S}/install/src" "${ED}/usr/lib/xc16" || die
	mv "${S}/install/errata-lib" "${ED}/usr/lib/xc16" || die
	
	dodir /usr/share/doc/xc16-1.24
	find "${S}/install/docs/." \
		-exec cp -r '{}' "${ED}/${EROOT}/usr/share/doc/xc16-1.24/" \; || die
	cp -r "${S}/install/MPLAB_XC16_Compiler_License.txt" \
		"${ED}/${EROOT}/usr/share/doc/xc16-1.24/" || die
}

