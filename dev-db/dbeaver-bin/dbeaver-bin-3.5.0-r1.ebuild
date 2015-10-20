# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user eutils

DESCRIPTION="Free Universal Database Manager"
HOMEPAGE="http://dbeaver.jkiss.org/"
SRC_URI="
	x86?
	(
		!enterprise? ( http://dbeaver.jkiss.org/files/${PV}/dbeaver-ce-${PV}-linux.gtk.x86.tar.gz  )
		enterprise? ( http://dbeaver.jkiss.org/files/${PV}/dbeaver-ee-${PV}-linux.gtk.x86.tar.gz )
	)
	amd64?
	(
		!enterprise? ( http://dbeaver.jkiss.org/files/${PV}/dbeaver-ce-${PV}-linux.gtk.x86_64.tar.gz )
		enterprise? ( http://dbeaver.jkiss.org/files/${PV}/dbeaver-ee-${PV}-linux.gtk.x86_64.tar.gz )
	)"

RESTRICT="primaryuri"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+enterprise"

DEPEND=">=virtual/jre-1.7.0:*"
RDEPEND="${DEPEND}"

pkg_setup()
{
	enewgroup dbeaver
}

src_unpack()
{
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/"${A} -C "${S}" || die
}

src_install()
{
	# create dest directories
	dodir /opt
	dodir /usr/bin

	# fix permissions
	chown -R root:dbeaver "${S}" || die
	find "${S}"/configuration -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/configuration -type f -exec chmod 0664 '{}' \; || die
	find "${S}"/plugins -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/plugins -type f -exec chmod 0664 '{}' \; || die

	# install docs
	dodoc "${S}/licenses/commons_license.txt"
	dodoc "${S}/licenses/dbeaver_license.txt"
	dodoc "${S}/licenses/eclipse_license.html"
	dodoc "${S}/licenses/jsch-license.txt"
	rm -r "${S}/licenses"

	# install dbeaver
	mv "${S}" "${ED}/opt/${P}" || die
	dosym "/opt/${P}/dbeaver" /usr/bin/dbeaver

	# copy icon
	cp "${FILESDIR}/icon.xpm" "${ED}/opt/${P}/icon.xpm"

	# install desktop entry
	echo "[Desktop Entry]" > "${T}/dbeaver.desktop" || die
	echo "Name=DBeaver" >> "${T}/dbeaver.desktop" || die
	echo "GenericName=Free Universal Database Manager" >> "${T}/dbeaver.desktop" || die
	echo "Comment=Free Universal Database Manager" >> "${T}/dbeaver.desktop" || die
	echo "Icon=${EROOT}opt/${P}/icon.xpm" >> "${T}/dbeaver.desktop" || die
	echo "Exec=${EROOT}opt/${P}/dbeaver" >> "${T}/dbeaver.desktop" || die
	echo "StartupNotify=true" >> "${T}/dbeaver.desktop" || die
	echo "Terminal=false" >> "${T}/dbeaver.desktop" || die
	echo "Type=Application" >> "${T}/dbeaver.desktop" || die
	echo "Categories=Development;IDE;" >> "${T}/dbeaver.desktop" || die
	domenu "${T}/dbeaver.desktop"
}

pkg_postinst()
{
	ewarn "In order to use DBeaver you must be"
	ewarn "in the dbeaver group."
	ewarn "Just run 'gpasswd -a <USER> dbeaver'"
}
