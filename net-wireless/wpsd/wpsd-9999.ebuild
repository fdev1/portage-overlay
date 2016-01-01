# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

WANT_AUTOMAKE=none

DESCRIPTION="WiFi Positioning System Daemon"
HOMEPAGE="https://github.com/fernando-rodriguez/ssmtp-reloaded"

if [[ ${PV} == 9999* ]]; then
	inherit eutils autotools user git-r3
	EGIT_REPO_URI=(
		"https://github.com/fernando-rodriguez/wpsd.git"
		"git://github.com/fernando-rodriguez/wpsd.git" )
	KEYWORDS=""
else
	inherit eutils autotools user
	SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> ssmtp-reloaded-${PV}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/openssl
	net-wireless/wpsapi"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch_user
	eautoconf
}
