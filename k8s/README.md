# k8s cheat sheet

## Setup
in ~/.bash_aliases: 

    alias k=kubectl

## Cluster Admin

### Cluster Status
    microk8s status

### Changing IP Address
If the host system's IP address is changed, Microk8s TLS certifications will be invalidated as they're tied to the original IP address.

To refresh certs for new IP address:

    sudo microk8s refresh-certs --cert ca.crt

### top
#### node
    kubectl top node
#### pods
    kubectl top pods -A --sum=true

## pod
### Generate yaml skeleton
    kubectl run nginx --image=nginx --dry-run=client -o yaml
output:
```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

## Logs
    kubectl logs <pod> 

## Shell in a Pod
    kubectl exec -it <pod> -- /bin/bash