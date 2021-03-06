# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be de es he ro ru uk"
GNOME2_EAUTORECONF="yes"
inherit l10n gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"
	SRC_URI=""
	S="${WORKDIR}/${P}/${PN}"
else
	SRC_URI="
		https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.orig.tar.gz
		mirror://githubraw/AndrewCrewKuznetsov/xneur-devel/master/dists/${PV}/${PN}_${PV}.orig.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="GTK+ based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="ayatana gconf nls"

DEPEND="
	gnome-base/libglade:2.0
	gconf? ( gnome-base/gconf:2 )
	>=sys-devel/gettext-0.16.1
	>=x11-libs/gtk+-2.20:2
	=x11-misc/xneur-${PV}:${SLOT}[nls=]
	ayatana? ( dev-libs/libappindicator:2 )
"
RDEPEND="
	${DEPEND}
	nls? ( virtual/libintl )
"
DEPEND="
	${DEPEND}
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"

src_prepare() {
	sed -e '/\(README\|TODO\)/d' -i Makefile.am
	gnome2_src_prepare
}

src_configure() {
	local myconf="
		$(use_with ayatana appindicator)
		$(use_with gconf)
		$(use_enable nls)
	"
	gnome2_src_configure ${myconf}
}
