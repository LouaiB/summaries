#!/bin/bash

dir=`date +%d-%m-%Y:%H:%M:%S`
path="/home/louaib/Desktop/sandbox/db_backups"
dest="$path/$dir/"
echo $dest
mkdir $dest
mongodump --host="localhost:27017" --out="$dest"
echo "now to delete old backups"

# Delete old backups
cur_sec=$(date +%s)
min_sec=$((cur_sec - 300)) #5 min archive
files=$(ls $path)
echo "path: $path"
for bu in $files
    do
        buPath="$path/$bu"
        echo "found $bu"
        if [ -d $buPath ]
        then
            dirModTime=$(stat -c '%Y' $buPath)
            echo "found backup $bu with modtime $dirModTime"
            if [ "$dirModTime" -lt "$min_sec" ]
            then
                echo "removing old backup..."
                rm -rf "$buPath"
            fi
        fi
done