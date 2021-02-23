#!/bin/bash

#If the folder the Moloch is storing pcap is not standard 3.2 change these vars
pcapPath="/data/moloch/raw"
archivePath="/data/moloch/raw/archive"

#loops through all moloch capture pods
#awk expration may need to change if pod naming scheme is not standard
for podName in $(kubectl get pods | awk '/-moloch/{print$1;}');
do
#kubectl is called two times because the output from the first is used for input of second call
kubectl exec $podName -- bash -c "\
cd $pcapPath && \
find *.pcap -type f -mtime +15 -print" | while read fileName;
do
kubectl exec $podName -- bash -c "\
cd $pcapPath && \
mv $fileName $archivePath/$fileName && \
/data/moloch/db/db.pl elaticsearch:9200 mv $pcapPath/$fileName $archivePath/$fileName"
#above two lines are where all the magic happens
done;
done;