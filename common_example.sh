#!/bin/bash

source common.sh

# optional: get notified by mail on error or completion
# MAIL_TO="x@y.z"

daemonize

echo "Hello World"
check_error

echo "\"exit 24\""
$(exit 24)
check_error 24

notify_complete
