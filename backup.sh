#!/usr/local/bin/bash
exec 1> >(logger -s -t $(basename $0)) 2>&1 # sends stdout/err to /var/log/messages
# takes the variables SOURCE, DEST & EMAIL

perform_backup () {
# this function simply performs the rclone sync and sends an email if rclone exits on a nonzero value
	rclone sync\
	--log-file /tmp/rclone.log\
	-vvv\
	--transfers 32\
	$SOURCE $DEST
	rc=$?
	if [[ $rc != 0 ]]; then send_mail_and_print "Backup failed with exit code $rc! $(tail -n 5 /tmp/rclone)" "Backup failed!"; exit $rc; fi
}

send_mail_and_print () {
# this function is similar to tee in that when passed 2 values it will send an email off as well as output to stdout (syslog)
	printf "$1" | mail -s "$HOST: $2" $EMAIL
	echo "$2" >&1 # only log subject to syslog
}

send_mail_and_print "Begun backup of $HOST at $(date)" "Backup scheduled"

if pgrep rclone > /dev/null; then # if rclone is already running
	send_mail_and_print "Backup will not run backup again as rclone is already running\n" "Backup already running!"
	exit 1
else
	send_mail_and_print "$(./cost_calc.py)" "Backup has begun!"
	perform_backup
fi
