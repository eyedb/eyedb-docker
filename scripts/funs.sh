function check_image() {
    docker images | grep -qs "$1"
}

function check_image_exit() {
    if ! check_image "$1" ; then
	echo >&2 "Error: Docker image \"$1\" does not exists!"
	exit 2
    fi
}

function create_image() {
    (cd $SCRIPT_DIR/../$IMAGE ; docker build -t $IMAGE . )
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

function docker_run() {
    docker run --interactive --tty --rm $* bash
}
