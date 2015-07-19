# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="XC16 Compiler for Microchip's 16-bit MCU's and DSP's."
HOMEPAGE="http://www.microchip.com/pagehandler/en_us/devtools/mplabxc/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/xc16-v1.24-src.zip"
#http://www.microchip.com/pagehandler/en-us/devtools/dev-tools-parts.html
RESTRICT="primaryuri strip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="
	app-arch/unzip
"
RDEPEND="${DEPEND}
	=sci-electronics/xc16-resources-1.24"

src_unpack()
{
	unzip -q "${DISTDIR}/xc16-v1.24-src.zip" || die
	mv "${WORKDIR}/v1.24.src" "${S}" || die
}

src_prepare()
{
	sed -i \
		-e "s/--host=i386-linux/--host=${CHOST} --build=${CHOST}/g" \
		-e "s/-cross=i686-pc-mingw32-nolm//g" \
		-e 's/EXTRA_CFLAGS=""/EXTRA_CFLAGS="-m32 -ggdb -D_FORTIFY_SOURCE=0"/g' \
		-e 's/\sCFLAGS="/CFLAGS="-m32 -ggdb -D_FORTIFY_SOURCE=0 /g' \
		-e 's/-DMCHP_VERSION=v0_00/-DMCHP_VERSION=v1.24/g' \
		"${S}/src_build.sh" || die

	sed -i \
		-e "s/--host=\${TARGET_OS}/--host=${CHOST} --build=${CHOST}/g" \
		-e "s/--host=i386-\${TARGET_OS}/--host=${CHOST} --build=${CHOST}/g" \
		-e "s/--build=\$BUILD_OS/--build=${CHOST} --host=${CHOST}/g" \
		-e "s/export CFLAGS=-m32//g" \
		-e "s/export CXXFLAGS=-m32//g" \
		-e 's|email:`whoami`\@`hostname`|https://github.com/fernando-rodriguez/freexc16/issues|g' \
		-e "s/gcc -o/${CHOST}-gcc -o/g" \
		-e "s/-j 2/${MAKEOPTS}/g" \
		-e "s/ZLIB_TOOLS=\".*{TARGET_OS}\"/ZLIB_TOOLS=\"${CHOST}\"/g" \
		-e 's/EXTRA_DEFINES="-DRESOURCE_MISMATCH_OK"/EXTRA_DEFINES=""/g' \
		-e "s/--disable-rpath//g" \
		"${S}/build_XC16_451" || die

	# copy necessary resource files	
	cp -f /usr/lib/xc16/bin/c30_device.info "${S}"/src/c30_resource/src/c30/ || die
	cp -f /usr/lib/xc16/bin/deviceSupport.xml "${S}"/src/c30_resource/src/c30/ || die
	cp -r /usr/lib/xc16/bin/device_files "${S}"/src/c30_resource/src/c30/ || die
	
}

src_compile()
{
	./src_build.sh || die
}

xc16_wrapper()
{
	echo "#!/bin/sh" > ${1} || die
	echo "XC16_ARGS=" >> ${1} || die
	echo "XC16_CMD=\${0##*-}" >> ${1} || die
	echo "XC16_INP=\$XC16_CMD" >> ${1} || die
	echo "while [ \$# != 0 ]; do" >> ${1} || die
	echo "        case \$1 in" >> ${1} || die
	echo "                -omf=elf) XC16_CMD=\"elf-\${XC16_CMD}\" ;;" >> ${1} || die
	echo "                -omf=coff) XC16_CMD=\"coff-\${XC16_CMD}\" ;;" >> ${1} || die
	echo "                *) XC16_ARGS=\"\${XC16_ARGS} \$1\" ;;" >> ${1} || die
	echo "        esac" >> ${1} || die
	echo "        shift" >> ${1} || die
	echo "done" >> ${1} || die
	echo "if [ \"\$XC16_CMD\" == \"\$XC16_INP\" ]; then" >> ${1} || die
	echo "        XC16_CMD=\"elf-\${XC16_CMD}\"" >> ${1} || die
	echo "fi" >> ${1} || die
	echo "exec \"${EROOT}/usr/lib/xc16/bin/bin/\$XC16_CMD\" \$XC16_ARGS" >> ${1} || die
}

src_install()
{
	dodir "${EROOT}/usr/lib/xc16/bin"
	mv "${S}/install/bin/bin" "${ED}/${EROOT}/usr/lib/xc16/bin" || die
	#mv "${S}/install/bin/c30_device.info" "${ED}/${EROOT}/usr/lib/xc16/bin" || die

	# create and install wrapper scripts
	xc16_wrapper xc16-as
	xc16_wrapper xc16-ar
	xc16_wrapper xc16-bin2hex
	xc16_wrapper xc16-cc1
	xc16_wrapper xc16-gcc
	xc16_wrapper xc16-ld
	xc16_wrapper xc16-objdump
	xc16_wrapper xc16-strip
	insopts --mode=0755
	insinto "${EROOT}/usr/lib/xc16/bin"
	doins xc16-as
	doins xc16-ar
	doins xc16-bin2hex
	doins xc16-cc1
	doins xc16-gcc
	doins xc16-ld
	doins xc16-objdump
	doins xc16-strip

	# create symlinks in /usr/bin
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-as" "${EROOT}/usr/bin/xc16-as"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-ar" "${EROOT}/usr/bin/xc16-ar"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-bin2hex" "${EROOT}/usr/bin/xc16-bin2hex"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-cc1" "${EROOT}/usr/bin/xc16-cc1"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-gcc" "${EROOT}/usr/bin/xc16-gcc"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-ld" "${EROOT}/usr/bin/xc16-ld"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-objdump" "${EROOT}/usr/bin/xc16-objdump"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-strip" "${EROOT}/usr/bin/xc16-strip"
}
