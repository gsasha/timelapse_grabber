#!/bin/sh

# TimeLapse snapshot capture script.
# Captures data

storage_directory=/stills
mkdir -p $storage_directory/$CAMERA_NAME
log_file=$storage_directory/$CAMERA_NAME/log.txt

if [ ! -t 0 ]; then
	exec > $log_file 2>&1
fi

time=`date '+%Y_%m_%d__%H_%M_%S'`;
storage_filename=$CAMERA_NAME-$time.png
storage_file=$storage_directory/$storage_filename

# Record an attempt to grab a frame.
attempts=`cat $storage_directory/$CAMERA_NAME/attempts`
attempts=$((attempts+1))
echo -n $attempts > "$storage_directory/$CAMERA_NAME/attempts"

# Attempt to grab a frame
successes=`cat $storage_directory/$CAMERA_NAME/successes`

timeout -t 5 ffmpeg -rtsp_transport udp -i rtsp://$CAMERA_USER:$CAMERA_PASSWORD@$CAMERA_ADDR/udp/av0_0 -ss 00:00:00.50 -frames:v 1 $storage_directory/$CAMERA_NAME/$storage_filename -loglevel info

retcode=$?
if [ $retcode -ne 0 ] ; then
	echo "Grab failed"
	successes=$((successes+0))
else
	echo "Grab succeeded"
        successes=$((successes+1))
fi
echo -n $successes > "$storage_directory/$CAMERA_NAME/successes"

# Report stats to pushgateway.
if [ ! -z $PUSHGATEWAY_ADDR ]; then
	echo "Reporting stats to $PUSHGATEWAY_ADDR"
	cat<<EOF | curl --data-binary @- http://$PUSHGATEWAY_ADDR/metrics/job/timelapse_grabber/instance/$CAMERA_NAME
# TYPE attempts counter
attempts $attempts
# TYPE successes counter
successes $successes
EOF
fi
