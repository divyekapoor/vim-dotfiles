#!/bin/bash
#
# Instructions from: https://benyoung.blog/persistent-storage-class-in-kubernetes-backed-by-synology-nfs/
#
echo "Installing NFS subdir external provisioner."
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.50.142 \
    --set nfs.path=/volumeUSB1/usbshare \
    --namespace nfs-subdir-external-provisioner \
    --create-namespace

# Set as default storage provider
echo "Setting provisioner as default"
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Verify
echo "Verify that (default) is shown below"
kubectl get storageclass

echo "Showing all current PVCs"
kubectl describe pvc -A

# Verify that claims are successful
echo "Applying test pod with a pvc claim."
kubectl create -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-claim.yaml -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-pod.yaml

echo "Check that the PVC claim is successful"
kubectl describe pvc -A

echo "Clean up."
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-claim.yaml -f https://raw.githubusercontent.com/kubernetes-sigs/nfs-subdir-external-provisioner/master/deploy/test-pod.yaml


