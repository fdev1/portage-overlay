# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Roslyn Compiler"
HOMEPAGE="https://github.com/mono/roslyn"
EGIT_REPO_URI="https://github.com/mono/roslyn.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/mono"
