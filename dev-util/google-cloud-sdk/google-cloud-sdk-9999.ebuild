# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Google Cloud SDK"
HOMEPAGE="https://cloud.google.com/sdk/"
SRC_URI="https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="zsh +bashcomp"

DEPEND="dev-lang/python:2.7
	dev-vcs/git
	zsh? ( app-shells/zsh )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}"
MERGEDIR="opt/${PN}"
EMERGEDIR="${ED}${MERGEDIR}"

src_install()
{
	addpredict /var/cache/samba/gencache.tdb

	# update shebangs to use Python 2.7 (bootstrapping)
	einfo "Fixing python shebangs for bootstrapping..."
	find "${S}/bin/bootstrapping" -name '*.py' -type f -exec sed -i \
		-e '1,/RE/s:^#!/usr/bin/env python$:#!/usr/bin/env python2.7:g' '{}' \;

	# run install script script
	einfo "Running install script..."
	bin/bootstrapping/install.py || die

	# update shebangs to use Python 2.7
	einfo "Fixing python shebangs..."
	find "${S}" -name '*.py' -type f -exec sed -i \
		-e '1,/RE/s:^#!/usr/bin/env python$:#!/usr/bin/env python2.7:' '{}' \;

	# install documents
	dodoc "${S}/LICENSE"
	dodoc "${S}/README"
	dodoc "${S}/RELEASE_NOTES"

	# delete unnecessary files
	rm "${S}/install.sh" || die
	rm "${S}/install.bat" || die
	rm "${S}/LICENSE" || die
	rm "${S}/README" || die
	rm "${S}/RELEASE_NOTES" || die
	rm -r "${S}/.install" || die
	rm -r "${S}/bin/bootstrapping" || die

	# disable usage reporting by default
	sed -i -e 's/disable_usage_reporting = False/disable_usage_reporting = True/g' \
		"${S}/properties"

	# install symlinks to bash completion and
	# environment setup scripts
	dodir /etc/bash/bashrc.d
	dosym "${EMERGEDIR}/path.bash.inc" /etc/bash/bashrc.d/google-cloud-sdk-paths.sh
	if use bashcomp; then
		dosym "${EMERGEDIR}/completion.bash.inc" /etc/bash/bashrc.d/google-cloud-sdk-bashcomp.sh
	else
		rm "${S}/completion.bash.inc" || die
	fi

	# remove zsh files if the zsh flag is not set
	# TODO: create zsh symlinks if the flag is set (I dont know where they go)
	if use !zsh; then
		rm "${S}/path.zsh.inc" || die
		rm "${S}/completion.zsh.inc" || die
	fi

	# install the SDK
	dodir "${MERGEDIR}"
	find "${S}" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${EMERGEDIR}" \; || die
}

pkg_postinst()
{
	echo
	ewarn "Before you can use Google Cloud SDK you must run:"
	ewarn "source /etc/profile"
	echo
	ewarn "To update Google Cloud SDK just run:"
	ewarn "emerge --oneshot dev-util/google-cloud-sdk"
	echo
}
