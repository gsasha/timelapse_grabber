#!/bin/sh

# TimeLapse snapshot capture script.

# This script should capture any stills in the incoming Stills directory

time=`date '+%Y_%m_%d__%H_%M_%S'`;

# The 4 parameters below should be provided in Docker environment vars.
#CameraName='camname'
#CameraIP='10.10.1.5'
#CameraUsername='user'
#CameraPassword='passwd'

# Shouldn't need to be changed!
StorageDirectory=/stills
StorageFilename=$CameraName-$time.png

mkdir -p $StorageDirectory/$CameraName;

#echo ffmpeg -rtsp_transport udp -i rtsp://$CameraUsername:$CameraPassword@$CameraIP:10554/udp/av0_0 -ss 00:00:00.50 -frames:v 1 $StorageDirectory/$CameraName/$StorageFilename -loglevel debug >> /stills/log.txt 

attempts=`cat $StorageDirectory/$CameraName/attempts`
attempts=$((attempts+1))
echo -n $attempts > '$StorageDirectory/$CameraName/attempts'

successes=`cat $StorageDirectory/$CameraName/successes`
successes=$((successes+1))

timeout 5 ffmpeg -rtsp_transport udp -i rtsp://$CameraUsername:$CameraPassword@$CameraIP:10554/udp/av0_0 -ss 00:00:00.50 -frames:v 1 $StorageDirectory/$CameraName/$StorageFilename -loglevel info >> /stills/log.txt 2>&1

if ! $? ; then
	echo "Grab succeeded"
	echo -n $successes > '$StorageDirectory/$CameraName/attempts'
fi
