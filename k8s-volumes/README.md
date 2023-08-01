1. Assign a single volume to specific container in a pod
2. Share a same volume to all containers within a pod
3. Assign dedicated volumes to each container in a pod
4. Share volume across all pods running on different worker nodes
    Mount the NFS volumes on the /mnt/data mount point
    Use the same mount point to the containers
5. PV and PVC
    PV -> persistent volume is a resource which is created by storage administrator to provide storage provisioning
    PVC -> persistent volume claims will request the storage size allocating to pod level then it claims storage to the containers
    