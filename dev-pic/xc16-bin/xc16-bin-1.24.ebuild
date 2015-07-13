# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils chroot-jail

DESCRIPTION="XC16 Compiler for Microchip's 16-bit MCU's and DSP's."
HOMEPAGE="http://www.microchip.com/pagehandler/en-us/devtools/mplabxc/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/xc16-v1.24-full-install-linux-installer.run"
RESTRICT="mirror userpriv strip"

LICENSE="MICROCHIP"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

INSTALLDIR=opt/"${P}"
QA_PREBUILT="${INSTALLDIR}/*"
CHROOT_JAIL_VERBOSE=1
VERBOSE=0

src_unpack()
{
	mkdir -p "${S}" || die
	cd "${S}" || die
	cp "${DISTDIR}/xc16-v1.24-full-install-linux-installer.run" . || die
	chmod 0755 xc16-v1.24-full-install-linux-installer.run || die
}

src_install()
{
	# create chroot jail
	chroot_create_jail
	chroot_add_bins bash ln tar gzip ls find
	chroot_add_libs libc.so.6 libdl.so.2 libm.so.6 libnsl.so.1 \
		libreadline.so.6 libncurses.so.5 libacl.so.1 libattr.so.1 \
		libpthread.so.0 libnss_compat.so.2 librt.so.1
	chroot_mv xc16-v1.24-full-install-linux-installer.run /tmp
	
	if [ $VERBOSE == 1 ]; then
		echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\nY\n1\nN\n\nN\nY\nN\nN\nN\n\n" > answers || die
		chroot_add_file answers /tmp
		installcmd="/tmp/xc16-v1.24-full-install-linux-installer.run"
		installcmd="$installcmd	--mode text"
		installcmd="$installcmd --installdir /${INSTALLDIR}  0< /tmp/answers"
	else
		installcmd="/tmp/xc16-v1.24-full-install-linux-installer.run"
		installcmd="$installcmd	--mode unattended"
		installcmd="$installcmd --netservername ''"
		installcmd="$installcmd --installdir /${INSTALLDIR}"
	fi
	
	chroot_exec "$installcmd"
	chroot_cleanup

	# remove unnecessary files
	chroot_rm "${INSTALLDIR}/Uninstall MPLAB XC16 C Compiler.desktop"
	chroot_rm "${INSTALLDIR}/Uninstall-xc16-v1.dat"
	chroot_rm "${INSTALLDIR}/Uninstall-xc16-v1.24"
	chmod -R 0644 chroot/${INSTALLDIR}/docs || die
	chmod -R 0644 chroot/${INSTALLDIR}/lib || die
	chmod -R 0644 chroot/${INSTALLDIR}/errata-lib || die
	chmod -R 0644 chroot/${INSTALLDIR}/include || die
	chmod -R 0644 chroot/${INSTALLDIR}/support || die
	chmod -R 0644 chroot/${INSTALLDIR}/src || die
	chmod -R 0644 chroot/${INSTALLDIR}/examples || die

	chroot_install
}

