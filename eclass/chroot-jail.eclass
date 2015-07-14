# Copyright 2015 Fernando Rodriguez
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Fernando Rodriguez
# Purpose: Run programs (ie. installers) inside a chroot jail
#

inherit eutils

CHROOT_JAIL_VERBOSE=0

CHROOT_LIBS=
CHROOT_DIRS=
CHROOT_FILES=
CHROOT_DIR=chroot

chroot_einfo()
{
	[ ${CHROOT_JAIL_VERBOSE} == 1 ] && einfo ${1}
}

chroot_create_jail()
{
	einfo "Creating chroot jail..."
	CHROOT_DIRS="bin etc $(get_libdir) usr/bin usr/$(get_libdir) tmp usr"
	CHROOT_FILES="$(get_libdir)/ld-linux.so.2 etc/group etc/passwd"
	mkdir -p "${S}"/chroot/{bin,etc,$(get_libdir),usr/{bin,$(get_libdir)}} || die
	cp -L ${EROOT}/bin/sh chroot/bin || die
	cp -L ${EROOT}/sbin/ldconfig chroot/bin || die
	cp -L ${EROOT}/$(get_libdir)/ld-linux.so.2 chroot/$(get_libdir) || die
	echo "root:x:0:0:root:/root:/bin/bash" > chroot/etc/passwd || die
	echo "root:x:0:root" > chroot/etc/group || die
	echo "/$(get_libdir)" >> chroot/etc/ld.so.conf || die 
	if [ "$(get_libdir)" != "lib" ]; then
		CHROOT_DIRS="${CHROOT_DIRS} lib32"
		CHROOT_FILES="${CHROOT_FILES} $(get_libdir)/ld-linux-x86-64.so.2"
		CHROOT_FILES="${CHROOT_FILES} lib32/ld-linux.so.2"
		mkdir -p chroot/lib32 || die
		cp -L ${EROOT}/$(get_libdir)/ld-linux-x86-64.so.2 chroot/$(get_libdir) || die
		cp -L ${EROOT}/lib32/ld-linux.so.2 chroot/lib32 || die
		ln -s $(get_libdir) chroot/lib || die
		echo "/lib32" >> chroot/etc/ld.so.conf || die
	fi
}

chroot_mkdir()
{
	DIRNAME=$(echo "${1}" | sed -e 's/^\///;s#/$##')
	FS='/' read -ra DIRARR <<< "$DIRNAME"
	DN=
	for d in "${DIRARR[@]}"; do 
		DN="${DN}/${d}"
		chroot_einfo "Creating directory ${DN}..."
		CHROOT_DIRS="${CHROOT_DIRS} $(echo "${DN}" | sed -e 's/^\///;s#/$##')"
	done
	mkdir -p chroot/${DN}
}

# copies a binary and all it's library dependencies
# to the chroot
#
chroot_add_bins()
{
	while [ $# != 0 ]; do
		chroot_einfo "Adding binary ${1} to chroot jail..."
		CHROOT_FILES="${CHROOT_FILES} bin/$1"
		cp -L  `which $1` chroot/bin || die
		for l in $(ldd `which $1` | grep "=>" | cut -d ">" -f2 | cut -d "(" -f1 | sed -e "s/^\s\/*//g;s/\s*$//g"); do
			if [ ! -f "chroot/${l}" ]; then
				chroot_einfo "Adding dependency ${l} to chroot:/$(dirname $l)..."
				CHROOT_FILES="${CHROOT_FILES} ${l}"
				cp -L /"${l}" chroot/"$(dirname $l)" || die
			fi
		done
		shift
	done
}

# copies a library to the chroot. On a multilib amd64 system
# this will copy both the 32 and 64-bit libraries if they
# exists.
#
# This is only needed when an executable installer will unpack
# binaries that require libraries. For binaries added with
# chroot_add_bins the required libraries will be added 
# automagically.
#
chroot_add_libs()
{
	while [ $# != 0 ]; do
		chroot_einfo "Adding library ${1} to chroot jail..."
		CHROOT_FILES="${CHROOT_FILES} $(get_libdir)/${1}"
		cp "${EROOT}"/$(get_libdir)/"${1}" chroot/$(get_libdir) || \
			die "Cannot find library ${1}!"
		if [ "$(get_libdir)" != "lib" ]; then
			if [ -f "${EROOT}/lib32/${1}" ]; then
				CHROOT_FILES="${CHROOT_FILES} lib32/${1}"
				cp ${EROOT}/lib32/${1} chroot/lib32 || \
					die "Cannot find 32-bit library ${1}!!"
			fi
		fi
		shift
	done
}

chroot_cp()
{
	einfo "Adding file ${1} to chroot:${2}..."
	CHROOT_FILES="${CHROOT_FILES} ${2}/${1}"
	chroot_mkdir ${2}
	cp -L ${1} chroot/${2} || die
}

chroot_mv()
{
	chroot_einfo "Moving file ${1} to chroot:${2}..."
	CHROOT_FILES="${CHROOT_FILES} ${2}/${1}"
	chroot_mkdir ${2}
	mv "${1}" chroot/"${2}" || die
}

chroot_rm()
{
	RMOPTS=
	RMFILES=()
	while [ $# != 0 ]; do
		case $1 in
			-*)
				RMOPTS="${RMOPTS} -r"
			;;
			*)
				RMFILES+=("$1")
			;;
		esac
		shift
	done
	for f in $(seq 0 $((${#RMFILES[@]} - 1))); do
		chroot_einfo "Removing file chroot:${RMFILES[$f]}..."
		rm ${RMOPTS} "chroot/${RMFILES[$f]}" || die "chroot_rm: Cannot remove file: ${f}!!"
	done
}

chroot_exec()
{
	einfo "Entering chroot jail..."
	echo ${1}
	env -i chroot ./chroot /bin/sh -c "export PATH=/bin && ldconfig && $1" || die
}

chroot_cleanup()
{
	einfo "Cleaning chroot jail..."
	rm -rf chroot/bin/ldconfig || die
	rm -rf chroot/bin/sh || die
	rm -rf chroot/tmp || die
	rm -rf chroot/etc/ld.so.conf || die
	rm -rf chroot/etc/ld.so.cache || die

	if [ "$(get_libdir)" != "lib" ]; then
		rm -rf chroot/lib || die
	fi

	for f in $CHROOT_FILES; do
		if [ -f "chroot/${f}" ]; then
			chroot_einfo "Removing ${f}..."
			rm -f "chroot/${f}"
		fi
	done

	deleted=1
	while [ $deleted == 1 ]; do
		deleted=9
		for d1 in $( \
			find chroot -type d -empty | \
			sort | awk '$0 !~ last "/" {print last} {last=$0} END {print last}'); do
			for d2 in ${CHROOT_DIRS}; do
				if [ "${d1}" == "chroot/${d2}" ]; then
					rmdir "${d1}"
					deleted=1
				fi
			done
		done
	done
}

chroot_install()
{
	einfo "Installing chroot to image..."
	find chroot -mindepth 1 -maxdepth 1 -exec mv '{}' "${ED}" \; || die
}
