#!/bin/sh

HOST=gimli

source="/storage/vault"
dest="cloud:gimlivault"
email="samlockart@gmail.com"
cd /root
if pgrep rclone > /dev/null
then
	printf '[!] Backup already running\n'
	printf "Backup job already running on $HOST\n\n$(fortune)" | mail -s "$HOST: backup already in progress" $email
	exit 0 
else
	printf "[-] Backing up $HOST\n"
	rclone sync\
	--log-file /tmp/rclone.log\
	-v\
	--transfers 32\
	$source $dest
		printf "Backing up $HOST suceeded! \n\ndf -h:\n $(df -h)\nLast 32 lines of logging:\n$(tail -n 32 /tmp/rclone.log)" | mail -s "$HOST: backup success" $email
fi
