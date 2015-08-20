# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

WANT_AUTOMAKE=none

DESCRIPTION="Extremely simple yet flexible MTA to get mail off the system."
HOMEPAGE="https://github.com/fernando-rodriguez/ssmtp-reloaded"

if [[ ${PV} == 9999* ]]; then
	inherit eutils autotools user git-r3
	EGIT_REPO_URI=(
		"https://github.com/fernando-rodriguez/ssmtp-reloaded.git"
		"git://github.com/fernando-rodriguez/ssmtp-reloaded.git" )
	KEYWORDS=""
else
	inherit eutils autotools user
	SRC_URI="https://github.com/fernando-rodriguez/${PN}/archive/${PV}.tar.gz -> ssmtp-reloaded-${PV}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ipv6 +ssl gnutls +mta"

DEPEND="ssl? (
		!gnutls? ( dev-libs/openssl )
		gnutls? ( net-libs/gnutls )
	)"
RDEPEND="${DEPEND}
	net-mail/mailbase
	mta? (
		!net-mail/mailwrapper
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/msmtp[mta]
		!mail-mta/nbsmtp
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
		!mail-mta/opensmtpd
		!mail-mta/ssmtp
	)"

REQUIRED_USE="gnutls? ( ssl )"

pkg_setup() {
	if ! use prefix; then
		enewgroup ssmtp
	fi
}

src_prepare() {
	epatch_user
	if use prefix; then
		sed -ie '/\$(GROUPADD)/d' Makefile.in || die
		sed -ie 's/--group=ssmtp//g' Makefile.in || die
	fi
	eautoconf
}

src_configure() {
	econf \
		$(use_enable ssl) $(use_with gnutls) \
		$(use_enable ipv6 inet6) \
		--enable-md5auth
}

src_install() {
	if use mta; then
		emake install-sendmail DESTDIR="${ED}" || die
	else
		emake install DESTDIR="${ED}" || die
	fi
	dodoc ChangeLog CHANGELOG_OLD INSTALL README TLS
	newdoc ssmtp.lsm DESC
}
