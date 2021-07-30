#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED createCluster-PD.sh ***
***************
'
    echo "An error occurred in createCluster-PD.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
# TODO: Check gCloud has the cluster. If present then delete.
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
CLUSTERNAME=crack-detection-cluster

echo "gcloud container clusters create $CLUSTERNAME --num-nodes=2"
gcloud container clusters create $CLUSTERNAME --zone us-east1-b


# First you need to create a persistent disk in your Google Cloud Console
echo "creating compute disk in us-east1-b with size of 10GB"
gcloud compute disks create gce-nfs-disk --size=10GB --zone=us-east1-b

trap : 0

echo >&2 '
************
*** DONE createCluster-PD ***
************'