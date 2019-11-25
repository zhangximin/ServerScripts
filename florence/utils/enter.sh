#!/bin/bash

EXPECTED_NUM_ARGS=1;

if [ "$#" -ne $EXPECTED_NUM_ARGS ]; then
    # user didn't specify which container ID, assume the latest one
    CONTAINER_ID=`/usr/bin/docker ps -q --no-trunc | /bin/sed -n 1p`
    /usr/bin/docker exec -it -e TERM=xterm $CONTAINER_ID bash
else
    # enter the container the user specified
    /usr/bin/docker exec -it -e TERM=xterm $1 bash
fi

