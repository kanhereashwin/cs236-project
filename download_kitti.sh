#!/bin/bash

files=(
00:2011_10_03_drive_0027
01:2011_10_03_drive_0042
02:2011_10_03_drive_0034
03:2011_09_26_drive_0067
04:2011_09_30_drive_0016
05:2011_09_30_drive_0018
)
echo 'start'
axel 'https://www.polybox.ethz.ch/index.php/s/90OlHg6KWBzG6gR'
echo 'finished!'

mkdir 'images'

for i in ${files[@]}; do
        if [ ${i:(-3)} != "zip" ]
        then
                rename=${i:0:2}
                shortname=${i:3}'_sync.zip'
                fullname=${i:3}'/'${i:3}'_sync.zip'
        else
                $i=${i:(-3)}
                shortname=$i
                fullname=$i
        fi

        axel 'https://s3.eu-central-1.amazonaws.com/avg-kitti/raw_data/'$fullname
        if [ $? -ne 0 ]
        then
                axel 'http://kitti.is.tue.mpg.de/kitti/raw_data/'$fullname
        fi

        unzip -o $shortname
        #tar -xvf $shortname
        rm $shortname

        # Remove image00 image01 image02, rename dir
        if [ ${i:(-3)} != "zip" ]
        then
                dirn=${i:3:10}'/'${i:3}'_sync''/'
                rm -r $dirn'image_00/' $dirn'image_01/' $dirn'image_02/' $dirn'velodyne_points/'
                #mv $dirn 'images/'$rename
                mv $dirn'image_03/data' 'images/'$rename
                rm -r ${dirn:0:10}
        fi
echo 'Done!'
done