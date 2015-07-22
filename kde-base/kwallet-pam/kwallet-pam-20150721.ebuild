# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# see https://www.dennogumi.org/2014/04/unlocking-kwallet-with-pam/

EAPI=5
KDE_REQUIRED=never

inherit kde4-base pam

DESCRIPTION="KWallet PAM Integration"
HOMEPAGE="https://projects.kde.org/projects/playground/base/kwallet-pam/repository"
SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> kwallet-pam-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="
	>=kde-base/kdebase-startkde-4.11.19
	>=kde-base/kdebase-pam-9
	>=kde-apps/kwalletd-4.14.3
	>=dev-libs/libgcrypt-1.5.4"
RDEPEND="${DEPEND}"

src_prepare()
{
	sed -ie "s/\.kde/\.kde4/g" pam_kwallet.c || die
	cp ${EROOT}/etc/pam.d/kde . || die
}

src_configure()
{
	pammod_hide_symbols
	kde4-base_src_configure
}
src_install()
{
	# update existing /etc/pamd/kde
	if [ "$(cat kde | grep pam_kwallet.so)" == "" ]; then
		echo >> kde
		echo "-auth       optional     pam_kwallet.so" >> kde
		echo "-session    optional     pam_kwallet.so" >> kde
	fi
	dopammod ../"${P}"_build/pam_kwallet.so
	dopamd kde
}

pkg_postinst()
{
	ewarn "In order for KWallet PAM Integration to work correctly"
	ewarn "you must use the same password for KWallet and your"
	ewarn "user account."
	echo
	ewarn "You must run etc-update and then logoff and back in"
	ewarn "in order to start using KWallet PAM Integration."
}
