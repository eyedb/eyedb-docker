#
# Docker file for Centos 6.9 image to build eyedb
# The source tree and the build tree are located in Docker volume
#

FROM centos:6.9

# Install needed packages for eyedb build
RUN yum -y install git autoconf libtool make gcc-c++ pkgconfig flex bison

WORKDIR /eyedb
