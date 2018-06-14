# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: media-sound/rosegarden/rosegarden-16.02.ebuild,v 1.3 2016/04/04 23:15:32 -radhermit Exp $

EAPI=5

case "${PV}" in
	(*9999*)
		KEYWORDS=""
		VCS_ECLASS=subversion
		ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk/${PN}"
		;;
	(*)
		KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
		SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.bz2"
		;;
esac
inherit eutils cmake-utils fdo-mime gnome2-utils ${VCS_ECLASS}

DESCRIPTION="MIDI and audio sequencer and notation editor"
HOMEPAGE="http://www.rosegardenmusic.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug lirc dssi qt4 qt5 kde gnome lilypond sndfile export"
REQUIRED_USE="|| ( qt4 qt5 )"

RDEPEND="media-libs/ladspa-sdk:=
	x11-libs/libSM:=
	virtual/jack
	media-libs/alsa-lib:=
	dssi? ( >=media-libs/dssi-1.0.0:= )
	media-libs/liblo:=
	media-libs/liblrdf:=
	sci-libs/fftw:3.0
	media-libs/libsamplerate:=[sndfile]
	lirc? ( app-misc/lirc:= )
	sndfile? ( media-libs/libsndfile:= )
	qt4? ( >=dev-qt/qtxml-4.8:4 >=dev-qt/qtgui-4.8:4 >=dev-qt/qtnetwork-4.8:8
		>=dev-qt/qttest-4.8:4 )
	qt5? ( >=dev-qt/qtxml-5.1:5 >=dev-qt/qtgui-5.1:5 >=dev-qt/qtnetwork-5.1:5
		>=dev-qt/qtprintsupport-5.1:5 >=dev-qt/qttest-5.1:5 >=dev-qt/qtwidgets-5.1:5 )
	export? (
                || ( kde-apps/kdialog )
                dev-perl/XML-Twig
                >=media-libs/libsndfile-1.0.16 )
	lilypond? ( >=media-sound/lilypond-2.6.0
                || (
                    	kde? ( kde-apps/okular )
                        gnome? ( app-text/evince )
                        app-text/acroread ) )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-misc/makedepend"

pkg_setup(){
	if ! use export && \
                ! ( has_all-pkg "media-libs/libsndfile dev-perl/XML-Twig" && \
                has_any-pkg "kde-apps/kdialog kde-apps/kdebase-meta" ) ;then
                ewarn "you won't be able to use the rosegarden-project-package-manager"
                ewarn "please emerge with USE=\"export\""
        fi

        if ! use lilypond && ! ( has_version "media-sound/lilypond" && has_any-pkg "app-text/acroread kde-apps/okular app-text/evince" ) ;then
                ewarn "lilypond preview won't work."
                ewarn "If you want this feature please remerge USE=\"lilypond\""
        fi
}

src_configure()
{
	local -a mycmakeargs=(
		$(usex debug '-DCMAKE_BUILD_TYPE=Debug')
		$(usex qt4 '-DUSE_QT4=TRUE')
		$(usex qt5 '-DUSE_QT5=TRUE')
		$(cmake-utils_use_enable lirc LIRC)
		--with-qtdir=/usr
		--with-qtlibdir=/usr/$(get_libdir)/qt4
	)
	cmake-utils_src_configure
}

pkg_preinst()
{
	gnome2_icon_savelist
}

pkg_postinst()
{
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm()
{
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
