#!/bin/bash

SUPPORTED_DISTROS="ubuntu18.04 centos6.9 fedora29 debian9.6"

function usage() {
    script=$(basename $0)
    echo >&2 "Usage: $script DISTRO"
    echo >&2 "Run a docker image for eyedb building"
    echo >&2 ""
    echo >&2 "DISTRO is the base Linux distro of the image"
    echo >&2 "Currently available distributions:"
    for distro in $SUPPORTED_DISTROS ; do
    echo >&2 "  - $distro"
    done
    echo >&2 ""
    echo >&2 "Options:"
    echo >&2 "-r ROOTDIR      give eyedb root dir, where source dirs are located"
    echo >&2 "                (default: \$HOME/eyedb)"
    echo >&2 ""
    exit 1
}

function check_rootdir() {
    for dir in eyedb eyedbsm ; do
	if test ! -f "$1/$dir/configure.ac" ; then
	    echo >&2 "Error: source directory \"$1/$dir\" not found!"
	    exit 2
	fi
    done
}

function check_distro() {
    for distro in $SUPPORTED_DISTROS ; do
	if test "$distro" = "$1" ; then return ; fi
    done
    echo >&2 "Error: \"$1\" is not a supported distro!"
    exit 2
}

function check_image() {
    docker images | grep -qs "$1"
}

function check_image_exit() {
    if ! check_image "$1" ; then
	echo >&2 "Error: Docker image \"$1\" does not exists!"
	exit 2
    fi
}

function check_volume() {
    docker volume ls | grep -qs "$1"
}

function check_volume_exit() {
    if ! check_volume "$1" ; then
	echo >&2 "Error: Docker volume \"$1\" does not exists!"
	exit 2
    fi
}

function create_volume() {
    echo "Creating Docker volume \"$1\""
    docker volume create $1
}

function create_volume_if_needed() {
    if ! check_volume $1 ; then create_volume $1 ; fi
}

if [ $# -lt 1 ] ; then usage $* ; fi

while getopts "hr:" opt; do
    case $opt in
	r)
	    ROOTDIR="$OPTARG"
	    ;;
	h)
	    usage
	    ;;
	\?)
	    usage
	    ;;
	:)
	    usage
	    ;;
    esac
done
shift $((OPTIND-1))

if test -z "$ROOTDIR" ; then ROOTDIR="$HOME/eyedb" ; fi
check_rootdir "$ROOTDIR"

DISTRO=$1
check_distro "$DISTRO"

DISTRO_VOLUME=eyedb-${DISTRO}
IMAGE=fdshell/eyedb:${DISTRO}

#check_image_exit $IMAGE

create_volume_if_needed $DISTRO_VOLUME

docker run --interactive --tty --rm \
       --mount source=$DISTRO_VOLUME,target=/eyedb \
       --mount type=bind,source=$HOME/projects/eyedb/git,target=/eyedb/git \
       $IMAGE \
       bash

