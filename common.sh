#!/bin/bash

if [ "$COMMON_SH" != "1" ]; then

COMMON_SH="1"

SCRIPT=$(readlink -nf $0)

if [ "$LOGFILE" == "" ]; then
	LOGFILE=`mktemp /tmp/$0.XXXXXX`
fi

if [ "$MAIL_TO" == "" ]; then
	MAIL_TO="" # provide default value here
fi

function check_error() {
	local exitcode=$?
	local exitcode_comp=$1; shift
	if [ -z $exitcode_comp ]; then
		exitcode_comp=0
	fi
	if [ $exitcode -ne $exitcode_comp ]; then
		if [ "$MAIL_TO" != "" ] && [ "$LOGFILE" != "" ]; then
			mail -s "[$SCRIPT] Failed" $MAIL_TO <$LOGFILE &>/dev/null
		fi
		exit 1;
	fi
}

function notify_complete() {
	if [ "$MAIL_TO" != "" ]; then
		mail -s "[$SCRIPT] Completed" $MAIL_TO </dev/null &>/dev/null
	fi
}

function daemonize() {
	# ignore SIGHUP
	trap '' 1
	# disconnect stdin; stdout and stderr go to LOGFILE
	echo "writing to $LOGFILE"
	exec 0<&- &>$LOGFILE
}

fi
