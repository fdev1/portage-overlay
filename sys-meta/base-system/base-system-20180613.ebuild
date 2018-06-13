# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	sys-apps/lshw
	sys-auth/pam_ssh
	sys-process/iotop
	sys-process/lsof
	sys-process/systemd-cron
	sys-apps/net-tools

	!minimal? (
		net-analyzer/speedtest-cli
		net-analyzer/nbtscan
		net-analyzer/traceroute
		net-analyzer/nmap
		net-misc/whois
		dev-libs/geoip
		app-text/wgetpaste
		sys-apps/dmidecode
	)

	alsa? (
		media-plugins/alsa-plugins
		media-sound/alsa-utils
	)

	multimedia? (
		app-cdr/cdrtools
		>=media-video/ffmpeg-2.8
	)
"
RDEPEND="${DEPEND}"
