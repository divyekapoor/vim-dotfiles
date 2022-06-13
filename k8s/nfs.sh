helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=192.168.50.142 \
    --set nfs.path=/volumeUSB1/usbshare \
    --namespace nfs-subdir-external-provisioner \
    --create-namespace
