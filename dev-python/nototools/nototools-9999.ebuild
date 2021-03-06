# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5ed2f7c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV//./-}-tooling-for-phase3-update"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A python package for maintaining the Noto Fonts project"
HOMEPAGE="https://github.com/googlei18n/nototools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.31[ufo,${PYTHON_USEDEP}]
	>=dev-python/pillow-4[${PYTHON_USEDEP}]
	dev-python/pyclipper[${PYTHON_USEDEP}]
	dev-python/freetype-py[${PYTHON_USEDEP}]
	media-libs/harfbuzz
"
RDEPEND="
	${DEPEND}
	media-gfx/scour
"
PATCHES=( "${FILESDIR}"/${PN}-ufolib.diff )

python_prepare_all() {
	sed -e "s:HB_SHAPE_PATH,:'/usr/bin/hb-shape',:" \
		-i "${S}"/nototools/render.py
	distutils-r1_python_prepare_all
}

python_test() {
	cd tests
	./run_tests || die
}
