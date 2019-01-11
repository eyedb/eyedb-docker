#!/bin/bash

function usage() {
    script=$(basename $0)
    echo >&2 "Usage: $script DISTRO"
    echo >&2 "Run a docker image for eyedb building"
    echo >&2 ""
    echo >&2 "DISTRO is the base Linux distro of the image"
    echo >&2 "Currently available distributions:"
    echo >&2 "  - ubuntu18.04"
    echo >&2 "  - centos6.9"
    echo >&2 "  - fedora29"
    echo >&2 "  - debian9.6"
    echo >&2 ""
    echo >&2 "Options:"
    echo >&2 "-r ROOTDIR      give eyedb root dir (default: $HOME/eyedb"
    exit 1
}

if [ $# -lt 1 ] ; then usage $* ; fi

while getopts "h" opt; do
    case $opt in
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

DISTRO=$1
DISTRO_VOLUME=eyedb-${DISTRO}
IMAGE=eyedb-${DISTRO}

. $(dirname $0)/funs.sh

check_image_exit $IMAGE

create_volume_if_needed $DISTRO_VOLUME

docker_run \
    --mount source=eyedb-ssh,target=/root/.ssh \
    --mount source=${DISTRO_VOLUME},target=/eyedb \
    $IMAGE
