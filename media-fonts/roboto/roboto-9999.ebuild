# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
MY_PN="${PN}-hinted"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="f61b7a2"
	SRC_URI="
		binary? (
			https://github.com/google/${PN}/releases/download/v${PV}/${MY_PN}.zip
			-> ${MY_PN}-${PV}.zip
		)
		!binary? (
			mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Google's signature family of fonts"
HOMEPAGE="https://github.com/google/roboto"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	binary? (
		app-arch/unzip
	)
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/cu2qu[${PYTHON_USEDEP}]
			dev-python/ufo2ft[${PYTHON_USEDEP}]
			dev-python/robofab[${PYTHON_USEDEP}]
			dev-python/feaTools[${PYTHON_USEDEP}]
			dev-python/booleanOperations[${PYTHON_USEDEP}]
			sci-libs/scipy[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	if use binary; then
		S="${WORKDIR}/${MY_PN}"
		FONT_SUFFIX="ttf"
	else
		python-any-r1_pkg_setup
		FONT_S=( out/Roboto{,Condensed}{O,T}TF )
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	python_fix_shebang "${S}"
	sed -e "s:\<python\>:${EPYTHON}:" -i Makefile
}

src_compile() {
	use binary && return
	default
}
