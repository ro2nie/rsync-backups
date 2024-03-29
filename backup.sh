#!/bin/bash

HOMES="ronnie" #i.e: bob john joe
DRIVE="/mnt/nas-homes"
COMPUTER="lenovo-linux/"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
TODAY=$(date '+%Y-%m-%d')

for HOME in $HOMES; do
     FILE=/home/$HOME/rsync/.rsync-backup.lock
     LOGFILE_RUN=/home/$HOME/rsync/logs/runs/run-$TODAY.log
     LOGFILE_RSYNC=/home/$HOME/rsync/logs/rsync/run-$TIMESTAMP.log
     LOGFILE_RSYNC_FIND=/home/$HOME/rsync/logs/rsync/run-$TIMESTAMP-find.log

     #Cleanup - remove logs older than 7 days
     find /home/$HOME/rsync/logs/ -name "*.log" -type f -mtime +7 -exec rm -f {} \;

     if [ ! -f "$FILE" ]; then
          DESTINATION=$DRIVE/$HOME/rsync/daily/$COMPUTER
          if [ -d "$DESTINATION" ]; then
               touch $FILE
               echo "[$(date '+%Y-%m-%d %H:%M:%S')] Initiating daily rsync backup to NAS to $DESTINATION directory" >> "$LOGFILE_RUN"
               cd /home/$HOME
               rsync -dlptov --progress --append-verify --exclude-from="/home/$HOME/rsync/.rsyncignore" --delete . $DESTINATION >> "$LOGFILE_RSYNC"
               find . -maxdepth 1 -type d -not -name "." -exec rsync -rlptov --append-verify --progress --exclude-from="/home/$HOME/rsync/.rsyncignore" --delete {} $DESTINATION \; >> "$LOGFILE_RSYNC_FIND"
               rm -f $FILE
               echo "[$(date '+%Y-%m-%d %H:%M:%S')] Finished daily rsync backup to NAS to $DESTINATION directory" >> "$LOGFILE_RUN"
          else
               echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cannot access directory $DESTINATION. Check mount state." >> "$LOGFILE_RUN"
          fi
     echo "------------------------------------------------------------------------------" >> "$LOGFILE_RUN"
     fi
done
