# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="XC16 Compiler for Microchip's 16-bit MCU's and DSP's."
HOMEPAGE="http://www.microchip.com/pagehandler/en_us/devtools/mplabxc/"
SRC_URI="http://ww1.microchip.com/downloads/en/DeviceDoc/xc16-v1.24-src.zip"
#http://www.microchip.com/pagehandler/en-us/devtools/dev-tools-parts.html

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="
	app-arch/unzip
"
RDEPEND="${DEPEND}
	=dev-pic/xc16-resources-1.24"

src_unpack()
{
	unzip -q "${DISTDIR}/xc16-v1.24-src.zip" || die
	mv "${WORKDIR}/v1.24.src" "${S}" || die
}

src_prepare()
{
	sed -i \
		-e "s/--host=i386-linux/--host=${CHOST} --build=${CHOST}/g" \
		-e "s/-cross=i686-pc-mingw32-nolm/-cross=${CHOST}/g" \
		-e 's/EXTRA_CFLAGS=""/EXTRA_CFLAGS="-m32"/g' \
		"${S}/src_build.sh" || die

	sed -i \
		-e "s/--host=\${TARGET_OS}/--host=${CHOST} --build=${CHOST}/g" \
		-e "s/--host=i386-\${TARGET_OS}/--host=${CHOST} --build=${CHOST}/g" \
		-e "s/gcc -o/${CHOST}-gcc -o/g" \
		-e "s/-j 2/${MAKEOPTS}/g" \
		-e "s/ZLIB_TOOLS=\".*{TARGET_OS}\"/ZLIB_TOOLS=\"${CHOST}\"/g" \
		"${S}/build_XC16_451" || die
}

src_compile()
{
	./src_build.sh || die
}

src_install()
{
	dodir "${EROOT}/usr/lib/xc16/bin"
	mv "${S}/install/bin/bin" "${ED}/${EROOT}/usr/lib/xc16/bin" || die
	mv "${S}/install/bin/c30_device.info" "${ED}/${EROOT}/usr/lib/xc16/bin" || die

	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-as" "${EROOT}/usr/lib/xc16/bin/xc16-as"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-ar" "${EROOT}/usr/lib/xc16/bin/xc16-ar"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-bin2hex" "${EROOT}/usr/lib/xc16/bin/xc16-bin2hex"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-cc1" "${EROOT}/usr/lib/xc16/bin/xc16-cc1"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-gcc" "${EROOT}/usr/lib/xc16/bin/xc16-gcc"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-ld" "${EROOT}/usr/lib/xc16/bin/xc16-ld"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-objdump" "${EROOT}/usr/lib/xc16/bin/xc16-objdump"
	dosym "${EROOT}/usr/lib/xc16/bin/bin/elf-strip" "${EROOT}/usr/lib/xc16/bin/xc16-strip"

	dosym "${EROOT}/usr/lib/xc16/bin/xc16-as" "${EROOT}/usr/bin/xc16-as"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-ar" "${EROOT}/usr/bin/xc16-ar"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-bin2hex" "${EROOT}/usr/bin/xc16-bin2hex"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-cc1" "${EROOT}/usr/bin/xc16-cc1"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-gcc" "${EROOT}/usr/bin/xc16-gcc"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-ld" "${EROOT}/usr/bin/xc16-ld"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-objdump" "${EROOT}/usr/bin/xc16-objdump"
	dosym "${EROOT}/usr/lib/xc16/bin/xc16-strip" "${EROOT}/usr/bin/xc16-strip"
}
