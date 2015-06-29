# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the WFTPL version 2
# $Header: $

EAPI=5

inherit games

DESCRIPTION="ePSXe Playstation Emulator"
HOMEPAGE="http://www.epsxe.com"
SRC_URI="http://www.epsxe.com/files/epsxe1925lin.zip
bios? ( https://drive.google.com/uc?export=download&id=0BzPt9N2PyrQGenh0MGxCa1pxejQ -> playstation-bios.tar.xz )
xgl2? ( http://www.pbernert.com/gpupetexgl209.tar.gz )
mesa? ( http://www.pbernert.com/gpupeopsmesagl178.tar.gz )
softgpu? ( http://www.pbernert.com/gpupeopssoftx118.tar.gz )
oss? ( http://www.pbernert.com/spupeopsoss109.tar.gz )
menu? ( http://www.epsxe.com/files/ePSXe1925.zip )
nullspu? ( http://www.pbernert.com/spupetenull101.tar.gz )
alsa? ( http://downloads.sourceforge.net/project/peops/peopsspu/P.E.Op.S.%20Sound%20SPU%201.9/PeopsSpu109.tar.gz )
http://www.pbernert.com/petegpucfg_V2-9_V1-77_V1-18.tar.gz"

LICENSE="epsxe"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc bios xgl2 mesa softgpu config-ui oss +menu nullspu alsa"
RESTRICT="mirror"

DEPEND="
	app-arch/unzip
	>=app-arch/upx-ucl-3.0
	menu? ( media-gfx/icoutils )
"
RDEPEND="${DEPEND}
	>=sys-libs/ncurses-5.0[abi_x86_32]
	>=sys-libs/ncurses-5.0[tinfo]
	>=sys-libs/zlib-1.2.8[abi_x86_32]
	>=x11-libs/libX11-1.6.0[abi_x86_32]
	>=media-libs/alsa-lib-1.0.29[abi_x86_32]
	x11-libs/gtk+:2[abi_x86_32]
	>=media-libs/sdl-ttf-2.0.0[abi_x86_32]
	media-libs/mesa[abi_x86_32]
	config-ui? ( xgl2? ( x11-libs/gtk+:1[abi_x86_32] ) )
	config-ui? ( mesa? ( x11-libs/gtk+:1[abi_x86_32] ) )
	config-ui? ( softgpu? ( x11-libs/gtk+:1[abi_x86_32] ) )
"

src_unpack()
{
	mkdir -p "${S}" || die "Unpack failed!"
	unzip -x "${DISTDIR}/epsxe1925lin.zip" -d "${S}" >/dev/null || die "Unpack failed!"
	use bios && tar -xf "${DISTDIR}/playstation-bios.tar.xz" -C "${S}"
	use xgl2 && tar -xf "${DISTDIR}/gpupetexgl209.tar.gz" -C "${S}"
	use mesa && tar -xf "${DISTDIR}/gpupeopsmesagl178.tar.gz" -C "${S}"
	use softgpu && tar -xf "${DISTDIR}/gpupeopssoftx118.tar.gz" -C "${S}"
	if (use config-ui && (use xgl2 || use mesa || use softgpu)); then
		mkdir -p "${S}/cfg-files"
		tar -xf "${DISTDIR}/petegpucfg_V2-9_V1-77_V1-18.tar.gz" -C "${S}/cfg-files"
	fi
	use oss && tar -xf "${DISTDIR}/spupeopsoss109.tar.gz" -C "${S}"
	use nullspu && tar -xf "${DISTDIR}/spupetenull101.tar.gz" -C "${S}"
	if use alsa; then
		mkdir -p "${S}/alsa"
		tar -xf "${DISTDIR}/PeopsSpu109.tar.gz" -C "${S}/alsa"
	fi
	if use menu; then
		mkdir -p "${S}/w32" || die "Unpack failed!"
		unzip -x "${DISTDIR}/ePSXe1925.zip" -d "${S}/w32" > /dev/null || die "Unpack failed!"
	fi
}

src_prepare()
{	
	# unupx it
	#
	mv "${S}/epsxe" "${S}/epsxe.bak"
	upx -d -o "${S}/epsxe" "${S}/epsxe.bak"
	rm "${S}/epsxe.bak"

	# fix bios filenames
	#
	if use bios; then
		cp -v "${S}/SCPH1000.BIN"  "${S}/scph1000.bin"
		cp -v "${S}/SCPH1001.bin"  "${S}/scph1001.bin"
		cp -v "${S}/SCPH5000.BIN"  "${S}/scph5000.bin"
		cp -v "${S}/SCPH5500.BIN"  "${S}/scph5500.bin"
		cp -v "${S}/SCPH7001.BIN"  "${S}/scph7001.bin"
		cp -v "${S}/SCPH7502.BIN"  "${S}/scph7502.bin"
	fi

	# fix readme filenames
	#
	if use oss; then
		cp -v "${S}/readme_1_9.txt" "${S}/spuPeopsOSS_readme_1_9.txt"
	fi
	if use nullspu; then
		cp -v "${S}/readme.txt" "${S}/spuPeteNull_readme.txt"
	fi

	if use alsa; then
		cp -v "${S}/alsa/src/Makefile" "${S}/alsa/src/Makefile.orig"
		sed -e "s/USEALSA = FALSE/USEALSA = TRUE/g" "${S}/alsa/src/Makefile.orig" | \
		sed -e "s/-mpentium//g" | \
		sed -e "s/-fPIC/-fPIC -m32/g" | \
		sed -e "s/LINKFLAGS = /LINKFLAGS = -m32 /g" > "${S}/alsa/src/Makefile"
	fi

	# extract windows icon
	#
	if use menu; then
		wrestool -x -t 14 "${S}/w32/ePSXe.exe" > "${S}/epsxe.ico"
	fi
}

src_configure()
{
	return
}

src_compile()
{
	if use alsa; then
		cd "${S}/alsa/src"
		make
	fi
}

src_install()
{
	MERGEDIR="/opt/epsxe-${PV}"
	INSTALLDIR="${D}/${MERGEDIR}"

	diropts --owner=root --group=root
	dodir "${MERGEDIR}"
	dodir "${MERGEDIR}/bios"
	dodir "${MERGEDIR}/plugins"
	dodir "${MERGEDIR}/cfg"
	dodir "${MERGEDIR}/config"

	if use doc; then
		dodir "${MERGEDIR}/docs"
		insinto "${MERGEDIR}/docs"
		insopts --owner=root --group=root --mode=644
		doins "${S}/docs/ePSXe_en.txt"
		doins "${S}/docs/epsxe_linux_en.txt"
		doins "${S}/docs/ePSXe_sp.txt"
		doins "${S}/docs/epsxe_linux_sp.txt"
	fi

	dodir /usr/share/epsxe
	diropts --owner=root --group=games --mode=775
	dodir /var/epsxe/memcards
	dodir /var/epsxe/memcards/games
	dodir /var/epsxe/isos
	dodir /var/epsxe/patches
	dodir /var/epsxe/snap
	dodir /var/epsxe/sstates
	dodir /var/epsxe/idx
	dodir /var/epsxe/cheats

	dosym /var/epsxe/memcards "${MERGEDIR}/memcards"
	dosym /var/epsxe/isos "${MERGEDIR}/isos"
	dosym /var/epsxe/patches "${MERGEDIR}/patches"
	dosym /var/epsxe/snap "${MERGEDIR}/snap"
	dosym /var/epsxe/sstates "${MERGEDIR}/sstates"
	dosym /var/epsxe/idx "${MERGEDIR}/idx"
	dosym /var/epsxe/cheats "${MERGEDIR}/cheats"

	touch epsxerc
	dodir /etc/epsxe
	insopts --owner=root --group=games --mode=664
	insinto /etc/epsxe
	doins epsxerc
	dosym /etc/epsxe/epsxerc "${MERGEDIR}/.epsxerc"

	insinto "${MERGEDIR}"
	insopts --owner=root --group=root --mode=755
	doins "${S}/epsxe"
	insopts --owner=root --group=root --mode=644
	doins "${S}/keycodes.lst"

	if use doc; then
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/bios"
		doins "${S}/bios/erase.me"
		insinto "${MERGEDIR}/cfg"
		doins "${S}/cfg/erase.me"
		insinto "${MERGEDIR}/config"
		doins "${S}/config/erase.me"
		insinto /var/epsxe/idx
		doins "${S}/idx/kill.me"
		insinto /var/epsxe/isos
		doins "${S}/isos/kill.me"
		insinto /var/epsxe/memcards
		doins "${S}/memcards/delete.me"
		insinto /var/epsxe/memcards/games
		doins "${S}/memcards/games/delete.me"
		insinto /var/epsxe/patches
		doins "${S}/patches/kill.me"
		insinto "${MERGEDIR}/plugins"
		doins "${S}/plugins/remove.me"
		insinto /var/epsxe/snap
		doins "${S}/snap/kill.me"
		insinto /var/epsxe/sstates
		doins "${S}/sstates/kill.me"
		doins "${S}/sstates/punch.me"
	fi

	if use bios; then
		rm -f "${INSTALLDIR}/bios/erase.me"
		insinto "${MERGEDIR}/bios"
		insopts --owner=root --mode=root --mode=644
		doins "${S}/scph1000.bin"
		doins "${S}/scph1001.bin"
		doins "${S}/scph1002.bin"
		doins "${S}/scph5000a.bin"
		doins "${S}/scph5000.bin"
		doins "${S}/scph5500.bin"
		doins "${S}/scph5502.bin"
		doins "${S}/scph7001.bin"
		doins "${S}/scph7003.bin"
	fi

	if use xgl2; then
		rm -f "${INSTALLDIR}/plugins/remove.me"
		rm -f "${INSTALLDIR}/cfg/erase.me"
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/plugins"
		doins "${S}/libgpuPeteXGL2.so.2.0.9"
		insopts --owner=root --group=games --mode=664
		insinto /etc/epsxe
		doins "${S}/gpuPeteXGL2.cfg"
		dosym /etc/epsxe/gpuPeteXGL2.cfg "${MERGEDIR}/cfg/gpuPeteXGL2.cfg"
		if use config-ui; then
			insopts --owner=root --group=games --mode=750
			insinto "${MERGEDIR}/cfg"
			doins "${S}/cfg-files/cfg/cfgPeteXGL2"
		fi
	fi

	if use mesa; then
		rm -f "${INSTALLDIR}/plugins/remove.me"
		rm -f "${INSTALLDIR}/cfg/erase.me"
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/plugins"
		doins "${S}/peops_psx_mesagl_gpu/libgpuPeopsMesaGL.so.1.0.78"
		insopts --owner=root --group=games --mode=664
		insinto /etc/epsxe
		doins "${S}/peops_psx_mesagl_gpu/gpuPeopsMesaGL.cfg"
		dosym /etc/epsxe/gpuPeopsMesaGL.cfg "${MERGEDIR}/cfg/gpuPeopsMesaGL.cfg"
		if use config-ui; then
			insopts --owner=root --group=games --mode=750
			insinto "${MERGEDIR}/cfg"
			doins "${S}/peops_psx_mesagl_gpu/cfgPeopsMesaGL"
		fi
	fi

	if use softgpu; then
		rm -f "${INSTALLDIR}/plugins/remove.me"
		rm -f "${INSTALLDIR}/cfg/erase.me"
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/plugins"
		doins "${S}/libgpuPeopsSoftX.so.1.0.18"
		insopts --owner=root --group=games --mode=664
		insinto /etc/epsxe
		doins "${S}/gpuPeopsSoftX.cfg"
		dosym /etc/epsxe/gpuPeopsSoftX.cfg "${MERGEDIR}/cfg/gpuPeopsSoftX.cfg"
		if use config-ui; then
			insopts --owner=root --group=games --mode=750
			insinto "${MERGEDIR}/cfg"
			doins "${S}/cfg-files/cfg/cfgPeopsSoft"
		fi
		if use doc; then
			insopts --owner=root --group=root --mode=644
			insinto "${MERGEDIR}/docs"
			doins "${S}/peops_soft_readme_1_18.txt"
		fi
	fi

	if use oss; then
		rm -f "${INSTALLDIR}/plugins/remove.me"
		rm -f "${INSTALLDIR}/cfg/erase.me"
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/plugins"
		doins "${S}/libspuPeopsOSS.so.1.0.9" "${INSTALLDIR}/plugins"
		insopts --owner=root --group=games --mode=664
		insinto /etc/epsxe
		doins "${S}/spuPeopsOSS.cfg"
		dosym /etc/epsxe/spuPeopsOSS.cfg "${MERGEDIR}/cfg/spuPeopsOSS.cfg"
		if use config-ui; then
			insopts --owner=root --group=games --mode=750
			insinto "${MERGEDIR}/cfg"
			doins "${S}/cfgPeopsOSS"
		fi
		if use doc; then
			insopts --owner=root --group=root --mode=644
			insinto "${MERGEDIR}/docs"
			doins "${S}/spuPeopsOSS_readme_1_9.txt"
		fi
	fi

	if use alsa; then
		rm -f "${INSTALLDIR}/plugins/remove.me"
		rm -f "${INSTALLDIR}/cfg/erase.me"
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/plugins"
		doins "${S}/alsa/src/libspuPeopsALSA.so.1.0.9"
	fi

	if use nullspu; then
		rm -f "${INSTALLDIR}/plugins/remove.me"
		rm -f "${INSTALLDIR}/cfg/erase.me"
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}/plugins"
		doins "${S}/libspuPeteNull.so.1.0.1"
		if use doc; then
			insopts --owner=root --group=root --mode=644
			insinto "${MERGEDIR}/docs"
			doins "${S}/spuPeteNull_readme.txt"
		fi
	fi

	if use menu; then
		insopts --owner=root --group=root --mode=644
		insinto "${MERGEDIR}"
		doins "${S}/epsxe.ico"
		echo "[Desktop Entry]" > epsxe.desktop || die "Install failed!"
		echo "Name=ePSXe" >> epsxe.desktop || die "Install failed!"
		echo "Comment=Playstation Emulator" >> epsxe.desktop || die "Install failed!"
		echo "Exec=${MERGEDIR}/epsxe" >> epsxe.desktop || die "Install failed!"
		echo "Icon=${MERGEDIR}/epsxe.ico" >> epsxe.desktop || die "Install failed!"
		echo "Terminal=false" >> epsxe.desktop || die "Install failed!"
		echo "Type=Application" >> epsxe.desktop || die "Install failed!"
		echo "Categories=Game;Emulator;" >> epsxe.desktop || die "Install failed!"
		domenu epsxe.desktop || die "Install failed!"
	fi

	echo "#!/bin/sh" > epsxe-run || die "Install failed!"
	echo "cd ${MERGEDIR}" >> epsxe-run || die "Install failed!"
	echo "./epsxe" >> epsxe-run || die "Install failed!"
	insopts --owner=root --group=root --mode=755
	insinto "${MERGEDIR}"
	doins epsxe-run
	dosym "${MERGEDIR}/epsxe-run" /usr/bin/epsxe

}

