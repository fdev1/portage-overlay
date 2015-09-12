# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Intel Software Development Emulator"
HOMEPAGE="https://software.intel.com/en-us/articles/pre-release-license-agreement-for-intel-software-development-emulator-accept-end-user-license-agreement-and-download"
SRC_URI="https://software.intel.com/system/files/managed/5b/62/sde-external-7.21.0-2015-04-01-lin.tar.bz2"
RESTRICT="fetch"
QA_PREBUILT="opt/${P}/*"

LICENSE="Intel-SDE"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_nofetch()
{
	einfo "!!! This package is fetch restricted"
	einfo ""
	einfo "Fetch it from: ${HOMEPAGE}"
}

src_unpack()
{
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/${A}" -C "${S}" || die
}

src_install()
{
	dodir "/opt/intel-sde-${PV}"
	find "${S}/sde-external-7.21.0-2015-04-01-lin" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}/opt/intel-sde-${PV}" \;
}
