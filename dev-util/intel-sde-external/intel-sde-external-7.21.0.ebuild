# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Intel Software Development Emulator"
HOMEPAGE="https://software.intel.com/en-us/articles/pre-release-license-agreement-for-intel-software-development-emulator-accept-end-user-license-agreement-and-download"
SRC_URI="https://software.intel.com/system/files/managed/5b/62/sde-external-7.21.0-2015-04-01-lin.tar.bz2"
RESTRICT="fetch strip"
QA_PREBUILT="opt/${PN}/*"

LICENSE="Intel-SDE"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_nofetch()
{
	einfo "!!! This following file is fetch restricted"
	einfo "${A}"
	einfo "Fetch it from: ${HOMEPAGE}"
}

src_unpack()
{
	mkdir -p "${S}" || die
	tar -xf "${DISTDIR}/${A}" -C "${S}" || die
}

src_install()
{
	dodir "/opt/${PN}" || die
	find "${S}/sde-external-7.21.0-2015-04-01-lin" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}/opt/${PN}" \; || die
	find "${ED}/opt/${PN}" -type f -exec chmod 0644 '{}' \; || die
	find "${ED}/opt/${PN}" -type d -exec chmod 0755 '{}' \; || die
	chmod 0755 "${ED}/opt/${PN}/sde" || die
	chmod 0755 "${ED}/opt/${PN}/sde64" || die
	chmod 0755 "${ED}/opt/${PN}/xed" || die
	chmod 0755 "${ED}/opt/${PN}/xed64" || die
	chmod 0755 "${ED}/opt/${PN}/ia32/pinbin" || die
	chmod 0755 "${ED}/opt/${PN}/intel64/pinbin" || die
	chmod 0755 "${ED}/opt/${PN}/misc/cntrl_client.py" || die

	if use amd64; then
		dosym /opt/${PN}/sde64 /usr/bin/sde
		dosym /opt/${PN}/sde /usr/bin/sde32
		dosym /opt/${PN}/xed64 /usr/bin/xed
		dosym /opt/${PN}/xed /usr/bin/xed32
	else
		rm -r "${ED}/opt/${PN}/intel64" || die
		rm "${ED}/opt/${PN}/sde64" || die
		rm "${ED}/opt/${PN}/xed64" || die
		dosym /opt/${PN}/sde /usr/bin/sde
		dosym /opt/${PN}/xed /usr/bin/xed
	fi
}
