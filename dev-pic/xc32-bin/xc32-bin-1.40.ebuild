# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils chroot-jail user

DESCRIPTION="Microchip's MPLAB® XC32 Compiler"
HOMEPAGE="http://www.microchip.com/pagehandler/en-us/devtools/mplabxc/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-v1.40-full-install-linux-installer.run"
RESTRICT="mirror userpriv strip"

LICENSE="MICROCHIP"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+system-jre"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

XC32DIR=opt/"${P}"
QA_PREBUILT="${XC32DIR}/*"
CHROOT_JAIL_VERBOSE=0
VERBOSE=0

pkg_setup()
{
	enewgroup xclm
}

src_unpack()
{
	mkdir -p "${S}" || die
	cd "${S}" || die
	cp "${DISTDIR}/xc32-v1.40-full-install-linux-installer.run" . || die
	chmod 0755 xc32-v1.40-full-install-linux-installer.run || die
}

src_install()
{
	# create chroot jail
	chroot_create_jail
	chroot_add_bins bash ln tar gzip ls find
	chroot_add_libs libc.so.6 libdl.so.2 libm.so.6 libnsl.so.1 \
		libreadline.so.6 libncurses.so.5 libacl.so.1 libattr.so.1 \
		libpthread.so.0 libnss_compat.so.2 librt.so.1
	chroot_mv xc32-v1.40-full-install-linux-installer.run /tmp
	installcmd="/tmp/xc32-v1.40-full-install-linux-installer.run"
	installcmd="${installcmd} --installdir /${XC32DIR}"
	installcmd="${installcmd} --netservername ''"

	if [ $VERBOSE == 1 ]; then
		echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nY\n1\n\nN\n\nN\nN\nN\nN\n" > answers || die
		chroot_mv answers /tmp
		installcmd="${installcmd}	--mode text"
		installcmd="${installcmd} 0< /tmp/answers"
	else
		installcmd="${installcmd}	--mode unattended"
	fi
	
	chroot_exec "$installcmd"
	chroot_cleanup

	# remove unnecessary files
	chroot_rm "${XC32DIR}/Uninstall MPLAB XC32 Compiler.desktop"
	chroot_rm "${XC32DIR}/Uninstall-xc32-v1.dat"
	chroot_rm "${XC32DIR}/Uninstall-xc32-v1.40"

	# fix permissions
	einfo "Fixing permissions..."
	find chroot/"${XC32DIR}"/docs -type f -exec chmod 0644 {} \;
	find chroot/"${XC32DIR}"/docs -type d -exec chmod 0755 {} \;
	find chroot/"${XC32DIR}"/examples -type f -exec chmod 0644 {} \;
	find chroot/"${XC32DIR}"/examples -type d -exec chmod 0755 {} \;
	find chroot/"${XC32DIR}"/lib -type f -exec chmod 0644 {} \;
	find chroot/"${XC32DIR}"/lib -type d -exec chmod 0755 {} \;
	find chroot/"${XC32DIR}"/pic32-libs -type f -exec chmod 0644 {} \;
	find chroot/"${XC32DIR}"/pic32-libs -type d -exec chmod 0755 {} \;
	find chroot/"${XC32DIR}"/pic32mx -type f -exec chmod 0644 {} \;
	find chroot/"${XC32DIR}"/pic32mx -type d -exec chmod 0755 {} \;
	find chroot/"${XC32DIR}"/etc -type f -exec chmod 0664 {} \;
	find chroot/"${XC32DIR}"/etc -type d -exec chmod 0775 {} \;
	chown -R root:xclm chroot/"${XC32DIR}"/etc

	chroot_install
	keepdir /opt/microchip/xclm/license
	chown root:xclm "${ED}/opt/microchip/xclm/license"
	chmod 0775 "${ED}/opt/microchip/xclm/license"
}

pkg_postinst()
{
	ewarn "In order to manage XC32 licenses you must"
	ewarn "be in the group xclm."
	ewarn "Just do 'gpasswd -a <USER> xclm'"
}
