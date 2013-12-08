# FlightGear Build

..a Makefile to rule 'em all!


## What's this?

This makefile allows you to quickly build FlightGear 2.12.1, by just
typing ``make`` at the command prompt.

It will also set up some handy launcher scripts that set everything
you need in order to run them from a non-standard prefix (no garbage
in ``/usr/local``, no need to be root on your machine).


## What it does

* Build & install plib
* Build & install OpenRTI
* Build & install OpenSceneGraph
* Build & install SimGear
* Build & install FlightGear
* Setup a nice environment for running fgfs


## Usage

First, you'll need a bunch of tools & libraries.

On debian:

```console
apt-get install cvs subversion cmake make build-essential automake \
    fluid gawk gettext scons git-core \
    libalut0 libalut-dev \
    libasound2 libasound2-dev \
    libboost-dev \
    libboost-serialization-dev \
    libfltk1.3 libfltk1.3-dev \
    libglew1.5-dev \
    libhal-dev \
    libjasper1 libjasper-dev \
    libopenal1 libopenal-dev \
    libopenexr-dev \
    libpng12-0 libpng12-dev \
    libqt4-dev \
    libsvn-dev \
    libwxgtk2.8-0 libwxgtk2.8-dev \
    libxft2 libxft-dev \
    libxi6 libxi-dev \
    libxinerama1 libxinerama-dev \
    libxmu6 libxmu-dev \
    python-imaging-tk \
    python-tk \
    zlib1g zlib1g-dev \
    freeglut3-dev \
    libjpeg8 libjpeg8-dev
```

Then, I'd recommend you clone the FGDATA repository somewhere,
as it's quite heavy:

```
git clone --mirror git://gitorious.org/fg/fgdata.git /mnt/data/fgdata
```

Ok, we're ready to go:

```
make FGDATA_REPO=/mnt/data/fgdata
```

if everything went fine, you will be able to run FlightGear by running:

```
./bin/fgfs
```

..have fun!
