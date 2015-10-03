# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Google App Engine SDK"
HOMEPAGE="https://cloud.google.com/appengine"
SRC_URI="https://storage.googleapis.com/appengine-sdks/featured/google_appengine_${PV}.zip"

LICENSE="Google-App-Engine"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/php:5.4[cgi]
	dev-lang/python:2.7
	virtual/mysql"
RDEPEND="${DEPEND}"
S="${WORKDIR}/google_appengine"
MERGEDIR="opt/${PN}-php/"

src_install()
{
	dodir "${MERGEDIR}"
	insinto "${MERGEDIR}"
	insopts --mode=755
	doins "${FILESDIR}/google-app-engine-php"
	dosym /opt/google-app-engine-php/google-app-engine-php /usr/bin/google-app-engine-php
	find "${S}" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}/${MERGEDIR}" \;
}

pkg_postinst()
{
	einfo "To start a shell with the google app engine enabled run:"
	einfo "google-app-engine-php"
}
