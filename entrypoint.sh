#!/bin/sh

set -e

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

if [[ "$1" == 'no-cron' ]]; then
    exec /command.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    CRON_ENV=`env | grep -v CRON_SCHEDULE`
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /onstart.sh > $LOGFIFO 2>&1; /command.sh > $LOGFIFO 2>&1; /onfinish.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    crond
    tail -f "$LOGFIFO"
fi
