# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Apparmor Policies"
HOMEPAGE="http://github.com/fernando-rodriguez/apparmor-policy/"
SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/apparmor
	sys-apps/apparmor-utils"

src_install()
{
	rm -f "${S}"/README.md || die
	rm -f "${S}"/.gitignore || die
	chmod 0750 "${S}"/usr/bin/aa-uexec || die
	find "${S}" -mindepth 1 -maxdepth 1 \
		-exec mv '{}' "${ED}" \; || die
}

pkg_postinst()
{
	einfo "After updating your kernel you must re-emerge"
	einfo "sys-apps/apparmor-utils, just run:"
	einfo ""
	einfo "emerge --oneshot sys-apps/apparmor-utils"
	echo ""
	einfo "After updating sec-policy/apparmor-policy you"
	einfo "must do the following:"
	einfo ""
	einfo "1. Run etc-update to update your profiles"
	einfo "2. Run aa-profiles-compile to compile your profiles"
	einfo "3. Run aa-profiles-load to load your new profiles"
}
