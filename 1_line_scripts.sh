#!/bin/bash

# password generator, excludes inappropriate symbols, written by Pavel Borisovskiy
cat /dev/urandom | tr -d -c 'a-hj-km-np-zA-HJ-KM-NP-Z2-9$%!@#' | fold -w 12 | head -1

# delete unused legacy docker images
docker rmi $(docker images -f "dangling=true" -q)

# delete all docker images
docker rmi $(docker images | grep -v CREATED | awk '{print $3}')

# top 5 memory-used processes
ps aux | awk '{print $6/1024 " MB\t\t" $11}' | sort -rn | head -n5

# Simpliest way to share directory content (run in directory which content you want to share)
python -m SimpleHTTPServer 9080 --bind 0.0.0.0