# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_mono/mod_mono-2.10.ebuild,v 1.7 2015/06/07 19:15:21 pacho Exp $

EAPI=5

# Watch the order of these!
inherit autotools apache-module multilib eutils mono

KEYWORDS="amd64 ppc x86"

DESCRIPTION="Apache module for Mono"
HOMEPAGE="http://www.mono-project.com/Mod_mono"
LICENSE="Apache-2.0"
SRC_URI="http://download.mono-project.com/sources/mod_mono/mod_mono-${PV}.tar.gz"

SLOT="0"
IUSE="debug"

DEPEND="=dev-dotnet/xsp-3.8"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="2.2/70_${PN}"
APACHE2_MOD_DEFINE="MONO"

DOCFILES="AUTHORS ChangeLog COPYING INSTALL NEWS README"

need_apache2

src_prepare()
{
	sed -e "s:@LIBDIR@:$(get_libdir):" "${FILESDIR}/${APACHE2_MOD_CONF}.conf" \
		> "${WORKDIR}/${APACHE2_MOD_CONF##*/}.conf" || die
}

src_compile()
{
	emake
}

src_install()
{
	default
	find "${D}" -name 'mod_mono.conf' -delete || die "failed to remove mod_mono.conf"
	insinto "${APACHE_MODULES_CONFDIR}"
	newins "${WORKDIR}/${APACHE2_MOD_CONF##*/}.conf" "${APACHE2_MOD_CONF##*/}.conf" \
		|| die "internal ebuild error: '${FILESDIR}/${APACHE2_MOD_CONF}.conf' not found"
}

pkg_postinst()
{
	apache-module_pkg_postinst

	elog "To enable mod_mono, add \"-D MONO\" to your Apache's"
	elog "conf.d configuration file. Additionally, to view sample"
	elog "ASP.NET applications, add \"-D MONO_DEMO\" too."
}
