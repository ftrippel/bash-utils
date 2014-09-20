#!/bin/bash

##########################################
# A simple bash framework to run processes
# 
# You can run x processes at a time and 
# y (x<=y) in total (see example)
#
# @author https://github.com/ftrippel
##########################################

if [ "$PROCESS_SH" != "1" ]; then

PROCESS_SH="1"

declare -a cmds
declare -a pids
declare -i run_id=0
declare -i kill_all=0

# default implementation for starting the child process
# can be overriden
function start_process_impl
{
	local cmd=$1; shift
	$cmd 0</dev/null && sleep 5 & # &>/dev/null
}

# public final
function start_process()
{
	if [ "$kill_all" == "0" ]; then
		local cmd=$1; shift
		cmds[$run_id]="$cmd"
		start_process_impl "$cmd"
		pids[$run_id]=$!
		let run_id++
	fi
}

# public final
function kill_processes()
{
	kill_all=1
	for i in ${!pids[@]}
	do
		local pid=${pids[$i]}
		kill -9 $pid &>/dev/null
	done
}

# public final
function wait_processes()
{
	# 1st parameter: function to call with parameters (command, process id, exit status) upon completion
	local on_process_complete=$1; shift

	# 2nd parameter: 0 or 1
	local debug=$1; shift

	while [ ${#pids[@]} -gt 0 ]; do
		#echo "pids: ${pids[@]}"
		#echo "cmds: ${cmds[@]}"
		local n=${#pids[@]}
		for i in ${!pids[@]}
		do
			local pid=${pids[$i]}
			kill -0 $pid &>/dev/null
			if [ $? -gt 0 ]; then
				wait $pid &>/dev/null
				local exitstatus=$?
				if [ "$debug" == "1" ]; then
					echo "\"${cmds[$i]}\" with pid ${pid} exited with status ${exitstatus}"
				fi
				if [ "$on_process_complete" != "" ]; then
					$on_process_complete "${cmds[$i]}" "${pid}" "${exitstatus}"
				fi
				unset cmds[$i]
				unset pids[$i]
			fi
		done
		sleep 1
	done
}

fi

