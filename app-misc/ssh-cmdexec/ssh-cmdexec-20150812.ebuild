# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A small program to remove IP from xt_recent list upon connection via ssh."
HOMEPAGE="https://github.com/fernando-rodriguez/misc/blob/master/ssh-cmdexec.c"
SRC_URI="https://raw.githubusercontent.com/fernando-rodriguez/misc/e8d1211733/ssh-cmdexec.c -> ssh-cmdexec-${PV}.c"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack()
{
	mkdir -p "${S}" || die
	cd "${S}" || die
	cp "${DISTDIR}"/"ssh-cmdexec-${PV}.c" "${S}"/ssh-cmdexec.c || die
}

src_compile()
{
	${CHOST}-gcc -Wall -DRECENT_LIST=ssh_bad ssh-cmdexec.c -o ssh-cmdexec || die
}

src_install()
{
	insopts --mode=4711
	insinto /usr/bin
	doins ssh-cmdexec
}

pkg_postinst()
{
	einfo "ssh-cmdexec has been configured to remove the"
	einfo "blacklisted IP from /proc/net/xt_recent/ssh_bad."
	einfo "Please update your iptables rules accordingly."
	einfo "For example, to drop SSH connections after three"
	einfo "failed login attempts use the following rules:"
	einfo ""
	einfo "iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set --name ssh_bad --rsource"
	einfo "iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 300 --hitcount 4 --name ssh_bad -j DROP"
	einfo ""
	einfo "In order to use this program you must add the"
	einfo "following to /etc/ssh/sshd_config:"
	einfo ""
	einfo "ForceCommand /usr/bin/ssh-cmdexec"
}
