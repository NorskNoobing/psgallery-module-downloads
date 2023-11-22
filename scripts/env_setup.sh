#!/bin/bash
cat > /scripts/env_setup.sh <<- EOM
#!/bin/bash
#Export all the ENV variables into the cron job
export PSGALLERY_PROFILE_URI=$PSGALLERY_PROFILE_URI
export INFLUX_BUCKET=$INFLUX_BUCKET
export INFLUX_HOST=$INFLUX_HOST
export INFLUX_ORG=$INFLUX_ORG
export INFLUX_TOKEN=$INFLUX_TOKEN
EOM