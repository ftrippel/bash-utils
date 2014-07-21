#!/bin/bash

source process.sh

# Example: run a command NUM_RUN times in batches of NUM_PARALLEL

declare -i NUM_RUNS=10
declare -i NUM_PARALLEL=3
declare -i RUN=1

function do_start()
{
	start_process "echo \"Hello World: $RUN\""
	let RUN++
	let NUM_RUNS--
}

function on_complete()
{
	local cmd=$1; shift
	local pid=$1; shift
	local exitstatus=$1; shift
	if [ "$NUM_RUNS" -gt 0 ] && [ "$exitstatus" -eq 0 ]; then
		do_start
	fi
}

# use ctrl-c to kill all processes
trap kill_processes SIGINT

for ((n=0;n<$NUM_PARALLEL;n++)); do
	do_start
done

wait_processes on_complete 1
