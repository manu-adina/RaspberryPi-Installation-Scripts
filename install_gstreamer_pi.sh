#!/bin/bash

printf 'Installing Gstreamer for Raspberry Pi - (was made for Pi 3B+ with Raspbian Buster)\n\n'

printf '########################\n\n'

printf 'Updating and Upgrading.\n\n'

if sudo apt-get -y --assume-yes update && sudo apt-get -y --assume-yes upgrade ; then
	printf '\nUpdated Successfully\n\n'
else 
	printf '\nFailed to Update\n\n\'
	exit 1
fi

printf '#########################\n\n'

printf 'Installing Gstreamer Binaries and Depenedencies\n\n' 

if sudo apt-get -y --assume-yes install build-essential autotools-dev automake autoconf \
libtool autopoint libxml2-dev zlib1g-dev libglib2.0-dev \
pkg-config bison flex python3 git gtk-doc-tools libasound2-dev \
libgudev-1.0-dev libxt-dev libvorbis-dev libcdparanoia-dev \
libpango1.0-dev libtheora-dev libvisual-0.4-dev iso-codes \
libgtk-3-dev libraw1394-dev libiec61883-dev libavc1394-dev \
libv4l-dev libcairo2-dev libcaca-dev libspeex-dev libpng-dev \
libshout3-dev libjpeg-dev libaa1-dev libflac-dev libdv4-dev \
libtag1-dev libwavpack-dev libpulse-dev libsoup2.4-dev libbz2-dev \
libcdaudio-dev libdc1394-22-dev ladspa-sdk libass-dev \
libcurl4-gnutls-dev libdca-dev libdvdnav-dev \
libexempi-dev libexif-dev libfaad-dev libgme-dev libgsm1-dev \
libiptcdata0-dev libkate-dev libmimic-dev libmms-dev \
libmodplug-dev libmpcdec-dev libofa0-dev libopus-dev \
librsvg2-dev librtmp-dev libschroedinger-dev libslv2-dev \
libsndfile1-dev libsoundtouch-dev libspandsp-dev libx11-dev \
libxvidcore-dev libzbar-dev libzvbi-dev liba52-0.7.4-dev \
libcdio-dev libdvdread-dev libmad0-dev libmp3lame-dev \
libmpeg2-4-dev libopencore-amrnb-dev libopencore-amrwb-dev \
libsidplay1-dev libtwolame-dev libx264-dev libusb-1.0 \
python-gi-dev yasm python3-dev libgirepository1.0-dev \
gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev \
libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev ; then
	printf '\nInstalled Dependencies Success\n\n'
else
	printf '\nError, Installing Dependencies, Quitting Script\n\n'
	exit 1
fi

printf '########################\n\n'
printf 'Installing Gst-Plugins-Bad\n\n'

cd ~/Downloads
if wget https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.10.4.tar.xz ; then
	printf '\nDownloaded Gst-Plugins-Bad\n\n'
else
	printf '\nFailed to download gst-plugins-bad\n\n'
	rm gst-plugins-bad-1.10.4.tar.xz
	exit 1
fi

tar xf gst-plugins-bad-1.10.4.tar.xz
cd gst-plugins-bad-1.10.4

printf '########################\n\n'
printf '\nInstalling Gst-OMX for Pi\n\n'
export LDFLAGS='-L/opt/vc/lib' CFLAGS='-I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/EGL -I/opt/vc/include/GLES -I/opt/vc/include/GLES2' CPPFLAGS='-I/opt/vc/include -I/opt/vc/include/interface/vcos/pthreads -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/EGL -I/opt/vc/include/GLES -I/opt/vc/include/GLES2'

if ./autogen.sh --disable-gtk-doc --disable-examples --disable-x11 --disable-glx --disable-opengl --disable-wayland --enable-gles2 --enable-egl --enable-dispmanx --enable-introspection=yes --with-gles2-module-name=/opt/vc/lib/libbrcmGLESv2.so --with-egl-module-name=/opt/vc/lib/libbrcmEGL.so --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib/arm-linux-gnueabihf ; then
	printf '\nConfigured Succesfully\n\n'
else
	printf '\nFailed to Configure\n\n'
	exit 1
fi

printf 'Building Gst-Plugins-Bad\n\n'

if make ; then
	printf '\nBuild was Successful\n\n'
else
	make clean
	printf'\nError Building Gst-Plugins-Bad\n\n'
	exit 1
fi
