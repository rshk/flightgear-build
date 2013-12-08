# First, you need to install a bunch of stuff..
# ------------------------------------------------------------
#
# cvs subversion cmake make build-essential automake
# fluid gawk gettext scons git-core
# libalut0 libalut-dev
# libasound2 libasound2-dev
# libboost-dev
# libboost-serialization-dev
# libfltk1.3 libfltk1.3-dev
# libglew1.5-dev
# libhal-dev
# libjasper1 libjasper-dev
# libopenal1 libopenal-dev
# libopenexr-dev
# libpng12-0 libpng12-dev
# libqt4-dev
# libsvn-dev
# libwxgtk2.8-0 libwxgtk2.8-dev
# libxft2 libxft-dev
# libxi6 libxi-dev
# libxinerama1 libxinerama-dev
# libxmu6 libxmu-dev
# python-imaging-tk
# python-tk
# zlib1g zlib1g-dev
# freeglut3-dev
# libjpeg8 libjpeg8-dev


SVN := svn
TAR := tar
WGET := wget

CACHE_DIR := .cache
SRC_DIR := src
INSTALL_DIR := $(abspath root)
BINDIR := bin

FGFS_TARBALL := http://ftp.snt.utwente.nl/pub/software/flightgear/ftp/Source/flightgear-2.12.1.tar.bz2
SIMGEAR_TARBALL := http://mirrors.ibiblio.org/simgear/ftp/Source/simgear-2.12.1.tar.bz2
FGDATA_REPO := git://gitorious.org/fg/fgdata.git
FGDATA_TAG := version/2.12.0
BOOST_TARBALL := http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2
PLIB_TARBALL := http://plib.sourceforge.net/dist/plib-1.8.5.tar.gz
OSC_SVN := http://svn.openscenegraph.org/osg/OpenSceneGraph/tags/OpenSceneGraph-3.2.1-rc1
OPENRTI_TARBALL := https://gitorious.org/openrti/openrti/archive/ed6e7262ea52483a9bc198d01e783729ce82361b.tar.gz


PLIB_CONF_FLAGS := --disable-pw --disable-sl --disable-psl --disable-ssg --disable-ssgaux
OSC_CMAKE_FLAGS = \
	-D "CMAKE_BUILD_TYPE=Release" \
	-D "CMAKE_CXX_FLAGS=-O3 -D__STDC_CONSTANT_MACROS" \
	-D "CMAKE_C_FLAGS=-O3" \
	-D "CMAKE_INSTALL_PREFIX:PATH=$(INSTALL_DIR)"
OPENRTI_CMAKE_FLAGS = \
	-D "CMAKE_BUILD_TYPE=Release" \
	-D "CMAKE_CXX_FLAGS=-O3 -D__STDC_CONSTANT_MACROS" \
	-D "CMAKE_C_FLAGS=-O3" \
	-D "CMAKE_INSTALL_PREFIX:PATH=$(INSTALL_DIR)"
SIMGEAR_CMAKE_FLAGS = \
	-D "CMAKE_BUILD_TYPE=Release" \
	-D "CMAKE_CXX_FLAGS=-O3 -D__STDC_CONSTANT_MACROS", \
	-D "CMAKE_C_FLAGS=-O3" \
	-D "CMAKE_INSTALL_PREFIX:PATH=$(INSTALL_DIR)" \
	-D "CMAKE_PREFIX_PATH=$(INSTALL_DIR)" \
	-D "ENABLE_RTI=ON"
FLIGHTGEAR_CMAKE_FLAGS = \
	-D "CMAKE_BUILD_TYPE=Release" \
	-D "CMAKE_CXX_FLAGS=-O3 -D__STDC_CONSTANT_MACROS", \
	-D "CMAKE_C_FLAGS=-O3" \
	-D "CMAKE_INSTALL_PREFIX:PATH=$(INSTALL_DIR)" \
	-D "CMAKE_PREFIX_PATH=$(INSTALL_DIR)" \
	-D "ENABLE_RTI=ON" \
	-D "WITH_FGPANEL=OFF"


## Flags for spawned make processes
SUB_MAKE_FLAGS := -j9


all: install_flightgear install_scripts


.cache/flightgear-2.12.1.tar.bz2:
	mkdir -p .cache
	$(WGET) $(FGFS_TARBALL) -O $@

.cache/simgear-2.12.1.tar.bz2:
	mkdir -p .cache
	$(WGET) $(SIMGEAR_TARBALL) -O $@

.cache/boost_1_55_0.tar.bz2:
	mkdir -p .cache
	$(WGET) $(BOOST_TARBALL) -O $@

.cache/plib-1.8.5.tar.gz:
	mkdir -p .cache
	$(WGET) $(PLIB_TARBALL) -O $@

.cache/openrti-0.3.0.tar.gz:
	mkdir -p .cache
	$(WGET) $(OPENRTI_TARBALL) -O $@

src/flightgear: .cache/flightgear-2.12.1.tar.bz2
	mkdir -p src
	rm -rf $@
	$(TAR) -C $(SRC_DIR) -xjvf $<
	mv src/flightgear-2.12.1 $@
	touch $@  # to update date!

src/simgear: .cache/simgear-2.12.1.tar.bz2
	mkdir -p src
	rm -rf $@
	$(TAR) -C $(SRC_DIR) -xjvf $<
	mv src/simgear-2.12.1 $@
	touch $@  # to update date!

src/boost: .cache/boost_1_55_0.tar.bz2
	mkdir -p src
	rm -rf $@
	$(TAR) -C $(SRC_DIR) -xjvf $<
	mv src/boost_1_55_0 $@
	touch $@  # to update date!

src/plib: .cache/plib-1.8.5.tar.gz
	mkdir -p src
	rm -rf $@
	$(TAR) -C $(SRC_DIR) -xzvf $<
	mv src/plib-1.8.5 $@
	touch $@  # to update date!

src/openscenegraph:
	mkdir -p src
	svn co $(OSC_SVN) $@

src/openrti: .cache/openrti-0.3.0.tar.gz
	mkdir -p src
	rm -rf $@
	$(TAR) -C $(SRC_DIR) -xzvf $<
	mv src/openrti-openrti $@
	touch $@  # to update date!

$(INSTALL_DIR):
	mkdir -p $@
	mkdir -p $@/lib64
	ln -s lib64 $@/lib

##------------------------------------------------------------
## PLib

build_plib: $(INSTALL_DIR) src/plib
	cd src/plib && ./configure $(PLIB_MAKE_FLAGS) --prefix=$(INSTALL_DIR) --exec-prefix=$(INSTALL_DIR)
	$(MAKE) $(SUB_MAKE_FLAGS) -C src/plib

install_plib: build_plib
	$(MAKE) -C src/plib install

clean_plib:
	$(MAKE) -C src/plib clean

uninstall_plib:
	$(MAKE) -C src/plib uninstall

##------------------------------------------------------------
## OpenSceneGraph

build_openscenegraph: $(INSTALL_DIR) src/openscenegraph
	mkdir -p src/openscenegraph_build
	cd src/openscenegraph_build && cmake $(OSC_CMAKE_FLAGS) ../openscenegraph
	$(MAKE) $(SUB_MAKE_FLAGS) -C src/openscenegraph_build

install_openscenegraph: build_openscenegraph
	$(MAKE) -C src/openscenegraph_build install

clean_openscenegraph:
	$(MAKE) -C src/openscenegraph_build clean
	rm -f src/openscenegraph/CMakeCache.txt

uninstall_openscenegraph:
	$(MAKE) -C src/openscenegraph_build uninstall

##------------------------------------------------------------
## OpenRTI

build_openrti: $(INSTALL_DIR) src/openrti
	mkdir -p src/openrti_build
	cd src/openrti_build && cmake $(OPENRTI_CMAKE_FLAGS) ../openrti
	$(MAKE) $(SUB_MAKE_FLAGS) -C src/openrti_build

install_openrti: build_openrti
	$(MAKE) -C src/openrti_build install

clean_openrti:
	$(MAKE) -C src/openrti_build clean
	rm -f src/openrti/CMakeCache.txt

# uninstall_openrti:
# 	$(MAKE) -C src/openrti_build uninstall

##------------------------------------------------------------
## SimGear

build_simgear: $(INSTALL_DIR) src/simgear
	mkdir -p src/simgear_build
	cd src/simgear_build && cmake $(SIMGEAR_CMAKE_FLAGS) ../simgear
	$(MAKE) $(SUB_MAKE_FLAGS) -C src/simgear_build

install_simgear: build_simgear
	$(MAKE) -C src/simgear_build install

clean_simgear:
	$(MAKE) -C src/simgear_build clean
	rm -f src/simgear/CMakeCache.txt

uninstall_simgear:
	$(MAKE) -C src/simgear_build uninstall

##------------------------------------------------------------
## FlightGear

build_flightgear: $(INSTALL_DIR) src/flightgear install_plib install_openscenegraph install_openrti install_simgear
	mkdir -p src/flightgear_build
	cd src/flightgear_build && cmake $(FLIGHTGEAR_CMAKE_FLAGS) ../flightgear
	$(MAKE) $(SUB_MAKE_FLAGS) -C src/flightgear_build

$(INSTALL_DIR)/fgdata:
	git clone $(FGDATA_REPO) -b $(FGDATA_TAG) --depth 0 $@

install_flightgear: build_flightgear $(INSTALL_DIR)/fgdata
	$(MAKE) -C src/flightgear_build install

clean_flightgear:
	$(MAKE) -C src/flightgear_build clean
	rm -f src/flightgear/CMakeCache.txt

uninstall_flightgear:
	$(MAKE) -C src/flightgear_build uninstall


##------------------------------------------------------------
## Global

clean: clean_plib clean_openscenegraph clean_openrti clean_simgear clean_flightgear

uninstall: uninstall_plib uninstall_openscenegraph uninstall_simgear uninstall_flightgear

define LAUNCHER_WRAPPER
#!/usr/bin/env python
import sys, os
INSTALL_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'root')
BIN_NAME = os.path.basename(sys.argv[0])
BIN_PATH = os.path.join(INSTALL_DIR, 'bin', BIN_NAME)
ARGS = sys.argv[1:]
if BIN_NAME == 'fgfs':
    FGDATA_DIR = os.path.join(INSTALL_DIR, 'fgdata')
    ARGS = ['--fg-root={}'.format(FGDATA_DIR)] + ARGS
ENV = {'LD_LIBRARY_PATH': os.path.join(INSTALL_DIR, 'lib')}
os.execve(BIN_PATH, ARGS, ENV)
endef
export LAUNCHER_WRAPPER

install_scripts:
	mkdir -p $(BINDIR)
	rm -f $(BINDIR)/*
	echo "$$LAUNCHER_WRAPPER" > $(BINDIR)/wrapper
	chmod +x $(BINDIR)/wrapper
	ln -s wrapper $(BINDIR)/fgadmin
	ln -s wrapper $(BINDIR)/fgfs
	ln -s wrapper $(BINDIR)/fgviewer
	ln -s wrapper $(BINDIR)/metar
	ln -s wrapper $(BINDIR)/terrasync
