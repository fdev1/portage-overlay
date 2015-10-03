# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Google Cloud SDK"
HOMEPAGE="https://cloud.google.com"
SRC_URI="https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz"

LICENSE="GoogleCloudSdk"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"
MERGEDIR="opt/${PN}"

src_install()
{
	addpredict /var/cache/samba/gencache.tdb
	bin/bootstrapping/install.py || die

	dodir /etc/bash/bashrc.d
	insinto /etc/bash/bashrc.d
	dosym "${ED}/${MERGEDIR}/path.bash.inc" "/etc/bash/bashrc.d/google-cloud-sdk-paths.sh"
	dosym "${ED}/${MERGEDIR}/completion.bash.inc" "/etc/bash/bashrc.d/google-cloud-sdk-bashcomp.sh"

	dodir "/${MERGEDIR}"
	find "${S}" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}/${MERGEDIR}" \; || die
}

pkg_postinst()
{
	ewarn "Before you can use Google Cloud SDK you must run: "
	ewarn "source /etc/profile"
}
