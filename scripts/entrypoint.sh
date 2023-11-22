#!/bin/bash
/scripts/env_setup.sh 2> /dev/null
# Run cron in the foreground
cron -f