# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils eutils
MY_PV="${PV/_/-}"
MY_PV="${MY_PV/rc/RC}"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	SRC_URI="
		https://codeload.github.com/open-eid/${PN}/tar.gz/v${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Estonian ID card digital signature desktop tools"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="c++0x +qt5"

DEPEND="
	dev-libs/libdigidocpp
	sys-apps/pcsc-lite
	dev-libs/opensc
	qt5? (
		dev-qt/linguist-tools:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
	)
	!qt5? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
	net-nds/openldap
"
RDEPEND="
	${DEPEND}
	app-crypt/qesteidutil
"
S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_useno c++0x DISABLE_CXX11)
		$(cmake-utils_use_find_package qt5 Qt5Widgets)
	"
	cmake-utils_src_configure
}

