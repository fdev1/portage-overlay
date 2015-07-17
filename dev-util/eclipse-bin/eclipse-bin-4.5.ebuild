# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user eutils

DESCRIPTION="Eclipse IDE for Java Developers"
HOMEPAGE="https://www.eclipse.org/"
SRC_URI="
	x86? ( http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/mars/R/eclipse-jee-mars-R-linux-gtk.tar.gz )
	amd64? ( http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/mars/R/eclipse-jee-mars-R-linux-gtk-x86_64.tar.gz )
"

RESTRICT="primaryuri"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	virtual/jdk"

pkg_setup()
{
	enewgroup eclipse
}

src_unpack()
{
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}"/${A} -C "${S}" || die
}

src_install()
{
	mkdir -p "${ED}"/opt || die
	mkdir -p "${ED}"/usr/bin || die

	chmod 0664 "${S}"/eclipse/eclipse.ini || die
	chown root:eclipse "${S}"/eclipse/eclipse.ini || die
	chmod 0644 "${S}"/eclipse/icon.xpm || die
	find "${S}"/eclipse/configuration -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/eclipse/configuration -type f -exec chmod 0664 '{}' \; || die
	find "${S}"/eclipse/configuration -exec chown root:eclipse '{}' \; || die
	find "${S}"/eclipse/plugins -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/eclipse/plugins -type f -exec chmod 0664 '{}' \; || die
	find "${S}"/eclipse/plugins -exec chown root:eclipse '{}' \; || die
	find "${S}"/eclipse/dropins -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/eclipse/dropins -type f -exec chmod 0664 '{}' \; || die
	find "${S}"/eclipse/dropins -exec chown root:eclipse '{}' \; || die
	find "${S}"/eclipse/features -type d -exec chmod 0775 '{}' \; || die
	find "${S}"/eclipse/features -type f -exec chmod 0664 '{}' \; || die
	find "${S}"/eclipse/features -exec chown root:eclipse '{}' \; || die

	# docs
	#mkdir -p "${ED}"/usr/share/doc/"${P}"
	#mv "${S}"/eclipse/readme/readme_eclipse.html "${S}"/usr/share/doc/"${P}" || die
	#rm "${S}"/eclipse/readme || die
	
	# install it
	mv "${S}"/eclipse "${ED}"/opt/"${P}" || die
	ln -s "${EROOT}"/opt/"${P}"/eclipse "${ED}"/usr/bin/eclipse || die

	# menu entry
	echo "[Desktop Entry]" > eclipse.desktop || die
	echo "Name=Eclipse MARS" >> eclipse.desktop || die
	echo "GenericName=Eclipse IDE for Java Developers" >> eclipse.desktop || die
	echo "Comment=Eclipse IDE for Java Developers" >> eclipse.desktop || die
	echo "Icon=${EROOT}/opt/${P}/icon.xpm" >> eclipse.desktop || die
	echo "Exec=/usr/bin/eclipse" >> eclipse.desktop || die
	echo "StartupNotify=true" >> eclipse.desktop || die
	echo "Terminal=false" >> eclipse.desktop || die
	echo "Type=Application" >> eclipse.desktop || die
	echo "Categories=Development;IDE;" >> eclipse.desktop || die
	domenu eclipse.desktop
}

pkg_postinst()
{
	ewarn "In order to install Eclipse plugins you must"
	ewarn "be in the eclipse group."
	ewarn "Just do 'gpasswd -a <USER> eclipse"
}
