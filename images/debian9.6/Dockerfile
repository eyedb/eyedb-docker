#
# Docker file for Debian 9.6 image to build eyedb
# The source tree and the build tree are located in Docker volume
#

FROM debian:9.6

# Install needed packages for eyedb build
RUN apt-get update -y && apt-get install -y git autoconf libtool make g++ pkg-config flex bison

WORKDIR /eyedb
