#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED deleteCluster-PD.sh ***
***************
'
    echo "An error occurred in deleteCluster-PD.sh . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
# TODO: this script is broken.
# TODO: Check gCloud has the cluster. If present then delete.
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
# INFO: https://stackoverflow.com/questions/30604846/docker-error-no-space-left-on-device
echo "INFO: Docker system pruning to save space:"
CLUSTERNAME=crack-detection-cluster 
docker system prune -f

# INFO: when you try to do things parallely, then contexts will be deleted but not the cluster. 
gcloud container clusters delete $CLUSTERNAME --zone us-east1-b 
echo "deletion of gcloud cluster is in progress...in background."

# To delete the PD we will use the same deleting cluster shell file
echo "deletion of persistent disk"
gcloud compute disks delete gce-nfs-disk --zone=us-east1-b

trap : 0

echo >&2 '
************
*** DONE deleteCluster-PD ***
************'