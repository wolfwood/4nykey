# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/source-pro/source-pro-20130316.ebuild,v 1.2 2013/10/21 12:18:39 grobian Exp $

EAPI=6

DESCRIPTION="Adobe Source Pro, an open source multi-lingual font family"
HOMEPAGE="
	http://blogs.adobe.com/typblography/2012/08/source-sans-pro.html
	http://blogs.adobe.com/typblography/2012/09/source-code-pro.html
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk +monospace +sans +serif"

RDEPEND="
	cjk? ( media-fonts/source-han-sans )
	monospace? ( media-fonts/source-code-pro )
	serif? ( media-fonts/source-serif-pro )
	sans? ( media-fonts/source-sans-pro )
"