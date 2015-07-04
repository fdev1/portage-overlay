# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="The .NET Compiler Platform"
HOMEPAGE="https://github.com/dotnet/roslyn"
SRC_URI="https://github.com/fernando-rodriguez/roslyn/archive/20150703_alpha.tar.gz -> roslyn-20150703_alpha.tar.gz
	bootstrap-mono? ( https://dotnetci.blob.core.windows.net/roslyn/mono.linux.1.tar.bz2 )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="+bootstrap-mono"

DEPEND="
	>=dev-lang/mono-4.0.1
"
RDEPEND="${DEPEND}"

pkg_setup()
{
	BUILD_CONFIGURATION=Release
	XUNIT_VERSION=2.0.0-alpha-build2576
}

src_prepare()
{
	sed -ie "s|/tmp|${WORKDIR}|g" "${S}/cibuild.sh" || die
	for f in $(ls "${WORKDIR}/mono.linux.1/bin"); do
		if [ -f "${WORKDIR}/mono.linux.1/bin/${f}" ]; then
			if [ "$(file "${WORKDIR}/mono.linux.1/bin/${f}" | grep "POSIX shell")" != "" ]; then
				einfo "Fixing ${f}..."
				sed -ie "s|/tmp|${WORKDIR}|g" "${WORKDIR}/mono.linux.1/bin/${f}" || die
			fi
		fi
	done
	for f in $(ls ${WORKDIR}/mono.linux.1/lib/*.la); do
		einfo "Fixing ${f}..."
		[ -f "${f}" ] && \
			( sed -ie "s|/tmp|${WORKDIR}|g" "${f}" || die )
	done

#	einfo "Installing NuGet packages..."
#	nuget restore Roslyn.sln || nuget restore Roslyn.sln || nuget restore Roslyn.sln || die
#	nuget install xunit.runners -PreRelease -Version $XUNIT_VERSION -OutputDirectory packages || \
#	nuget install xunit.runners -PreRelease -Version $XUNIT_VERSION -OutputDirectory packages || \
#	nuget install xunit.runners -PreRelease -Version $XUNIT_VERSION -OutputDirectory packages || die
}

src_compile()
{
	${S}/cibuild.sh
#	einfo "Building bootstrap toolchain..."
#	xbuild \
#		/v:m \
#		/p:SignAssembly=false \
#		/p:DebugSymbols=false \
#		${S}/src/Compilers/CSharp/csc/csc.csproj \
#		/p:Configuration=${BUILD_CONFIGURATION} || die
#
#	xbuild \
#		/v:m \
#		/p:SignAssembly=false \
#		/p:DebugSymbols=false \
#		${S}/src/Compilers/VisualBasic/vbc/vbc.csproj \
#		/p:Configuration=${BUILD_CONFIGURATION} || die
#
# 	local compiler_binaries=(
#		csc.exe
#		Microsoft.CodeAnalysis.dll
#		Microsoft.CodeAnalysis.CSharp.dll
#		System.Collections.Immutable.dll
#		System.Reflection.Metadata.dll
#		vbc.exe
#		Microsoft.CodeAnalysis.VisualBasic.dll)
#
#	einfo "Saving bootstrap binaries..."
#    mkdir -p ${S}/Binaries/Bootstrap || die
#    for i in ${compiler_binaries[@]}; do
#        cp "${S}/Binaries/${BUILD_CONFIGURATION}/${i}" "${S}/Binaries/Bootstrap/${i}" || die
#        if [ $? -ne 0 ]; then
#            die "Saving bootstrap binaries failed"
#        fi  
#    done
#
#	einfo "Cleaning enlistment..."
#    xbuild /v:m /t:Clean "${S}/build/Toolset.sln" /p:Configuration=$BUILD_CONFIGURATION || die
#    rm -rf "${S}/Binaries/${BUILD_CONFIGURATION}"
#	
#	einfo "Building CrossPlatform.sln..."
#	xbuild \
#		/v:m \
#		/p:SignAssembly=false \
#		/p:DebugSymbols=false \
#		/p:BootstrapBuildPath=${S}/Binaries/Bootstrap \
#		CrossPlatform.sln \
#		/p:Configuration=${BUILD_CONFIGURATION} || die
}

src_install()
{
	dodir "${ROOT}/usr/lib/roslyn"
	cp "${S}"/Binaries/"${BUILD_CONFIGURATION}"/* "${ROOT}/usr/lib/roslyn" || die
}
