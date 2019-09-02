## Inspiration
The inspiration for writting this script comes from (here)[https://opensource.com/article/19/5/advanced-rsync]

## Using this rsync backup script

The backup script is found in `backup.sh`. To execute it manually, first make it executable and then run it with `./backup.sh` from the terminal.

This script will iterate over home directories (currently set to one), and back them up to another partition such as external NFS drive.
In order to run the script at regular intervals, use the `crontab -e` command, and add a line such as:
`0-59/30 * * * *         /bin/bash /home/ronnie/rsync/backup.sh > /dev/null 2>&1`
In this example, the script is run at every 30th minute of every hour. Change this to suite your needs.

The logs for the runs are found in the `logs/runs` directory.
Logs related to the rsync output are found in the `logs/rsync`.

Whenever the `backup.sh` script is running, an `.rsync-backup.lock` file will be created. This is so that if the cron attempts to start a new job, whilst another one is still running, the script will not start a new rsync backup task.

The script will make use of the `.rsyncignore` file which contains all the directories, files and/or extensions to ignore for the backup rsync job. You may add/remove your own directories/files/wildcards here.