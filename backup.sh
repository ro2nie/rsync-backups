HOMES="ronnie" #i.e: bob john joe
DRIVE="/mnt/nas-homes"
COMPUTER="lenovo-linux/"

for HOME in $HOMES; do
     FILE=/home/$HOME/rsync/.rsync-backup.lock

     if [ -f "$FILE" ]; then
          echo "Another rsync process is already running on directory ~/$HOME"
     else
          DESTINATION=$DRIVE/$HOME/rsync/$COMPUTER
          if [ -d "$DESTINATION" ]; then
               touch $FILE
               echo "Initiating daily rsync backup to NAS for ~/$HOME directory"
               cd /home/$HOME
               rsync -cdlptov --exclude '.rsyncignore' --delete --log-file=logs/rsync-$(date +%Y-%m-%d).log . $DESTINATION
               find . -maxdepth 1 -type d -not -name "." -exec rsync -crlptov --exclude '.rsyncignore' --delete --log-file=logs/rsync-$(date +%Y-%m-%d)-find.log {} $DESTINATION \;
               rm -f $FILE
               echo "Finished daily rsync backup to NAS for ~/$HOME directory"
          else
               echo "Cannot access directory $DESTINATION. Check mount state."
          fi
     fi
done

