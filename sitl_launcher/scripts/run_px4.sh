#!/usr/bin/env sh

#tempdir=`mktemp -d`
tempdir="/home/scout_simulator/ScoutDev/pixhawk_sd"
echo "temporary rootfs: $tempdir"

#rm "$tempdir/test_data"

#px4dir=$(rospack find px4)
#echo "px4 dir detected: $px4dir"

#cp -R ${px4dir}/* $tempdir

#cd $tempdir
#rc_script=$1
#px4 ${tempdir} ${px4dir}/${rc_script} -d

