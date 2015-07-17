# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user eutils

DESCRIPTION="Free Universal Database Manager"
HOMEPAGE="http://dbeaver.jkiss.org/"
SRC_URI="
	x86? 
	( 
		!enterprise? ( http://dbeaver.jkiss.org/files/dbeaver-3.4.2-linux.gtk.x86.zip  )
		enterprise? ( http://dbeaver.jkiss.org/files/dbeaver-3.4.2-ee-linux.gtk.x86.zip )
	)
	amd64? 
	( 
		!enterprise? ( http://dbeaver.jkiss.org/files/dbeaver-3.4.2-linux.gtk.x86_64.zip )
		enterprise? ( http://dbeaver.jkiss.org/files/dbeaver-3.4.2-ee-linux.gtk.x86_64.zip )
	)"

RESTRICT="primaryuri"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+enterprise"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/jre"

pkg_setup()
{
	enewgroup dbeaver
}

src_unpack()
{
	unzip -q "${DISTDIR}"/"${A}" -d "${S}" || die
}

src_install()
{
	mkdir -p "${ED}"/opt || die
	mkdir -p "${ED}"/usr/bin || die
	chown -R root:dbeaver "${S}"/dbeaver || die
	find "${S}"/dbeaver/configuration -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/dbeaver/configuration -type f -exec chmod 0664 '{}' \; || die
	find "${S}"/dbeaver/plugins -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/dbeaver/plugins -type f -exec chmod 0664 '{}' \; || die
	mv "${S}"/dbeaver "${ED}"/opt/"${P}" || die
	ln -s "${EROOT}"/opt/"${P}"/dbeaver "${ED}"/usr/bin/dbeaver || die

	echo "[Desktop Entry]" > dbeaver.desktop || die
	echo "Name=DBeaver" >> dbeaver.desktop || die
	echo "GenericName=Free Universal Database Manager" >> dbeaver.desktop || die
	echo "Comment=Free Universal Database Manager" >> dbeaver.desktop || die
	echo "Icon=${EROOT}/opt/${P}/icon.xpm" >> dbeaver.desktop || die
	echo "Exec=${EROOT}/opt/${P}/dbeaver" >> dbeaver.desktop || die
	echo "StartupNotify=true" >> dbeaver.desktop || die
	echo "Terminal=false" >> dbeaver.desktop || die
	echo "Type=Application" >> dbeaver.desktop || die
	echo "Categories=Development;IDE;" >> dbeaver.desktop || die
	domenu dbeaver.desktop
}

pkg_postinst()
{
	ewarn "In order to use DBeaver you must be"
	ewarn "in the dbeaver group."
	ewarn "Just run 'gpasswd -a <USER> dbeaver'"
}
