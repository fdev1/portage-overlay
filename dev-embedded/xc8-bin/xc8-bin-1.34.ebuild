# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils chroot-jail user

INSTALLER="xc8-v1.34-full-install-linux-installer.run"
DESCRIPTION="Microchip's MPLAB XC8 Compiler"
HOMEPAGE="http://www.microchip.com/pagehandler/en-us/devtools/mplabxc/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/xc8-v1.34-full-install-linux-installer.run"
RESTRICT="mirror userpriv strip"

LICENSE="MICROCHIP"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MERGEDIR=opt/"${P}"
QA_PREBUILT="${MERGEDIR}/*"
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
	cp "${DISTDIR}/${INSTALLER}" . || die
	chmod 0755 ${INSTALLER} || die
}

src_install()
{
	# create chroot jail
	chroot_create_jail
	chroot_add_bins bash ln tar gzip ls find
	chroot_add_libs libc.so.6 libdl.so.2 libm.so.6 libnsl.so.1 \
		libreadline.so.6 libncurses.so.5 libacl.so.1 libattr.so.1 \
		libpthread.so.0 libnss_compat.so.2 librt.so.1
	chroot_mkdir /proc
	chroot_mv ${INSTALLER} /tmp
	installcmd="/tmp/${INSTALLER}"
	installcmd="${installcmd} --prefix /${MERGEDIR}"
	installcmd="${installcmd} --netservername ''"

	if [ $VERBOSE == 1 ]; then
		echo -e "\n\n\n\n\n\n\n\n\n\nY\n1\n\nN\nN\n\nN\nN\nN\nN\n" > answers || die
		chroot_mv answers /tmp
		installcmd="${installcmd}	--mode text"
		installcmd="${installcmd} 0< /tmp/answers"
	else
		installcmd="${installcmd}	--mode unattended"
	fi

	# the installer needs to access /proc to complete
	# successfully.
	(
		addwrite /run/mount/utab
		trap "umount chroot/proc ; exit 1" SIGHUP SIGINT SIGTERM
		mount --bind /proc chroot/proc || die
		chroot_exec "$installcmd"
		umount chroot/proc || die
	) || die 
	chroot_cleanup

	# remove unnecessary files
	chroot_rm "${MERGEDIR}/Uninstall MPLAB XC8 C Compiler.desktop"
	chroot_rm "${MERGEDIR}/Uninstall-xc8-v1.dat"
	chroot_rm "${MERGEDIR}/Uninstall-xc8-v1.34"

	# fix permissions
	einfo "Fixing permissions..."
	find chroot/"${MERGEDIR}"/docs -type f -exec chmod 0644 {} \;
	find chroot/"${MERGEDIR}"/docs -type d -exec chmod 0755 {} \;
	find chroot/"${MERGEDIR}"/include -type f -exec chmod 0644 {} \;
	find chroot/"${MERGEDIR}"/include -type d -exec chmod 0755 {} \;
	find chroot/"${MERGEDIR}"/sources -type f -exec chmod 0644 {} \;
	find chroot/"${MERGEDIR}"/sources -type d -exec chmod 0755 {} \;
	find chroot/"${MERGEDIR}"/dat -type f -exec chmod 0644 {} \;
	find chroot/"${MERGEDIR}"/dat -type d -exec chmod 0755 {} \;
	find chroot/"${MERGEDIR}"/lib -type f -exec chmod 0644 {} \;
	find chroot/"${MERGEDIR}"/lib -type d -exec chmod 0755 {} \;
	find chroot/"${MERGEDIR}"/etc -type f -exec chmod 0664 {} \;
	find chroot/"${MERGEDIR}"/etc -type d -exec chmod 0775 {} \;
	chown -R root:xclm chroot/"${MERGEDIR}"/etc

	chroot_install
	keepdir /opt/microchip/xclm/license
	chown root:xclm "${ED}/opt/microchip/xclm/license"
	chown root:xclm "${ED}/opt/microchip/xc8/v1.34/etc"
	chmod 0775 "${ED}/opt/microchip/xclm/license"
	chmod 0775 "${ED}/opt/microchip/xc8/v1.34/etc/"
}

pkg_postinst()
{
	ewarn "In order to manage XC8 licenses you must"
	ewarn "be in the group xclm."
	ewarn "Just do 'gpasswd -a <USER> xclm'"
}
