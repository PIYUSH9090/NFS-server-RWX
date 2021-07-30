# NFS Persistent Volumes with Kubernetes on GKE - ReadWriteMany(RWX)

=:> If you refer the official Google Documentation, you will notice that in ReadWriteMany access type, PersistentVolumes that are backed by Compute Engine persistent disks are not supported.

=:> There are alternative solutions for this like Google Filestore, which can be found in their documentation [here](https://cloud.google.com/filestore/docs/accessing-fileshares). However, you should take note that Google Filestore is developed targeting large scale file system use cases, as the minimum size of an instance is 1TB which is quite expensive for a small scale company with very little data trying to meet the requirement addressed in this post. 

=:> So the ideal solution for this problem is to create a Network File System(NFS) Server with Google Compute Engine persistent disks and mount them to your containers.


## Create GKE cluster and Persistent Disk in Google Compute Engine

To create these things run the createCluster-PD.sh shell file

```
sh createCluster-PD.sh
```

Now your cluster and PD is ready for opration, you can create the nfs-server. 

## Create NFS Server in GKE

Now the disk is created, let’s create the NFS server.

```
kubectl apply -f 001-nfs-server.yaml
```

## Create NFS Service

The compute disk and nfs-server is ready, let's create nfs-service

```
kubectl apply -f 002-nfs-server-service.yaml
```

Also check the service is created perfectly or not.

```
kubectl get svc nfs-server
```

## Create Persistent Volume and Persistent Volume Claim

#### Note : Note down the *clusterIP* from the nfs-service as it will be required for the next part.

Now we create a persistent volume and a persistent volume claim in kubernetes.

```
kubectl apply -f 003-pv-pvc.yaml
```

#### Note : Notice here that storage is 10Gi on both PV and PVC. It’s 10Gi on PV because the Compute Engine persistent disk we created was of the size 10Gi.You can have any storage value for PVC as long as you don’t exceed the storage value defined in PV.

## Appling the pod

Now checking the PVC is binding the PD(persistent disk) via nfs-server with this manually created another pod.yaml
This pod should have stored data which is in the default deployment pod.

```
kubectl apply -f pod.yaml
```
```
kubectl apply -f pod-2.yaml
```


Now you can login to the mypod and check wheather your stored data as is or not which is in nfs-server deployment pod.
For all the pod if data is there same as same which means you have now multiple pod with shared data.
To login the pod use the command

echo "kubectl exec -it << pod-name >> -- /bin/bash"

In out case

```
kubectl exec -it mypod -- /bin/bash
```
Now you can check and store the data as well.




Thank you... :)