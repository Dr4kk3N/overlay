# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="MIDI network gateway application that sends and receives MIDI data."
SLOT=0
SRC_URI="http://downloads.sourceforge.net/qmidinet/qmidinet-0.4.2.tar.gz"

KEYWORDS="~amd64 ~x86"

RDEPEND="
    dev-qt/qtcore
    dev-qt/qtgui
"

DEPEND="
    ${RDEPEND}
"

src_configure() {
    econf --with-qt5=/usr/lib/qt5
}    
