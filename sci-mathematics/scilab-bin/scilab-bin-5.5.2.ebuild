# Copyright 2015 Fernando Rodriguez 
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Open source software for numerical computation"
HOMEPAGE="Open source software for numerical computation"
SRC_URI="
	x86? ( http://www.scilab.org/download/5.5.2/scilab-5.5.2.bin.linux-i686.tar.gz )
	amd64? ( http://www.scilab.org/download/5.5.2/scilab-5.5.2.bin.linux-x86_64.tar.gz )"

LICENSE="CeCILL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="system-jre"

DEPEND=""
RDEPEND="${DEPEND}"
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
		die "TODO: Unbundle JRE..." 
	fi
}
