# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user eutils

DESCRIPTION="QB64 - Allows programs created using Quick Basic 4.5 or Qbasic to run on Linux"
HOMEPAGE="http://www.qb64.net"
SRC_URI="http://www.qb64.net/release/official/2015_03_12__02_08_19__v0000/linux/qb64v1000-lnx.tar.gz -> qb64-20150312.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/glu
	virtual/opengl
	x11-libs/libX11"

src_unpack()
{
	tar -xf "${DISTDIR}/${P}.tar.gz" || die
	mv "${WORKDIR}/qb64" "${S}" || die
}

src_prepare()
{
	sed -ie "s/echo \"Done compiling!!\"/exit 0/g"  "${S}/setup_lnx.sh" || die
	sed -ie "/Compiling and installing QB64.../d" "${S}/setup_lnx.sh" || die
}

src_compile()
{
	./setup_lnx.sh
}

pkg_setup()
{
	enewgroup qb64
}

src_install()
{
	diropts --owner=root --group=qb64 --mode=775
	dodir /opt/qb64
	dodir /opt/qb64/programs
	insopts --owner=root --group=qb64 --mode=750
	insinto /opt/qb64
	doins qb64

	chown -R root:qb64 internal || die
	chmod -R 0770 internal || die
	mv internal "${ED}/${EROOT}/opt/qb64/" || die

	echo "#!/bin/sh" > qb64-run || die
	echo "f=\"\$(pwd)/./\$1\"" >> qb64-run || die
	echo "cd ${EROOT}/opt/qb64" >> qb64-run || die
	echo "./qb64 \"\$f\"" >> qb64-run || die
	doins qb64-run
	dosym /opt/qb64/qb64-run /usr/bin/qb64

	insopts --owner=root --group=qb64 --mode=640
	echo "[Desktop Entry]" > qb64.desktop || die
	echo "Name=QB64 Programming IDE" >> qb64.desktop || die
	echo "GenericName=QB64 Programming IDE" >> qb64.desktop || die
	echo "Exec=${EROOT}/usr/bin/qb64" >> qb64.desktop || die
	echo "Icon=${EROOT}/opt/qb64/internal/source/qb64icon32.png" >> qb64.desktop || die
	echo "Terminal=false" >> qb64.desktop || die
	echo "Type=Application" >> qb64.desktop || die
	echo "Categories=Development;IDE;" >> qb64.desktop || die
	echo "Path=${EROOT}/opt/qb64" >> qb64.desktop || die
	echo "StartupNotify=false" >> qb64.desktop || die
	domenu qb64.desktop
}

pkg_postinst()
{
	ewarn "In order to run qb64 you have to be in"
	ewarn "the 'qb64' group:"
	ewarn "Just run 'gpasswd -a <USER> qb64'"
}
