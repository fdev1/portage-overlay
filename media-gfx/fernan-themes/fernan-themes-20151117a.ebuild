# Copyright 1999-2015 Gentoo Foundation 
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Fernan's Theme Collection"
HOMEPAGE="https://github.com/fernando-rodriguez/themes"
#SRC_URI="https://github.com/fernando-rodriguez/themes/archive/${PV}.tar.gz -> fernan-themes-${PV}.tar.gz"
SRC_URI="https://codeload.github.com/fernando-rodriguez/themes/tar.gz/${PV} -> fernan-themes-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="grub2 kde kdm plymouth"

DEPEND="
	grub2? ( sys-boot/grub:2 )
	plymouth? ( sys-boot/plymouth )
	kde? ( >=kde-base/ksplash-4.11 )
	kdm? ( >=kde-base/kdm-4.11 )
"
RDEPEND="${DEPEND}"

src_unpack()
{
	tar -xf "${DISTDIR}"/${A} || die
	mv "${WORKDIR}/themes-${PV}" "${S}" || die
}

src_install()
{
	rm plymouth/radioactive/bg.xcf || die
	rm plymouth/radioactive/glow.orig.png || die

	if use grub2; then
		mkdir -p "${ED}"/usr/share/grub/themes || die
		find "${S}"/grub2 -maxdepth 1 -mindepth 1 \
			-exec mv '{}' "${ED}"/usr/share/grub/themes \; || die
	fi

	if use kdm; then
		mkdir -p "${ED}"/usr/share/apps/kdm/themes || die
		find "${S}"/kdm -maxdepth 1 -mindepth 1 \
			-exec mv '{}' "${ED}"/usr/share/apps/kdm/themes \; || die
	fi

	if use kde; then
		# install ksplash themes
		mkdir -p "${ED}"/usr/share/apps/ksplash/Themes || die
		find "${S}"/ksplash -maxdepth 1 -mindepth 1 \
			-exec mv '{}' "${ED}"/usr/share/apps/ksplash/Themes \; || die

		# install kde4 themes
		mkdir -p "${ED}/usr/share/apps/desktoptheme" || die
		mkdir -p "${ED}/usr/share/apps/aurorae/themes" || die
		find "${S}/kde4" -maxdepth 1 -mindepth 1 \
			-exec mv '{}' "${ED}/usr/share/apps/desktoptheme" \; || die
		find "${S}/kde" -maxdepth 1 -mindepth 1 \
			-exec mv '{}' "${ED}/usr/share/apps/aurorae/themes" \; || die
	fi

	if use plymouth; then
		mkdir -p "${ED}"/usr/share/plymouth/themes || die
		find "${S}"/plymouth -maxdepth 1 -mindepth 1 \
			-exec mv '{}' "${ED}"/usr/share/plymouth/themes \; || die
	fi
}
