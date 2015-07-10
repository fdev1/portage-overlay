# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="MPLAB® X Integrated Development Environment (IDE)"
HOMEPAGE="http://www.microchip.com/pagehandler/en-us/family/mplabx/"
SRC_URI="http://www.microchip.com/mplabx-ide-linux-installer -> MPLABX-v3.05-linux-installer.tar"
RESTRICT="fetch userpriv strip"

LICENSE="MICROCHIP"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/jdk
	dev-pic/xc16
	>=dev-libs/expat-2.1.0[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	x11-libs/libXext[abi_x86_32]"

QA_PREBUILT="usr/lib/mplabx/*"

src_unpack()
{
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/MPLABX-v3.05-linux-installer.tar" -C "${S}" || die
	cd "${S}" || die
	#cp "${FILESDIR}/do_install.sh" . || die
	#chmod +x do_install.sh || die
	"${S}/MPLABX-v3.05-linux-installer.sh" --noexec --nolibrarycheck --target . || die
	mv "${S}/MPLABCOMM-v3.05-linux-installer.run" "${S}/MPLABCOMM-v3.05-linux-installer.runlater" || die
	echo -e "#/bin/sh\necho 'Fuck You!!!!!!!!!!'" > "${S}/MPLABCOMM-v3.05-linux-installer.run" || die
	#sed -i \
	#	-e "s:INSTALLDIR:${D}/usr/lib/mplabx:g" \
	#	-e "s:ANSWERS:${FILESDIR}/answers:g" do_install.sh || die
}

restore_preserved()
{
	if [ -f preserved/etc/.mplab_ide/mchpdefport ]; then
		mv preserved/etc/.mplab_ide/mchpdefport /etc/.mplab_ide/
	fi
	if [ -f preserved/etc/.mplab_ide/mchplinusbdevice ]; then
		mv preserved/etc/.mplab_ide/mchplinusbdevice /etc/.mplab_ide
	fi
	if [ -f preserved/etc/udev/rules.d/z010_mchp_tools.rules ]; then
		mv preserved/etc/udev/rules.d/z010_mchp_tools.rules /etc/udev/rules.d/z010_mchp_tools.rules
	fi
}

src_install_die()
{
	restore_preserved
}

do_java_wrapper()
{
	echo "#!/bin/sh" > mplab_ide || die
	echo "jrepath=" >> mplab_ide || die
	echo "jdkpath=" >> mplab_ide || die
	echo "cd /opt" >> mplab_ide || die
	echo "for f in \$(ls); do" >> mplab_ide || die
	echo "        n=\${f%-*}" >> mplab_ide || die
	echo "        if [ \"\$n\" == \"oracle-jdk-bin\" ]; then" >> mplab_ide || die
	echo "                jdkpath=/opt/\$f" >> mplab_ide || die
	echo "        elif [ \"\$n\" == \"oracle-jre-bin\" ]; then" >> mplab_ide || die
	echo "                jrepath=/opt/\$f" >> mplab_ide || die
	echo "        fi" >> mplab_ide || die
	echo "done" >> mplab_ide || die
	echo "if [ \"\$jdkpath\" != \"\" ]; then" >> mplab_ide || die
	echo "        ${EROOT}/usr/lib/mplabx/mplab_ide/bin/${1} --jdkhome \"\$jdkpath\"" >> mplab_ide || die
	echo "elif [ \"\$jrepath\" != \"\" ]; then" >> mplab_ide || die
	echo "        ${EROOT}/usr/lib/mplabx/mplab_ide/bin/${1} --jdkhome \"\$jrepath\"" >> mplab_ide || die
	echo "fi" >> mplab_ide || die
}

src_install()
{
	dodir /usr/bin
	mkdir -p preserved || die

	addwrite "/etc/.mplab_ide"
	addwrite "/etc/.mplab_ide/mchpdefport"
	addwrite "/etc/udev/rules.d/z010_mchp_tools.rules"
	addwrite "/usr/local/lib"
	addwrite "/usr/$(get_libdir)/libUSBAccessLink.so"
	addwrite "/usr/$(get_libdir)/libSerialAccessLink.so"

	if [ -f /etc/.mplab_ide/mchpdefport ]; then
		mkdir -p preserved/etc/.mplab_ide || die
		mv /etc/.mplab_ide/mchpdefport preserved/etc/.mplab_ide/ || die
	fi
	if [ -f /etc/.mplab_ide/mchplinusbdevice ]; then
		mkdir -p preserved/etc/.mplab_ide || die
		mv /etc/.mplab_ide/mchplinusbdevice preserved/etc/.mplab_ide/ || die
	fi
	if [ -f /etc/udev/rules.d/z010_mchp_tools.rules ]; then
		mkdir -p preserved/etc/udev/rules.d || die
		mv /etc/udev/rules.d/z010_mchp_tools.rules preserved/etc/udev/rules.d || die
	fi

	mkdir -p "/etc/.mplab_ide" || die
	addwrite "/usr/share"
	addwrite "/usr/share/applications"
	addwrite "/usr/share/applications/mplab_ipe.desktop"
	addwrite "/opt/microchip"

	# preserve mplab_ipe.desktop
	if [ -f /usr/share/applications/mplab_ipe.desktop ]; then
		mkdir -p preserved/usr/share/applications || die
		chmod 0644 /usr/share/applications/mplab_ipe.desktop
		mv /usr/share/applications/mplab_ipe.desktop preserved/usr/share/applications/
	fi

#./MPLABX-v3.05-linux-installer.sh -- --mode unattended --ide 1 --ipe 1 --installdir /opt/mplab
#	${S}/MPLABX-v3.05-linux-installer.sh --nolibrarycheck -- \	
#		--mode unattended \
#		--ide 1 \
#		--ipe 1 \
#		--installdir ${ED}/${EROOT}/usr/lib/mplabx

	#einfo "Installing MPLABCOMM..."
	#sudo "${S}/MPLABCOMM-v3.05-linux-installer.run" \
	#	--unattendedmodeui none \
	#	--mode unattended \
	#	--installdir "${ED}/${EROOT}/usr/lib/mplabx" || die


	sudo ${S}/MPLABX-v3.05-linux-installer.run \
		--mode text \
		--installdir ${ED}/${EROOT}/usr/lib/mplabx 0< ${FILESDIR}/answers

	#die
	#./do_install.sh
	#${S}/MPLABX-v3.05-linux-installer.run \
	#	--unattendedmodeui none \
	#	--mode unattended \
	#	--ide 1 \
	#	--installdir "${ED}/${EROOT}/usr/lib/mplabx" || die


	#einfo "Installing COMM drivers..."
	#"${S}/MPLABCOMM-v3.05-linux-installer.run" \
	#	--unattendedmodeui none \
	#	--mode unattended \
	#	--installdir "${ED}/${EROOT}/usr/lib/mplabx/comm" || die

	#mplabcomm
	mv /opt/microchip/mplabcomm/v3.05 \
		"${ED}/${ROOT}"/usr/lib/mplabcomm || die

	#jre1.7.0_67
	einfo "Unbundling JRE..."
	rm -rf "${ED}/usr/lib/mplabx/sys"
	rm -f "${ED}/usr/lib/mplabx/Uninstall_MPLAB_X_IDE_v3.dat"
	rm -f "${ED}/usr/lib/mplabx/Uninstall_MPLAB_X_IDE_v3.05.desktop"
	rm -f "${ED}/usr/lib/mplabx/Uninstall_MPLAB_X_IDE_v3.05"
	mv "${ED}/${EROOT}/usr/lib/mplabx/mplab_ide/bin/mplab_ide" \
		"${ED}/${EROOT}/usr/lib/mplabx/mplab_ide/bin/mplab_ide-run" || die
	do_java_wrapper mplab_ide-run mplab_ide
	insopts --mode=755
	insinto "${EROOT}/usr/lib/mplabx/mplab_ide/bin"
	doins mplab_ide

	mkdir -p "${ED}/${EROOT}/usr/share/doc"
	mv "${ED}/${EROOT}/usr/lib/mplabx/docs" "${ED}/${EROOT}/usr/share/doc/${P}"

	chmod 0644 /usr/share/applications/mplab_ipe.desktop
	rm -f "/usr/share/applications/mplab_ipe.desktop"
	rm -fr "${ED}/${EROOT}/usr/lib/mplabx/rollbackBackupDirectory" || die
	#rm -f "/usr/$(get_libdir)/libUSBAccessLink.so" || die
	#rm -f "/usr/$(get_libdir)/libSerialAccessLink.so" || die
	#rm -f "/usr/local/lib/libmchpusb-1.0.so"
	mv /etc/udev/rules.d/z010_mchp_tools.rules .
	dosym "../lib/mplabcomm/lib/libUSBAccessLink.so" "${EROOT}/usr/$(get_libdir)/libUSBAccessLink.so"
	dosym "../lib/mplabcomm/lib/libSerialAccessLink.so" "${EROOT}/usr/$(get_libdir)/libSerialAccessLink.so"
	dosym "../lib/mplabcomm/lib/libmchpusb-1.0.so.0.0.0" "${EROOT}/usr/$(get_libdir)/libmchpusb-1.0.so"

	#insopts --mode=0644
	#insinto /lib/udev/rules.d
	#doins z010_mchp_tools.rules

	echo "localhost" > mchpdefport || die
	echo "30000" >> mchpdefport || die
	echo "30002" >> mchpdefport || die
	echo "30004" >> mchpdefport || die
	echo "30006" >> mchpdefport || die
	echo "30008" >> mchpdefport || die
	insinto /etc/.mplab_ide 
	doins mchpdefport

	rm "${ED}/${EROOT}/usr/lib/mplabx/mplab_ipe/mplab_ipe"
	echo "#!/bin/sh" > mplab_ipe || die
	echo "/usr/bin/java -jar /usr/lib/mplabx/mplab_ipe/ipe.jar" >> mplab_ipe || die
	insopts --mode=0755
	insinto "${EROOT}/usr/lib/mplabx/mplab_ipe"
	doins mplab_ipe

	insopts --mode=0644
	echo "[Desktop Entry]" > mplab_ipe.desktop || die
	echo "Name=MPLAB IPE" >> mplab_ipe.desktop || die
	echo "Comment=IPE for Microchip PIC and dsPIC programming" >> mplab_ipe.desktop || die
	echo "Exec=/usr/bin/mplab_ipe" >> mplab_ipe.desktop || die
	#echo "Icon=mplab_ipe.png" >> mplab_ipe.desktop || die
	echo "Terminal=false" >> mplab_ipe.desktop || die
	echo "Type=Application" >> mplab_ipe.desktop || die
	echo "Categories=Development;IDE;" >> mplab_ipe.desktop || die
	echo "StartupNotify=true" >> mplab_ipe.desktop || die
	domenu mplab_ipe.desktop	

	dosym "${EROOT}/usr/lib/mplabx/mplab_ipe/mplab_ipe" "${EROOT}/usr/bin/mplab_ipe"
	dosym "${EROOT}/usr/lib/mplabx/mplab_ide/bin/mplab_ide" "${EROOT}/usr/bin/mplab_ide"
	
	# install config files
	#mv /etc/.mplab_ide/mchpdefport .
	rm /etc/.mplab_ide/mchplinusbdevice
	dodir /etc/.mplab_ide
	insinto /etc/.mplab_ide
	insopts --mode=0744
	doins mchpdefport
	dosym ${EROOT}/usr/lib/mplabcomm/lib/mchplinusbdevice /etc/.mplab_ide/mchplinusbdevice
	
	# restore any preserved files
	#mv preserved/* / || die
	restore_preserved
}

