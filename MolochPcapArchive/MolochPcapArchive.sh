#!/bin/bash

#Vars may need to be changed, defaults for CVA/H 3.2.1 and 89th custom configs
pcapPath="/data/moloch/raw"
archivePath="/data/moloch/raw/archive"
age=3 #days

echo -n "Started: " > last_run.txt
date >> last_run.txt

for podName in $(kubectl get pods | awk '/-moloch/{print$1;}');
do
    kubectl exec $podName -- bash -c "cd $pcapPath && find *.pcap -type f - mtime +$age -print" | while read fileName;
    do
        echo -n "moving $fileName"
        kubectl exec $podName -- bash -c "mv $pcapPath/$fileName $archivePath/$fileName"
        echo "done"
    done;
done;

echo -n "Finished: " >> last_run.txt
date >> last_run.txt