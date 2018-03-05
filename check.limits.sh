#!/bin/bash
# check if limits work which has been set up
for pid in `pidof nginx`; do echo "$(< /proc/$pid/cmdline)"; egrep 'files|Limit' /proc/$pid/limits; echo "Currently open files: $(ls -1 /proc/$pid/fd | wc -l)"; echo; done