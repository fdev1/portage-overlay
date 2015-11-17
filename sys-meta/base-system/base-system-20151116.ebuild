# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Base system metapackage"
HOMEPAGE="https://mybasesystem.com"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE="+alsa multimedia minimal"

DEPEND="
	mail-mta/ssmtp-reloaded
	net-mail/mailutils
	sys-process/htop
	app-admin/sudo
	app-editors/curses-hexedit
	app-editors/vim
	app-misc/screen
	app-portage/eix
	app-portage/gentoolkit
	app-portage/mirrorselect
	net-analyzer/iftop
	net-analyzer/netcat6
	net-ftp/ftp
	net-misc/socat
	sec-policy/apparmor-policy
	sys-apps/lshw
	sys-auth/pam_ssh
	sys-process/iotop
	sys-process/lsof
	sys-process/systemd-cron

	!minimal? (
		net-analyzer/speedtest-cli
		net-analyzer/nbtscan
		net-analyzer/traceroute
		net-analyzer/nmap
		app-text/wgetpaste
		sys-apps/dmidecode
	)

	alsa? (
		media-plugins/alsa-plugins
		media-plugins/alsaequal
		media-sound/alsa-utils
	)

	multimedia? (
		app-cdr/cdrtools
		media-sound/madplay
		>=media-video/ffmpeg-2.8[theora,jpeg2k,vaapi,vdpau,amr,vpx,threads,openssl]
		>=media-video/ffmpeg-2.8[celt,schroedinger,bs2b,amrenc,fontconfig,gme,libass,libv4l,lzma]
		>=media-video/ffmpeg-2.8[wavpack,zvbi,x265,speex,quvi,opus,ladspa,gsm,aacplus]
		>=media-video/ffmpeg-2.8[modplug,webp,snappy,fribidi,frei0r]
	)
"
RDEPEND="${DEPEND}"
