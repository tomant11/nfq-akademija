#!/bin/bash

cd $(dirname $0)

#remove log files created more than one hour ago
#this leaves only last hour logs
find log -type f -mmin +60 -delete