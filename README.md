istepanov/cron
======================

Docker image that runs cron that periodically executes `command.sh` script. Use this a base image for your periodic task containers.

### Usage

    docker run -d [docker option like env vars, etc.] your_image_based_on_this_image [no-cron]

### Base image parameters

* `-e 'CRON_SCHEDULE=0 1 * * *'`: specifies when cron job starts ([details](http://en.wikipedia.org/wiki/Cron)). Default is `0 1 * * *` (runs every day at 1:00 am).
* `no-cron`: if specified, run container once and exit (no cron scheduling). Good for testing `command.sh`.

### Example

Let's build an image that will run Docker-flavored `cowsay` periodically.

`Dockerfile`

    FROM istepanov/cron

    RUN apk add --no-cache perl ca-certificates wget && \
        wget -O /usr/local/bin/cowsay https://raw.githubusercontent.com/docker/whalesay/master/cowsay && \
        mkdir -p /usr/local/share/cows && \
        wget -O /usr/local/share/cows/default.cow https://raw.githubusercontent.com/docker/whalesay/master/docker.cow && \
        chmod +x /usr/local/bin/cowsay && \
        apk del wget ca-certificates

`command.sh`

    #!/bin/sh

    set -e

    cowsay "$COW_SPEECH"

Build the image:

    docker build -t cowsay .

Run the image in background:

    docker run -d -e 'CRON_SCHEDULE=* * * * *' -e COW_SPEECH='Hello World!' --name cowsay-container cowsay

Get the output:

    docker logs cowsay-container

    # output:

    Job started: Fri Oct  6 04:48:00 UTC 2017

    < Hello World! >
     --------------
        \
         \
          \
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
          {                       /  ===-
           \______ O           __/
             \    \         __/
              \____\_______/

    Job finished: Fri Oct  6 04:48:00 UTC 2017
    Job started: Fri Oct  6 04:49:00 UTC 2017
     ______________
    < Hello World! >
     --------------
        \
         \
          \
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
          {                       /  ===-
           \______ O           __/
             \    \         __/
              \____\_______/

    Job finished: Fri Oct  6 04:49:00 UTC 2017
