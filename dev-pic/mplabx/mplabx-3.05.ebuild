# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="MPLAB® X Integrated Development Environment (IDE)"
HOMEPAGE="http://www.microchip.com/pagehandler/en-us/family/mplabx/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v3.05-linux-installer.tar"
RESTRICT="mirror userpriv strip"

LICENSE="MICROCHIP"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+system-jre"

DEPEND=""
RDEPEND="${DEPEND}
	system-jre? ( || ( dev-java/oracle-jre-bin dev-java/oracle-jdk-bin ) )
	>=dev-libs/expat-2.1.0[abi_x86_32]
	x11-libs/libX11[abi_x86_32]
	x11-libs/libXext[abi_x86_32]"

QA_PREBUILT="usr/lib/mplabx/*"
VERBOSE=0

src_unpack()
{
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/MPLABX-v3.05-linux-installer.tar" -C "${S}" || die
	cd "${S}" || die
	"${S}/MPLABX-v3.05-linux-installer.sh" --noexec --nolibrarycheck --target . || die

	# stupid mchp devs bundled this file twice, once inside
	# the sh installer and again inside the MPLABX .run
	# installer - I guess they don't feel it's large enough
	# with the bundled jre and all
	rm "${S}/MPLABCOMM-v3.05-linux-installer.run" || die

	# no longer needed
	rm "${S}/MPLABX-v3.05-linux-installer.sh" || die
}

do_java_wrapper()
{
	echo "#!/bin/sh" > ${2} || die
	echo "jrepath=" >> ${2} || die
	echo "jdkpath=" >> ${2} || die
	echo "cd /opt" >> ${2} || die
	echo "for f in \$(ls); do" >> ${2} || die
	echo "        n=\${f%-*}" >> ${2} || die
	echo "        if [ \"\$n\" == \"oracle-jdk-bin\" ]; then" >> ${2} || die
	echo "                jdkpath=/opt/\$f" >> ${2} || die
	echo "        elif [ \"\$n\" == \"oracle-jre-bin\" ]; then" >> ${2} || die
	echo "                jrepath=/opt/\$f" >> ${2} || die
	echo "        fi" >> ${2} || die
	echo "done" >> ${2} || die
	echo "if [ \"\$jdkpath\" != \"\" ]; then" >> ${2} || die
	if [ "${1##*.}" == "jar" ]; then
		echo "	\$jdkpath/bin/java -jar ${1}" >> ${2} || die
	else
		echo "        ${1} --jdkhome \"\$jdkpath\"" >> ${2} || die
	fi
	echo "elif [ \"\$jrepath\" != \"\" ]; then" >> ${2} || die
	if [ "${1##*.}" == "jar" ]; then
		echo "	\$jrepath/bin/java -jar ${1}" >> ${2} || die
	else
		echo "        ${1} --jdkhome \"\$jrepath\"" >> ${2} || die
	fi
	echo "fi" >> ${2} || die
}

src_install()
{
	MPLABXDIR=usr/lib/mplabx
	MPLABCOMMDIR=usr/lib/mplabcomm

	einfo "Creating chroot jail..."
	mkdir -p chroot/{bin,etc,$(get_libdir),usr/{bin,$(get_libdir),local/lib},tmp} || die
	cp -L ${EROOT}/sbin/ldconfig chroot/bin || die
	cp -L ${EROOT}/usr/bin/find chroot/bin || die
	cp -L ${EROOT}/bin/{sh,ln,tar,gzip} chroot/bin || die
	cp -L ${EROOT}/$(get_libdir)/libc.so.6 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/ld-linux.so.2 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libdl.so.2 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libm.so.6 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libnsl.so.1 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libreadline.so.6 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libncurses.so.5 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libacl.so.1 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libattr.so.1 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libpthread.so.0 chroot/$(get_libdir) || die
	cp -L ${EROOT}/$(get_libdir)/libnss_compat.so.2 chroot/$(get_libdir) || die
	mv MPLABX-v3.05-linux-installer.run chroot/tmp || die

	# create a dummy libsandbox.so for the chroot
	# this is not a problem because it will only be used
	# inside the chroot
	#echo "" | gcc -nostdlib -nostartfiles -shared -o chroot/$(get_libdir)/libsandbox.so -xc - || die

	echo "root:x:0:0:root:/root:/bin/bash" > chroot/etc/passwd || die
	echo "root:x:0:root" > chroot/etc/group || die
	echo "/$(get_libdir)" >> chroot/etc/ld.so.conf || die

	if [ "$(get_libdir)" == "lib64" ]; then
		mkdir -p chroot/lib32 || die
		cp -L ${EROOT}/$(get_libdir)/ld-linux-x86-64.so.2 chroot/$(get_libdir) || die
		cp -L ${EROOT}/lib32/libc.so.6 chroot/lib32 || die
		cp -L ${EROOT}/lib32/ld-linux.so.2 chroot/lib32 || die
		cp -L ${EROOT}/lib32/libdl.so.2 chroot/lib32 || die
		cp -L ${EROOT}/lib32/libm.so.6 chroot/lib32 || die
		cp -L ${EROOT}/lib32/libnsl.so.1 chroot/lib32 || die
		cp -L ${EROOT}/lib32/libpthread.so.0 chroot/lib32 || die
		cp -L ${EROOT}/lib32/libnss_compat.so.2 chroot/lib32 || die
		ln -s $(get_libdir) chroot/lib || die
		echo "/lib32" >> chroot/etc/ld.so.conf || die
	fi
	
	if [ $VERBOSE == 1 ]; then
		einfo "Running MPLAB X installer..."
		echo -e "\n\n\n\n\n\n\n\n\n\nY\n\nY\nY\n\nY\nN\nN\nN\nN\nN\n" > chroot/tmp/answers || die
		installcmd="/tmp/MPLABX-v3.05-linux-installer.run"
		installcmd="$installcmd	--mode text"
		installcmd="$installcmd --installdir /${MPLABXDIR}  0< /tmp/answers"
	else
		einfo "Reticulating splines..."
		installcmd="/tmp/MPLABX-v3.05-linux-installer.run"
		installcmd="$installcmd	--mode unattended"
		installcmd="$installcmd --installdir /${MPLABXDIR}"
	fi
	env -i chroot ./chroot /bin/sh -c "export PATH=/bin && ldconfig && $installcmd" \
		2>&1 > /dev/null || die

	einfo "Fixing installation..."
	rm -fr chroot/{bin,lib,lib32,lib64,tmp} || die
	mkdir -p chroot/lib/udev || die
	mkdir -p chroot/${MPLABCOMMDIR} || die
	rm -r chroot/"${MPLABCOMMDIR}" || die
	mv -f chroot/opt/microchip/mplabcomm/v3.05 chroot/"${MPLABCOMMDIR}" || die
	rm -r chroot/opt || die
	rm -r chroot/etc/{group,passwd,ld.so.conf,ld.so.cache} || die
	mv -f chroot/etc/udev/rules.d chroot/lib/udev
	rm -r chroot/etc/udev
	mv -f chroot/etc/.mplab_ide chroot/etc/mplabx || die
	rm -f chroot/etc/mplabx/mchplinusbdevice || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/mchplinusbdevice chroot/etc/mplabx/mchplinusbdevice || die
	ln -s mplabx chroot/etc/.mplab_ide || die
	
	sed -i \
		-e "s/.png//g" \
		-e "s/Application;Development;Programming;/Development;IDE;/g" \
		chroot/usr/share/applications/mplab.desktop || die
	sed -i \
		-e "s/.png//g" \
		-e "s/Application;Development;Programming;/Development;IDE;/g" \
		chroot/usr/share/applications/mplab_ipe.desktop || die

	# fix /usr/bin symlinks
	rm -f chroot/usr/bin/{mplab_ide,mplab_ipe} || die
	ln -s ../../"${MPLABXDIR}"/mplab_ide/bin/mplab_ide chroot/usr/bin/mplab_ide || die
	ln -s ../../"${MPLABXDIR}"/mplab_ipe/mplab_ipe chroot/usr/bin/mplab_ipe || die

	# fix library  locations
	mv chroot/usr/lib/libSEGGERAccessLink.so . || die
	mv chroot/usr/local/lib/libjlinkpic32.so.4.96.7 . || die
	rm -f chroot/usr/lib/{libSerialAccessLink.so,libUSBAccessLink.so} || die
	rm -f chroot/usr/local/lib/{libjlinkpic32.so,libmchpusb-1.0.so} || die

	mv libSEGGERAccessLink.so chroot/"${MPLABCOMMDIR}"/lib || die
	mv libjlinkpic32.so.4.96.7 chroot/"${MPLABCOMMDIR}"/lib || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/libSEGGERAccessLink.so chroot/usr/$(get_libdir)/libSEGGERAccessLink.so || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/libjlinkpic32.so.4.96.7 chroot/usr/$(get_libdir)/libjlinkpic32.so.4.96.7 || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/libSerialAccessLink.so chroot/usr/$(get_libdir)/libSerialAccessLink.so || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/libUSBAccessLink.so chroot/usr/$(get_libdir)/libUSBAccessLink.so || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/libjlinkpic32.so.4.96.7 chroot/usr/$(get_libdir)/libjlinkpic32.so || die
	ln -s ../../"${MPLABCOMMDIR}"/lib/libmchpusb-1.0.so.0.0.0 chroot/usr/$(get_libdir)/libmchpusb-1.0.so || die

	rm -f chroot/"${MPLABXDIR}"/Uninstall_MPLAB_X_IDE_v3.05.desktop || die
	rm -f chroot/"${MPLABXDIR}"/Uninstall_MPLAB_X_IDE_v3.dat || die
	rm -f chroot/"${MPLABXDIR}"/Uninstall_MPLAB_X_IDE_v3.05 || die
	rm -r chroot/usr/local || die
	#[ "$(get_libdir)" != "lib" ] && rm -r chroot/usr/lib || die

	# move documentation
	mkdir -p chroot/usr/share/doc || die
	mv chroot/${MPLABXDIR}/docs chroot/usr/share/doc/"${P}" || die

	# fix permissions
	chmod 0644 chroot/etc/mplabx/mchpsegport || die
	chmod 0644 chroot/lib/udev/rules.d/z011_mchp_jlink.rules || die
	chmod -R 0644 chroot/usr/share/doc || die

	if use system-jre; then
		# unbundle jre
		einfo "Unbundling JRE..."
		rm -r chroot/"${MPLABXDIR}"/sys || die
		mv chroot/"${MPLABXDIR}"/mplab_ide/bin/mplab_ide \
			chroot/"${MPLABXDIR}"/mplab_ide/bin/mplab_ide-run || die
		do_java_wrapper "${EROOT}"/"${MPLABXDIR}"/mplab_ide/bin/mplab_ide-run \
			chroot/"${MPLABXDIR}"/mplab_ide/bin/mplab_ide
		chmod 0755 chroot/"${MPLABXDIR}"/mplab_ide/bin/mplab_ide || die
		mv chroot/"${MPLABXDIR}"/mplab_ipe/mplab_ipe \
			chroot/"${MPLABXDIR}"/mplab_ipe/mplab_ipe-run || die
		do_java_wrapper "${EROOT}"/"${MPLABXDIR}"/mplab_ipe/ipe.jar \
			chroot/"${MPLABXDIR}"/mplab_ipe/mplab_ipe

		chmod 0755 chroot/"${MPLABXDIR}"/mplab_ipe/mplab_ipe || die
	fi

	# install to final destination
	einfo "Installing to image directory..."
	find chroot -mindepth 1 -maxdepth 1 -exec mv '{}' "${ED}" \; || die
}

pkg_postinst()
{
	ewarn "In order to use MPLAB X you'll need to install"
	ewarn "one of the following compilers:"
	ewarn "    dev-pic/xc16"
	ewarn "    dev-pic/xc32"
}
