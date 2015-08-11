# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A small program to remove IP from xt_recent list upon connection via ssh."
HOMEPAGE="https://github.com/fernando-rodriguez/misc/blob/master/ssh-cmdexec.c"
SRC_URI="https://raw.githubusercontent.com/fernando-rodriguez/misc/e74568ec4210595e9abe94c8f046c8f433ef7e7c/ssh-cmdexec.c -> ssh-cmdexec-${PV}.c"
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
	insopts --mode=4755
	insinto /usr/bin
	doins ssh-cmdexec
}
