# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Open source software for numerical computation"
HOMEPAGE="Open source software for numerical computation"
SRC_URI="
	x86? ( http://www.scilab.org/download/5.5.2/scilab-5.5.2.bin.linux-i686.tar.gz )
	amd64? ( http://www.scilab.org/download/5.5.2/scilab-5.5.2.bin.linux-x86_64.tar.gz )"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+system-jre"

DEPEND="
	dev-libs/openssl:0.9.8
	dev-libs/openssl:0
	app-arch/bzip2
	app-crypt/mit-krb5
	dev-lang/tcl:0
	dev-lang/tk:0
	dev-libs/expat
	dev-libs/icu
	dev-libs/libpcre
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:0
	net-misc/curl
	net-nds/openldap
	sci-libs/fftw:3.0
	sys-apps/keyutils
	>=sys-devel/llvm-3.5.0
	>=sys-libs/e2fsprogs-libs-1.42.13
	sys-libs/ncurses:5/5
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrender
	x11-libs/libXScrnSaver
"
RDEPEND="${DEPEND}
	system-jre? ( || ( >=dev-java/oracle-jre-bin-1.6.0.41 >=dev-java/oracle-jdk-bin-1.6.0.41 ) )"
QA_PREBUILT="opt/${P}/*"

src_unpack()
{
	default
	mv "${WORKDIR}/scilab-${PV}" "${S}" || die
}

src_install()
{
	mkdir -p "${ED}"/opt/"${P}" || die
	find "${S}" -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}"/opt/"${P}" \; || die
	mkdir -p "${ED}"/usr/share/applications || die
	mv "${ED}"/opt/"${P}"/share/applications . || die
	mv "${ED}"/opt/"${P}"/share/icons . || die

	mv icons "${ED}"/usr/share || die

	find applications/ -name '*.desktop' -exec sed -ie "/\]\=/d" '{}' \; || die
	find applications/ -name '*.desktop' -exec sed -ie "s/Science;Math;/Development;Science;Math;/g" '{}' \; || die
	find applications/ -name '*.desktop' -exec sed -ie "s/StartupNotify=false/StartupNotify=true/g" '{}' \; || die
	find applications/ -maxdepth 1 -mindepth 1 -name '*.desktop' \
		-exec mv '{}' "${ED}"/usr/share/applications \; || die

	# docs
	mkdir -p "${ED}"/usr/share/doc/"${P}" || die
	find "${ED}/opt/${P}" -name 'CHANGES*' -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}"/usr/share/doc/"${P}" \; || die
	find "${ED}/opt/${P}" -name 'RELEASE*' -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}"/usr/share/doc/"${P}" \; || die
	find "${ED}/opt/${P}" -name 'COPYING*' -maxdepth 1 -mindepth 1 \
		-exec mv '{}' "${ED}"/usr/share/doc/"${P}" \; || die
	mv "${ED}"/opt/"${P}"/ACKNOWLEDGEMENTS "${ED}"/usr/share/doc/"${P}" || die
	mv "${ED}"/opt/"${P}"/README_Unix "${ED}"/usr/share/doc/"${P}" || die
	mv "${ED}"/opt/"${P}"/license.txt "${ED}"/usr/share/doc/"${P}" || die

	# symmlinks
	mkdir -p "${ED}"/usr/bin || die
	ln -s /opt/"${P}"/bin/scinotes "${ED}"/usr/bin/scinotes || die
	ln -s /opt/"${P}"/bin/scilab "${ED}"/usr/bin/scilab || die
	ln -s /opt/"${P}"/bin/xcos "${ED}"/usr/bin/xcos || die
	ln -s /opt/"${P}"/bin/scilab-cli "${ED}"/usr/bin/scilab-cli || die
	ln -s /opt/"${P}"/bin/scilab-adv-cli "${ED}"/usr/bin/scilab-adv-cli || die

	if use system-jre; then
		cat >> find-jre << "EOF"
for f in $(ls /opt); do
		n=${f%-*}
		if [ "$n" == "oracle-jdk-bin" ]; then
				JAVA_HOME=/opt/$f
				JRE_HOME=/opt/$f/jre
		elif [ "$n" == "oracle-jre-bin" ]; then
				JAVA_HOME=/opt/$f
				JRE_HOME=/opt/$f
		fi
done
EOF
		rm -r "${ED}"/opt/"${P}"/thirdparty/java || die

		mv "${ED}"/opt/"${P}"/bin/scilab scilab.orig || die
		sed '/# Check if the lib exists or not/,$d' scilab.orig > scilab || die
		cat find-jre >> scilab || die
		sed -n '/^# Check if the lib exists or not/,$p' scilab.orig >> scilab || die
		chmod 0755 scilab || die
		mv scilab "${ED}"/opt/"${P}"/bin || die

		mv "${ED}"/opt/"${P}"/bin/scinotes scinotes.orig || die
		sed '/# Check if the lib exists or not/,$d' scinotes.orig > scinotes || die
		cat find-jre >> scinotes || die
		sed -n '/^# Check if the lib exists or not/,$p' scinotes.orig >> scinotes || die
		chmod 0755 scinotes || die
		mv scinotes "${ED}"/opt/"${P}"/bin || die

		mv "${ED}"/opt/"${P}"/bin/xcos xcos.orig || die
		sed '/# Check if the lib exists or not/,$d' xcos.orig > xcos || die
		cat find-jre >> xcos || die
		sed -n '/^# Check if the lib exists or not/,$p' xcos.orig >> xcos || die
		chmod 0755 xcos || die
		mv xcos "${ED}"/opt/"${P}"/bin || die
	fi
}
