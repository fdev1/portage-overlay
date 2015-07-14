# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Cron job for running shake."
HOMEPAGE="https://github.com/fernando-rodriguez/misc/blob/03528eb4de90b68ec275f59ff860ccbf17c96786/autoshake"
SRC_URI="https://raw.githubusercontent.com/fernando-rodriguez/misc/03528eb4de90b68ec275f59ff860ccbf17c96786/autoshake -> ${P}"
RESTRICT="primaryuri"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-fs/shake-0.999
	sys-process/cronbase
	virtual/cron"

src_unpack()
{
	mkdir -p "${S}" || die
	cd "${S}" || die
	cp "${DISTDIR}"/"${P}" "${S}"/autoshake || die
	echo "# The shake interval in days" > autoshake.conf || die
	echo "interval=7" >> autoshake.conf || die
	echo >> autoshake.conf || die
	echo "# The hours, in 24 hour format, when it's OK" >> autoshake.conf || die
	echo "# to shake it" >> autoshake.conf || die
	echo 'shake_hours="22 23 0 1 2 3 4 5"' >> autoshake.conf || die
	echo "/bin" >> autoshake_dirs || die
	echo "/etc" >> autoshake_dirs || die
	echo "/usr" >> autoshake_dirs || die
	echo "/home" >> autoshake_dirs || die
	echo "/lib" >> autoshake_dirs || die
	echo "/opt" >> autoshake_dirs || die
	echo "/root" >> autoshake_dirs || die
	echo "/sbin" >> autoshake_dirs || die
	echo "/var" >> autoshake_dirs || die
	if  use amd64; then
		echo "/lib32" >> autoshake_dirs || die
	fi
}

src_install()
{
	insopts --mode=0700
	insinto /etc/cron.hourly
	doins autoshake
	diropts --mode=0755
	dodir /etc/shake.d
	insopts --mode=0644
	insinto /etc/shake.d
	doins autoshake.conf
	doins autoshake_dirs
}
