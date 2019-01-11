#
# Docker file for Fedora 29 image to build eyedb
# The source tree and the build tree are located in Docker volume
#

FROM fedora:29

# Install needed packages for eyedb build
RUN yum -y install git autoconf libtool make gcc-c++ pkgconfig flex bison

WORKDIR /eyedb
