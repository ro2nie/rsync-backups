#!/bin/bash

SRC="/var/services/homes/ronnie/rsync/daily/*"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DESTINATION="/var/services/homes/ronnie/rsync/weekly"
LOGS="/var/services/homes/ronnie/rsync/logs/run-$TIMESTAMP"
STATE="$DESTINATION/.last-run"
NEEDS_TO_RUN=false

if [ ! -f "$STATE" ]; then
  NEEDS_TO_RUN=true  
else
  previousRun=`cat $STATE`
  timeago='7 days ago'
  lastRun=$(date --date "$previousRun" +'%s')
  monthAgo=$(date --date "$timeago" +'%s')

  if [ $lastRun -lt $monthAgo ]; then
    NEEDS_TO_RUN=true
  fi
fi

if [ "$NEEDS_TO_RUN" = true ] ; then
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
  echo $TIMESTAMP > "$STATE"
  rsync -rlptogv --progress --append-verify --delete $SRC $DESTINATION >> "$LOGS"  
fi
