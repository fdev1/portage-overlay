# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Apparmor Policies"
HOMEPAGE=""
SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install()
{
	rm -f "${S}"/README.md || die
	chmod 0750 "${S}"/usr/lib/apparmor/aa-uexec || die
	find "${S}" -mindepth 1 -maxdepth 1 \
		-exec mv '{}' "${ED}" \; || die
	dosym /usr/lib/apparmor/aa-uexec /usr/bin/aa-uexec
}
