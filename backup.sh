#!/usr/local/bin/bash
exec 1> >(logger -s -t $(basename $0)) 2>&1 # sends stdout/err to /var/log/messages
# takes the variables SOURCE, DEST & EMAIL

printf "Starting backup of $SOURCE to $DEST\n"
if pgrep rclone > /dev/null # if rclone is already running
then
	printf 'Backup already running\n'
	printf "Backup job already running on $HOST\n\n$(fortune)" | mail -s "$HOST: backup already in progress" $EMAIL
	exit 0 
else
	printf "Starting back up of $HOST\n"
	rclone sync\
	--log-file /tmp/rclone.log\
	-v\
	--transfers 32\
	$SOURCE $DEST
		printf "$(./cost_calc.py)" | mail -s "$HOST: backup success" $EMAIL
fi
