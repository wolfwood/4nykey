# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	MY_C="certs-5415bae"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/open-eid/${MY_C%-*}/tar.gz/${MY_C##*-} -> ${MY_C}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit flag-o-matic cmake-utils

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="apidocs doc"
REQUIRED_USE="apidocs? ( doc )"

RDEPEND="
	dev-libs/libxml2:2
	dev-libs/openssl:0
	dev-libs/opensc
	sys-libs/zlib[minizip]
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
	dev-util/cmake-openeid
"
DOCS=( AUTHORS RE{ADME,LEASE-NOTES}.md )

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_C}/* "${S}"/etc/certs
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-i CMakeLists.txt
	sed \
		-e '/INSTALL_RPATH/d' \
		-i libdigidoc/CMakeLists.txt
	cmake-utils_src_prepare
	append-cppflags '-DOF=_Z_OF'
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOC=$(usex doc)
		-DCMAKE_INSTALL_SYSCONFDIR="${EROOT}"etc
	)
	cmake-utils_src_configure
}
