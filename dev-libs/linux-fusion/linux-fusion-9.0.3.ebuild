# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils linux-mod

DESCRIPTION="Fusion Kernel Modules (for DirectFB)"
HOMEPAGE="https://web.archive.org/web/20150526182020/http://directfb.org/"
SRC_URI="https://web.archive.org/web/20150323120731/http://www.directfb.org/downloads/Core/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

S=${WORKDIR}/linux-fusion-${PV}

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="linux/drivers/char/fusion/fusion(misc:${S}) one/linux-one(misc:${S})"

pkg_setup() {
	linux-mod_pkg_setup

	BUILD_PARAMS="KERN_DIR=${KV_DIR} KERNOUT=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
}

src_prepare() {
	epatch "${FILESDIR}/linux4-fixes.patch"
	default
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
}
