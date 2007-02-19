# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.0.38_rc2-r1.ebuild,v 1.1 2005/04/18 15:44:32 flameeyes Exp $

inherit subversion flag-o-matic autotools qt4

PATCHLEVEL=7
DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.4_branch"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86"
IUSE="
	a52 aac alsa altivec arts encode esd mad mmx nls png vorbis sdl truetype
	xvid xv oss x264 dts qt4 fontconfig lame faac aften
"

RDEPEND="
	>=dev-libs/libxml2-2.6.7
	>=x11-libs/gtk+-2.6.0
	>=dev-lang/spidermonkey-1.5-r2
	a52? ( >=media-libs/a52dec-0.7.4 )
	aften? ( >=media-sound/aften-0.0.6 )
	aac? ( >=media-libs/faad2-2.0-r2 )
	faac? ( >=media-libs/faac-1.23.5 )
	mad? ( media-libs/libmad )
	lame? ( >=media-sound/lame-3.93 )
	xvid? ( >=media-libs/xvid-1.0.0 )
	nls? ( >=sys-devel/gettext-0.12.1 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	arts? ( >=kde-base/arts-1.2.3 )
	truetype? ( >=media-libs/freetype-2.1.5 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	x264? ( media-libs/x264 )
	png? ( media-libs/libpng )
	esd? ( media-sound/esound )
	dts? ( || ( media-libs/libdca media-libs/libdts ) )
	sdl? ( media-libs/libsdl )
	xv? ( x11-libs/libXv )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	qt4? ( $(qt4_min_version 4.2) )
	fontconfig? ( media-libs/fontconfig )
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

filter-flags "-fno-default-inline"
filter-flags "-funroll-loops"
filter-flags "-funroll-all-loops"
filter-flags "-fforce-addr"

src_unpack() {
	subversion_src_unpack
	cd ${S}

	REVISION="$(svnversion \
		${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/})"
	sed -i "s:if .*svn/entries[^;]*: if true:; s:rev=\`.*:rev=${REVISION}:" \
		configure.in.in

	make -f admin/Makefile.common configure.in
	touch acinclude.m4
	eautoreconf
}

src_compile() {
	local myconf
	use mmx || myconf="--disable-mmx"
	use x264 || export ac_cv_header_x264_h="no"
	use qt4 && QT4="/usr" || QT4="xxx"
	has_version '>=media-libs/faad2-2.1' || myconf="${myconf} --with-newfaad"

	econf \
		$(use_enable nls) \
		$(use_enable altivec) \
		$(use_enable xv) \
		$(use_enable mp3 mad) \
		$(use_with arts) \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with vorbis) \
		$(use_with a52 a52dec) \
		$(use_with sdl libsdl) \
		$(use_with truetype freetype2) \
		$(use_with fontconfig) \
		$(use_with aac faad2) \
		$(use_with xvid) \
		$(use_with esd) \
		$(use_with dts libdca) \
		$(use_with lame) \
		$(use_with faac) \
		$(use_with aften) \
		--with-jsapi-include=/usr/include/js \
		--with-qt-dir=${QT4} --with-qt-lib=/usr/lib/qt4\
		--disable-warnings --disable-dependency-tracking \
		${myconf} || die "configure failed"
	make || die "make failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog History
}
