# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A Tcl/Tk front-end to Genesis Emulator DGen"
HOMEPAGE="http://sourceforge.net/projects/tkdgen/"
SRC_URI="http://downloads.sourceforge.net/project/tkdgen/TkDgen/1.1.1/tkdgen-1.1.1.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Ftkdgen%2Ffiles%2Flatest%2Fdownload%3Fsource%3Drecommended&ts=1435778164&use_mirror=colocrossing -> tkdgen-1.1.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=games-emulation/dgen-sdl-1.33
	>=dev-lang/tcl-8.0.0
"

src_prepare()
{
	# remove the check for tk version as it tries to use the display
	# patch configure so it doesn't bail out on not supported options (passed by portage)
	# patch Makefile not to ignore installation directories
	sed -ie 's/eval "test `$WISH vertk`"/true/g' "${S}/configure" || die
	sed -ie "s/\s\-\*)/\*);;\n-invalid-opt)/g" "${S}/configure" || die
	sed -ie 's/datadir = $(prefix)\/tkdgen/datadir = $(prefix)\/share\/tkdgen/g' "${S}/Makefile.in" || die
	sed -ie 's/prefix = \/usr\/local/prefix = $(DEST)\/$(strip @prefix@)/g' "${S}/Makefile.in" || die
	sed -ie 's/echo \/usr\/local/echo $(prefix)\/share/g' "${S}/Makefile.in" || die

	# fix compat issues with dgen 1.33
	sed -i \
		-e "s/bool_splitscreen_startup/#removed_opt/g" \
		-e "s/bool_16bit/#removed_opt/g" \
		-e "s/splitscreen_startup//g" \
		-e "s/16bit//g" \
		"${S}"/tkdgen_opav.tcl || die
	sed -i \
		-e "s/1.23/1.33/g" \
		-e "s/ToBin tobin/ToBin dgen_tobin/g" \
		-e "s/\*tobin from.smd to.bin\*/\*tobin \{from.smd\} \{to.bin\}\*/g" \
		tkdgen.tcl || die
}

src_install()
{
	emake DEST="${D}" install
	echo "[Desktop Entry]" > tkdgen.desktop || die "Install failed!"
	echo "Name=TkDgen" >> tkdgen.desktop || die "Install failed!"
	echo "Comment=A Tcl/Tk front-end to Genesis Emulator DGen" >> tkdgen.desktop || die "Install failed!"
	echo "Exec=/usr/bin/tkdgen" >> tkdgen.desktop || die "Install failed!"
	echo "Icon=/usr/share/tkdgen/imgs/im_tkdgen.gif" >> tkdgen.desktop || die "Install failed!"
	echo "Terminal=false" >> tkdgen.desktop || die "Install failed!"
	echo "Type=Application" >> tkdgen.desktop || die "Install failed!"
	echo "Categories=Game;Emulator;" >> tkdgen.desktop || die "Install failed!"
	domenu tkdgen.desktop || die "Install failed!"
}
