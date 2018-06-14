# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit cmake-utils 

if [[ ${PV} == 9999* ]]
then
    	EGIT_REPO_URI="https://github.com/Cairo-Dock/${PN}.git"
       	inherit git-r3
        KEYWORDS=""
else
       	SRC_URI="https://github.com/Cairo-Dock/${PN}/archive/${PV}.zip -> ${P}.zip"
        KEYWORDS="~amd64"
fi

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="http://glx-dock.org/index.php"

LICENSE="GPL-3"
SLOT="0"

IUSE="alsa exif gmenu gtk3 kde terminal gnote vala webkit xfce xgamma xklavier twitter indicator3 zeitgeist mail"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg:2
	sys-apps/dbus
	x11-libs/cairo
	!gtk3? ( x11-libs/gtk+:2 )
	x11-libs/gtkglext
	~x11-misc/cairo-dock-${PV}
	gtk3? ( x11-libs/gtk+:3 )
	alsa? ( media-libs/alsa-lib )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	kde? ( kde-frameworks/kdelibs )
	terminal? ( x11-libs/vte:= )
	vala? ( dev-lang/vala:= )
	webkit? ( >=net-libs/webkit-gtk-1.4.0:3 )
	xfce? ( xfce-base/thunar )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	gnote? ( app-misc/gnote )
	twitter? ( dev-python/oauth dev-python/simplejson )
	indicator3? ( dev-libs/libindicator:= )
	zeitgeist? ( dev-libs/libzeitgeist )
	mail? ( net-libs/libetpan )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig
	dev-libs/libdbusmenu[gtk3]
"

src_configure() {
	mycmakeargs=(
		# broken with 0.99.x (as of cairo-dock 3.3.2)
		"-Denable-upower-support=OFF"
		# broken 
		"-Denable-scooby-do=ON"
		`use gtk3 && echo "-Dforce-gtk2=OFF" || echo "-Dforce-gtk2=ON"`
	)
	cmake-utils_src_configure
}
